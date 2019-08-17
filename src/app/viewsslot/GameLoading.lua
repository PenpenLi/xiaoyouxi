

local GameLoading = class( "GameLoading",BaseLayer )




function GameLoading:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameLoading.super.ctor( self,param.name )

	self:addCsb( "csbslot/Loading.csb" )

	self._plist = {
		"csbslot/SlotPlist1.plist",
		"csbslot/SlotPlist2.plist",
		"csbslotgame1/Pharaoh1.plist",
		"csbslotgame1/Pharaoh2.plist",
		"csbslotgame1/Pharaoh3.plist",
		"csbslotgame1/Pharaoh4.plist",
		"csbslotgame1/Pharaoh5.plist",
		"csbslotgame1/Pharaoh6.plist",
		"csbslotgame1/Pharaoh7.plist",
		"csbslotgame1/Pharaoh8.plist",
		"csbslotgame1/Pharaoh9.plist",
		"csbslotgame1/Pharaoh10.plist",
		"csbslotgame1/Pharaoh11.plist",
		"csbslotgame1/Pharaoh12.plist",
	}

	self._music = {
		-- "shmp3/music.mp3"
	}

	self._sound = {
		-- "shmp3/button.mp3",
		-- "shmp3/sendPoker.mp3"
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
	if #self._music > 0 then
		local index = 1
		self:schedule( function ()
			audio.preloadMusic( self._music[index] )
			index = index + 1
			if index > #self._music then
				self:unSchedule()
				self:loadSound()
			end
		end,0.02)
	else
		self:loadSound()
	end
end
function GameLoading:loadSound()
	local index = 1
	if #self._sound > 0 then
		self:schedule( function ()
			audio.preloadSound( self._sound[index] )
			index = index + 1
			if index > #self._sound then
				self:unSchedule()
				self:loadStart()
			end
		end,0.02)
	else
		self:loadStart()
	end
end

function GameLoading:loadStart()
	removeUIFromScene( UIDefine.SLOT_KEY.Loading_UI )
	addUIToScene( UIDefine.SLOT_KEY.Start_UI )
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end


return GameLoading