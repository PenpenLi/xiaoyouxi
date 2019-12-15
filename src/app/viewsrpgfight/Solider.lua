

local Solider = class("Solider",BaseNode) 

Solider.STATUS = {
	DEAD = "dead", -- 死亡状态
	SEARCH = "search", -- 搜索敌人状态
	ATTACK = "attack", -- 攻击敌人状态
	MOVE = "move", -- 移动状态
	NOTMOVE = "not_move",--不可移动状态
	WAIT = "wait", --等待状态
}

function Solider:ctor( soliderId,gameLayer )
	assert( soliderId," !! soliderId is nil !! " )
	assert( gameLayer," !! gameLayer is nil !! " )
	Solider.super.ctor( self,"Solider" )
	self:addCsb( "csbrpgfight/NodeSolider.csb" )
	self._id = soliderId
	self._gameLayer = gameLayer
	self._guid = getGUID()
	self._config = rpgsolider_config[self._id]
	self._status = self.STATUS.SEARCH
	self._hp = self._config.hp
	self._mode = 2 -- 1,士兵，2,英雄
	
	self._modeType = "" -- "people" 玩家 "enemy" 敌人

	local path = self._config["idle_frame"].path.."1.png"
	self.Icon:loadTexture( path,1 )


	-- 自己在地图中当前坐标
	self._blockMapPos = nil
	-- 自己在地图中的下一个坐标
	self._nextBlockMapPos = nil
	-- 方向 1:向左 2:向右
	self._dir = 1
	-- 自己的目标敌人
	self._destEnemy = nil
	-- 攻击自己的近战敌人列表
	self._attackedMyEnemyList = {} 
end


-- 设置在地图中的坐标
function Solider:setBlockPos( col,row )
	assert( col," !! col is nil !! " )
	assert( row," !! row is nil !! ")
	self._blockMapPos = { col = col,row = row }
end
function Solider:getBlockPos()
	return self._blockMapPos
end
function Solider:getNextBlockPos()
	return self._nextBlockMapPos
end
-- 子类重写
function Solider:setDirection( dir )
	if self._dir ~= dir then
		self._dir = dir
		self.Icon:getVirtualRenderer():getSprite():setFlippedX( self._dir == 1 )
	end
end
function Solider:getDir()
	return self._dir
end
function Solider:getBrickId()
	return self._brickId
end
function Solider:getDestEnemy()
	return self._destEnemy
end
function Solider:getAttackType()
	return self._config.attack_type
end
function Solider:getStatus()
	return self._status
end
function Solider:setStatus( status )
	if self._status ~= status then
		self._status = status
	end
end
function Solider:getSoliderGUID()
	return self._guid
end
function Solider:getHp()
	return self._hp
end
function Solider:addHp( hp )
	self._hp = self._hp + hp
	if self._hp > hunsolider_config[self._id].hp then
		self._hp = hunsolider_config[self._id].hp
	end
	self.Hp:setPercent( self._hp / self._config.hp * 100 )
end
function Solider:getId()
	return self._id
end
function Solider:getAttackDistance()
	return self._config.attack_distance
end
function Solider:getSpeed()
	return self._config.speed
end
function Solider:getModeType()
	return self._modeType
end

function Solider:playFrameAction( frameName,isRepeate,callBack )
	if self._curFrameName and self._curFrameName == frameName then
		self:printLog("帧重复了 self._curFrameName = "..self._curFrameName.." isRepeate = "..tostring(isRepeate))
		if not isRepeate then
			callBack()
		end
		return
	end
	self._curFrameName = frameName
	local index = 1
	self.Icon:stopAllActions()
	schedule( self.Icon,function()
		local frame = self._config[frameName].frames[index]
		local path = self._config[frameName].path..frame..".png"
		self.Icon:loadTexture( path,1 )
		self.Icon:getVirtualRenderer():getSprite():setFlippedX( self._dir == 1 )
		index = index + 1
		if index > #self._config[frameName].frames then
			if not isRepeate then
				self.Icon:stopAllActions()
				self._curFrameName = nil
			else
				index = 1
			end
			if callBack then
				callBack()
			end
		end
	end,0.1 )
