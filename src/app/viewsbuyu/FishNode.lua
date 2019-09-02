
local FishNode = class("FishNode",BaseNode)


function FishNode:ctor( fishIndex,fishLine )
	FishNode.super.ctor( self,"FishNode" )

	self._fishIndex = self:randomFish()
	self._config = buyu_config.fish[self._fishIndex]
	local fish = ccui.ImageView:create( self._config.path..self._config.startNum..".png",1 )
	self:addChild( fish )

	self._fish = fish
	self._fishLine = fishLine
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
	dump( self._config.multiple,"----------------self._config.multiple = ")
	return self._config.multiple
end







return FishNode