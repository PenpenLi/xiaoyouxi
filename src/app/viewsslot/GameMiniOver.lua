

local GameMiniOver = class( "GameMiniOver",BaseLayer )

function GameMiniOver:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameMiniOver.super.ctor( self,param.name )
	self._coin = param.data
	self:addCsb( "csbslot/hall/OverOfMiniGame.csb" )
	self:playCsbAction( "start",false )

	self:addNodeClick( self.ButtonCollect,{
		endCallBack = function ()
			self:close()
		end
	})
end
function GameMiniOver:onEnter()
	GameMiniOver.super.onEnter( self )
	self:loadUi()
end

function GameMiniOver:loadUi()
	self.TextCoin1:setString( self._coin )
end

function GameMiniOver:close( ... )
	removeUIFromScene( UIDefine.SLOT_KEY.OverMini2_UI )
end

return GameMiniOver