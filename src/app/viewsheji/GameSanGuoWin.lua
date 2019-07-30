
local GameSanGuoWin = class("GameSanGuoWin",BaseLayer)

function GameSanGuoWin:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameSanGuoWin.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )

    self._layer = layer

    self:addCsb( "csbheji/csbsanguo/Win.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonReturn,{ 
        endCallBack = function() self:close() end
    })
    -- 再来一局
    self:addNodeClick( self.ButtonGoOn,{ 
        endCallBack = function() self:again() end
    })

    self:loadUIData()
end


function GameSanGuoWin:onEnter()
    GameSanGuoWin.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))

    -- 播放音效
    if G_GetModel("Model_Sound"):isVoiceOpen() then
        audio.playSound("csbheji/csbsanguo/sgmp3/win.mp3", false)
    end
end

function GameSanGuoWin:loadUIData()
    
end




function GameSanGuoWin:again()
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_Win_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_UI )
    addUIToScene( UIDefine.HEJI_KEY.SanGuo_UI )
end

-- 关闭
function GameSanGuoWin:close()
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_Win_UI )
    removeUIFromScene( UIDefine.HEJI_KEY.SanGuo_UI )
    addUIToScene( UIDefine.HEJI_KEY.Start_UI )
end



return GameSanGuoWin