

local GameWolfFreeSpinOver = class( "GameWolfFreeSpinOver",BaseLayer )




function GameWolfFreeSpinOver:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameWolfFreeSpinOver.super.ctor( self,param.name )

	self._coin = param.data
	local layer = cc.LayerColor:create( cc.c4b(0,0,0,180) )
	self:addChild( layer )

	self:addCsb( "csbslot/wolfLighting/FreeSpinOver.csb" )
end



function GameWolfFreeSpinOver:onEnter()
	GameWolfFreeSpinOver.super.onEnter( self )

	self.m_lb_coins:setString( self._coin )

	self:playCsbAction( "start",false,function() 
		self:playCsbAction( "idle" )

		performWithDelay( self,function()
			self:playCsbAction( "over",false,function()
				removeUIFromScene( UIDefine.SLOT_KEY.FreeSpinWolfOver_UI ) 
			end )
		end,2 )
	end )
end





return GameWolfFreeSpinOver