


local GameBuy = class( "GameBuy",BaseLayer )

GameBuy.GEM = {
	500,
	1000,
	1500
}
GameBuy.DOLLAR = {
	"$1",
	"$2",
	"$3"
}

function GameBuy:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameBuy.super.ctor( self,param.name )

	self._index = param.data

	self:addCsb( "Buy.csb" )

	self:addNodeClick( self.ButtonYes,{
		endCallBack = function ()
			self:buy()
		end
	})
	self:addNodeClick( self.ButtonNo,{
		endCallBack = function ()
			self:close()
		end
	})

	self:loadUi()
end

function GameBuy:loadUi()
	self.TextDollar:setString( self.DOLLAR[self._index] )
	self.TextGem:setString( self.GEM[self._index] )
end

function GameBuy:onEnter()
	GameBuy.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end
function GameBuy:buy()
	-- 调用sdk

    -- 这里是用于测试 请在调用完sdk后 回调 buyCoinCallBack 
    self:buyCoinCallBack()
end

function GameBuy:buyCoinCallBack()
	local gem = self.GEM[self._index]
	G_GetModel("Model_Eight"):setCoin( gem )
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_EIGHT_BUY_COIN )
	self:close()
end
function GameBuy:close()
	removeUIFromScene( UIDefine.EIGHT_KEY.Buy_UI )
end





return GameBuy