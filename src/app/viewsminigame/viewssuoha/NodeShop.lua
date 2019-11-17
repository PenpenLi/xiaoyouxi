

local NodeShop = class( "NodeShop",BaseNode )

NodeShop.ICON = {
	"image/store/30img.png",
	"image/store/60img.png",
	"image/store/100img.png",
}

NodeShop.Gold = {
	"image/store/30gold.png",
	"image/store/60gold.png",
	"image/store/100gold.png",
}

NodeShop.Dollar = {
	"$6.00",
	"$12.00",
	"$18.00",
}


function NodeShop:ctor( parentPanel,index )
	self._parentPanel = parentPanel
	self._index = index
	NodeShop.super.ctor( self )

	self:addCsb( "csbsuoha/NodeShop.csb" )

	self:loadDataUi( index )

	TouchNode.extends( self.ImageCoinBg,function ( event )
		return self:touchCard( event )
	end)
end

function NodeShop:loadDataUi( index )
	assert( index," !! index is nil !! " )
	self.ImageGold:loadTexture( self.Gold[index],1 )
	self.ImageCoin:loadTexture( self.ICON[index],1 )
	self.TextDollar:setString( self.Dollar[index] )
end

function NodeShop:touchCard( event )
	if event.name == "began" then
		return true
	elseif event.name == "moved" then

	elseif event.name == "ended" then
		self:buyCoin()
	elseif event.name == "outsideend" then
	end
end

function NodeShop:buyCoin()
	addUIToScene( UIDefine.MINIGAME_KEY.SuoHa_Buy_UI,self._index )
end







return NodeShop