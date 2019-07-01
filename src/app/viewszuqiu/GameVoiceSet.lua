

local GameVoiceSet = class( "GameVoiceSet",BaseLayer )


function GameVoiceSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameVoiceSet.super.ctor( self,param.name )


    self:addCsb( "csbzuqiu/Set.csb" )
	
	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end}
	)

	self:addNodeClick( self.ButtonMusic,{
		endCallBack = function ()
			self:setMusic()
		end}
	)

	self:addNodeClick( self.ButtonEffects,{
		endCallBack = function ()
			self:setVoice()
		end}
	)



	self:loadUi()
end

function GameVoiceSet:loadUi()
	local is_open = G_GetModel("Model_Sound"):isMusicOpen()
	if is_open then
		self.ImageOpen:loadTexture( "image/set/kai.png",1 )
		self.ImageOpen:setPositionX( 36 )
	else
		self.ImageOpen:loadTexture( "image/set/guan.png",1 )
		self.ImageOpen:setPositionX( 84 )
	end
	is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		self.ImageClose:loadTexture( "image/set/kai.png",1 )
		self.ImageClose:setPositionX( 36 )
	else
		self.ImageClose:loadTexture( "image/set/guan.png",1 )
		self.ImageClose:setPositionX( 84 )
	end

end

function GameVoiceSet:setMusic()
	local model = G_GetModel("Model_Sound")
	local is_open = model:isMusicOpen()
	if is_open then
		self.ImageOpen:loadTexture( "image/set/guan.png",1 )
		model:setMusicState(model.State.Closed)
		model:stopPlayBgMusic()
		self.ImageOpen:setPositionX( 84 )
	else
		self.ImageOpen:loadTexture( "image/set/kai.png",1 )
		model:setMusicState(model.State.Open)
		model:playBgMusic()
		self.ImageOpen:setPositionX( 36 )
	end
end

function GameVoiceSet:setVoice()
	local model = G_GetModel("Model_Sound")
	local is_open = model:isVoiceOpen()
	if is_open then
		self.ImageClose:loadTexture( "image/set/guan.png",1 )
		model:setVoiceState(model.State.Closed)
		self.ImageClose:setPositionX( 84 )
	else
		self.ImageClose:loadTexture( "image/set/kai.png",1 )
		model:setVoiceState(model.State.Open)
		self.ImageClose:setPositionX( 36 )
	end
end

function GameVoiceSet:onEnter( ... )
	GameVoiceSet.super.onEnter( self )
	casecadeFadeInNode( self.ImageShadow,0.5,150 )
	casecadeFadeInNode( self.Bg,0.5 )
end

function GameVoiceSet:close()
	removeUIFromScene( UIDefine.ZUQIU_KEY.Voice_UI )
end









return GameVoiceSet