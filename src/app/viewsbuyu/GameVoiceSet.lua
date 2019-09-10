

local GameVoiceSet = class( "GameVoiceSet",BaseLayer )


function GameVoiceSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameVoiceSet.super.ctor( self,param.name )
    
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbbuyu/GameSet.csb" )

    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
    self:addNodeClick( self.ButtonMusicBg,{
    	endCallBack = function ()
    		self:setMusic()
    	end
    	-- scaleAction = false
    })
    self:addNodeClick( self.ButtonSoundBg,{
    	endCallBack = function ()
    		self:setVoice()
    	end
    	-- scaleAction = false
    })


    self:loadUi()
end

function GameVoiceSet:loadUi()
	local is_open = G_GetModel("Model_Sound"):isMusicOpen()
	if is_open then
		self.ImageMusic:loadTexture( "image/set/music1.png",1 )
		self.ImageMusic:setPositionX( 38 )
	else
		self.ImageMusic:loadTexture( "image/set/music2.png",1 )
		self.ImageMusic:setPositionX( 118 )
	end
	is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		self.ImageSound:loadTexture( "image/set/music1.png",1 )
		self.ImageSound:setPositionX( 38 )
	else
		self.ImageSound:loadTexture( "image/set/music2.png",1 )
		self.ImageSound:setPositionX( 118 )
	end
end

function GameVoiceSet:setMusic()
	local model = G_GetModel("Model_Sound")
	local is_open = model:isMusicOpen()
	if is_open then
		self.ImageMusic:loadTexture( "image/set/music2.png",1 )
		model:setMusicState(model.State.Closed)
		self.ImageMusic:setPositionX( 118 )
		model:stopPlayBgMusic()
	else
		self.ImageMusic:loadTexture( "image/set/music1.png",1 )
		model:setMusicState(model.State.Open)
		model:playBgMusic()
		self.ImageMusic:setPositionX( 38 )
	end
	-- body
end

function GameVoiceSet:setVoice()
	local model = G_GetModel("Model_Sound")
	local is_open = model:isVoiceOpen()
	if is_open then
		self.ImageSound:loadTexture( "image/set/music2.png",1 )
		model:setVoiceState(model.State.Closed)
		self.ImageSound:setPositionX( 118 )
	else
		self.ImageSound:loadTexture( "image/set/music1.png",1 )
		model:setVoiceState(model.State.Open)
		self.ImageSound:setPositionX( 38 )
	-- body
	end
end

function GameVoiceSet:onEnter()
	GameVoiceSet.super.onEnter( self )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
	-- body
end

function GameVoiceSet:close()
	removeUIFromScene( UIDefine.BUYU_KEY.Voice_UI )
	-- body
end




return GameVoiceSet


