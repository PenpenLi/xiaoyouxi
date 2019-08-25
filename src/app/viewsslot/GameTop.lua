


--
-- Author: 	刘阳
-- Date: 	2019-05-09
-- Desc:	关卡场景的顶部条


local GameTop = class("GameTop",BaseLayer)



function GameTop:ctor( param )
	GameTop.super.ctor( self )

	-- 加载csb
	self:addCsb("csbslot/hall/GameTop.csb")
end


function GameTop:onEnter()
	GameTop.super.onEnter( self )
	self.listener:setSwallowTouches(false)
	self:loadDataUi()
end



function GameTop:loadDataUi()
	self:loadCoinUi()
end


function GameTop:loadCoinUi()
	local coin = G_GetModel("Model_Slot"):getCoin()
	self.TextHasCoin:setString( coin )
end












return GameTop