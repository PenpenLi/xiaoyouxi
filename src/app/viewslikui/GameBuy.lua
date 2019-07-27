

local GameBuy = class( "GameBuy",BaseLayer )


function GameBuy:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameBuy.super.ctor( self,param.name )
	self._index = param.data
	self._money = {
		6,12,18
	}
	self._coin = {
		300,600,1000
	}

	self:addCsb( "Buy.csb" )


	self:loadUi()
end

function GameBuy:loadUi()
	self.Text:setString( "您将花费%d元购买%d金币",self._money[self._index],self._coin[self._index] )
end

function GameBuy:onEnter()
	GameBuy.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end












return GameBuy