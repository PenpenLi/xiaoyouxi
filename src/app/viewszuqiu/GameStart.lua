
local nodeCountry = import( ".NodeCountry")
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

    self:loadUi()

end

function GameStart:loadUi(  )
    local node1 = nodeCountry.new( self,1 )
    self.ImageChooseBg:addChild( node1 )
    node1:setPosition( 248,367 )--372,367---248,235
    -- dump( cc.p(node1:getPosition()),"-------------pos = ")
    local x = 248
    local y = 367
    self._number = 1--记录几号球队
    for i = 1,3 do
        for j = 1,6 do
            local node = nodeCountry.new( self,self._number )
            self.ImageChooseBg:addChild( node )
            node:setPosition( x + j * 123 - 123,y - i * 122 + 122)
            -- dump( cc.p(node:getPosition()),"-------------pospppppp = ")

            self._number = self._number + 1
            if self._number > 16 then
                return
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
	-- removeUIFromScene( UIDefine.ZHIPAI_KEY.Start_UI )
	-- addUIToScene( UIDefine.ZHIPAI_KEY.Play_UI,{ level = 1 } )
end

function GameStart:help()
    addUIToScene( UIDefine.ZUQIU_KEY.Help_UI )
end

function GameStart:set()
    addUIToScene( UIDefine.ZUQIU_KEY.Voice_UI )
end

return GameStart