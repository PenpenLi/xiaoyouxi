


local BaseSymbolUnit = import("app.viewsslot.base.BaseSymbolUnit")

local RedDiamondSymbolUnit = class("RedDiamondSymbolUnit",BaseSymbolUnit)






function RedDiamondSymbolUnit:loadDataUI( symbolId )
	RedDiamondSymbolUnit.super.loadDataUI( self,symbolId )

	-- 切换到静止帧
	if symbolId ~= self._reelConfig.scattle_id then
		self:playCsbAction("idleframe")
	end

	-- 针对特殊新号块
	if self._symbolId == self._reelConfig.special_id then
		local num = random(1,9) * 100
		self._csbVar["TextCoin"]:setString( num )
		self._coinNum = num
	end
end


function RedDiamondSymbolUnit:getCoinNum()
	return self._coinNum
end




return RedDiamondSymbolUnit