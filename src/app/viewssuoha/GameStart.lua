

local GameStart = class( "GameStart",BaseLayer )

function GameStart:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameStart.super.ctor( self,param.name )

	self:addCsb( "Start.csb" )

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
	removeUIFromScene( UIDefine.SUOHA_KEY.Start_UI )
	addUIToScene( UIDefine.SUOHA_KEY.Play_UI )
end
function GameStart:rules()
	addUIToScene( UIDefine.SUOHA_KEY.Help_UI )
end
function GameStart:learders()
	addUIToScene( UIDefine.SUOHA_KEY.Rank_UI )
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
	addUIToScene( UIDefine.SUOHA_KEY.Shop_UI )
end





return GameStart