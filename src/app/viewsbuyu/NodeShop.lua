

local NodeShop = class( "NodeShop",BaseNode )

function NodeShop:ctor( parentPanel,index )
	NodeShop.super.ctor( self )
	
	self._index = index
	self._coin = {
		1000,
		2000,
		3000
	}
	self._coinImg = {
		"image/shop/rate_1.png",
		"image/shop/rate_2.png",
		"image/shop/rate_3.png"
	}
	self._dollor = {
		"$ 6",
		"$ 12",
		"$ 18"
	}
	self:addCsb( "csbbuyu/NodeShop.csb" )
	TouchNode.extends( self.Panel_1,function ( event )
		return self:touchCard( event )
	end)

	self:loadUi()
end
function NodeShop:loadUi()
	self.ImageCoin:ignoreContentAdaptWithSize( true )
	self.ImageCoin:loadTexture( self._coinImg[self._index] )
	self.TextCoin:setString( self._coin[self._index] )
	self.TextDollor:setString( self._dollor[self._index] )
end
function NodeShop:onEnter( ... )
	NodeShop.super.onEnter( self )


end



function NodeShop:touchCard()
	addUIToScene( UIDefine.BUYU_KEY.Buy_UI,self._index)
end





return NodeShop