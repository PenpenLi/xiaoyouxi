

local GameLoading = class("GameLoading",BaseLayer)



function GameLoading:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )

    self:addCsb( "csbheji/csbdating/Loading.csb" )

    self._plist = {
		"csbheji/csbdating/DaTingPlist1.plist",

		"csbheji/csbsanguo/SanGuoPlist1.plist",
		"csbheji/csbsanguo/SanGuoPlist2.plist",
		"csbheji/csbsanguo/SanGuoPlist3.plist",
		"csbheji/csbsanguo/SanGuoPlist4.plist",

		"csbheji/csbtwentyone/twntyonePlist1.plist",
		"csbheji/csbtwentyone/twntyonePlist2.plist",
		"csbheji/csbtwentyone/twntyonePlist3.plist",

		"csbheji/csbzhipai/ZhiPaiPlist1.plist",
		"csbheji/csbzhipai/ZhiPaiPlist2.plist",
		"csbheji/csbzhipai/ZhiPaiPlist3.plist",
	}
	self._music = {
		"csbheji/csbsanguo/sgmp3/bg.mp3",
		"csbheji/csbtwentyone/tomp3/dating.mp3",
		"csbheji/csbzhipai/zpmp3/mainScene.mp3",
	}
	self._sound = {
		"csbheji/csbsanguo/sgmp3/button.mp3",
		"csbheji/csbsanguo/sgmp3/lost.mp3",
		"csbheji/csbsanguo/sgmp3/win.mp3",
		"csbheji/csbsanguo/sgmp3/sendcard.mp3",

		"csbheji/csbtwentyone/tomp3/selectpoker.mp3",

		"csbheji/csbzhipai/zpmp3/btn_bubble.mp3",
	}
end


function GameLoading:loadPlist()
	local index = 1
	self:schedule( function()
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
	self:schedule( function()
		if self._music[index] then
			audio.preloadMusic( self._music[index] )
		end
		index = index + 1
		if index > #self._music then
			self:unSchedule()
			self:loadEffect()
		end
	end,0.02 )
end

function GameLoading:loadEffect()
	local index = 1
	self:schedule( function()
		if self._sound[index] then
			audio.preloadSound( self._sound[index] )
		end
		index = index + 1
		if index > #self._sound then
			self:unSchedule()
			removeUIFromScene( UIDefine.HEJI_KEY.Loading_UI )
			addUIToScene( UIDefine.HEJI_KEY.Start_UI )
		end
	end,0.02 )
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end




return GameLoading