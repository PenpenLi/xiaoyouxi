

local NodeImageDraw = class( "NodeImageDraw",BaseNode )
function NodeImageDraw:ctor()
	NodeImageDraw.super.ctor( self )

	self:addCsb( "csbslot/hall/NodeImageDraw.csb" )
end

return NodeImageDraw