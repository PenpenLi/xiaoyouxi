

local GameVoiceSet = class( "GameVoiceSet",BaseLayer )


function GameVoiceSet:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameVoiceSet.super.ctor( self,param.name )

	self._layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ))
	self:addChild( self._layer )

	self:addCsb( "Set.csb" )


	self:addNodeClick( self.ButtonMusic,{
		endCallBack = function ()
			self:setMusic()
		end
	})

	self:addNodeClick( self.ButtonSound,{
		endCallBack = function ()
			self:setVoice()
		end
	})

	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end
	})
end

function GameVoiceSet:loadUi()
	local start = G_GetModel("Model_Sound"):getInstance():isMusicOpen()
	if start then
		self.ButtonMusic:loadTexture( "image/set/on.png" )
	else
		self.ButtonMusic:loadTexture( "image/set/off.png" )
	end
	start = G_GetModel("Model_Sound"):getInstance():isVoiceOpen()
	if start then
		self.ButtonSound:loadTexture( "image/set/on.png" )
	else
		self.ButtonSound:loadTexture( "image/set/off.png" )
	end
end

function GameVoiceSet:onEnter()
	GameVoiceSet.super.onEnter( self )

	casecadeFadeInNode( self._layer,0.5,150 )
	casecadeFadeInNode( self._csbNode,0.5 )
	self:loadUi()
end

function GameVoiceSet:setMusic()
	local model = G_GetModel("Model_Sound"):getInstance()-----这里用不用getInstance()，有什么区别？？？？？？？？？？？？
	local is_open = model:isMusicOpen()
	if is_open then
		model:setMusicState( model.State.Closed )------Model_Sound.State.Closed这句是错的，这里不是这个方法取
		model:stopPlayBgMusic()
		self.ButtonMusic:loadTexture( "image/set/off.png",1 )
	else
		model:setMusicState( model.State.Open )
		model:playBgMusic()
		self.ButtonMusic:loadTexture( "image/set/on.png",1 )
	end
end

function GameVoiceSet:setVoice()--------------------------------音效是怎么控制的，没太明白，DEBUG大于1？就关闭？
	local model = G_GetModel("Model_Sound"):getInstance()-----这里用不用getInstance()，有什么区别？？？？？？？？？？？？
	local is_open = model:isVoiceOpen()
	if is_open then
		model:setVoiceState( model.State.Closed )
		self.ButtonSound:loadTexture( "image/set/off.png",1 )
	else
		model:setVoiceState( model.State.Open )
		self.ButtonSound:loadTexture( "image/set/on.png",1 )
	end
end


function GameVoiceSet:close()
	removeUIFromScene( UIDefine.SUOHA_KEY.Voice_UI )
end



















return GameVoiceSet