

local GameWolfFreeSpinStart = class( "GameWolfFreeSpinStart",BaseLayer )




function GameWolfFreeSpinStart:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameWolfFreeSpinStart.super.ctor( self,param.name )

	local layer = cc.LayerColor:create( cc.c4b(0,0,0,180) )
	self:addChild( layer )

	self:addCsb( "csbslot/wolfLighting/FreeSpinStart.csb" )
end



function GameWolfFreeSpinStart:onEnter()
	GameWolfFreeSpinStart.super.onEnter( self )
	self:playCsbAction( "start",false,function() 
		self:playCsbAction( "idle" )

		performWithDelay( self,function()
			self:playCsbAction( "over",false,function()
				removeUIFromScene( UIDefine.SLOT_KEY.FreeSpinWolfStart_UI ) 
			end )
		end,2 )
	end )
end





return GameWolfFreeSpinStart