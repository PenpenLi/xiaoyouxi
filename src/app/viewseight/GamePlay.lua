

local GamePlay = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )

    self:addCsb( "csbeight/GamePlay.csb" )
end


function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	-- 创建所有的牌
	self._allPokerNode = {}
	self:createBeiCard()
	-- 发牌动画
	performWithDelay( self,function()
		self:sendCardByBegan()
	end,0.5 )
end


function GamePlay:createBeiCard()
	local allPokerData = getRandomArray( 1,52 )
	for i = 1,#allPokerData do
		local poker = NodePoker.new( self,allPokerData[i] )
		self.PaiDuiNode:addChild( poker )
		self._allPokerNode[i] = poker
	end
end

function GamePlay:sendCardByBegan()
end


function GamePlay:sendCardToPlayer( seatPos,callBack )
	assert( seatPos," !! seatPos is nil !! " )
	assert( #self._allPokerNode > 0," !! pai dui card length must be > 0 !! " )
	local top_poker = self._allPokerNode[#self._allPokerNode]
	local world_pos = top_poker:getParent():convertToWorldSpace( cc.p( top_poker:getPosition() ) )
	top_poker:retain()
	top_poker:removeFromParent()
	self["AINode"..seatPos]:addChild( top_poker )
	top_poker:release()
	local node_pos = self["AINode"..seatPos]:convertToNodeSpace( world_pos )
	top_poker:setPosition( node_pos )
	
	local move_to = cc.MoveTo:create( 0.3,cc.p(0,0) )
end


function GamePlay:sortCardPosByColor( seatPos )
	assert( seatPos," !! seatPos is nil !! " )
	local childs = self["AINode"..seatPos]:getChildren()
	if #childs <= 1 then
		return
	end
	local diff = 20
	local start_pos = diff * #childs / 2
	
end




return GamePlay