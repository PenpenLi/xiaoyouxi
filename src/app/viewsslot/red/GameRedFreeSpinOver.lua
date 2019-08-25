

local GameRedFreeSpinOver = class( "GameRedFreeSpinOver",BaseLayer )




function GameRedFreeSpinOver:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameRedFreeSpinOver.super.ctor( self,param.name )

	self._coin = param.data
	local layer = cc.LayerColor:create( cc.c4b(0,0,0,180) )
	self:addChild( layer )

	self:addCsb( "csbslot/RedDiamond/RedDiamond_FreespinOver.csb" )

	self.lab_fs_num:setString(5)
end



function GameRedFreeSpinOver:onEnter()
	GameRedFreeSpinOver.super.onEnter( self )

	self.lab_fs_win:setString( self._coin )

	self:playCsbAction( "actionframestart",false,function() 
		self:playCsbAction( "idle" )
		performWithDelay( self,function()
			self:playCsbAction( "actionframeover",false,function()
				removeUIFromScene( UIDefine.SLOT_KEY.FreeSpinRedOver_UI ) 
			end )
		end,2 )
	end )
end





return GameRedFreeSpinOver