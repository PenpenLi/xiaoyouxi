
local GameWin = class("GameWin",BaseLayer)

function GameWin:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameWin.super.ctor( self,param.name )

    self._param = param


    self:addCsb( "Win.csb" )

    -- 再来一局
    self:addNodeClick( self.ButtonNext,{ 
        endCallBack = function() self:again() end
    })

    self:loadUIData()
end


function GameWin:onEnter()
    GameWin.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
end

function GameWin:loadUIData()
    self.TextScore:setString( self._param.data.score )
end


function GameWin:again()
    removeUIFromScene( UIDefine.MINIGAME_KEY.ZhanDou_Win_UI )
    removeUIFromScene( UIDefine.MINIGAME_KEY.ZhanDou_Play_UI )
    addUIToScene( UIDefine.MINIGAME_KEY.ZhanDou_Play_UI )
end





return GameWin