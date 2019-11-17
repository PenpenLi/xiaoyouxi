
local GameStart = class( "GameStart",BaseLayer )


function GameStart:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameStart.super.ctor( self,param.name )

	self:addCsb( "csbminigame/csbeight/Start.csb" )

	self:addNodeClick( self.ButtonPlay,{
		endCallBack = function ()
			self:play()
		end
	})
	self:addNodeClick( self.ButtonHelp,{
		endCallBack = function ()
			self:help()
		end
	})
	self:addNodeClick( self.ButtonStore,{
		endCallBack = function ()
			self:store()
		end
	})
	self:addNodeClick( self.ButtonReturn,{
		endCallBack = function ()
			self:fanhui()
		end
	})

	self:loadCoin()
end

function GameStart:loadCoin()
	G_GetModel("Model_Eight"):getInstance():resetAICoin()
	G_GetModel("Model_Eight"):getInstance():getCoin()
end

function GameStart:onEnter()
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	G_GetModel( "Model_Sound" ):playBgMusic()

end

function GameStart:play()
	local coin = G_GetModel("Model_Eight"):getCoin()
	if coin <= 0 then
		addUIToScene( UIDefine.MINIGAME_KEY.Eight_Shop_UI )
	else
		addUIToScene( UIDefine.MINIGAME_KEY.Eight_Play_UI )
	end
	
end

function GameStart:help()
	addUIToScene( UIDefine.MINIGAME_KEY.Eight_Help_UI )
end

function GameStart:store()
	addUIToScene( UIDefine.MINIGAME_KEY.Eight_Shop_UI )
end


function GameStart:fanhui()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Eight_Start_UI )
	-- 停止播放背景音乐
	audio.stopMusic()
	-- cc.FileUtils:getInstance():addSearchPath( "res" )
	cc.FileUtils:getInstance():addSearchPath( "res/csbminigame/csbdating" )
	local scene = require("app.scenes.MiniGameScene").new()
	display.runScene(scene)
end



















return GameStart