end
-- 停止播放动画
function Solider:stopPlayFrameAction()
	self._curFrameName = nil
	self.Icon:stopAllActions()
end
-- 播放idle动画
function Solider:playIdle( isRepeate,callBack )
	self:playFrameAction("idle_frame",isRepeate,callBack)
end

function Solider:onEnter()
	Solider.super.onEnter( self )
	-- 开帧 搜索敌人
	self:aiLogicBegan()
end

function Solider:aiLogicBegan()
	self:onUpdate( function() self:searchEnemy() end )
end

---------------------------- 搜索相关 START -----------------------
function Solider:searchEnemy()
	assert( not self._destEnemy," !! error aleary has enemy !! " )
	self:playIdle( true )
	-- 1:没有敌人
	if #self._enemyList == 0 then
		return
	end
	-- 2:检查自己周围有没有敌人
	for i,v in ipairs( self._enemyList ) do
		if self:canFightDestEnemy( v:getBlockPos() ) then
			self:setDestEnemy(v)
			return
		end
	end

	-- 3:确定敌人列表
	local enemy_list = {}
	if self._config.attack_type == 1 then
		-- 近战 找出有空闲砖块的敌人
		for i,v in ipairs( self._enemyList ) do
			local empty_brack = v:getEmptyAroundBrack()
			if #empty_brack > 0 then
				table.insert( enemy_list,v )
			end
		end
		if #enemy_list == 0 then
			return
		end
	else
		-- 远程
		enemy_list = self._enemyList
	end

	-- 3:找出距离自己最近的敌人
	local choose_list = {}
	for i,v in ipairs( enemy_list ) do
		local enemy_block_pos = v:getBlockPos()
		local dis = math.abs( self._blockMapPos.col - enemy_block_pos.col ) + math.abs( self._blockMapPos.row - enemy_block_pos.row )
		local meta = { dis = dis,enemy = v }
		table.insert( choose_list,meta )
	end
	table.sort( choose_list,function(a,b)
		-- 优先查找敌人被攻击目标少的
		if #a.enemy:getBeAttackedList() ~= #b.enemy:getBeAttackedList() then
			return #a.enemy:getBeAttackedList() < #b.enemy:getBeAttackedList()
		end
		return a.dis < b.dis
	end )

	self:setDestEnemy( choose_list[1].enemy )
end

function Solider:setDestEnemy( enemySolider )
	-- 设置敌人目标
	self._destEnemy = enemySolider
	-- 关闭搜索帧
	self:unscheduleUpdate()
	-- 进入计算状态模块
	self:calSetStatusByDestEnemy()
end

---------------------------- 搜索相关 END -----------------------


---------------------------- 当搜索到敌人 进入计算状态模块 START ---------------
function Solider:calSetStatusByDestEnemy()
	-- 1:当没有敌人了
	if not self._destEnemy  then
		-- 开帧从新搜索
		self:aiLogicBegan()
		return
	end
	-- 2:当敌人已经死亡
	if self._destEnemy:isDead() then
		self._destEnemy = nil
		-- 开帧从新搜索
		self:aiLogicBegan()
		return
	end

	-- 计算状态相关 1:是否可以攻击 2：是否需要等待 3:是否需要移动
	-- 1:是否可以攻击
	if self:canFightDestEnemy( self._destEnemy:getBlockPos() ) then
		self:setStatus( self.STATUS.ATTACK )
		self:attackEnemy()
		return
	end
	-- 2:是否需要等待 (针对自己的目标下一个位置点位正是我可以攻击的距离 则进行等待)
	local next_block = self._destEnemy:getNextBlockPos()
	if next_block and self:canFightDestEnemy( next_block ) then
		-- 等待
		self:setStatus( self.STATUS.WAIT )
		performWithDelay( self,function()
			-- 从新进入计算状态
			self:calSetStatusByDestEnemy()
		end,self._destEnemy:getSpeed() )
		return
	end
	-- 3:移动
	local can_move,brack = self:canMove()
	-- 能移动
	if can_move then
		self:setStatus( self.STATUS.MOVE )
		-- 开始移动
		self:printLog("移向目标")
		self:runToEnemy( brack )
		return
	end
	-- 不能移动 
	-- 播放idle动画
	self:stopPlayFrameAction()
	self:setStatus( self.STATUS.NOTMOVE )
	self:playIdle( false,function()
		self:calSetStatusByDestEnemy()
	end )
