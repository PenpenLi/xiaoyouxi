
local GameTwentyOneOver = class("GameTwentyOneOver",BaseLayer)

function GameTwentyOneOver:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameTwentyOneOver.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbheji/csbtwentyone/Over.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonNo,{ 
        endCallBack = function() self:close() end
    })

    -- 继续
    self:addNodeClick( self.ButtonYes,{ 
        endCallBack = function() self:continue() end
    })

    self.TextScore:setString( self._param.data.score )
end


function GameTwentyOneOver:onEnter()
    GameTwentyOneOver.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function GameTwentyOneOver:continue()
    removeUIFromScene( UIDefine.HEJI_KEY.TwentyOne_Over_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.GameTwentyOne_UI )
    addUIToScene( UIDefine.HEJI_KEY.GameTwentyOne_UI )
end

-- 关闭
function GameTwentyOneOver:close()
    removeUIFromScene( UIDefine.HEJI_KEY.TwentyOne_Over_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.GameTwentyOne_UI )
    addUIToScene( UIDefine.HEJI_KEY.Start_UI )
end




return GameTwentyOneOver