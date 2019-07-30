
local GameSanGuoLiuJu = class("GameSanGuoLiuJu",BaseLayer)

function GameSanGuoLiuJu:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameSanGuoLiuJu.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbheji/csbsanguo/LiuJu.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonReturn,{ 
        endCallBack = function() self:close() end
    })
    -- 再来一局
    self:addNodeClick( self.ButtonGoOn,{ 
        endCallBack = function() self:again() end
    })
end


function GameSanGuoLiuJu:onEnter()
    GameSanGuoLiuJu.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function GameSanGuoLiuJu:again()
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_LiuJu_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_UI )
    addUIToScene( UIDefine.HEJI_KEY.SanGuo_UI )
end

-- 关闭
function GameSanGuoLiuJu:close()
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_LiuJu_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_UI )
    addUIToScene( UIDefine.HEJI_KEY.Start_UI )
end




return GameSanGuoLiuJu