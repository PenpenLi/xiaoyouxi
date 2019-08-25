


--
-- Author: 	刘阳
-- Date: 	2019-05-09
-- Desc:	关卡场景的底部条


local GameBottom = class("GameBottom",BaseLayer)

GameBottom.SPIN_STATUS = {
	SPIN_IDLE				=  0,      
	SPIN_SEND				=  1,		
	SPIN_RECE               =  2,       

	REEL_STOP_START         =  3,      
	ALL_REEL_STOP_END	    =  4,       

	FREE_SPIN_IDLE          =  6,       
	FREE_SPIN_SEND          =  7,       
	FREE_SPIN_RECE          =  8,
}

function GameBottom:ctor( param )
	GameBottom.super.ctor( self )

	-- 加载csb
	self:addCsb("csbslot/hall/GameMainDown.csb")

	self:addNodeClick( self.ButtonSpin,{
		endCallBack = function() self:touchSpin() end
	})


	self:addNodeClick( self.BtnBetSub,{
		endCallBack = function() self:betSub() end
	})

	self:addNodeClick( self.BtnBetAdd,{
		endCallBack = function() self:betAdd() end
	})

	self:addNodeClick( self.BtnPayTable,{
		endCallBack = function() self:rule() end
	})

	self._spinStatus = self.SPIN_STATUS.SPIN_IDLE
end


function GameBottom:onEnter()
	GameBottom.super.onEnter( self )
	self:loadUiData()
	
	performWithDelay( self,function()
		self._gameLayer = display.getRunningScene():getPlayLayer()
		self._topLayer = display.getRunningScene():getTopLayer()
		self._gameModel = self._gameLayer:getGameModel()
	end,0.1 )
end



function GameBottom:loadUiData()
	-- 默认开始能spin
	self._canSpin = true

	--初始化LastWin跟TotalBet钱
	self._betCoin = 1000
	self:setTotalBetNum( self._betCoin )
	self:setWinCoin("0")
	self.TextFreeCount:setVisible( false )
end


function GameBottom:setTotalBetNum( coin )
	self["m_lb_coins"]:setString( tostring(coin) )
end

function GameBottom:setWinCoin( coin )
	self["TextWinCoin"]:setString( tostring(coin) )
end


function GameBottom:touchSpin()
	if self._spinMark then
		return
	end
	self._spinMark = true
	self.TextWinCoin:setString(0)
	if self._gameModel:isFreeSpinStatus() then
		self.TextFreeCount:setOpacity( 150 )
		self._gameModel:useFreeSpinTimes()
		self._gameLayer:startRoll()
		self.ButtonSpin:loadTexture( "image/common/spin_freespin_down.png",1 )
	else
		-- 判断金币
		local coin = G_GetModel("Model_Slot"):getCoin()
		if coin < self._betCoin then
			-- 弹出商店界面
			return
		end
		
		G_GetModel("Model_Slot"):setCoin( -self._betCoin )
		self._topLayer:loadCoinUi()
		self._gameLayer:startRoll()
		self.ButtonSpin:loadTexture( "image/common/spin_down.png",1 )
	end
end


function GameBottom:resetButtonSpin()
	self._spinMark = nil
	local free_count = self._gameModel:getFreeSpinCount()
	self.TextFreeCount:setVisible( free_count > 0 )
	if self._gameModel:isFreeSpinStatus() then
		self.TextFreeCount:setString( free_count )
		self.TextFreeCount:setOpacity( 255 )
		self.ButtonSpin:loadTexture( "image/common/spin_freespin_up.png",1 )
	else
		self.ButtonSpin:loadTexture( "image/common/spin_up.png",1 )
	end
end

function GameBottom:setWinCoinUi( coin )
	self.TextWinCoin:setString( coin )
end

function GameBottom:rule()
	addUIToScene( UIDefine.SLOT_KEY.Rule_UI )
end

return GameBottom