end

---------------------------- 当搜索到敌人 进入计算状态模块 END ---------------

----------------------------------死亡相关 START --------------------
-- 自己死亡
function Solider:setDead()
	self:setStatus( self.STATUS.DEAD )
	-- 自己占用的砖块设置为空闲
	self._gameLayer:setBrackStatus( self._blockMapPos.col,self._blockMapPos.row,0 )
	self:printLog("自己死亡")
	self._gameLayer:soliderDead( self._guid,self._modeType )
	local call_back = function()
		self:removeFromParent()
	end
	-- 播放死亡动画
	self:playDead( call_back )
end

function Solider:setHpByHurt( hurtValue )
	if self._hp <= 0 then
		return
	end
	self._hp = self._hp - hurtValue
	self:printLog( "当前正在受到攻击的log" )
	self.Hp:setPercent( self._hp / self._config.hp * 100 )
	if self._hp <= 0 then
		-- 死亡
		self:setDead()
	end
end

-- 播放死亡动画
function Solider:playDead( callBack )
	self:playFrameAction("dead_frame",false,callBack )
end

function Solider:isDead()
	return self._status == self.STATUS.DEAD
end

-- 根据guid 清空自己的目标敌人
function Solider:clearDestByGuid( guid )
	assert( guid," !! guid is nil !!" )
	if not self._destEnemy then
		return
	end
	if self._destEnemy:getSoliderGUID() == guid then
		self:printLog("自己的目标死亡，清除目标类型的指针 guid = "..guid)
		self._destEnemy = nil
	end
end


----------------------------------死亡相关 ENd --------------------


-------------------------------- 被攻击列表相关 START -------------------------
-- 当攻击自己的近战士兵死亡 从自己的敌人列表清除
function Solider:removeAttackMyEnemyList( guid )
	assert( guid," !! guid is nil !! " )
	if self._attackedMyEnemyList[guid] then
		self._attackedMyEnemyList[guid] = nil
	end
end
function Solider:getBeAttackedList()
	return self._attackedMyEnemyList
end
-- 加入solider到攻击自己的敌人队列中
function Solider:addAttackMyEnemyList( solider )
	local guid = solider:getSoliderGUID()
	self._attackedMyEnemyList[guid] = solider
end
-------------------------------- 被攻击列表相关 END -------------------------


-------------------------------- 攻击相关 START -------------------------

-- 判断能否攻击自己的敌人
function Solider:canFightDestEnemy( block )
	local col_dis = math.abs(self._blockMapPos.col - block.col)
	local row_dis = math.abs(self._blockMapPos.row - block.row)
	local total_dis = col_dis + row_dis
	return self._config.attack_distance >= total_dis
end

-- 攻击自己的敌人
function Solider:attackEnemy()
	-- 检查状态
	if self._status ~= self.STATUS.ATTACK then
		self:printLog(" attackEnemy 状态出错 不是攻击状态")
		return
	end
	-- 将自己加入到目标敌人的攻击队列中
	self._destEnemy:addAttackMyEnemyList( self )
	-- 设置朝向
	local enemy_block = self._destEnemy:getBlockPos()
	if enemy_block.col > self._blockMapPos.col then
		self:setDirection( 2 )
	elseif enemy_block.col < self._blockMapPos.col then
		self:setDirection( 1 )
	end

	local call_back = function()
		-- 敌人受伤
		if self._destEnemy then
			self._destEnemy:setHpByHurt( self._config.attack_value )
		end
		-- 播放静止帧 来充当时间间隔
		self:playIdle( false,function()
			-- 攻击结束 从新进入计算状态
			self:calSetStatusByDestEnemy()
		end )
	end
	self:playAttack( call_back )
end

