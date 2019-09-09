

local GameCandyFreeSpinStart = class( "GameCandyFreeSpinStart",BaseLayer )




function GameCandyFreeSpinStart:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameCandyFreeSpinStart.super.ctor( self,param.name )

	local layer = cc.LayerColor:create( cc.c4b(0,0,0,180) )
	self:addChild( layer )

	self:addCsb( "csbslot/newcandy/NewCandy_FreeSpinStart.csb" )

	self.spintimes:setString( 5 )
end



function GameCandyFreeSpinStart:onEnter()
	GameCandyFreeSpinStart.super.onEnter( self )

	-- 播放音效
	if G_GetModel("Model_Sound"):isVoiceOpen() then
		audio.playSound("csbslot/hall/hmp3/free_spin.mp3")
	end

	
	self:playCsbAction( "actionframestart",false,function() 
		self:playCsbAction( "actionframeidle" )

		performWithDelay( self,function()
			self:playCsbAction( "actionframeover",false,function()
				removeUIFromScene( UIDefine.SLOT_KEY.FreeSpinCandyStart_UI ) 
			end )
		end,2 )
	end )
end





return GameCandyFreeSpinStart