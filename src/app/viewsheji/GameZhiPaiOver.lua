
local GameZhiPaiOver = class("GameZhiPaiOver",BaseLayer)

function GameZhiPaiOver:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameZhiPaiOver.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbheji/csbzhipai/Over.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonOk,{ 
        endCallBack = function() self:close() end
    })

    self.TextScore:setString( self._param.data.score )
end


function GameZhiPaiOver:onEnter()
    GameZhiPaiOver.super.onEnter( self )
    casecadeFadeInNode( self.ImageOverBg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end


-- 关闭
function GameZhiPaiOver:close()
    removeUIFromScene( UIDefine.HEJI_KEY.ZhiPai_Over_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.GameZhiPai_UI )
    addUIToScene( UIDefine.HEJI_KEY.Start_UI )
end




return GameZhiPaiOver