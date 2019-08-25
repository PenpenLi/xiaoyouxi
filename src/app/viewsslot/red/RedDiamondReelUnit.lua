
local BaseReelUnit = import("app.viewsslot.base.BaseReelUnit")
local RedDiamondSymbolUnit = import(".RedDiamondSymbolUnit")
local RedDiamondReelUnit = class("RedDiamondReelUnit",BaseReelUnit)


function RedDiamondReelUnit:createSingleSymbol()
	local symbol = RedDiamondSymbolUnit.new( self._symbolSize,self._reelConfig )
	return symbol
end



return RedDiamondReelUnit