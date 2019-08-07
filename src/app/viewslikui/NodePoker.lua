



local NodePoker = class( "NodePoker",BaseNode )

function NodePoker:ctor( panelParent,numberIndex )
	assert( numberIndex," !! numberIndex is nil !! " )
	NodePoker.super.ctor( self,"NodePoker" )
	self._panelParent = panelParent
	self._numberIndex = numberIndex

	self:addCsb("csblikui/NodePoker.csb")

	self.Icon:setVisible( false )
	self.ImageQuan2:setVisible( false )
	self.ImageQuan1:setVisible( false )

	self.Icon:loadTexture( likui_config.poker[self._numberIndex].path,1 )
end

function NodePoker:showPoker()
	self.Icon:setVisible( true )
end
-- 获取牌的序号
function NodePoker:getNumberIndex()
	return self._numberIndex
end
function NodePoker:getColorIndex()
	return likui_config.poker[self._numberIndex].color
end
-- 获取牌的值
function NodePoker:getNumberOfBigOrSmall()
	return likui_config.poker[self._numberIndex].num
end

function NodePoker:showQuan1( value )
	self.ImageQuan1:setVisible( value )
end

function NodePoker:showQuan2( value )
	self.ImageQuan2:setVisible( value )
end

function NodePoker:showObtAniUseScaleTo( time )
	assert( time," !! time is nil!! " )
	self.Icon:setVisible( false )
	local call_front = cc.CallFunc:create( function()
		self.Icon:setScaleX( 0 )
		self.Icon:setSkewY( -10 )
		local scale_front = cc.ScaleTo:create(time,1,1)
		local skew1 = cc.SkewTo:create( time, 0, 0 )
		local spawn_front = cc.Spawn:create({ scale_front,skew1 })
		local pSeqFront = cc.Sequence:create({ cc.Show:create(),spawn_front })
		self.Icon:runAction(pSeqFront)
	end )

	local skew1 = cc.SkewTo:create( time, 0, -10 )
	local scale_to = cc.ScaleTo:create(time,0,1)
	local spawn_back = cc.Spawn:create({ scale_to,skew1 })
	local pBackSeq = cc.Sequence:create({spawn_back,cc.Hide:create(),call_front})
	self.ImageBei:runAction( pBackSeq )
end


function NodePoker:showBackAniUseScaleTo( time )
	assert( time," !! time is nil!! " )
	self.Icon:setVisible( true )
	local call_front = cc.CallFunc:create( function()
		self.ImageBei:setScaleX( 0 )
		self.ImageBei:setSkewY( -10 )
		local scale_front = cc.ScaleTo:create(time,1,1)
		local skew1 = cc.SkewTo:create( time, 0, 0 )
		local spawn_front = cc.Spawn:create({ scale_front,skew1 })
		local pSeqFront = cc.Sequence:create({ cc.Show:create(),spawn_front })
		self.ImageBei:runAction(pSeqFront)
	end )

	local skew1 = cc.SkewTo:create( time, 0, -10 )
	local scale_to = cc.ScaleTo:create(time,0,1)
	local spawn_back = cc.Spawn:create({ scale_to,skew1 })
	local pBackSeq = cc.Sequence:create({spawn_back,cc.Hide:create(),call_front})
	self.Icon:runAction( pBackSeq )
end

function NodePoker:addPokerClick()
	assert( self.PanelPoker.listener == nil," !! listener is exist !! " )
	TouchNode.extends( self.PanelPoker, function(event)
		return self:touchCard( event ) 
	end )
	self.PanelPoker.listener:setSwallowTouches(true)
end

function NodePoker:removePokerClick()
	TouchNode.removeListener( self.PanelPoker )
end

function NodePoker:touchCard( event )
	if event.name == "began" then
		return true
	elseif event.name == "moved" then
		
	elseif event.name == "ended" then
		self._panelParent:playerOutPoker( self )
	end
end





return NodePoker