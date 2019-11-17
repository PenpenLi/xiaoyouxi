


local NodePoker = class( "NodePoker",BaseNode )


function NodePoker:ctor( parentPanel,numIndex )
	assert( parentPanel," !! parentPanel is nil !! " )
	assert( numIndex > 0," !! numIndex is error !! " )
	self._parentPanel = parentPanel
	self._numIndex = numIndex
	NodePoker.super.ctor( self,"NodePoker" )
	assert( zuqiu_card_config[numIndex]," !! error numIndex = "..numIndex.." !! ")
	self._cardNum = zuqiu_card_config[numIndex].num
	-- 添加图片
	self._image = ccui.ImageView:create( "image/poker/bei.png",1 )
	self:addChild( self._image )
	self._image:setScale( 0.86 )
	-- 添加阴影
	self._yinying = ccui.ImageView:create( "image/play/mengban.png",1 )
	self:addChild( self._yinying )
	self._yinying:setScale( 0.86 )
	self._yinying:setVisible( false )

	self._showBei = false
end


function NodePoker:showPoker()
	local path = zuqiu_card_config[self._numIndex].path
	self._image:loadTexture( path,1 )
	self._showBei = false
end

function NodePoker:setSeatPos( seatPos )
	assert( seatPos > 0," !! seatPos must be > 0 !! " )
	self._seatPos = seatPos
end

function NodePoker:getSeatPos()
	assert( self._seatPos > 0," !! self._seatPos must be > 0 !! " )
	return self._seatPos
end

function NodePoker:getCardNum()
	return self._cardNum
end

function NodePoker:showBei()
	self._image:loadTexture( "image/poker/bei.png",1 )
	self._showBei = true
end

function NodePoker:isShowBei()
	return self._showBei
end

function NodePoker:getNumIndex()
	return self._numIndex
end


function NodePoker:addPokerClick()
	self._toListener = TouchNode.extends( self._image, function(event)
		return self:touchCard( event ) 
	end,true )
end

function NodePoker:removePokerClick()
	if self._toListener then
		local dispater = cc.Director:getInstance():getEventDispatcher()
		dispater:removeEventListener( self._toListener )
		self._toListener = nil
	end
end

function NodePoker:touchCard( event )
	if event.name == "began" then
		return true
	elseif event.name == "moved" then
		
	elseif event.name == "ended" then
		self:outCard()
	elseif event.name == "outsideend" then
	end
end

function NodePoker:outCard()
	self._parentPanel:playerOutCard( self )
end

function NodePoker:setYinYingVisible( value )
	self._yinying:setVisible( value )
end

return NodePoker