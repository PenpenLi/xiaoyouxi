


local BaseSymbolUnit = import("app.viewsslot.base.BaseSymbolUnit")

local CandySymbolUnit = class("CandySymbolUnit",BaseSymbolUnit)






function CandySymbolUnit:loadDataUI( symbolId )
	CandySymbolUnit.super.loadDataUI( self,symbolId )

	-- 针对特殊新号块
	if self._symbolId == self._reelConfig.special_id then
		local num = random(1,9) * 100
		self._csbVar["lab_item"]:setString( num )
		self._coinNum = num
	end
end


function CandySymbolUnit:getCoinNum()
	return self._coinNum
end




return CandySymbolUnit