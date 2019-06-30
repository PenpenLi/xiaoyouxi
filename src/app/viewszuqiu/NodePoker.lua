


local NodePoker = class( "NodePoker",BaseNode )


function NodePoker:ctor( parentPanel,numIndex )
	assert( parentPanel," !! parentPanel is nil !! " )
	assert( numIndex > 0," !! numIndex is error !! " )

	self._parentPanel = parentPanel
	self._numIndex = numIndex
	NodePoker.super.ctor( self,"NodePoker" )

	assert( zuqiu_card_config[numIndex]," !! error numIndex = "..numIndex.." !! ")

	self._cardNum = zuqiu_card_config[numIndex].num

	self._image = ccui.ImageView:create( "image/poker/bei.png",1 )
	self:addChild( self._image )
	self._image:setScale( 0.86 )
end


function NodePoker:showPoker()
	local path = zuqiu_card_config[self._numIndex].path
	self._image:loadTexture( path,1 )
end


function NodePoker:getCardNum()
	return self._cardNum
end


function NodePoker:getNumIndex()
	return self._numIndex
end



return NodePoker