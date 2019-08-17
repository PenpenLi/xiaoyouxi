

local GameCollect = class( "GameCollect",BaseLayer )

function GameCollect:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param is nil !! " )
	GameCollect.super.ctor( self,param.name )


	self:addCsb( "csbslot/hall/TurnReward.csb" )
	self:playCsbAction( "start",false )


	self:addNodeClick( self.ButtonCollect,{
		endCallBack = function ()
			self:collectCoin()
		end
	})
end

function GameCollect:collectCoin()
	print("----------------------guanbi")
	removeUIFromScene( UIDefine.SLOT_KEY.Turn_UI )
	removeUIFromScene( UIDefine.SLOT_KEY.Collect_UI )
end





















return GameCollect