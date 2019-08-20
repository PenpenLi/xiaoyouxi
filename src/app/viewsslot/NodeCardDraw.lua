

local NodeCardDraw = class( "NodeCardDraw",BaseNode )


function NodeCardDraw:ctor(  )
	NodeCardDraw.super.ctor( self )
	-- self._num = param.data
	-- self._coin,self._keepOn = G_GetModel("Model_Slot"):getInstance():getCoinDrawData()

	self:addCsb( "csbslot/hall/CardDrawCoin.csb" )
end

function NodeCardDraw:onEnter()
	NodeCardDraw.super.onEnter( self )
	self:loadUi()
end

function NodeCardDraw:loadUi()
	self._coin,self._keepOn = G_GetModel("Model_Slot"):getInstance():getCoinDrawData()
	self.TextCoin:setString( self._coin )
	if self._keepOn == 0 then
		self.ImageCoin:loadTexture( "image/carddraw/fortune1.png" )
	else
		self.ImageCoin:loadTexture( "image/carddraw/fortune3.png" )
	end
end

function NodeCardDraw:getCoin( ... )
	return self._coin
end

function NodeCardDraw:getKeepOn( ... )
	return self._keepOn
end











return NodeCardDraw