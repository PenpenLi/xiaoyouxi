

local Solider = class("Solider",BaseNode) 

Solider.STATUS = {
	DEAD = "dead", -- 死亡状态
	SEARCH = "search", -- 搜索敌人状态
	ATTACK = "attack", -- 攻击敌人状态
	MOVE = "move", -- 移动状态
}

function Solider:ctor( soliderId,gameLayer )
	assert( soliderId," !! soliderId is nil !! " )
	assert( gameLayer," !! gameLayer is nil !! " )
	Solider.super.ctor( self,"Solider" )
	self:addCsb( "csbhunzhan/NodeSolider.csb" )
	self._id = soliderId
	self._gameLayer = gameLayer
	self._guid = getGUID()
	self._config = rpgsolider_config[self._id]
	self._status = self.STATUS.SEARCH
	self._hp = self._config.hp
	
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
-- 播放idle动画
function Solider:playIdle( isRepeate,callBack )
	self:playFrameAction("idle_frame",isRepeate,callBack)
end




function Solider:onEnter()
	Solider.super.onEnter( self )

	-- 开帧 搜索敌人
	self:onUpdate( function() self:searchEnemy() end )
end


function Solider:updateStatus( dt )
	-- -- 处于攻击的标志 节约性能 直接return
	-- if self.m_attackMark then
	-- 	return
	-- end
	-- -- 1:自己当前是否死亡
	-- if self._status == self.STATUS.DEAD then
	-- 	self:printLog(" updateStatus 自己死亡")
	-- 	return
	-- end
	-- -- 2:自己正在移动
	-- if self._status == self.STATUS.MOVE then
	-- 	self:printLog(" updateStatus 自己正在移动")
	-- 	return
	-- end
	-- -- 3:当自己有敌人
	-- if self._destEnemy then
	-- 	-- 1:敌人是否死亡
	-- 	if self._destEnemy:isDead() then
	-- 		self:printLog(" updateStatus 目标死亡 出错")
	-- 		self._destEnemy = nil
	-- 		return
	-- 	end
	-- 	-- 2:存在
	-- 	if self._config.attack_type == 1 then
	-- 		-- 自己是近战 判断要攻击的目标 他的近战敌人是否已经满了
	-- 		if self._destEnemy:isCloseCombatFull() then
	-- 			self:printLog(" updateStatus 自己是近战 攻击目标的近战单位已满")
	-- 			self._destEnemy = nil
	-- 			return
	-- 		end
	-- 	end
	-- 	-- >> 根据距离判断能否攻击敌人
	-- 	if self:canFightDestEnemy() then
	-- 		-- 开始攻击敌人
	-- 		self:setStatus( self.STATUS.ATTACK )
	-- 		self:attackEnemy()
	-- 		self:printLog(" updateStatus 攻击目标")
	-- 		return
	-- 	end
	-- 	-- 3:不能攻击
	-- 	-- >> 判断当前的敌人下一个移动点位是否在自己的攻击范围内 是：等待 


	-- 	-- 否:行走一个单元格
	-- 	-- 判断能否移动
	-- 	local can_move,brack = self:canMove()
	-- 	if can_move then
	-- 		self:setStatus( self.STATUS.MOVE )
	-- 		-- 开始移动
	-- 		self:printLog(" updateStatus 移向目标")
	-- 		self:runToEnemy( brack )
	-- 	end
	-- 	return
	-- end

	-- -- 4:没有敌人目标 搜索敌人
	-- self:searchEnemy()
end


---------------------------- 搜索相关 START -----------------------
function Solider:searchEnemy()
	assert( not self._destEnemy," !! error aleary has enemy !! " )
	-- 1:没有敌人
	if #self._enemyList == 0 then
		return
	end
	-- 2:确定敌人列表
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
		return a.dis < b.dis
	end )
	-- 设置敌人目标
	self._destEnemy = choose_list[1].enemy
	-- 关闭搜索帧
	self:unscheduleUpdate()
	-- 进入计算状态模块
	self:calSetStatusByDestEnemy()
end

---------------------------- 搜索相关 END -----------------------


---------------------------- 当搜索到敌人 进入计算状态模块 START ---------------
function Solider:calSetStatusByDestEnemy()
end

---------------------------- 当搜索到敌人 进入计算状态模块 END ---------------











