
--
-- Author: 	刘智勇
-- Date: 	2019-06-30
-- Desc:	足球场景


local GameLoading = class( "GameLoading",BaseLayer )

function GameLoading:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameLoading.super.ctor( self,param.name )

	self:addCsb( "csbzuqiu/Loading.csb" )

	self._plist = {
		"csbzuqiu/Plist1.plist",
		"csbzuqiu/Plist2.plist",
		"csbzuqiu/Plist3.plist",
		"csbzuqiu/Plist4.plist"
	}
	self._music = {
		"zqmp3/music.mp3"
	}
	self._sound = {
		"zdmp3/button.mp3",
		"zdmp3/lose.mp3",
		"zdmp3/win.mp3",
		"zdmp3/sendpoker.mp3",
	}

	

end

function GameLoading:loadPlist()
	local index = 1
	self:schedule( function()
		cc.SpriteFrameCache:getInstance():addSpriteFrames( self._plist[index] )---getInstance,自定义了？cc.?
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
			self:loadEffect()
		end
	end,0.02)
end
function GameLoading:loadEffect()
	local index = 1
	self:schedule( function ()
		audio.preloadSound( self._sound[index] )
		index = index + 1
		if index > #self._sound then
			self:unSchedule()
			removeUIFromScene( UIDefine.ZUQIU_KEY.Loading_UI )
			addUIToScene( UIDefine.ZUQIU_KEY.Start_UI )
		end
	end,0.02)
end


function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end

return GameLoading