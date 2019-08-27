

local GameSet = class( "GameSet",BaseLayer )

function GameSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameSet.super.ctor( self,param.name )
    local layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbslot/hall/GameSet.csb")

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
end
function GameSet:onEnter()
	GameSet.super.onEnter( self )
	self:loadUi()
end
function GameSet:loadUi( ... )
	local state = G_GetModel("Model_Sound"):getInstance():isMusicOpen()
	if state then
		self.ImageMusic:loadTexture( "image/set/kai.png",1 )
		self.ImageMusic:setPositionX( 83 )
	else
		self.ImageMusic:loadTexture( "image/set/guan.png",1 )
		self.ImageMusic:setPositionX( 37 )
	end
	state = G_GetModel("Model_Sound"):getInstance():isVoiceOpen()
	if state then
		self.ImageSound:loadTexture( "image/set/kai.png",1 )
		self.ImageSound:setPositionX( 83 )
	else
		self.ImageSound:loadTexture( "image/set/guan.png",1 )
		self.ImageSound:setPositionX( 37 )
	end
end

function GameSet:setMusic( ... )
	local is_open = G_GetModel("Model_Sound"):getInstance():isMusicOpen()
	if is_open then
		self.ImageMusic:loadTexture( "image/set/guan.png",1 )
		self.ImageMusic:setPositionX( 37 )
		G_GetModel("Model_Sound"):stopPlayBgMusic()
	else
		self.ImageMusic:loadTexture( "image/set/kai.png",1 )
		self.ImageMusic:setPositionX( 83 )
		G_GetModel("Model_Sound"):playBgMusic()
	end
end
function GameSet:setSound( ... )
	local is_open = G_GetModel("Model_Sound"):getInstance():isVoiceOpen()
	if is_open then
		self.ImageSound:loadTexture( "image/set/guan.png",1 )
		self.ImageSound:setPositionX( 37 )
	else
		self.ImageSound:loadTexture( "image/set/kai.png",1 )
		self.ImageSound:setPositionX( 83 )
	end
end
function GameSet:close( ... )
	removeUIFromScene( UIDefine.SLOT_KEY.Set_UI )
end


return GameSet