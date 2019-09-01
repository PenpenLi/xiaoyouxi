
local FishNode = class("FishNode",BaseNode)


function FishNode:ctor( fishIndex,fishLine )
	FishNode.super.ctor( self,"FishNode" )

	self._config = buyu_config.fish[fishIndex]
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











return FishNode