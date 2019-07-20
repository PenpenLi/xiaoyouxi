

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

function NodePoker:showPoker()
	self._img:loadTexture( eight_poker_config.poker_config[self._numIndex].path,1 )
end

function NodePoker:getColor()
	return self._cardColor
end

function NodePoker:getCardNum()
	return self._cardNum
end

function NodePoker:getImageSize()
	return self._img:getContentSize()
end




return NodePoker