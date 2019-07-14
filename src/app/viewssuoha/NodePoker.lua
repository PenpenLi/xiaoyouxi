
--
-- Author: 	刘智勇
-- Date: 	2019-07-13
-- Desc:	梭哈的poker

local NodePoker = class( "NodePoker",BaseNode )


function NodePoker:ctor( parentPanel,numIndex )
	assert( parentPanel," !! parentPanel is nil !! ")
	assert( numIndex," !!numIndex is nil !! " )
	NodePoker.super.ctor( self,"NodePoker" )

	self._parentPanel = parentPanel
	self._numIndex = numIndex
	self._state = nil--判断牌所在牌堆，1为上，2为下

	self._img = ccui.ImageView:create( suoha_config.poker[self._numIndex].path,1 )
	self:addChild( self._img )

	self._img_hand = ccui.ImageView:create( "image/poker/hand.png",1 )--底牌
	self:addChild( self._img_hand )
	self._img_hand:setPosition( cc.p( 0,0 ) )
	self._img:setLocalZOrder( 100 )
end



function NodePoker:addPokerClick( upOrDownPos )
	assert( upOrDownPos," !! upOrDownPos is nil !! " )
	self._state = upOrDownPos
	self._toListener = TouchNode.extends( self._img, function(event)
		return self:touchCard( event ) 
	end,true )
end

function NodePoker:touchCard( event )
	if event.name == "began" then
		self._img:stopAllActions()
		self._touch_began_pos = cc.p( event.x,event.y )
		self._img_began_pos = cc.p( self._img:getPosition())

		return true
	elseif event.name == "moved" then
		local touch_newPos = cc.p( event.x,event.y )
		local eff_x = touch_newPos.x - self._touch_began_pos.x
		local eff_y = touch_newPos.y - self._touch_began_pos.y
		self._img:setPosition( self._img_began_pos.x + eff_x,self._img_began_pos.y + eff_y )
	elseif event.name == "ended" then
		self._parentPanel:putPokerEnd( self )
	elseif event.name == "outsideend" then
		self:backToOriginalPos()
	end
end

function NodePoker:removePokerClick()
	if self._toListener then
		local dispater = cc.Director:getInstance():getEventDispatcher()
		dispater:removeEventListener( self._toListener )
		self._toListener = nil
	end
end

-- 回到原位
function NodePoker:backToOriginalPos()
	local move_to = cc.MoveTo:create( 0.5,cc.p( 0,0 ) )
	self._img:runAction( move_to )
end

function NodePoker:resetNumIndex( numIndex )
	assert( numIndex," !! numIndex is nil !! " )
	self._numIndex = numIndex
	self._img:loadTexture( suoha_config.poker[self._numIndex].path,1 )
end


function NodePoker:getNumIndex()
	return self._numIndex
end

function NodePoker:getColor()
	return suoha_config.poker[self._numIndex].color
end

function NodePoker:getCardNum()
	return suoha_config.poker[self._numIndex].num
end


return NodePoker