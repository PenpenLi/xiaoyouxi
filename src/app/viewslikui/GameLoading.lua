

local GameLoading = class( "GameLoading",BaseLayer )



function GameLoading:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )

    self:addCsb( "csbeight/Loading.csb" )

    self._plist = {
		"csblikui/Plist1.plist",
		"csblikui/Plist2.plist",
		"csblikui/Plist3.plist"
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
	print( "-------------1" )
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
	print( "-------------1" )
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
		print( "-------------2" )
		index = index + 1
		if index > #self._sound then
			self:unSchedule()
			print( "-------------1" )
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