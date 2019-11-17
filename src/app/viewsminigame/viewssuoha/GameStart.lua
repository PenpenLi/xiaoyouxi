

local GameStart = class( "GameStart",BaseLayer )

function GameStart:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameStart.super.ctor( self,param.name )

	self:addCsb( "csbminigame/csbsuoha/Start.csb" )

	--开始
	self:addNodeClick( self.ButtonPlay,{
		endCallBack = function ()
			self:start()
		end
	})
	--帮助
	self:addNodeClick( self.ButtonRules,{
		endCallBack = function ()
			self:rules()
		end
	})
	--排行榜
	self:addNodeClick( self.ButtonLeaders,{
		endCallBack = function ()
			self:learders()
		end
	})
	--音乐
	self:addNodeClick( self.ButtonMusic,{
		endCallBack = function ()
			self:setMusic()
		end
	})
	--商店
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
	-- self:loadCoin()
end

function GameStart:loadCoin(  )

	local coin = G_GetModel("Model_SuoHa"):getInstance():getCoin()
	-- dump( coin,"-----------coin = ")
end
function GameStart:onEnter( ... )
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	-- local coin = G_GetModel("Model_SuoHa"):getInstance():getCoin()
	-- local model = G_GetModel("Model_SuoHa"):getInstance()
	-- local coin = model:getCoin()

	self:loadCoin()
	
	self:loadMusic()
end

function GameStart:loadMusic()
	local model = G_GetModel("Model_Sound"):getInstance()
	local is_open = model:isMusicOpen()
	if is_open then
		model:playBgMusic()
		self.ButtonMusic:loadTexture( "image/start/musicOpen.png",1 )
	else
		self.ButtonMusic:loadTexture( "image/start/musicClose.png",1 )
	end
end

function GameStart:start()
	removeUIFromScene( UIDefine.MINIGAME_KEY.SuoHa_Start_UI )
	addUIToScene( UIDefine.MINIGAME_KEY.SuoHa_Play_UI )
end
function GameStart:rules()
	addUIToScene( UIDefine.MINIGAME_KEY.SuoHa_Help_UI )
end
function GameStart:learders()
	addUIToScene( UIDefine.MINIGAME_KEY.SuoHa_Rank_UI )
end
function GameStart:setMusic()
	-- addUIToScene( UIDefine.SUOHA_KEY.Voice_UI )
	local model = G_GetModel("Model_Sound"):getInstance()
	local is_open = model:isMusicOpen()
	if is_open then
		model:setMusicState( model.State.Closed )
		model:stopPlayBgMusic()
		self.ButtonMusic:loadTexture( "image/start/musicClose.png",1 )
	else
		model:setMusicState( model.State.Open )
		model:playBgMusic()
		self.ButtonMusic:loadTexture( "image/start/musicOpen.png",1 )
	end
end
function GameStart:store()
	addUIToScene( UIDefine.MINIGAME_KEY.SuoHa_Shop_UI )
end
function GameStart:fanhui()
	removeUIFromScene( UIDefine.MINIGAME_KEY.SuoHa_Start_UI )
	-- 停止播放背景音乐
	audio.stopMusic()
	-- cc.FileUtils:getInstance():addSearchPath( "res" )
	cc.FileUtils:getInstance():addSearchPath( "res/csbminigame/csbdating" )
	local scene = require("app.scenes.MiniGameScene").new()
	display.runScene(scene)
end




return GameStart