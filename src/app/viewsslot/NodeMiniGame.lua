

local NodeMiniGame = class( "NodeMiniGame",BaseNode )

function NodeMiniGame:ctor( parent )
	NodeMiniGame.super.ctor( self )
	self._parent = parent

	self:addCsb( "csbslot/hall/NodeMiniGame.csb" )
	-- self:addCsb( "csbslot/hall/NodeShop.csb")
	TouchNode.extends( self.Panel,function ( event )
		return self:collect( event )
	end)
	self:loadUi()
end

function NodeMiniGame:loadUi()
	NodeMiniGame.coin = random( 1000,5000 )

end

-- function NodeMiniGame:getCoin( ... )
-- 	return 
-- end

function NodeMiniGame:collect( ... )
	self:setVisible( false )
	self._parent:setTextCoin( NodeMiniGame.coin )
end








return NodeMiniGame