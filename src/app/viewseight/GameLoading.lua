

local GameLoading = class( "GameLoading",BaseLayer )

function GameLoading:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param is nil !! " )
	GameLoading.super.ctor( self,param.name )
end




return GameLoading