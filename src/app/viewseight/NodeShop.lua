

local NodeShop = class( "NodeShop",BaseNode )

NodeShop.DOLLAR = {
	"1$",
	"2$",
	"3$"
}
NodeShop.GEMIMG = {
	"image/shop/500bs.png",
	"image/shop/1000bs.png",
	"image/shop/1500bs.png"
}
NodeShop.GEM = {
	500,
	1000,
	1500
}




function NodeShop:ctor( parentPanel,index )
	assert( parentPanel," !! parentPanel is nil !! " )
	assert( index," !! index is nil !! " )
	
	NodeShop.super.ctor( self,"NodeShop" )

	self._index = index
	self:addCsb( "csbeight/NodeShop.csb" )

	self:loadUi( index )

	TouchNode.extends( self.bg, function(event)-----------讲讲这个触摸？？？？？？
		return self:touchCard( event ) 
	end )
end

function NodeShop:loadUi( index )
	assert( index," !! index is nil !! " )

	self.Imagebs1:loadTexture( NodeShop.GEMIMG[index],1 )
	self.TextBs:setString( NodeShop.GEM[index] )
	self.TextDollor:setString( NodeShop.DOLLAR[index] )
end

function NodeShop:touchCard( event )
	if event.name == "began" then
        return true
    elseif event.name == "moved" then
		
    elseif event.name == "ended" then
    	self:buyCoin()
    	audio.playSound("emp3/button.mp3", false)
    elseif event.name == "outsideend" then
    	
    end
end

function NodeShop:buyCoin(  )
	addUIToScene( UIDefine.EIGHT_KEY.Buy_UI,self._index )
end





return NodeShop