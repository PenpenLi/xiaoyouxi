
local NodeCountry = import( ".NodeCountry")
local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbminigame/csbzuqiu/Start.csb" )

    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end,
    })

    -- 设置
    self:addNodeClick( self.ButtonOptions,{ 
        endCallBack = function() self:set() end
    })
    self:addNodeClick( self.Image_1,{
        endCallBack = function ()
            self:fanhui()
        end
    })

    self:loadUi()
end

function GameStart:loadUi(  )
    local x = 248
    local y = 367
    self._number = 1--记录几号球队
    for i = 1,3 do
        if zuqiu_card_lang == 1 then
            for j = 1,5 do
                local node = NodeCountry.new( self._number )
                self.ImageChooseBg:addChild( node )
                node:setPosition( x + j * 123 - 123,y - i * 122 + 122)
                self._number = self._number + 1
                if self._number > 16 then
                    return
                end
            end
        else
            for j = 1,6 do
                local node = NodeCountry.new( self._number )
                self.ImageChooseBg:addChild( node )
                node:setPosition( x + j * 123 - 123,y - i * 122 + 122)
                self._number = self._number + 1
                if self._number > 16 then
                    return
                end
            end
        end
    end
end

function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )

    -- 播放背景音乐
    G_GetModel("Model_Sound"):playBgMusic()

    -- 初始化20铜币
    -- local coin = G_GetModel("Model_ZhiPai"):getCoin()
    -- if coin <= 0 then
    --     G_GetModel("Model_ZhiPai"):initCoin()
    -- end
end

function GameStart:start()
	removeUIFromScene( UIDefine.MINIGAME_KEY.ZuQiu_Start_UI )
	addUIToScene( UIDefine.MINIGAME_KEY.ZuQiu_Play_UI,{ level = 1 } )
end

function GameStart:help()
    addUIToScene( UIDefine.MINIGAME_KEY.ZuQiu_Help_UI )
end

function GameStart:set()
    addUIToScene( UIDefine.MINIGAME_KEY.ZuQiu_Voice_UI )
end

function GameStart:fanhui()
    removeUIFromScene( UIDefine.MINIGAME_KEY.ZuQiu_Start_UI )
    -- 停止播放背景音乐
    audio.stopMusic()
    -- cc.FileUtils:getInstance():addSearchPath( "res" )
    cc.FileUtils:getInstance():addSearchPath( "res/csbminigame/csbdating" )
    local scene = require("app.scenes.MiniGameScene").new()
    display.runScene(scene)
end

return GameStart