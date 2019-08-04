

local GameVoiceSet = class( "GameVoiceSet",BaseLayer )

function GameVoiceSet:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param is nil " )
	GameVoiceSet.super.ctor( self,param.name )

	local layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ))
	self:addChild( layer )
	self._layer = layer

	self:addCsb( "csbheji/csbdating/Set.csb" )

	self:addNodeClick( self.ButtonMusic,{
		endCallBack = function ()
			self:setMusic()
		end
	})
	self:addNodeClick( self.ButtonSound,{
		endCallBack = function ()
			self:setSound()
		end
	})
	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end
	})

	self:loadUi()
end

function GameVoiceSet:loadUi()
	local state = G_GetModel("Model_Sound"):getInstance():isMusicOpen()
	if state then
		self.ButtonMusic:loadTexture( "imagedating/set/on.png",1 )
	else
		self.ButtonMusic:loadTexture( "imagedating/set/off.png",1 )
	end
	state = G_GetModel("Model_Sound"):getInstance():isVoiceOpen()
	if state then
		self.ButtonSound:loadTexture( "imagedating/set/on.png",1 )
	else
		self.ButtonSound:loadTexture( "imagedating/set/off.png",1 )
	end
end

function GameVoiceSet:setMusic()
	local model = G_GetModel("Model_Sound"):getInstance()
	local is_open = model:isMusicOpen()
	if is_open then
		self.ButtonMusic:loadTexture( "imagedating/set/off.png",1 )
		model:setMusicState( model.State.Closed )
		model:stopPlayBgMusic()
	else
		self.ButtonMusic:loadTexture( "imagedating/set/on.png",1 )
		model:setMusicState( model.State.Open )
		model:playBgMusic()
	end
end

function GameVoiceSet:setSound()
	local model = G_GetModel("Model_Sound"):getInstance()
	local is_open = model:isVoiceOpen()
	if is_open then
		self.ButtonSound:loadTexture( "imagedating/set/off.png",1 )
		model:setVoiceState( model.State.Closed )
	else
		self.ButtonSound:loadTexture( "imagedating/set/on.png",1 )
		model:setVoiceState( model.State.Open )
	end
	
end
function GameVoiceSet:onEnter()
	GameVoiceSet.super.onEnter( self )
	casecadeFadeInNode( self.bg,0.5)
	casecadeFadeInNode( self._layer,0.5,150 )
end

function GameVoiceSet:close()
	removeUIFromScene( UIDefine.HEJI_KEY.Voice_UI )
end



return GameVoiceSet