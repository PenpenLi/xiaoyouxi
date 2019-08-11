
local FishNode = import(".FishNode")
local GamePlay = class( "GamePlay",BaseLayer )



function GamePlay:ctor( param )

	local fish = FishNode.new()
	fish:setPosition( 0,0 )
	self:addChild( fish )

	local c_point1 = cc.p( display.width / 4,display.height / 4 )
	local c_point2 = cc.p( display.width * 3 / 4,display.height * 3 / 4 )
	local end_point = cc.p( display.width,0 )
	local bz = cc.BezierTo:create(10,{ c_point1,c_point2,end_point })
	fish:runAction( bz )
end















return GamePlay