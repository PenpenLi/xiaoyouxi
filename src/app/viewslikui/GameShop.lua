
local NodeShop = import( "app/viewslikui/NodeShop" )
local GameShop = class( "GameShop",BaseLayer )

function GameShop:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameShop.super.ctor( self,param.name )

	self:addCsb( "Shop.csb" )

	self:loadUi()
end

function GameShop:loadUi()
	for i=1,3 do
		local node = NodeShop.new( self,i )
		self["Panel"..i]:addChild( node )
	end
end

function GameShop:onEnter()
	GameShop.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end








return GameShop