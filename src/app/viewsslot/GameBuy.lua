
local GameBuy = class( "GameBuy",BaseLayer )

function GameBuy:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameBuy.super.ctor( self,param.name )
	self._index = param.data
	local layer = cc.LayerColor:create( cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer

	self._dollor = {
		6,
		12,
		18,
	}

	self._coin = {
		1000,
		2000,
		3000,
	}
	self:addCsb( "csbslot/hall/GameBuy.csb" )
	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end
	})
	self:addNodeClick( self.ButtonNo,{
		endCallBack = function ()
			self:close()
		end
	})
	self:addNodeClick( self.ButtonYes,{
		endCallBack = function ()
			self:coinFlyAction()
		end
	})


	self:loadUi()
end
function GameBuy:loadUi()
	self.TextDollor:setString( self._dollor[self._index] )
	self.TextCoin:setString( self._coin[self._index] )
end
function GameBuy:onEnter()
	GameBuy.super.onEnter( self )
	casecadeFadeInNode( self._layer,0.5,150 )
	casecadeFadeInNode( self._csbNode,0.5 )
end
-- function GameBuy:buy( ... )
-- 	G_GetModel("Model_Slot"):getInstance():setCoin( self._coin[self._index] )
-- 	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN )
-- end

function GameBuy:close( ... )
	removeUIFromScene( UIDefine.SLOT_KEY.Buy_UI )
end

function GameBuy:coinFlyAction( ... )
	local node_pos = cc.p( self.ButtonYes:getPosition())
	local world_pos = self.ButtonYes:getParent():convertToWorldSpace(node_pos)
	local end_pos = cc.p( 155,display.height - 33 )
	G_GetModel("Model_Slot"):getInstance():setCoin( self._coin[self._index] )
	local call = function ()
		-- print("--------------123123")
		
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN )
	end
	-- local call = self:buy()
	coinFly( world_pos,end_pos,call )
end





return GameBuy