
local NodePlayer = import(".NodePlayer")
local NodePoker = import(".NodePoker")
local GamePlay = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )

    self:addCsb( "csbeight/GamePlay.csb" )

    self._handPokerWidth = 326
    -- self._handMetaWidth = 326 / 8
end



function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	-- 创建所有的牌
	self._allPokerNode = {}
	self:createBeiCard()
	--创建所有玩家
	self:createPlayer()
	--出牌顺序
	self._pointer = random( 1,3 )

	-- 发牌动画
	performWithDelay( self,function()
		self:sendCardByBegan()
	end,0.2 )
end

function GamePlay:createPlayer()
	for i = 1,4 do
		local play = NodePlayer.new( i )
		self["NodePlayer"..i]:addChild( play )
	end
end

function GamePlay:createBeiCard()
	local allPokerData = getRandomArray( 1,52 )
	for i = 1,#allPokerData do
		local poker = NodePoker.new( self,allPokerData[i] )
		self.PaiDuiNode:addChild( poker )
		self._allPokerNode[i] = poker
		poker:setLocalZOrder( i )
		poker:setPosition( -i * 0.5,i * 0.5 )
	end
end

function GamePlay:sendCardByBegan()
	local actions = {}
	for i = 1,8 do
		local delay_time = cc.DelayTime:create( 0.3 )
		table.insert( actions,delay_time )
		local call_send = cc.CallFunc:create( function()
			for j = 1,4 do
				self:sendCardToPlayer( j )
			end
		end )
		table.insert( actions,call_send )

		if i == 8 then
			local delay_time2 = cc.DelayTime:create( 1 )
			table.insert( actions,delay_time2 )
			local call_out = cc.CallFunc:create(function ()
				self:aiOutCard( self._pointer )
			end)
			table.insert( actions,call_out )
		end
	end
	self:runAction( cc.Sequence:create( actions ) )
end


function GamePlay:sendCardToPlayer( seatPos,callBack )
	assert( seatPos," !! seatPos is nil !! " )
	assert( #self._allPokerNode > 0," !! pai dui card length must be > 0 !! " )
	local top_poker = self._allPokerNode[#self._allPokerNode]
	self._allPokerNode[#self._allPokerNode] = nil
	local world_pos = top_poker:getParent():convertToWorldSpace( cc.p( top_poker:getPosition() ) )
	top_poker:retain()
	top_poker:removeFromParent()
	self["AINodePoker"..seatPos]:addChild( top_poker )
	top_poker:release()
	local node_pos = self["AINodePoker"..seatPos]:convertToNodeSpace( world_pos )
	top_poker:setPosition( node_pos )
	-- 明牌
	top_poker:showPoker()

	if seatPos == 1 then
		top_poker:setRotation( 90 )
	elseif seatPos == 2 then
		top_poker:setRotation( 180 )
	elseif seatPos == 3 then
		top_poker:setRotation( 270 )
	else
		top_poker:setRotation( 0 )
	end
	
	local move_to = cc.MoveTo:create( 0.3,cc.p(0,0) )
	local call_func = cc.CallFunc:create( function()
		self:sortCardPosByColor( seatPos )
	end )
	top_poker:runAction( cc.Sequence:create( { move_to,call_func } ) )
end

function GamePlay:sortCardPosByColor( seatPos )
	assert( seatPos," !! seatPos is nil !! " )
	local childs = self["AINodePoker"..seatPos]:getChildren()
	if #childs <= 1 then
		return
	end
	table.sort( childs,function( a,b )
		if a:getColor() ~= b:getColor() then
			return a:getColor() < b:getColor()
		end
		return a:getCardNum() < b:getCardNum()
	end )
	local size = childs[1]:getImageSize()
	if seatPos == 1 or seatPos == 3 then
		local meta_width = ( self._handPokerWidth - size.width ) / 7
		local start_pos = meta_width * #childs / 2
		for i,v in ipairs( childs ) do
			if seatPos == 1 then
				v:setLocalZOrder( i )
			else
				v:setLocalZOrder( 9 - i )
			end
			v:setPositionY( start_pos - (i-1) * meta_width )
		end
	end
	if seatPos == 2 or seatPos == 4 then
		local meta_width = ( self._handPokerWidth - size.width ) / 7
		local start_pos = meta_width * #childs / 2
		for i,v in ipairs( childs ) do
			if seatPos == 2 then
				v:setLocalZOrder( i )
			else
				v:setLocalZOrder( 9 - i )
			end
			v:setPositionX( start_pos - ( i - 1 ) * meta_width )
		end
	end
end


function GamePlay:aiOutCard( seatPos )
	assert( seatPos," !! seatPos is nill !! " )
	assert( seatPos >= 1 and seatPos <= 3," !! seatPos is error !! " )

	local childs = self["AINodePoker"..seatPos]:getChildren()
	self:outPokerFromPlayer( childs[2],seatPos )
end

function GamePlay:outPokerFromPlayer( poker,seatPos )
	assert( poker," !! poker is nill !! " )
	assert( seatPos," !! seatPos is nil !! " )
	local outNode_worldPos = self.OutNode:getParent():convertToWorldSpace( cc.p( self.OutNode:getPosition() ))
	local outTo_pos = self["AINodePoker"..seatPos]:convertToNodeSpace( outNode_worldPos )
	
	
	-- poker:setRotation( 0 )
	poker:setLocalZOrder( 100 )
	local rotate_to = cc.RotateTo:create( 5,0 )
	local move_to = cc.MoveTo:create( 5,outTo_pos )
	local spawn = cc.Spawn:create( rotate_to,move_to )
	local call = cc.CallFunc:create(function ()
		poker:retain()
		poker:removeFromParent()
		self.OutNode:addChild( poker )
		poker:setPosition( 0,0 )
		poker:release()
		self:sortCardPosByColor( seatPos )
	end)
	poker:runAction( cc.Sequence:create({ spawn,call }))
end


return GamePlay