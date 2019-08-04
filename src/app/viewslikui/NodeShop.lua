


local NodeShop = class( "NodeShop",BaseNode )


function NodeShop:ctor( parentPanel,index )
	NodeShop.super.ctor( self )

	self._index = index
	self._coinNum = {
		"image/shop/300coin.png",
		"image/shop/600coin.png",
		"image/shop/1000coin.png",
	}
	self._coinImg = {
		"image/shop/coin1.png",
		"image/shop/coin2.png",
		"image/shop/coin3.png",
	}
	self._money = {
		"image/shop/6yuan.png",
		"image/shop/12yuan.png",
		"image/shop/18yuan.png",
	}

	self:addCsb( "NodeShop.csb" )

	TouchNode.extends( self.bg,function ( event )
		return self:touchCard( event )
	end)

	self:loadUi()
end

function NodeShop:loadUi()
	self.ImageCoinNum:loadTexture( self._coinNum[self._index],1 )
	self.ImageCoin:loadTexture( self._coinImg[self._index],1 )
	self.ImageQian:loadTexture( self._money[self._index],1 )
end

function NodeShop:touchCard( event )
	if event.name == "began" then
        return true
    elseif event.name == "moved" then
		
    elseif event.name == "ended" then
    	self:openBuy()
    	if G_GetModel("Model_Sound"):isVoiceOpen() then
    		audio.playSound("emp3/button.mp3", false)
    	end
    elseif event.name == "outsideend" then
    	
    end
end

function NodeShop:openBuy()
	addUIToScene( UIDefine.LIKUI_KEY.Buy_UI,self._index )
end

return NodeShop