----------------------------------死亡相关 START --------------------
-- 自己死亡
function Solider:setDead()
	self:setStatus( self.STATUS.DEAD )
	-- 关闭定时器
	self:unscheduleUpdate()
	self:printLog("自己死亡")
	-- 播放死亡动画
	self._gameLayer:soliderDead( self._guid,self._modeType )
	local call_back = function()
		self:removeFromParent()
	end
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
-- 判断自己的近战攻击点位是否已经满了
function Solider:isCloseCombatFull()
	if table.nums( self._attackedMyEnemyList ) < 4 then
		return false 
	end
	local num = 0
	for k,v in pairs( self._attackedMyEnemyList ) do
		if v:getAttackType() == 1 then
			-- 近战
			num = num + 1
		end
	end
	assert( num > 4," !! error 攻击自己近战的敌人超过了4个 !! " )
	return num == 4
end
-------------------------------- 被攻击列表相关 END -------------------------






-------------------------------- 攻击相关 START -------------------------

-- 判断能否攻击自己的敌人
function Solider:canFightDestEnemy()
	assert( self._destEnemy," !! self._destEnemy is nil !! " )
	local enemy_block = self._destEnemy:getBlockPos()
	local col_dis = math.abs(self._blockMapPos.col - enemy_block.col)
	local row_dis = math.abs(self._blockMapPos.row - enemy_block.row)
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

	self.m_attackMark = true
	-- 将自己加入到目标敌人的攻击队列中
	self._destEnemy:addAttackMyEnemyList( self )
	local call_back = function()
		-- 敌人受伤
		self._destEnemy:setHpByHurt( self._config.attack_value )
		-- 播放静止帧 来充当时间间隔
		self:playIdle( false,function()
			self.m_attackMark = nil
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
		local brack = self:chooseMinDisBrack( empty_brack )
		return true,brack
	end
	return false
end

-- 获取自己周围4个点 没有被占用的
function Solider:getEmptyAroundBrack()
	local top = { col = self._blockMapPos.col,row = self._blockMapPos.row + 1 }
	local down = { col = self._blockMapPos.col,row = self._blockMapPos.row - 1 }
	local left = { col = self._blockMapPos.col - 1 ,row = self._blockMapPos.row }
	local right = { col = self._blockMapPos.col + 1 ,row = self._blockMapPos.row }
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
	-- 2:检查这几个点是否有被占用
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
	assert( #dest_around > 0," !! 敌人周围必须有空格的点 不然不应该调用此方法 !! " )

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
			table.insert( all_line,meta )
		end
	end
	table.sort( all_line,function(a,b)
		return a.dis < b.dis
	end )

	local min_dis = all_line[1].dis
	local min_list = {}
	for i,v in ipairs( all_line ) do
		if v.dis == min_dis then
			table.insert(min_list,v)
		end
	end
	return min_list[random(1,#min_list)].my_pos
end

-- 跑向敌人 只移动一个单元格
function Solider:runToEnemy( brack )
	assert( brack," !! runToEnemy is nil !! " )

	-- 设置自己的下一个点位
	self._nextBlockMapPos = clone(brack)
	-- 设置将要移动的砖块被占用
	self._gameLayer:setBrackStatus( brack.col,brack.row,1 )
	-- 播放移动帧动画
	self:playMove()

	local pos = self._gameLayer:getBrackPos(brack.col,brack.row)
	local move_to = cc.MoveTo:create( self._config.speed,pos)
	local call = cc.CallFunc:create(function ()
		-- 移动完之后 重置目标
		self:printLog(" runToEnemy 移动结束 ")
		self:playIdle( false )
		self._status = self.STATUS.SEARCH
		-- 将之前占用的砖块设置为空闲
		self._gameLayer:setBrackStatus( self._blockMapPos.col,self._blockMapPos.row,1 )
		-- 重置自己的砖块位置
		self._blockMapPos = clone( brack )
		-- 重置自己的下一个位置
		self._nextBlockMapPos = nil
		self._destEnemy = nil
	end)
	local seq = cc.Sequence:create(move_to,call)
	self:runAction(seq)
end

-- 播放移动动画
function Solider:playMove()
	self:playFrameAction("move_frame",true)
end

-------------------------------- 移动相关 END -------------------------




-- 重置自己的状态为可以战斗的状态
function Solider:resetCanFightStatus()
	-- 开帧
	self:setStatus( self.STATUS.SEARCH )
	self._curFrameName = nil
	self:playIdle( true )
	self:unscheduleUpdate()
	self:onUpdate( function() self:updateStatus() end )
end



function Solider:printLog( str )
	print( string.format( " 自己的 type = %s hp= %s guid = %s,statue= %s 额外信息 = %s",self._modeType,self._hp,self._guid,self._status,str ) )
end


-- 检查目标敌人是否存在
function Solider:isDestEnemyLife()
	if (not self._destEnemy) or (self._destEnemy:getHp() <= 0) then
		return false
	end
	return true
end




return Solider