--播放攻击动画
function Solider:playAttack( callBack )
	local call_set = function()
		-- 添加箭头
		if self._destEnemy and self._config.attack_type == 2 then
			local color_layer = cc.LayerColor:create( cc.c4b( 255,0,0,255 ) )
			color_layer:setContentSize( cc.size( 20,5 ) )
			self:addChild( color_layer )
			local world_pos = self._destEnemy:getParent():convertToWorldSpace( cc.p( self._destEnemy:getPosition() ) )
			local node_pos = self:convertToNodeSpace( world_pos )
			local move_to = cc.MoveTo:create(0.1,node_pos)
			local remove = cc.RemoveSelf:create()
			local seq = cc.Sequence:create({ move_to,remove })
			color_layer:runAction( seq )
		end
		if callBack then
			callBack()
		end
	end
	self:playFrameAction("attack_frame",false,call_set )
end

-------------------------------- 攻击相关 END -------------------------















-------------------------------- 移动相关 START -------------------------

-- 判断自己能否移动
function Solider:canMove()
	-- 筛选出可以移动的点
	local empty_brack = self:getEmptyAroundBrack()
	-- 当只有一个点
	if #empty_brack == 1 then
		return true,empty_brack[1]
	end

	-- 选出最小的点
	if #empty_brack > 1 then
		-- 朝目标最近的能攻击点位方向筛选(优先横着走 列的移动)
		local can_move,brack = self:chooseMinDisBrack( empty_brack )
		if can_move then
			return true,brack
		end
	end
	return false
end

-- 获取自己周围4个点 没有被占用的
function Solider:getEmptyAroundBrack()

	local left = { col = self._blockMapPos.col - 1 ,row = self._blockMapPos.row,dir_type = 1 }
	local right = { col = self._blockMapPos.col + 1 ,row = self._blockMapPos.row,dir_type = 2 }
	local top = { col = self._blockMapPos.col,row = self._blockMapPos.row + 1,dir_type = 3 }
	local down = { col = self._blockMapPos.col,row = self._blockMapPos.row - 1,dir_type = 4 }

	if self._destEnemy then
		local enemy_pos = self._destEnemy:getBlockPos()
		if math.abs( self._blockMapPos.col - enemy_pos.col ) < math.abs( self._blockMapPos.row - enemy_pos.row ) then
			top.dir_type = 1
			down.dir_type = 2
			left.dir_type = 3
			right.dir_type = 4
		end
	end

	-- 1:检查是否在方块内
	local enabled_brack = {}
	if top.row <= self._gameLayer:getMaxRow() then
		table.insert( enabled_brack,top )
	end
	if down.row >= 1 then
		table.insert( enabled_brack,down )
	end
	if left.col >= 1 then
		table.insert( enabled_brack,left )
	end
	if right.col <= self._gameLayer:getMaxCol() then
		table.insert( enabled_brack,right )
	end
	-- 筛选出可以移动的点
	local empty_brack = {}
	for k,v in ipairs( enabled_brack ) do
		if self._gameLayer:isEmptyBrack( v.col,v.row ) then
			table.insert( empty_brack,v )
		end
	end
	return empty_brack
end

