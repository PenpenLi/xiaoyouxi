

local GameBuy = class( "GameBuy",BaseLayer )

function GameBuy:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameBuy.super.ctor( self,param.name )
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer
    self._index = param.data
    self:addCsb( "csbbuyu/GameBuy.csb" )
    self._coin = {
		1000,
		2000,
		3000
	}

	self._dollor = {
		6,
		12,
		18
	}

    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
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
	self.TextDollor:setString( self._dollor[self._index])
	self.TextCoin:setString( self._coin[self._index])
end

function GameBuy:onEnter()
	GameBuy.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
    casecadeFadeInNode( self._layer,0.5,150 )
end

function GameBuy:close()
	removeUIFromScene( UIDefine.BUYU_KEY.Buy_UI )
end

function GameBuy:buy(  )
	G_GetModel("Model_BuYu"):setCoin( self._coin[self._index] )
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_BUYU_BUY_COIN )
	self:close()
end












return GameBuy