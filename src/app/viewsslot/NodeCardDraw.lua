

local NodeCardDraw = class( "NodeCardDraw",BaseNode )


function NodeCardDraw:ctor(  )
	NodeCardDraw.super.ctor( self )
	-- self._num = param.data


	self:addCsb( "csbslot/hall/CardDrawCoin.csb" )
end

function NodeCardDraw:onEnter()
	NodeCardDraw.super.onEnter( self )
	self:loadUi()
end

function NodeCardDraw:loadUi()
	
end















return NodeCardDraw