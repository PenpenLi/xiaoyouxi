

local NodeMiniGame2 = class( "NodeMiniGame2",BaseNode )

function NodeMiniGame2:ctor( parent )
	NodeMiniGame2.super.ctor( self )
	self._parent = parent

	self:addCsb( "csbslot/hall/bigwin_FlyCoins.csb" )

	self:playCsbAction( "idle",true )
	TouchNode.extends( self.Panel,function ( event )
		return self:collect( event )
	end)
end

function NodeMiniGame2:onExit()
	NodeMiniGame2.super.onExit( self )
	TouchNode.removeListener( self.Panel )
end

function NodeMiniGame2:collect( ... )
	self._parent:collectCoin( NodeMiniGame2.coin )
	self.node_coins:setVisible( false )
	self:textCoinAction()
	local began_pos = self.node_coins:getParent():convertToWorldSpace( cc.p(self.node_coins:getPosition()))
	local end_pos = cc.p( 150,display.height - 30 )
	G_GetModel("Model_Slot"):getInstance():setCoin( NodeMiniGame2.coin )
	local call = function ()
	    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN )
	end
	coinFly( began_pos,end_pos,call )
end

function NodeMiniGame2:freeFallingBody( time )
	local x = random( 50,display.width - 50 )
	local pos = cc.p( x,display.height + 100 )
	self:setPosition( pos )
	local scale = random( 7,12 )
	self:setScale( scale / 10 )
	NodeMiniGame2.coin = random( 5 * scale * scale,10 * scale * scale ) -- 金币值
	local end_pos = cc.p( x,-100 )
	local move_to = cc.MoveTo:create( time,end_pos )
	local ease_sine_in = cc.EaseSineIn:create( move_to )
	local delay = cc.DelayTime:create( 1 )
	local call = cc.CallFunc:create( function ()
		self:removeFromParent()
	end)
	local seq = cc.Sequence:create({ ease_sine_in,delay,call })
	self:runAction( seq )
end

function NodeMiniGame2:textCoinAction()
	local pos = cc.p( self:getPosition())
	local text_coin = ccui.Text:create()
	self._parent:addChild( text_coin )
	text_coin:setString( NodeMiniGame2.coin )
	text_coin:setPosition( pos )
	text_coin:setFontSize( 30 )
	text_coin:setTextColor( cc.c4b( 255,255,0,255 ) )
	local move_by = cc.MoveBy:create( 1,cc.p( 0,25 ))
	local fade_out = cc.FadeOut:create( 1 )
	local spawn = cc.Spawn:create({ move_by,fade_out })
	local call = function ()
		text_coin:removeFromParent()
	end
	local seq = cc.Sequence:create({ spawn,text_coin })
	text_coin:runAction( seq )
end
return NodeMiniGame2