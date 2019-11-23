

local GameLoading = class("GameLoading",BaseLayer)



function GameLoading:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )

    self:addCsb( "csbminigame/csbzhipai/Loading.csb" )

    self._plist = {
		"csbminigame/csbzhipai/ZhiPaiPlist1.plist",
		"csbminigame/csbzhipai/ZhiPaiPlist2.plist",
		"csbminigame/csbzhipai/ZhiPaiPlist3.plist",
	}
	self._music = {
		"zpmp3/mainScene.mp3",
	}
	self._sound = {
		"zpmp3/btn_bubble.mp3",
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
	self:schedule( function()
		audio.preloadSound( self._sound[index] )
		index = index + 1
		if index > #self._sound then
			self:unSchedule()
			removeUIFromScene( UIDefine.MINIGAME_KEY.ZhiPai_Loading_UI )
			addUIToScene( UIDefine.MINIGAME_KEY.ZhiPai_Start_UI )
		end
	end,0.02 )
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end




return GameLoading