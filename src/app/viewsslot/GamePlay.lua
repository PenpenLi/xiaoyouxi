

local GamePlay = class( "GamePlay",BaseLayer )


function GamePlay:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GamePlay.super.ctor( self,param.name )

	self._levelIndex = param.data[1]

	self:addCsb( "csbslot/wolfLighting/GameScreenPharaoh.csb" )
end





















return GamePlay