
local NodeShop  = class("NodeShop",BaseNode)


NodeShop.ICON = {
	"image/shop/less.png",
	"image/shop/medium.png",
	"image/shop/more.png"
}

NodeShop.TITLE = {
	"image/shop/lessbg.png",
	"image/shop/mediumbg.png",
	"image/shop/morebg.png"
}

NodeShop.COIN = {
	30,
	60,
	100
}

NodeShop.QIAN = {
	"image/shop/six.png",
	"image/shop/twelve.png",
	"image/shop/eighteen.png"
}

-- NodeShop.Bg = {
-- 	"image/shop/lesbg.png",
-- 	"image/shop/mediumbg.png",
-- 	"image/shop/morebg.png"
-- }

function NodeShop:ctor( parentPanel,index )
	self._parentPanel = parentPanel
	NodeShop.super.ctor( self,"NodeShop" )

	self:addCsb( "NodeShop.csb" )

	self:loadDataUi( index )

    TouchNode.extends( self.ImageLessbg, function(event)
		return self:touchCard( event ) 
	end )
end

function NodeShop:loadDataUi( index )
	assert( index," !! index is nil !! ")
	self._index = index
	self.ImageLess:loadTexture( NodeShop.ICON[index],1 )
	self.ImageLessbg:loadTexture( NodeShop.TITLE[index],1 )

	local coin_str = ""
	if laba_config.lang == 1 then
		coin_str = "金币"
	else
		coin_str = "coin"
	end

	self.Text1:setString( NodeShop.COIN[index]..coin_str )
	self.ImageSix:loadTexture( NodeShop.QIAN[index],1 )
end


function NodeShop:touchCard( event )
	if event.name == "began" then
        return true
    elseif event.name == "moved" then
		
    elseif event.name == "ended" then
    	self:buyCoin()
    	audio.playSound("labamp3/button.mp3", false)
    elseif event.name == "outsideend" then
    	
    end
end




function NodeShop:buyCoin()
	addUIToScene( UIDefine.MINIGAME_KEY.LaBa_Buy_UI,self._index )
end


return NodeShop