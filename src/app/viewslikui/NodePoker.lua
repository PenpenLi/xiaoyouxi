



local NodePoker = class( "NodePoker",BaseNode )

function NodePoker:ctor( panelParent,numberIndex )
	assert( numberIndex," !! numberIndex is nil !! " )
	NodePoker.super.ctor( self,"NodePoker" )
	self._panelParent = panelParent
	self._numberIndex = numberIndex
	self._img = ccui.ImageView:create( likui_config.poker[numberIndex].path )

	self:addChild( self._img )
	self._img:setVisible( false )

	self._imgBack = ccui.ImageView:create( "image/poker/bei.png" )
	self:addChild( self._imgBack )

end

function NodePoker:showPoker()
	
end
-- 获取牌的序号
function NodePoker:getNumberIndex()
	return self._numberIndex
end
function NodePoker:getColorIndex()
	return likui_config.poker[self._numberIndex].color
end
-- 获取牌的值
function NodePoker:getNumberOfBigOrSmall( ... )
	return likui_config.poker[self._numberIndex].num
end

function NodePoker:showObtAniUseScaleTo( time )
	assert( time," !! time is nil!! " )
	local call_front = cc.CallFunc:create( function()
		self._img:setScaleX( 0 )
		self._img:setSkewY( -10 )
		local scale_front = cc.ScaleTo:create(time,1,1)
		local skew1 = cc.SkewTo:create( time, 0, 0 )
		local spawn_front = cc.Spawn:create({ scale_front,skew1 })
		local pSeqFront = cc.Sequence:create({ cc.Show:create(),spawn_front })
		self._img:runAction(pSeqFront)
	end )

	local skew1 = cc.SkewTo:create( time, 0, -10 )
	local scale_to = cc.ScaleTo:create(time,0,1)
	local spawn_back = cc.Spawn:create({ scale_to,skew1 })
	local pBackSeq = cc.Sequence:create({spawn_back,cc.Hide:create(),call_front})
	self._imgBack:runAction( pBackSeq )
end
-- function NodePoker:AISendPokerShowAnction( time )
-- 	assert( time," !! time is nil !! " )
-- 	local scale_to = cc.ScaleTo:create( time,0.6 )

-- end








return NodePoker