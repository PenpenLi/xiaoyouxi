

local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )

	self:addCsb( "csbchengbao/play.csb" )

end

function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	
end






return GamePlay