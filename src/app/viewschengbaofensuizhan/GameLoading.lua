
local GameLoading = class( "GameLoading",BaseLayer )

function GameLoading:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameLoading.super.ctor( self,param.name )

	self:addCsb( "csbchengbaofensuizhan/Loading.csb" )

	self._plist = {
		"csbchengbaofensuizhan/Plist1.plist",
		"csbchengbaofensuizhan/Plist2.plist",
		"csbchengbaofensuizhan/Plist3.plist",
		"csbchengbaofensuizhan/Plist4.plist",
		"csbchengbaofensuizhan/Plist5.plist",
		"csbchengbaofensuizhan/Plist6.plist",
		"csbchengbaofensuizhan/Plist7.plist",
		"csbchengbaofensuizhan/Plist8.plist",
	}
	-- self._music = {
	-- 	"sgmp3/bg.mp3"
	-- }
	-- self._sound = {
	-- 	"sgmp3/button.mp3",
	-- 	"sgmp3/lost.mp3",
	-- 	"sgmp3/win.mp3",
	-- 	"sgmp3/sendcard.mp3"
	-- }
end

function GameLoading:loadPlist()
	if self._plist == nil then
		self:loadMusic()
		return
	end
	local index = 1
	self:schedule( function()
		cc.SpriteFrameCache:getInstance():addSpriteFrames( self._plist[index] )
		index = index + 1
		if index > #self._plist then
			self:unSchedule()
			self:loadMusic()
		end
	end,0.02)
end
function GameLoading:loadMusic()
	if self._music == nil then
		self:loadEffect()
		return
	end
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
	if self._sound == nil then
		removeUIFromScene( UIDefine.CHENGBAOFENSUIZHAN_KEY.Loading_UI )
		addUIToScene( UIDefine.CHENGBAOFENSUIZHAN_KEY.Play_UI )
		addUIToScene( UIDefine.CHENGBAOFENSUIZHAN_KEY.Operation_UI )
		return
	end
	local index = 1
	self:schedule( function ()
		audio.preloadSound( self._sound[index] )
		index = index + 1
		if index > #self._sound then
			self:unSchedule()
			removeUIFromScene( UIDefine.CHENGBAOFENSUIZHAN_KEY.Loading_UI )
			addUIToScene( UIDefine.CHENGBAOFENSUIZHAN_KEY.Start_UI )
			addUIToScene( UIDefine.CHENGBAOFENSUIZHAN_KEY.Operation_UI )
		end
	end,0.02)
end


function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end

return GameLoading