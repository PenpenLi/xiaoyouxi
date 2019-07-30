
local GameTwentyOneHelp = class("GameTwentyOneHelp",BaseLayer)

function GameTwentyOneHelp:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameTwentyOneHelp.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbheji/csbtwentyone/Help.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
end


function GameTwentyOneHelp:onEnter()
    GameTwentyOneHelp.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

-- 关闭
function GameTwentyOneHelp:close()
    removeUIFromScene( UIDefine.HEJI_KEY.TwentyOne_Help_UI )
end




return GameTwentyOneHelp