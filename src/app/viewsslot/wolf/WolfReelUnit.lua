
local BaseReelUnit = import("app.viewsslot.base.BaseReelUnit")
local WolfSymbolUnit = import(".WolfSymbolUnit")
local WolfReelUnit = class("WolfReelUnit",BaseReelUnit)


function WolfReelUnit:createSingleSymbol()
	local symbol = WolfSymbolUnit.new( self._symbolSize,self._reelConfig )
	return symbol
end



return WolfReelUnit