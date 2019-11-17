

local GameWin = class( "GameWin",BaseLayer )


function GameWin:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameWin.super.ctor( self,param.name )
    self._countryIndex = param.data.country_index
    self._layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ))
    self:addChild( self._layer )
    self:addCsb( "Win.csb" )
    self:addNodeClick( self.ButtonNext,{
    	endCallBack = function ()
    		self:next()
    	end
    })
end

function GameWin:next()
	local index = self._countryIndex
	removeUIFromScene( UIDefine.MINIGAME_KEY.ZuQiu_Win_UI )
	removeUIFromScene( UIDefine.MINIGAME_KEY.ZuQiu_Play_UI )
	addUIToScene( UIDefine.MINIGAME_KEY.ZuQiu_Play_UI,{ country_index = index } )
end

function GameWin:onEnter()
	GameWin.super.onEnter( self )
	casecadeFadeInNode( self._layer,0.5,150 )
	casecadeFadeInNode( self._csbNode,0.5 )
end



return GameWin