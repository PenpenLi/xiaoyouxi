
local GameRedDiamondModel = import(".GameRedDiamondModel")
local RedDiamondReelUnit = import(".RedDiamondReelUnit")
local BaseGamePlay = import("app.viewsslot.base.BaseGamePlay")

local GameRedDiamondPlay = class("GameRedDiamondPlay",BaseGamePlay)




function GameRedDiamondPlay:initConfig()
	self._reelConfig = require( "app.viewsslot.config.gameconfigred" )
end

function GameRedDiamondPlay:loadGameCsb()
	self:addCsb( "csbslot/RedDiamond/GameScreenRedDiamond.csb" )

	-- 播放背景音乐
	if G_GetModel("Model_Sound"):isMusicOpen() then
		audio.playMusic("csbslot/hall/hmp3/bg2.mp3",true)
	end
end

function GameRedDiamondPlay:initReelNode()
	for i = 1,self._reelConfig.level.reel_count do
		self._spReelList[i] = self["reel_sp"..i]
	end
end

function GameRedDiamondPlay:initGameModel()
	self._gameModel = GameRedDiamondModel.new( self._reelConfig )
end

function GameRedDiamondPlay:createSingleReel( index )
	local reel = RedDiamondReelUnit.new( self._reelConfig.level,index )
	return reel
end

function GameRedDiamondPlay:oneRellDoneAction( nCol )
	-- 针对 scattle 播放动画
	local symbol_list = self._reelList[nCol]:getSymbolList()
	for k,v in pairs( symbol_list ) do
		local id = v:getSymbolID()
		if v:getSymbolID() == self._reelConfig.level.scattle_id then
			v:playCsbAction( "buling" )
		end
	end
end


function GameRedDiamondPlay:allRellRollDone()
	GameRedDiamondPlay.super.allRellRollDone( self )
	-- 1:针对 special_id 播放金钱获取动画
	for i = 1,#self._reelList do
		local symbol_list = self._reelList[i]:getSymbolList()
		for k,v in pairs( symbol_list ) do
			-- 当前symbol的位置必须在显示区域
			local pos = cc.p( v:getPosition() )
			local in_view = false
			if pos.y >= -10 and pos.y <= self._reelConfig.level.symbol_height * 3 -10 then
				in_view = true
			end
			if in_view and v:getSymbolID() == self._reelConfig.level.special_id then
				local world_pos = v:getParent():convertToWorldSpace( cc.p( v:getPosition() ) )
				world_pos.x = world_pos.x + self._reelConfig.level.symbol_width / 2
				world_pos.y = world_pos.y + self._reelConfig.level.symbol_height / 2
				local image_coin = self._topLayer.ImageCoinDollar
				local end_pos = image_coin:getParent():convertToWorldSpace( cc.p(image_coin:getPosition()) )
				coinFly( world_pos,end_pos )
			end
		end
	end
end

function GameRedDiamondPlay:showWinCoinUi( lines )
	local coin = self:calResultCoinByLines( lines )

	-- 针对 special_id 获得的额外金钱
	for i = 1,#self._reelList do
		local symbol_list = self._reelList[i]:getSymbolList()
		for k,v in pairs( symbol_list ) do
			-- 当前symbol的位置必须在显示区域
			local pos = cc.p( v:getPosition() )
			local in_view = false
			if pos.y >= -10 and pos.y <= self._reelConfig.level.symbol_height * 3 -10 then
				in_view = true
			end
			if in_view and v:getSymbolID() == self._reelConfig.level.special_id then
				coin = coin + v:getCoinNum()
			end
		end
	end

	G_GetModel("Model_Slot"):setCoin( coin )

	-- 累积freespin中的金币
	if self._gameModel:isFreeSpinStatus() then
		local free_coin = self._gameModel:getFreeSpinWinCoin()
		free_coin = free_coin + coin
		self._gameModel:setFreeSpinWinCoin( free_coin )
	end

	-- 改变状态
	if self._curFreeMark then
		-- 进入free_spin状态
		self._gameModel:changeStatusToFreeSpin()
	end

	-- bottom layer 的显示
	self._bottomLayer:setWinCoinUi( coin )
	self._bottomLayer:resetButtonSpin()
	self._topLayer:loadCoinUi()

	-- 显示freestart界面
	performWithDelay( self,function()
		self:showFreeSpinUI()
	end,1 )
end

function GameRedDiamondPlay:showFreeSpinUI()
	if self._gameModel:isFreeSpinStart() then
		-- 显示 freespin 的 UI 
		addUIToScene( UIDefine.SLOT_KEY.FreeSpinRedStart_UI )
		return
	end
	if self._gameModel:getFreeSpinOverMark() then
		local coin = self._gameModel:getFreeSpinWinCoin()
		self._gameModel:changeStatusToNormalSpin()
		self._bottomLayer:resetButtonSpin()
		addUIToScene( UIDefine.SLOT_KEY.FreeSpinRedOver_UI,coin )
		return
	end
end


return GameRedDiamondPlay