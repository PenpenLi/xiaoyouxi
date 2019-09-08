
local FishNode = class("FishNode",BaseNode)


function FishNode:ctor( gameLayer,fishIndex,fishLine )
	FishNode.super.ctor( self,"FishNode" )

	self._fishIndex = self:randomFish()
	self._config = buyu_config.fish[self._fishIndex]
	local fish = ccui.ImageView:create( self._config.path..self._config.startNum..".png",1 )
	self:addChild( fish )

	self._fish = fish
	self._gameLayer = gameLayer
	self._fishLine = fishLine
	-- self._deadOfPoint = nil -- 死亡时世界坐标
	-- self:setAnchorPoint(cc.p(0.5,0.5))
	-- local box = self._fish:getBoundingBox()
	-- dump(box,"-----------------box = ")

	-- hp
	self._hp = self._config.blood
	self._dead = false
	self._coin = nil -- 当前鱼coin，包含子弹倍数，鱼倍数的最终coin
end



function FishNode:onEnter()
	FishNode.super.onEnter( self )

	local index = 0
	local last_point = cc.p( 0,0 )
	self:schedule( function()
		
		local path = self._config.path..index..".png"
		self._fish:loadTexture( path,1 )

		-- 设置转向
		local cur_point = cc.p( self:getPosition() )
		local x = cur_point.x - last_point.x
		local y = cur_point.y - last_point.y
		local k = math.atan2( y,x )
		local r = self._config.angle - k * 180 / math.pi
		self:setRotation( r )

		last_point = clone( cur_point )
		index = index + 1
		if index > self._config.endNum then
			index = 0
		end
	end,self._config.imageScheduleTime )

	self:fishMoveAction()
end


function FishNode:fishMoveAction()
	self._fishLine:createLine( self,self._config.dir )
end

-- 随机出现的鱼
function FishNode:randomFish()
	local weight = 0
	for i=1,#buyu_config.fish do
		weight = weight + buyu_config.fish[i].weight
	end
	local fish_all = random( 1,weight )
	local fish_now = 0
	for i=1,#buyu_config.fish do
		fish_now = fish_now + buyu_config.fish[i].weight
		if fish_all <= fish_now then
			return i
		end
	end
	assert( false,"没有找到鱼的数据！！！")
end

-- 获取鱼的倍数
function FishNode:getMultiple( ... )
	-- dump( self._config.multiple,"----------------self._config.multiple = ")
	return self._config.multiple
end


function FishNode:fishBeAttacked( hitNum )
	self._hp = self._hp - hitNum
	if self._hp <= 0 then
		-- 死亡动画
		self:actionOfDead()
		local pos = cc.p(self:getPosition())
		local worldPos = self:getParent():convertToWorldSpace( pos )
		-- dump(self._coin,"------------self._coin = ")
		self._gameLayer:createCoin( worldPos,self._coin )
		-- performWithDelay( self,function ()
		-- 	self:removeFromParent()
		-- end,1)
		
	else
		-- 受伤动画
		local index = 0 -- 控制变色时间
		self:onUpdate( function( dt ) 
			redSprite( self._fish:getVirtualRenderer():getSprite() )
			index = index + 1
			if index >= 10 then
				self:unscheduleUpdate()
			end

		end)










		-- local index = 0
		-- schedule( self,function ()
		-- 	redSprite( self._fish:getVirtualRenderer():getSprite() )
		-- 	index = index + 1
		-- 	if index >= 15 then
		-- 		unSchedule()
		-- 	end
		-- end,0.02)


		-- redSprite( self._fish:getVirtualRenderer():getSprite() )
		-- performWithDelay( self,function ()
		-- 	ungraySprite( self._fish:getVirtualRenderer():getSprite() )
		-- end,2)
	end
end
function FishNode:getBlood( ... )
	return self._hp
end
function FishNode:setBlood( harm )
	self._hp = self._hp - harm
end
function FishNode:getFish()
	return self._fish
end
function FishNode:getFishIndex( ... )
	return self._fishIndex
end
-- 死亡动画
function FishNode:actionOfDead( ... )
	if self._dead then
		return
	end
	self._dead = true
	-- -- 死亡从node移除到世界坐标，避免死了一直能攻击
	-- local dead_pos = cc.p(self:getPosition())
	-- local dead_worldPos = self:getParent():convertToWorldSpace( dead_pos )
	-- self:retain()
	-- self:removeFromParent()
	-- self._gameLayer:addChild( self )
	-- self:release()
	-- self:setPosition( dead_worldPos )



	self:stopAllActions()
	self:unSchedule()
	self._coin = self:getFishGetCoin()
	local index = 0
	local rot_node = self:getRotation()
	local rot_fish = self._fish:getRotation()
	-- dump( rot_node,"------------rot = ")
	self:schedule( function ()
		-- if index == 0 then
		-- 	dump( rot_node,"------------rot = ")
		-- end
		local path = self._config.path..index..".png"
		self._fish:loadTexture( path,1 )
		-- self._fish:setRotation( rot_fish )
		-- self:setRotation( rot_node )
		
		index = index + 1
		if index > self._config.endNum then
			local rot = self:getRotation()
			-- dump( rot,"------------rot = ")
			index = 0
			self:removeFromParent()
		end

	end,0.02)
end

-- 捕鱼获得金币
function FishNode:getFishGetCoin()
	-- dump( self._fishIndex,"--------------self._fishIndex = ")
	local bulletMultiple = G_GetModel("Model_BuYu"):getMultiple()
	local fishMultiple = self._config.multiple
	local coin = buyu_config.multiple[bulletMultiple] * fishMultiple
	
	-- dump( coin,"---------------coin = ")
	G_GetModel("Model_BuYu"):setCoin( coin )
	-- EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_BUYU_KILL_COIN )
	return coin
end
-- 冰封技能，鱼的状态
function FishNode:iceOfFishState( ... )
	-- local bubble = ccui.
end

return FishNode