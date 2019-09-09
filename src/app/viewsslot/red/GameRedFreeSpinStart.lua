

local GameRedFreeSpinStart = class( "GameRedFreeSpinStart",BaseLayer )




function GameRedFreeSpinStart:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameRedFreeSpinStart.super.ctor( self,param.name )

	local layer = cc.LayerColor:create( cc.c4b(0,0,0,180) )
	self:addChild( layer )

	self:addCsb( "csbslot/RedDiamond/RedDiamond_FreespinStart.csb" )

	self.spintimes:setString( 5 )
end



function GameRedFreeSpinStart:onEnter()
	GameRedFreeSpinStart.super.onEnter( self )

	-- 播放音效
	if G_GetModel("Model_Sound"):isVoiceOpen() then
		audio.playSound("csbslot/hall/hmp3/free_spin.mp3")
	end
	
	self:playCsbAction( "auto",false,function() 
		removeUIFromScene( UIDefine.SLOT_KEY.FreeSpinRedStart_UI ) 
	end )
end





return GameRedFreeSpinStart