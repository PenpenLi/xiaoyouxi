

local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbzuqiu/Start.csb" )

    -- -- 开始
    -- self:addNodeClick( self.ButtonStart,{ 
    --     endCallBack = function() self:start() end,
    -- })
    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end,
    })

    -- 设置
    self:addNodeClick( self.ButtonOptions,{ 
        endCallBack = function() self:set() end
    })

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
	-- removeUIFromScene( UIDefine.ZHIPAI_KEY.Start_UI )
	-- addUIToScene( UIDefine.ZHIPAI_KEY.Play_UI,{ level = 1 } )
end

function GameStart:help()
    -- addUIToScene( UIDefine.ZHIPAI_KEY.Help_UI )
end

function GameStart:set()
    -- addUIToScene( UIDefine.ZHIPAI_KEY.Voice_UI )
end

return GameStart