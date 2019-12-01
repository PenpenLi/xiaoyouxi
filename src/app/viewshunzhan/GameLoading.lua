

local GameLoading = class("GameLoading",BaseLayer)



function GameLoading:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )

    self:addCsb( "csbhunzhan/Loading.csb" )

    self._plist = {
		"FenShuiPlist1.plist",
		"FenShuiPlist2.plist",
		"FenShuiPlist3.plist",
		"FenShuiPlist4.plist",
		"FenShuiPlist5.plist",
		"FenShuiPlist6.plist",
		"FenShuiPlist7.plist",
		"FenShuiPlist8.plist",
	}
	self._music = {
		
	}
	self._sound = {
		
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
			removeUIFromScene( UIDefine.HUNZHAN_KEY.Loading_UI )
			-- addUIToScene( UIDefine.HUNZHAN_KEY.Fight_UI )
			-- addUIToScene( UIDefine.HUNZHAN_KEY.Operation_UI )
			addUIToScene( UIDefine.HUNZHAN_KEY.Choose_UI )
		end
	end,0.02 )
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end




return GameLoading