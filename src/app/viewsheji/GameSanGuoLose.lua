
local GameSanGuoLose = class("GameSanGuoLose",BaseLayer)

function GameSanGuoLose:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameSanGuoLose.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbheji/csbsanguo/Loser.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonReturn,{ 
        endCallBack = function() self:close() end
    })
    -- 再来一局
    self:addNodeClick( self.ButtonGoOn,{ 
        endCallBack = function() self:again() end
    })
end


function GameSanGuoLose:onEnter()
    GameSanGuoLose.super.onEnter( self )

    casecadeFadeInNode( self._csbNode,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))

    if G_GetModel("Model_Sound"):isVoiceOpen() then
        audio.playSound("csbheji/csbsanguo/sgmp3/lost.mp3", false)
    end
end





function GameSanGuoLose:again()
    local coin = G_GetModel("Model_Heji"):getInstance():getCoin()
    if coin < 10 then
        removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_Lose_UI )
        removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_UI )
        addUIToScene( UIDefine.HEJI_KEY.Start_UI )
    else
        removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_Lose_UI )
        removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_UI )
        addUIToScene( UIDefine.HEJI_KEY.SanGuo_UI )
    end
end

-- 关闭
function GameSanGuoLose:close()
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_Lose_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_UI )
    addUIToScene( UIDefine.HEJI_KEY.Start_UI )
end



return GameSanGuoLose