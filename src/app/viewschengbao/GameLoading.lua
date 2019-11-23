

local GameLoading = class( "GameLoading",BaseLayer )

function GameLoading:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )

	self:addCsb( "csbchengbao/Loading.csb" )

	self._plist = {
		
	}

end

function GameLoading:onEnter()
	GameLoading.super.onEnter(self)
end




return GameLoading