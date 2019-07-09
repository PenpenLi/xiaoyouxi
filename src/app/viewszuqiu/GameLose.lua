

local GameLose = class( "GameLose",BaseLayer )


function GameLose:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLose.super.ctor( self,param.name )


    self:addCsb( "csbzuqiu/Lose.csb" )

    self:addNodeClick( self.ButtonNext,{
    	endCallBack = function ()
    		self:next()
    	end
    })
end

function GameLose:next()
	removeUIFromScene( UIDefine.ZUQIU_KEY.Lose_UI )
end

function GameLose:onEnter()
	GameLose.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end










return GameLose