--[[
	当自己有多个点可以移动到目标 选择最近的点移动
	myAround:自己周围可以移动的点
]]
function Solider:chooseMinDisBrack( myAround )
	assert( myAround," !! myAround is nil !! " )
	assert( #myAround > 1," !! 自己必须存在1个点以上 才可以进行赛选操作 !! " )
	assert( self._destEnemy," !! self._destEnemy is nil !! " )
	local dest_around = self._destEnemy:getEmptyAroundBrack()
	
	-- 如果自己是近战
	if self._config.attack_type == 1 then
		-- 敌人已经被包围
		if #dest_around == 0 then
			return false
		end
	end

	local all_line = {}
	for i,v in ipairs( myAround ) do
		for a,b in ipairs( dest_around ) do
			local meta = {}
			local my_pos = clone(v) -- 表示自己可以移动的下一个位置
			local enemy_pos = clone(b)
			local dis = math.abs(my_pos.col - enemy_pos.col) + math.abs(my_pos.row - enemy_pos.row)
			meta.my_pos = my_pos
			meta.enemy_pos = enemy_pos
			meta.dis = dis
			meta.enemy_org_pos = self._destEnemy:getBlockPos() -- 敌人的原始点
			meta.my_org_pos = self:getBlockPos() -- 自己的原始点
			meta.dir_type = v.dir_type
			table.insert( all_line,meta )
		end
	end
	table.sort( all_line,function(a,b)
		-- 1:距离不等
		if a.dis ~= b.dis then
			return a.dis < b.dis
		end
		if math.abs( a.my_org_pos.col - a.enemy_org_pos.col ) >= math.abs( a.my_org_pos.row - a.enemy_org_pos.row ) then
			-- 2:列最近
			if a.my_org_pos.col < a.enemy_org_pos.col then
				if a.my_pos.col ~= b.my_pos.col then
					return a.my_pos.col > b.my_pos.col
				end
			elseif a.my_org_pos.col > a.enemy_org_pos.col then
				if a.my_pos.col ~= b.my_pos.col then
					return a.my_pos.col < b.my_pos.col
				end
			end
		else
			-- 3:行最近
			if a.my_org_pos.row < a.enemy_org_pos.row then
				if a.my_pos.row ~= b.my_pos.row then
					return a.my_pos.row > b.my_pos.row
				end
			elseif a.my_org_pos.row > a.enemy_org_pos.row then
				if a.my_pos.row ~= b.my_pos.row then
					return a.my_pos.row < b.my_pos.row
				end
			end
		end
		return a.dir_type < b.dir_type
	end )

	local min_dis = all_line[1].dis
	local min_list = {}
	for i,v in ipairs( all_line ) do
		if v.dis == min_dis then
			table.insert(min_list,v)
		end
	end
	return true,min_list[1].my_pos
end

-- 跑向敌人 只移动一个单元格
function Solider:runToEnemy( brack )
	assert( brack," !! brack is nil !! " )

	-- 设置自己的下一个点位
	self._nextBlockMapPos = clone(brack)
	-- 设置将要移动的砖块被占用
	self._gameLayer:setBrackStatus( brack.col,brack.row,2 )
	-- 播放移动帧动画
	self:playMove()

	-- 设置朝向
	if self._nextBlockMapPos.col > self._blockMapPos.col then
		self:setDirection( 2 )
	elseif self._nextBlockMapPos.col < self._blockMapPos.col then
		self:setDirection( 1 )
	end

	local pos = self._gameLayer:getBrackPos(brack.col,brack.row)
	local move_to = cc.MoveTo:create( self._config.speed,pos)
	local call = cc.CallFunc:create(function ()
		-- 移动完之后 重置目标
		self:printLog(" 移动结束 ")
		self:playIdle( false )
		self._status = self.STATUS.SEARCH
		-- 将之前占用的砖块设置为空闲
		self._gameLayer:setBrackStatus( self._blockMapPos.col,self._blockMapPos.row,0 )
		-- 重置自己的砖块位置
		self._blockMapPos = clone( brack )
		-- 设置现在的砖块为占用状态
		self._gameLayer:setBrackStatus( self._blockMapPos.col,self._blockMapPos.row,1 )

		-- 重置自己的下一个位置
		self._nextBlockMapPos = nil
		self._destEnemy = nil
		-- 开帧从新搜索
		local delay_time = random(10,20) / 100
		performWithDelay( self.HpBg,function()
			self:aiLogicBegan()
		end,delay_time )
	end)
	local seq = cc.Sequence:create(move_to,call)
	self:runAction(seq)
end

-- 播放移动动画
function Solider:playMove()
	self:playFrameAction("move_frame",true)
end

-------------------------------- 移动相关 END -------------------------



function Solider:printLog( str )
	-- print( string.format( " 自己的 type = %s hp= %s guid = %s,statue= %s 额外信息 = %s",self._modeType,self._hp,self._guid,self._status,str ) )
end


-- 检查目标敌人是否存在
function Solider:isDestEnemyLife()
	if (not self._destEnemy) or (self._destEnemy:getHp() <= 0) then
		return false
	end
	return true
end




return Solider