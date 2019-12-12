

local Solider = class("Solider",BaseNode) 

Solider.STATUS = {
	CREATE = "create", -- 刚刚创建的状态
	MARCH = "march", -- 行军状态
	CANFIGHT = "can_fight", -- 可以战斗的状态 搜索敌人
	ATTACK = "attack", -- 攻击敌人状态
	DEAD = "dead", -- 死亡状态
	SELECT = "select", -- 选中状态
}

function Solider:ctor( soliderId,gameLayer )
	assert( soliderId," !! soliderId is nil !! " )
	assert( gameLayer," !! gameLayer is nil !! " )
	Solider.super.ctor( self,"Solider" )
	self:addCsb( "csbhunzhan/NodeSolider.csb" )
	self._id = soliderId
	self._gameLayer = gameLayer
	self._guid = getGUID()
	self._config = hunsolider_config[self._id]
	self._status = self.STATUS.CREATE
	self._hp = self._config.hp
	self._dir = 1 -- 方向 1:向左 2:向右
	self._modeType = "" -- "people" 玩家 "enemy" 敌人

	self._destEnemy = nil -- 自己的目标敌人
	self._attackedMyEnemyList = {}  -- 攻击自己的敌人列表

	local path = self._config["idle_frame"].path.."1.png"
	self.Icon:loadTexture( path,1 )

	-- self:setScale( 0.8 )
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

function Solider:getDestEnemy()
	return self._destEnemy
end

function Solider:onEnter()
	Solider.super.onEnter( self )
	-- 开帧
	self:onUpdate( function() self:updateStatus() end )
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

function Solider:printLog( str )
	-- print( string.format( " 自己的 type = %s hp= %s guid = %s,statue= %s 额外信息 = %s",self._modeType,self._hp,self._guid,self._status,str ) )
end

-- 播放idle动画
function Solider:playIdle( isRepeate,callBack )
	self:playFrameAction("idle_frame",isRepeate,callBack)
end
-- 播放移动动画
function Solider:playMove()
	self:playFrameAction("move_frame",true)
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
-- 播放死亡动画
function Solider:playDead( callBack )
	self:playFrameAction("dead_frame",false,callBack )
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

function Solider:isDead()
	return self._status == self.STATUS.DEAD
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
function Solider:getSoliderGUID()
	return self._guid
end
function Solider:getStatus()
	return self._status
end

function Solider:setStatus( status )
	if self._status ~= status then
		self._status = status
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

function Solider:removeAttackMyEnemyList( guid )
	assert( guid," !! guid is nil !! " )
	if self._attackedMyEnemyList[guid] then
		self._attackedMyEnemyList[guid] = nil
	end
end


function Solider:updateStatus()
	
end


-- 检查目标敌人是否存在
function Solider:isDestEnemyLife()
	if (not self._destEnemy) or (self._destEnemy:getHp() <= 0) then
		return false
	end
	return true
end

-- 重置自己的状态为可以战斗的状态
function Solider:resetCanFightStatus()
	-- 开帧
	self:setStatus( self.STATUS.CANFIGHT )
	self._curFrameName = nil
	self:playIdle( true )
	self:unscheduleUpdate()
	self:onUpdate( function() self:updateStatus() end )
end

-- 自己死亡
function Solider:setDead()
	self:setStatus( self.STATUS.DEAD )
	self:printLog("自己死亡")
	-- 播放死亡动画
	self._gameLayer:soliderDead( self._guid,self._modeType )
	local call_back = function()
		self:removeFromParent()
	end
	self:playDead( call_back )
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
		self:printLog("从新开帧1")
		self:resetCanFightStatus()
	end
end



return Solider