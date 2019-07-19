

local GameStop = class( "GameStop",BaseLayer )

function GameStop:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameStop.super.ctor( self,param.name )

	self:addCsb( "csbeight/Stop.csb" )

	self:addNodeClick( self.ButtonMenu,{
		endCallBack = function ()
			self:menu()
		end
	})
	self:addNodeClick( self.ButtonContinue,{
		endCallBack = function ()
			self:continue()
		end
	})
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



	self:loadUi()
end

function GameStop:loadUi()
	local is_open = G_GetModel("Model_Sound"):getInstance():isMusicOpen()
	if is_open then
		self.ButtonMusic:loadTexture( "image/stop/MusicOn.png" )
		-- graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )--变灰
		-- G_GetModel("Model_Sound"):getInstance():playBgMusic()
	else
		self.ButtonMusic:loadTexture( "image/stop/MusicOff.png" )
		-- G_GetModel("Model_Sound"):getInstance():stopPlayBgMusic()
	end
	local is_open = G_GetModel("Model_Sound"):getInstance():isVoiceOpen()
	if is_open then
		self.ButtonSound:loadTexture( "image/stop/SoundOn.png" )
	else
		self.ButtonSound:loadTexture( "image/stop/SoundOff.png" )
	end
end
function GameStop:menu()
	
end
function GameStop:continue()
	-- body
end

function GameStop:setMusic()
	local user_default = G_GetModel("Model_Sound"):getInstance()
	local is_open = user_default:isMusicOpen()
	if is_open then
		self.ButtonMusic:loadTexture( "image/stop/MusicOn.png" )
		graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )
		user_default:setMusicState( G_GetModel("Model_Sound").State.Closed )
		user_default:stopPlayBgMusic()
	else
		self.ButtonMusic:loadTexture( "image/stop/MusicOn.png" )
		user_default:setMusicState( G_GetModel("Model_Sound").State.Open )
		user_default:playBgMusic()
	end
end

function GameStop:setSound()
	local user_default = G_GetModel("Model_Sound"):getInstance()
	local is_open = user_default:isVoiceOpen()
	if is_open then
		self.ButtonSound:loadTexture( "image/stop/SoundOff.png" )
		user_default:setVoiceState( user_default.State.Closed )
	else
		self.ButtonSound:loadTexture( "image/stop/SoundOff.png" )
		user_default:setVoiceState( user_default.State.Open )
	end
end

function GameStop:onEnter()
	GameStop.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end







return GameStop