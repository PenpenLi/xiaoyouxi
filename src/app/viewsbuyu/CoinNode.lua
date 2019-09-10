

local CoinNode = class( "CoinNode",BaseNode )

function CoinNode:ctor( gameLayer,start_Pos,end_Pos)
	CoinNode.super.ctor( self )

	self._startPos = start_Pos
	self._endPos = end_Pos
	self._coin = ccui.ImageView:create( "image/guns/gold_coin_0.png",1 )
	self:addChild( self._coin )
	-- self._coin:setPosition( start_Pos )


end
function CoinNode:onEnter()
	CoinNode.super.onEnter( self )
	self:coinAction()
	local is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		audio.playSound("bymp3/coinfly.mp3", false)
	end
	performWithDelay(self,function ()
		self:coinMove()
	end,0.1)
	
end

function CoinNode:coinAction()
	local index = 0
	self:schedule( function ()
		self._coin:loadTexture( "image/guns/gold_coin_"..index..".png",1 )
		index = index + 1
		if index > 11 then
			index = 0
		end
	end,0.03 )
end
function CoinNode:coinMove()

	local x_index = self._startPos.x - self._endPos.x
	local y_index = self._startPos.y - self._endPos.y
	local x_first = self._startPos.x * 2 / 3 - y_index/2
	local y_first = self._startPos.y * 3 / 3 - x_index/2
	local first_pos = cc.p( x_first,y_first )
	local x_second = self._startPos.x / 3 + y_index/2
	local y_second = self._startPos.y / 3 + x_index/2
	local second_pos = cc.p( x_second,y_second )
	-- dump( self._startPos,"----------------self._startPos = ")
	-- dump( self._endPos,"----------------self._endPos = ")
	-- local end_pos = self:getParent():convertToWorldSpace( self._endPos )
	-- local bz = cc.BezierTo:create(3,{ cc.p(0,720),cc.p(640,360),cc.p(640,100) })
	local bz = cc.BezierTo:create(1,{ first_pos,second_pos,self._endPos })
	local remove = cc.RemoveSelf:create()
	
	local call = cc.CallFunc:create(function ()
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_BUYU_KILL_COIN )
	end)
	local seq = cc.Sequence:create({ bz,call,remove })
	self:runAction( seq )
end



return CoinNode