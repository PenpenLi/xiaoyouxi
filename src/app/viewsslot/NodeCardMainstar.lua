

local NodeCardMainstar = class( "NodeCardMainstar",BaseNode )


function NodeCardMainstar:ctor()
	NodeCardMainstar.super.ctor( self )

	self:addCsb( "csbslot/hall/CardMainstar.csb" )
	self:playCsbAction( "actionframe",true )
end

function NodeCardMainstar:onEnter()
	NodeCardMainstar.super.onEnter( self )
end

return NodeCardMainstar