

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
	elseif self._seatPos == 1 then
		local coin1 = G_GetModel("Model_Eight"):getCoin1()
		self.TextCoin:setString( coin1 )
	elseif self._seatPos == 2 then
		local coin2 = G_GetModel("Model_Eight"):getCoin2()
		self.TextCoin:setString( coin2 )
	elseif self._seatPos == 3 then
		local coin3 = G_GetModel("Model_Eight"):getCoin3()
		self.TextCoin:setString( coin3 )
	end
	
end

function NodePlayer:setCoinString( addCoin )
	if self._seatPos == 4 then
		G_GetModel("Model_Eight"):setCoin( addCoin )
		local coin = G_GetModel("Model_Eight"):getCoin()
		self.TextCoin:setString( addCoin )
	elseif self._seatPos == 1 then
		G_GetModel("Model_Eight"):setCoin1( addCoin )
		local coin = G_GetModel("Model_Eight"):getCoin1()
		self.TextCoin:setString( addCoin )
	elseif self._seatPos == 2 then
		G_GetModel("Model_Eight"):setCoin2( addCoin )
		local coin = G_GetModel("Model_Eight"):getCoin2()
		self.TextCoin:setString( addCoin )
	elseif self._seatPos == 3 then
		G_GetModel("Model_Eight"):setCoin3( addCoin )
		local coin = G_GetModel("Model_Eight"):getCoin3()
		self.TextCoin:setString( addCoin )
	end
end






return NodePlayer