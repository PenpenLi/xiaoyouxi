

local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )

    self:addCsb( "csbminigame/csblaba/Start.csb" )


    -- 开始
    self:addNodeClick( self.ButtonStart,{ 
        endCallBack = function() self:start() end
    })
    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end
    })
    -- 设置
    self:addNodeClick( self.ButtonSet,{ 
        endCallBack = function() self:set() end
    })
    -- 商店
    self:addNodeClick( self.ButtonShop,{ 
        endCallBack = function() self:shop() end
    })
    self:addNodeClick( self.ButtonReturn,{
        endCallBack = function ()
            self:fanhui()
        end
    })
end

function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )

    -- 打开login背景音乐
    if G_GetModel("Model_Sound"):isMusicOpen() then
        audio.playMusic("labamp3/bgmusic.mp3",true)
    end

    -- 初始化20铜币
    local coin = G_GetModel("Model_LaBa"):getCoin()
    if coin <= 0 then
        G_GetModel("Model_LaBa"):initCoin()
    end
end

function GameStart:start()
	removeUIFromScene( UIDefine.MINIGAME_KEY.LaBa_Start_UI )
	addUIToScene( UIDefine.MINIGAME_KEY.LaBa_Play_UI )
end

function GameStart:help()
    addUIToScene( UIDefine.MINIGAME_KEY.LaBa_Help_UI )
end

function GameStart:rank()
    addUIToScene( UIDefine.MINIGAME_KEY.LaBa_Rank_UI )
end

function GameStart:set()
    addUIToScene( UIDefine.MINIGAME_KEY.LaBa_Voice_UI )
end

function GameStart:shop()
    addUIToScene( UIDefine.MINIGAME_KEY.LaBa_Shop_UI )
end
function GameStart:fanhui()
    removeUIFromScene( UIDefine.MINIGAME_KEY.LaBa_Start_UI )
    -- 停止播放背景音乐
    audio.stopMusic()
    -- cc.FileUtils:getInstance():addSearchPath( "res" )
    cc.FileUtils:getInstance():addSearchPath( "res/csbminigame/csbdating" )
    local scene = require("app.scenes.MiniGameScene").new()
    display.runScene(scene)
end

return GameStart