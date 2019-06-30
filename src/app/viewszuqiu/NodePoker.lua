


local NodePoker = class( "NodePoker",BaseNode )


function NodePoker:ctor( parentPanel )
	self._parentPanel = parentPanel
	NodePoker.super.ctor( self,"NodePoker" )

	self._image = ccui.ImageView:create( "image/poker/bei.png",1 )
	self:addChild( self._image )
end


function NodePoker:loadDataUI( numIndex )
	assert( numIndex," !! numIndex is nil !! ")
	self._numIndex = numIndex

	if self._numIndex == 0 then
		self._cardNum = 0
		self._image:loadTexture( "image/poker/bei.png",1 )
	else
		self._cardNum = zuqiu_card_config[numIndex].num
		local path = zuqiu_card_config[numIndex].path
		self._image:loadTexture( path,1 )
	end
end


function NodePoker:getCardNum()
	return self._cardNum
end


function NodePoker:getNumIndex()
	return self._numIndex
end



return NodePoker