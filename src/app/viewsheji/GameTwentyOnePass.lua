
local GameTwentyOnePass = class("GameTwentyOnePass",BaseLayer)

function GameTwentyOnePass:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameTwentyOnePass.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbheji/csbtwentyone/Pass.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:close() end
    })

    self.TextScore:setString( self._param.data.score )
end


function GameTwentyOnePass:onEnter()
    GameTwentyOnePass.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

-- 关闭
function GameTwentyOnePass:close()
    removeUIFromScene( UIDefine.HEJI_KEY.TwentyOne_Pass_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.GameTwentyOne_UI )
    addUIToScene( UIDefine.HEJI_KEY.Start_UI )
end




return GameTwentyOnePass