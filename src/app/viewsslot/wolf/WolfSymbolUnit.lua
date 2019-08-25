


local BaseSymbolUnit = import("app.viewsslot.base.BaseSymbolUnit")

local WolfSymbolUnit = class("WolfSymbolUnit",BaseSymbolUnit)






function WolfSymbolUnit:loadDataUI( symbolId )
	WolfSymbolUnit.super.loadDataUI( self,symbolId )

	-- 针对特殊新号块
	if self._symbolId == self._reelConfig.special_id then
		local num = random(1,9) * 100
		self._csbVar["score_lab"]:setString( num )
		self._coinNum = num
	end
end


function WolfSymbolUnit:getCoinNum()
	return self._coinNum
end




return WolfSymbolUnit