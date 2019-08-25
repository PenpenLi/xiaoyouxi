
local BaseReelUnit = import("app.viewsslot.base.BaseReelUnit")
local CandySymbolUnit = import(".CandySymbolUnit")
local CandyReelUnit = class("CandyReelUnit",BaseReelUnit)


function CandyReelUnit:createSingleSymbol()
	local symbol = CandySymbolUnit.new( self._symbolSize,self._reelConfig )
	return symbol
end



return CandyReelUnit