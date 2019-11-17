
local GameLose = class("GameLose",BaseLayer)

function GameLose:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLose.super.ctor( self,param.name )
    self._param = param
    self:addCsb( "Lose.csb" )
    -- 再来一局
    self:addNodeClick( self.ButtonNext,{ 
        endCallBack = function() self:again() end
    })
end


function GameLose:onEnter()
    GameLose.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
    G_GetModel("Model_ZhanDou"):resetStage()
end





function GameLose:again()
    removeUIFromScene( UIDefine.MINIGAME_KEY.ZhanDou_Lose_UI )
    removeUIFromScene( UIDefine.MINIGAME_KEY.ZhanDou_Play_UI )
    addUIToScene( UIDefine.MINIGAME_KEY.ZhanDou_Play_UI )
end




return GameLose