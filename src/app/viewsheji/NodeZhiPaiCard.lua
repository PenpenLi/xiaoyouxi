

local NodeZhiPaiCard = class( "NodeZhiPaiCard",BaseNode )



function NodeZhiPaiCard:ctor( parentPanel,size )
	self._parentPanel = parentPanel
	NodeZhiPaiCard.super.ctor( self,"NodeZhiPaiCard" )
	self._image = ccui.ImageView:create( "imagezhipai/poker/bei.png",1 )
	self:addChild( self._image )
	self._image:setPosition( size.width / 2,size.height / 2 )
end



function NodeZhiPaiCard:loadDataUI( numIndex )
	assert( numIndex," !! numIndex is nil !! ")
	self._numIndex = numIndex

	if self._numIndex == 0 then
		self._cardNum = { 0 }
		self._image:loadTexture( "imagezhipai/poker/bei.png",1 )
	else
		self._cardNum = zhipai_config.num_config[numIndex]
		local path = zhipai_config.poker_config[numIndex]
		self._image:loadTexture( path,1 )
	end
end



function NodeZhiPaiCard:getCardNum()
	return self._cardNum
end


function NodeZhiPaiCard:getNumIndex()
	return self._numIndex
end





return NodeZhiPaiCard