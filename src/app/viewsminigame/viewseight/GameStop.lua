

local GameStop = class( "GameStop",BaseLayer )

function GameStop:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameStop.super.ctor( self,param.name )

	self._parent = param.data

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
		self.ButtonMusic:loadTexture( "image/stop/MusicOn.png",1 )
		-- graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )--变灰
		-- G_GetModel("Model_Sound"):getInstance():playBgMusic()
	else
		self.ButtonMusic:loadTexture( "image/stop/MusicOff.png",1 )
		-- G_GetModel("Model_Sound"):getInstance():stopPlayBgMusic()
	end
	local is_open = G_GetModel("Model_Sound"):getInstance():isVoiceOpen()
	if is_open then
		self.ButtonSound:loadTexture( "image/stop/SoundOn.png",1 )
	else
		self.ButtonSound:loadTexture( "image/stop/SoundOff.png",1 )
	end
end
function GameStop:menu()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Eight_Stop_UI )
	removeUIFromScene( UIDefine.MINIGAME_KEY.Eight_Play_UI )
	addUIToScene( UIDefine.MINIGAME_KEY.Eight_Start_UI )
end
function GameStop:continue()
	self._parent:resume()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Eight_Stop_UI )
end

function GameStop:setMusic()
	local user_default = G_GetModel("Model_Sound"):getInstance()
	local is_open = user_default:isMusicOpen()
	if is_open then
		self.ButtonMusic:loadTexture( "image/stop/MusicOff.png",1 )
		-- graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )-----变灰
		user_default:setMusicState( G_GetModel("Model_Sound").State.Closed )
		user_default:stopPlayBgMusic()
	else
		self.ButtonMusic:loadTexture( "image/stop/MusicOn.png",1 )
		user_default:setMusicState( G_GetModel("Model_Sound").State.Open )
		user_default:playBgMusic()
	end
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_EIGHT_MUSIC )--发送监听消息
end

function GameStop:setSound()
	local user_default = G_GetModel("Model_Sound"):getInstance()
	local is_open = user_default:isVoiceOpen()
	if is_open then
		self.ButtonSound:loadTexture( "image/stop/SoundOff.png",1 )
		user_default:setVoiceState( user_default.State.Closed )
	else
		self.ButtonSound:loadTexture( "image/stop/SoundOn.png",1 )
		user_default:setVoiceState( user_default.State.Open )
	end
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_EIGHT_MUSIC )--发送监听消息
end

function GameStop:onEnter()
	GameStop.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end







return GameStop