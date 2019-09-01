

local GameLoading = class( "GameLoading",BaseLayer )



function GameLoading:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )

    self:addCsb( "csbbuyu/Loading.csb" )

    self._plist = {
		"csbbuyu/PlistFish1.plist",
		"csbbuyu/PlistFish2.plist",
		"csbbuyu/PlistFish3.plist",
		"csbbuyu/PlistFish4.plist",
		"csbbuyu/PlistFish5.plist",
		"csbbuyu/PlistFish6.plist",
		"csbbuyu/PlistFish7.plist",
		"csbbuyu/PlistFish8.plist",
	}
	self._music = {
		
	}
	self._sound = {
		
	}
end

function GameLoading:loadPlist()
	local index = 1
	self:schedule( function ()
		cc.SpriteFrameCache:getInstance():addSpriteFrames( self._plist[index] )
		index = index + 1
		if index > #self._plist then
			self:unSchedule()
			self:loadMusic()
		end
	end,0.02 )
end

function GameLoading:loadMusic()
	if #self._music > 0 then
		local index = 1
		self:schedule( function ()
			audio.preloadMusic( self._music[index] )
			index = index + 1
			if index > #self._music then
				self:unSchedule()
				self:loadEffect()
			end
		end,0.02 )
	else
		self:loadEffect()
	end
end

function GameLoading:loadEffect()
	if #self._sound > 0 then
		local index = 1
		self:schedule( function ()
			audio.preloadSound( self._sound[index] )
			index = index + 1
			if index > #self._sound then
				self:unSchedule()
				removeUIFromScene( UIDefine.BUYU_KEY.Loading_UI )
				addUIToScene( UIDefine.BUYU_KEY.Play_UI )
			end
		end,0.02 )
	else
		removeUIFromScene( UIDefine.BUYU_KEY.Loading_UI )
		addUIToScene( UIDefine.BUYU_KEY.Play_UI )
	end
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end







return GameLoading