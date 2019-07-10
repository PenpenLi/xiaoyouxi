

local GameLose = class( "GameLose",BaseLayer )


function GameLose:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLose.super.ctor( self,param.name )
    self._countryIndex = param.data.country_index
    self:addCsb( "csbzuqiu/Lose.csb" )
    self:addNodeClick( self.ButtonNext,{
    	endCallBack = function ()
    		self:next()
    	end
    })
end

function GameLose:next()
	local index = self._countryIndex
	removeUIFromScene( UIDefine.ZUQIU_KEY.Lose_UI )
	removeUIFromScene( UIDefine.ZUQIU_KEY.Play_UI )
	addUIToScene( UIDefine.ZUQIU_KEY.Play_UI,{ country_index = index } )
end

function GameLose:onEnter()
	GameLose.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end










return GameLose