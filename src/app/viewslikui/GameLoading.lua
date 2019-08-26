

local GameLoading = class( "GameLoading",BaseLayer )



function GameLoading:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )

    self:addCsb( "Loading.csb" )

    self._plist = {
		"LiKuiPlist1.plist",
		"LiKuiPlist2.plist",
		"LiKuiPlist3.plist",
		"LiKuiPlist4.plist"
	}
	self._music = {
		"lkmp3/music.mp3",
	}
	self._sound = {
		"lkmp3/button.mp3",
		"lkmp3/send.mp3",
		"lkmp3/win.mp3",
		"lkmp3/lose.mp3"
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
	local index = 1
	self:schedule( function ()
		audio.preloadMusic( self._music[index] )
		index = index + 1
		if index > #self._music then
			self:unSchedule()
			self:loadEffect()
		end
	end,0.02 )
end

function GameLoading:loadEffect()
	local index = 1
	self:schedule( function ()
		audio.preloadSound( self._sound[index] )
		-- audio.preloadSound( self._sound[index] )
		index = index + 1
		if index > #self._sound then
			self:unSchedule()
			removeUIFromScene( UIDefine.LIKUI_KEY.Loading_UI )
			addUIToScene( UIDefine.LIKUI_KEY.Start_UI )
		end
	end,0.02 )
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end







return GameLoading