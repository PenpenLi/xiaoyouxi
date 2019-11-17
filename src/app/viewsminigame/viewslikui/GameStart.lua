


local GameStart = class( "GameStart",BaseLayer )

function GameStart:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )

    self:addCsb( "csbminigame/csblikui/csblikuichinese/Start.csb" )
    -- self:addCsb( "csblikuichinese/Start.csb" )

    self:addNodeClick( self.ButtonLeft,{
    	endCallBack = function ()
    		self:left()
    	end
    })
    self:addNodeClick( self.ButtonRight,{
    	endCallBack = function ()
    		self:right()
    	end
    })
    self:addNodeClick( self.ButtonSound,{
    	endCallBack = function ()
    		self:setSound()
    	end
    })
    self:addNodeClick( self.ButtonMusic,{
    	endCallBack = function ()
    		self:setMusic()
    	end
    })
    self:addNodeClick( self.ButtonShop,{
    	endCallBack = function ()
    		self:openStore()
    	end
    })
    self:addNodeClick( self.ButtonPlay,{
    	endCallBack = function ()
    		self:play()
    	end
    })
    self:addNodeClick( self.ButtonRank,{
    	endCallBack = function ()
    		self:openRank()
    	end
    })

    self:addNodeClick( self.ButtonReturn,{
		endCallBack = function ()
			self:fanhui()
		end
	})

    self:loadUi()
end

function GameStart:loadUi()
	self.ButtonLeft:setVisible( false )
	local coin = G_GetModel("Model_LiKui"):getInstance():getCoin()
	if coin <= 0 then
		G_GetModel("Model_LiKui"):getInstance():initCoin( 50 )
	end

	local coin = G_GetModel("Model_LiKui"):getInstance():getCoin()
	self.TextCoin:setString( coin )
	

	local state = G_GetModel("Model_Sound"):isVoiceOpen()
	if state then
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
	else
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
		-- 变灰
		graySprite( self.ButtonSound:getVirtualRenderer():getSprite() )
	end
	state = G_GetModel("Model_Sound"):isMusicOpen()
	if state then
		self.ButtonMusic:loadTexture( "image/start/music.png",1 )
	else
		self.ButtonMusic:loadTexture( "image/start/music.png",1 )
		-- 变灰
		graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )
	end
end

function GameStart:onEnter()
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	G_GetModel( "Model_Sound" ):playBgMusic()
	self:loadHelp()

	-- 添加监听
	self:addMsgListener( InnerProtocol.INNER_EVENT_LIKUI_BUY,function ()
		local coin = G_GetModel("Model_LiKui"):getInstance():getCoin()
		self.TextCoin:setString( coin )
	end )
end

-- Help显示区域
function GameStart:loadHelp()
	self:schedule(function ()
		if self.Panel_2:getPositionY() > 0 then
			local left_moveby = cc.MoveBy:create( 0.5,cc.p( 0,-150 ))
			local right_moveby = cc.MoveBy:create( 0.5,cc.p( 0,-150 ))
			self.Panel_2:runAction( left_moveby )
			self.Panel_3:runAction( right_moveby )
		end
		if self.Panel_3:getPositionY() < 0 then
			local left_moveby = cc.MoveBy:create( 0.5,cc.p( 0,150 ))
			local right_moveby = cc.MoveBy:create( 0.5,cc.p( 0,150 ))
			self.Panel_2:runAction( left_moveby )
			self.Panel_3:runAction( right_moveby )
		end
	end,2 )
end
function GameStart:left()
	self.ButtonLeft:setVisible( false )
	self.ButtonRight:setVisible( true )
	if self.Panel1:getPositionX() < 0 then
		local left_moveby = nil
		local right_moveby = nil
		if likui_config.language == 2 then
			left_moveby = cc.MoveBy:create( 0.5,cc.p( 746,0 ))
			right_moveby = cc.MoveBy:create( 0.5,cc.p( 746,0 ))
		else
			left_moveby = cc.MoveBy:create( 0.5,cc.p( 715,0 ))
			right_moveby = cc.MoveBy:create( 0.5,cc.p( 715,0 ))
		end
		
		-- local apawn = cc.Spawn:create( left_moveby,right_moveby )
		self.Panel1:runAction( left_moveby )
		self.Panel2:runAction( right_moveby )
	end
end
function GameStart:right()
	self.ButtonLeft:setVisible( true )
	self.ButtonRight:setVisible( false )
	if self.Panel2:getPositionX() > 0 then
		local left_moveby = nil
		local right_moveby = nil
		if likui_config.language == 2 then
			left_moveby = cc.MoveBy:create( 0.5,cc.p( -746,0 ))
			right_moveby = cc.MoveBy:create( 0.5,cc.p( -746,0 ))
		else
			left_moveby = cc.MoveBy:create( 0.5,cc.p( -715,0 ))
			right_moveby = cc.MoveBy:create( 0.5,cc.p( -715,0 ))
		end
		
		-- local apawn = cc.Spawn:create( left_moveby,right_moveby )
		self.Panel1:runAction( left_moveby )
		self.Panel2:runAction( right_moveby )
	end
end

function GameStart:setMusic()
	local model = G_GetModel("Model_Sound"):getInstance()
	local is_open = model:isMusicOpen()
	if is_open then
		self.ButtonMusic:loadTexture( "image/start/music.png",1 )
		-- 变灰
		graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )
		model:setMusicState( model.State.Closed )
		model:stopPlayBgMusic()
	else
		self.ButtonMusic:loadTexture( "image/start/music.png",1 )
		ungraySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )
		model:setMusicState( model.State.Open )
		model:playBgMusic()
	end
end
function GameStart:setSound()
	local model = G_GetModel("Model_Sound"):getInstance()
	local is_open = model:isVoiceOpen()
	if is_open then
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
		-- 变灰
		graySprite( self.ButtonSound:getVirtualRenderer():getSprite() )
		model:setVoiceState( model.State.Closed )
	else
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
		ungraySprite( self.ButtonSound:getVirtualRenderer():getSprite() )
		model:setVoiceState( model.State.Open )
	end
end
function GameStart:openStore()
	addUIToScene( UIDefine.MINIGAME_KEY.LiKui_Shop_UI )
end
function GameStart:play()
	removeUIFromScene( UIDefine.MINIGAME_KEY.LiKui_Start_UI )
	addUIToScene( UIDefine.MINIGAME_KEY.LiKui_Play_UI )
end

function GameStart:openRank()
	addUIToScene( UIDefine.MINIGAME_KEY.LiKui_Rank_UI )
end
function GameStart:fanhui()
	removeUIFromScene( UIDefine.MINIGAME_KEY.LiKui_Start_UI )
	-- 停止播放背景音乐
	audio.stopMusic()
	-- cc.FileUtils:getInstance():addSearchPath( "res" )
	cc.FileUtils:getInstance():addSearchPath( "res/csbminigame/csbdating" )
	local scene = require("app.scenes.MiniGameScene").new()
	display.runScene(scene)
end


return GameStart