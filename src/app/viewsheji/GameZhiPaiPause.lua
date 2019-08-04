

local GameZhiPaiPause = class( "GameZhiPaiPause",BaseLayer )



function GameZhiPaiPause:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameZhiPaiPause.super.ctor( self,param.name )
    
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer

    self._parent = param.data.layer

    self:addCsb( "csbheji/csbzhipai/Pause.csb" )

    self:addNodeClick( self.ButtonGoOn,{
    	endCallBack = function ()
    		self:close()
    	end
    })
    self:addNodeClick( self.ButtonMusicBg,{
    	endCallBack = function ()
    		self:setMusic()
    	end,
    	scaleAction = false
    })
    self:addNodeClick( self.ButtonSoundBg,{
    	endCallBack = function ()
    		self:setVoice()
    	end,
    	scaleAction = false
    })


    self:loadUi()
end

function GameZhiPaiPause:loadUi()
	local is_open = G_GetModel("Model_Sound"):isMusicOpen()
	if is_open then
		self.ImageMusic:loadTexture( "imagezhipai/pause/kai.png",1 )
		self.ImageMusic:setPositionX( 34 )
	else
		self.ImageMusic:loadTexture( "imagezhipai/pause/guan.png",1 )
		self.ImageMusic:setPositionX( 114 )
	end
	is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		self.ImageEffect:loadTexture( "imagezhipai/pause/kai.png",1 )
		self.ImageEffect:setPositionX( 34 )
	else
		self.ImageEffect:loadTexture( "imagezhipai/pause/guan.png",1 )
		self.ImageEffect:setPositionX( 114 )
	end
end

function GameZhiPaiPause:setMusic()
	local model = G_GetModel("Model_Sound")
	local is_open = model:isMusicOpen()
	if is_open then
		self.ImageMusic:loadTexture( "imagezhipai/pause/guan.png",1 )
		model:setMusicState(model.State.Closed)
		model:stopPlayBgMusic()
		self.ImageMusic:setPositionX( 114 )
	else
		self.ImageMusic:loadTexture( "imagezhipai/pause/kai.png",1 )
		model:setMusicState(model.State.Open)
		model:playBgMusic()
		self.ImageMusic:setPositionX( 34 )
	end
	-- body
end

function GameZhiPaiPause:setVoice()
	local model = G_GetModel("Model_Sound")
	local is_open = model:isVoiceOpen()
	if is_open then
		self.ImageEffect:loadTexture( "imagezhipai/pause/guan.png",1 )
		model:setVoiceState(model.State.Closed)
		self.ImageEffect:setPositionX( 114 )
	else
		self.ImageEffect:loadTexture( "imagezhipai/pause/kai.png",1 )
		model:setVoiceState(model.State.Open)
		self.ImageEffect:setPositionX( 34 )
	end
end

function GameZhiPaiPause:onEnter()
	GameZhiPaiPause.super.onEnter( self )
	casecadeFadeInNode( self.ImagePauseBg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
end

function GameZhiPaiPause:close()
	self._parent:startSchedule()
	removeUIFromScene( UIDefine.HEJI_KEY.ZhiPai_Pause_UI)
end




return GameZhiPaiPause