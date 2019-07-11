

local GameLoading = class( "GameLoading",BaseLayer )




function GameLoading:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameLoading.super.ctor( self,param.name )

	self:addCsb( "csbsuoha/Loading.csb" )

	self._plist = {
		"csbsuoha/Plist1.plist",
		"csbsuoha/Plist2.plist",
	}

	self._music = {
		"shmp3/music.mp3"
	}

	self._sound = {
		"shmp3/button.mp3",
		"shmp3/sendPoker.mp3"
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
	end,0.02)
	
end
function GameLoading:loadMusic()
	local index = 1
	self:schedule( function ()
		audio.preloadMusic( self._music[index] )
		index = index + 1
		if index > #self._music then
			self:unSchedule()
			self:loadSound()
		end
	end,0.02)
	
end
function GameLoading:loadSound()
	local index = 1
	self:schedule( function ()
		audio.preloadSound( self._sound[index] )
		index = index + 1
		if index > #self._sound then
			self:unSchedule()
			self:loadStart()
		end
	end,0.02)
	
end

function GameLoading:loadStart()
	removeUIFromScene( UIDefine.SUOHA_KEY.Loading_UI )
	addUIToScene( UIDefine.SUOHA_KEY.Start_UI )
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end













return GameLoading