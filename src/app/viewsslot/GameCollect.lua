

local GameCollect = class( "GameCollect",BaseLayer )

function GameCollect:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param is nil !! " )
	GameCollect.super.ctor( self,param.name )


	self:addCsb( "csbslot/TurnReward.csb" )



	self:addNodeClick( self.ButtonCollect,{
		endCallBack = function ()
			self:collectCoin()
		end
	})
end

function GameCollect:collectCoin()
	-- body
end





















return GameCollect