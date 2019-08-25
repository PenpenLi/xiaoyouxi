

local NodeShop = class( "NodeShop",BaseNode )


function NodeShop:ctor( parentPanel,index )
	NodeShop.super.ctor( self )

	self._index = index
	self._dollor = {
		6,
		12,
		18,
	}
	self._coinImg = {
		"hall/image/shop/rate_1.png",
		"hall/image/shop/rate_2.png",
		"hall/image/shop/rate_3.png",
	}
	self._coin = {
		1000,
		2000,
		3000,
	}


	self:addCsb( "csbslot/hall/NodeShop.csb")
	TouchNode.extends( self.Panel,function ( event )
		return self:touchCard( event )
	end)

	self:loadUi()
end
function NodeShop:loadUi()
	dump( self._coinImg[self._index],"--------------self._coinImg[self._index] = ")
	self.ImageCoin:ignoreContentAdaptWithSize( true )
	-- local node = ccui.ImageView:create( self._coinImg[self._index],1 )
	-- self.ImageCoin:addChild( node )
	self.ImageCoin:loadTexture( self._coinImg[self._index] )
	self.TextCoin:setString( self._coin[self._index] )
	self.TextDollor:setString( self._dollor[self._index] )
end

function NodeShop:onEnter()
	NodeShop.super.onEnter( self )

end

function NodeShop:touchCard( event )
	if event.name == "began" then
        return true
    elseif event.name == "moved" then
		
    elseif event.name == "ended" then
    	self:openBuy()
    elseif event.name == "outsideend" then

    end
    	
end
function NodeShop:openBuy()
	addUIToScene( UIDefine.SLOT_KEY.Buy_UI,self._index )
end





return NodeShop