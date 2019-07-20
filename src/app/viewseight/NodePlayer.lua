

local NodePlayer = class( "NodePlayer",BaseNode )

NodePlayer.jqr = {
	"image/play/jqr1.png",
	"image/play/jqr2.png",
	"image/play/jqr3.png",
	"image/play/jqr4.png"
}
NodePlayer.playerName = {
	"image/play/Jean.png",
	"image/play/Lisa.png",
	"image/play/Tim.png",
	"image/play/You.png"
}
function NodePlayer:ctor( seatPos )
	assert( seatPos," !! seatPos is nil !! " )
	NodePlayer.super.ctor( self,"NodePlayer" )

	self._seatPos = seatPos
	self:addCsb( "csbeight/NodePlayer.csb" )

	self:loadUi()
end

function NodePlayer:loadUi(  )
	self.ImagePlayer:loadTexture( self.jqr[ self._seatPos ],1 )
	self.ImageName:loadTexture( self.playerName[ self._seatPos ],1 )
	
	if self._seatPos == 4 then
		local coin = G_GetModel("Model_Eight"):getCoin()
		self.TextCoin:setString( coin )
	else
		self.TextCoin:setString( 10000 )
	end
	
end






return NodePlayer