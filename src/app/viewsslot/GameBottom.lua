


--
-- Author: 	刘阳
-- Date: 	2019-05-09
-- Desc:	关卡场景的底部条


local GameBottom = class("GameBottom",BaseLayer)

GameBottom.SPIN_STATUS = {
	SPIN_IDLE				=  0,       -- 处于 common spin 静止的状态 (可以向服务器发送spin消息)
	SPIN_SEND				=  1,		-- 处于 common spin	发送消息的状态
	SPIN_RECE               =  2,       -- 处于 common spin 收到消息的状态 (此时可以给轮盘发送停止命令)

	REEL_STOP_START         =  3,       -- 轮盘开始停止滚动的状态
	ALL_REEL_STOP_END	    =  4,       -- 轮盘停止完成的状态 (必须所有滚轴停止完毕)

	FREE_SPIN_IDLE          =  6,       -- 处于 free_spin 静止状态
	FREE_SPIN_SEND          =  7,       -- 处于 ree_spin 发送消息状态
	FREE_SPIN_RECE          =  8,       -- 处于 free_spin 接受消息状态
}

function GameBottom:ctor( param )
	GameBottom.super.ctor( self )

	-- 加载csb
	self:addCsb("csbslot/hall/GameMainDown.csb")

	self:addNodeClick( self.ButtonSpin,{
		endCallBack = function() self:touchSpinButtonEnd() end
	})
	self._spinStatus = self.SPIN_STATUS.SPIN_IDLE
end


function GameBottom:onEnter()
	GameBottom.super.onEnter( self )
	self:loadUiData()
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









return GameBottom