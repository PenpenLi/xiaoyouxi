

local GameBuy = class( "GameBuy",BaseLayer )



GameBuy.Dollar = {
	"$6",
	"$12",
	"$18",
}
GameBuy.Coin = {
	30,
	60,
	100
}


function GameBuy:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameBuy.super.ctor( self,param.name )
	local index = param.data

	self._layer = cc.LayerColor:create( cc.c4b( 0,0,0,150))
	self:addChild( self._layer )

	self:addCsb( "csbsuoha/Buy.csb" )

	self:addNodeClick( self.ButtonYes,{
		endCallBack = function ()
			self:buy( index )
		end
	})
	self:addNodeClick( self.ButtonNo,{
		endCallBack = function ()
			self:close()
		end
	})
	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end
	})
	self:loadUi( index )
end

function GameBuy:loadUi( num )
	assert( num," !! num is nil !! " )
	
	self.TextDollor:setString( self.Dollar[num] )
	-- dump( self.Dollar[num],"------------>>>self.Dollar = ")
	self.TextCoin:setString( self.Coin[num] )
	-- dump( self.Coin[num],"------------>>>self.Coin = ")
end

function GameBuy:onEnter()
	GameBuy.super.onEnter( self )
	casecadeFadeInNode( self._layer,0.5,150 )
	casecadeFadeInNode( self.Bg,0.5 )

end
function GameBuy:close()
	removeUIFromScene( UIDefine.MINIGAME_KEY.SuoHa_Buy_UI )
end

function GameBuy:buy( index )
	-- 调用sdk

	-- 这里用于测试 请在调用完sdk后 回调 buyCoinCallBack
	self:buyCoinCallBack( index )
end


function GameBuy:buyCoinCallBack( index )
	local model = G_GetModel("Model_SuoHa"):getInstance()
	model:setCoin( self.Coin[index] )
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_SUOHA_BUY_COIN )
	self:close()
end








return GameBuy