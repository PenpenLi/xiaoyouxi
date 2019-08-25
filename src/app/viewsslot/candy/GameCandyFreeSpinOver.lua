

local GameCandyFreeSpinOver = class( "GameCandyFreeSpinOver",BaseLayer )




function GameCandyFreeSpinOver:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameCandyFreeSpinOver.super.ctor( self,param.name )

	self._coin = param.data
	local layer = cc.LayerColor:create( cc.c4b(0,0,0,180) )
	self:addChild( layer )

	self:addCsb( "csbslot/newcandy/NewCandy_FreeSpinOver.csb" )

	self.lab_fs_num:setString(5)
end



function GameCandyFreeSpinOver:onEnter()
	GameCandyFreeSpinOver.super.onEnter( self )

	self.lab_fs_win:setString( self._coin )

	self:playCsbAction( "actionframestart",false,function() 
		self:playCsbAction( "actionframeidle" )

		performWithDelay( self,function()
			self:playCsbAction( "actionframeover",false,function()
				removeUIFromScene( UIDefine.SLOT_KEY.FreeSpinCandyOver_UI ) 
			end )
		end,2 )
	end )
end





return GameCandyFreeSpinOver