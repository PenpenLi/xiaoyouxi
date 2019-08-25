


--
-- Author: 	刘阳
-- Date: 	2019-05-09
-- Desc:	关卡场景的顶部条


local GameTop = class("GameTop",BaseLayer)



function GameTop:ctor( param )
	GameTop.super.ctor( self )

	-- 加载csb
	self:addCsb("csbslot/hall/GameTop.csb")

	self:addNodeClick( self.ButtonBack,{
		endCallBack = function() 
			SceneManager:goToHallScene()
		end
	})
end


function GameTop:onEnter()
	GameTop.super.onEnter( self )
	self.listener:setSwallowTouches(false)
	self:loadDataUi()
end



function GameTop:loadDataUi()
	self:loadCoinUi()
	self:loadLevel()
end


function GameTop:loadCoinUi()
	local coin = G_GetModel("Model_Slot"):getCoin()
	self.TextHasCoin:setString( coin )
end


function GameTop:loadLevel()
	local level = G_GetModel("Model_Slot"):getLevel()
	self.TextLevel:setString( level )

	local need_exp = G_GetModel("Model_Slot"):getNeedExpForLevelUp()
	local now_exp = G_GetModel("Model_Slot"):getExpress()
	self.ExpressBar:setPercent( now_exp / need_exp * 100 )
end









return GameTop