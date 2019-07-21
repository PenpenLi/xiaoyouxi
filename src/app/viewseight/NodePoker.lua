

local NodePoker = class( "NodePoker",BaseNode )


function NodePoker:ctor( parentPanel,numIndex )
	assert( parentPanel," !! parentPanel is nil !! ")
	assert( numIndex," !!numIndex is nil !! " )
	NodePoker.super.ctor( self,"NodePoker" )

	self._parentPanel = parentPanel
	self._numIndex = numIndex
	self._cardNum = eight_poker_config.poker_config[self._numIndex].num
	self._cardColor = eight_poker_config.poker_config[self._numIndex].color

	self._img = ccui.ImageView:create( "image/poker/bei.png",1 )
	self:addChild( self._img )

end


function NodePoker:addPokerClick()
	assert( self._img.listener == nil," !! listener is exist !! " )
	TouchNode.extends( self._img, function(event)
		return self:touchCard( event ) 
	end )
	self._img.listener:setSwallowTouches(true)
end

function NodePoker:removePokerClick()
	TouchNode.removeListener( self._img )
end

function NodePoker:touchCard( event )
	if event.name == "began" then
		return true
	elseif event.name == "moved" then
		
	elseif event.name == "ended" then
		self._parentPanel:playerOutCard( self )
	end
end


function NodePoker:showPoker()
	self._img:loadTexture( eight_poker_config.poker_config[self._numIndex].path,1 )
end

function NodePoker:getColor()
	return self._cardColor
end

function NodePoker:setColor( colorNum )
	assert( colorNum," !! colorNum is nil !! " )
	assert( colorNum == 1 or colorNum == 2 or colorNum == 3 or colorNum == 4," !! colorNum is error !! " )
	self._cardColor = colorNum
end

function NodePoker:getCardNum()
	return self._cardNum
end

function NodePoker:getImageSize()
	return self._img:getContentSize()
end

function NodePoker:getNumIndex()
	return self._numIndex
end

function NodePoker:setNumIndex( numIndex )
	self._numIndex = numIndex
end

function NodePoker:getPokerImg()
	return self._img
end



return NodePoker