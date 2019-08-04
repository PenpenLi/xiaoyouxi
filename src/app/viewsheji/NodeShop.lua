

local NodeShop = class( "NodeShop",BaseNode )

NodeShop.ICON = {
	"imagedating/shop/product1.png",
	"imagedating/shop/product2.png",
}

-- NodeShop.TITLE = {
-- 	"image/shop/goumaidb.png"
-- }

NodeShop.COIN = {
	500,
	1000,
}

NodeShop.QIAN = {
	"6元",
	"12元",
}


function NodeShop:ctor( parentPanel,index )
	self._parentPanel = parentPanel
	NodeShop.super.ctor( self,"NodeShop" )
	self:addCsb( "NodeShop.csb")

	self:loadDataUi( index )

	TouchNode.extends( self.bg,function (event)
		return self:touchCard( event )
	end)
end

function NodeShop:loadDataUi( index )
	assert( index," !! index is nil !! " )
	self._index = index
	self.ImageCoin:loadTexture( NodeShop.ICON[index],1)
	self.TextCoin:setString( NodeShop.COIN[index] )
	self.TextRMB:setString( NodeShop.QIAN[index] )
end

function NodeShop:touchCard( event )
	if event.name == "began" then
		return true
	elseif event.name == "moved" then

	elseif event.name == "ended" then 
		self:buyCoin( self._index )
	elseif event.name == "outsideend" then
	end
end

function NodeShop:buyCoin( index )
	G_GetModel("Model_Heji"):getInstance():setCoin( NodeShop.COIN[index] )
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_HEJI_BUY_COIN )
end





return NodeShop