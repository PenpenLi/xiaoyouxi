

local GameVoiceSet = class( "GameVoiceSet",BaseLayer )


function GameVoiceSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameVoiceSet.super.ctor( self,param.name )

    local layer = cc.LayerColor:create( cc.c4b(0,0,0,150) )
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "Set.csb")

    self:addNodeClick( self.ButtonMusic,{
    	endCallBack = function ()
    		self:setMusic()
    	end
    })

    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
	-- body
	self:loadUi()
end

function GameVoiceSet:loadUi()
	local is_open = G_GetModel( "Model_Sound" ):isMusicOpen()
	if zhandou_config.lang == 1 then
		if is_open then
			self.ButtonMusic:loadTexture( "image/set/kaibg.png",1 )
			self.ImageMusic:loadTexture( "image/set/kai.png",1 )
			self.ImageMusic:setPositionX( 32 )
		else
			self.ButtonMusic:loadTexture( "image/set/guanbg.png",1 )
			self.ImageMusic:loadTexture( "image/set/guan.png",1 )
			self.ImageMusic:setPositionX( 122 )
		end
	else
		if is_open then
			self.ButtonMusic:loadTexture( "image/set/kaibg.png",1 )
			self.ImageMusic:loadTexture( "image/set/kai.png",1 )
			self.ImageMusic:setPositionX( 38 )
		else
			self.ButtonMusic:loadTexture( "image/set/guanbg.png",1 )
			self.ImageMusic:loadTexture( "image/set/guan.png",1 )
			self.ImageMusic:setPositionX( 187 )
		end
	end
end

function GameVoiceSet:setMusic()
	local model = G_GetModel( "Model_Sound" )
	local is_open = model:isMusicOpen()
	if zhandou_config.lang == 1 then
		if is_open then
			self.ButtonMusic:loadTexture( "image/set/guanbg.png",1 )
			self.ImageMusic:loadTexture( "image/set/guan.png",1 )
			self.ImageMusic:setPositionX( 122 )
			model:setMusicState( model.State.Closed )
			model:stopPlayBgMusic()
			model:setVoiceState( model.State.Closed )
		else
			self.ButtonMusic:loadTexture( "image/set/kaibg.png",1 )
			self.ImageMusic:loadTexture( "image/set/kai.png",1 )
			self.ImageMusic:setPositionX( 32 )
			model:setMusicState( model.State.Open )
			model:playBgMusic()
			model:setVoiceState( model.State.Open )
		end
	else
		if is_open then
			self.ButtonMusic:loadTexture( "image/set/guanbg.png",1 )
			self.ImageMusic:loadTexture( "image/set/guan.png",1 )
			self.ImageMusic:setPositionX( 187 )
			model:setMusicState( model.State.Closed )
			model:stopPlayBgMusic()
			model:setVoiceState( model.State.Closed )
		else
			self.ButtonMusic:loadTexture( "image/set/kaibg.png",1 )
			self.ImageMusic:loadTexture( "image/set/kai.png",1 )
			self.ImageMusic:setPositionX( 38 )
			model:setMusicState( model.State.Open )
			model:playBgMusic()
			model:setVoiceState( model.State.Open )
		end
	end
end

function GameVoiceSet:onEnter()
	GameVoiceSet.super.onEnter( self )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
end


function GameVoiceSet:close()
	removeUIFromScene( UIDefine.ZHANDOU_KEY.Voice_UI )
	-- body
end

return GameVoiceSet