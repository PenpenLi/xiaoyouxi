

local FishNode = class("FishNode",BaseNode)


function FishNode:ctor()
	FishNode.super.ctor( self,"FishNode" )

	local fish = ccui.ImageView:create("fish1_3/0.png")
	self:addChild( fish )
	self._fish = fish
end



function FishNode:onEnter()
	FishNode.super.onEnter( self )

	local index = 1
	local last_point = cc.p( 0,0 )
	self:schedule( function()
		local path = "fish1_3/"..index..".png"
		self._fish:loadTexture( path )

		local cur_point = cc.p( self:getPosition() )
		local k = math.atan2( cur_point.y,cur_point.x )
		self:setRotation( k * 180 / 3.14159265 )
		last_point = clone( cur_point )

		index = index + 1
		if index > 11 then
			index = 0
		end
	end,0.02 )
end


function FishNode:fishMoveAction()

end











return FishNode