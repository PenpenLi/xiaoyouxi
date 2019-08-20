


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
	self._spinStatus = self.SPIN_STATUS.SPIN_IDLE
end


function GameBottom:onEnter()
	GameBottom.super.onEnter( self )
	self:loadUiData()
	
	performWithDelay( self,function()
		self._gameLayer = display.getRunningScene():getPlayLayer()
	end,0.1 )
end



function GameBottom:loadUiData()
	-- 默认开始能spin
	self._canSpin = true

	--初始化LastWin跟TotalBet钱
	self:setTotalBetNum("1000")
	self:setWinCoin("0")
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
	self._gameLayer:startRoll()
	self.ButtonSpin:loadTexture( "image/common/spin_down.png",1 )
end


function GameBottom:resetButtonSpin()
	self._spinMark = nil
	self.ButtonSpin:loadTexture( "image/common/spin_up.png",1 )
end


return GameBottom