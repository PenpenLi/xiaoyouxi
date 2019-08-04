

local GameZhiPaiPass = class("GameZhiPaiPass",BaseLayer)




function GameZhiPaiPass:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameZhiPaiPass.super.ctor( self,param.name )

    self._param = param
    self._nextLevel = param.data.level

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbheji/csbzhipai/Pass.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonNextLevel,{ 
        endCallBack = function() self:close() end
    })
end


function GameZhiPaiPass:onEnter()
    GameZhiPaiPass.super.onEnter( self )
    casecadeFadeInNode( self.ImagePassBg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

-- 关闭
function GameZhiPaiPass:close()
    local next_level = self._nextLevel
    removeUIFromScene( UIDefine.HEJI_KEY.ZhiPai_Pass_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.GameZhiPai_UI )
    addUIToScene( UIDefine.HEJI_KEY.GameZhiPai_UI,{ level = next_level } )
end




















return GameZhiPaiPass