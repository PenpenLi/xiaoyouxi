

local BaseGameModel = import(".BaseGameModel")
local BaseReelUnit = import(".BaseReelUnit")
local BaseGamePlay = class( "BaseGamePlay",BaseLayer )



function BaseGamePlay:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	BaseGamePlay.super.ctor( self,param.name )

	self:initData()
end

function BaseGamePlay:initData()
	self._spReelList = {}
	self._reelList = {}
	self._effectList = {}

	self:initConfig()
	self:loadGameCsb()
	self:initReelNode()
	self:initGameModel()
end


---------------------------    子类必须重写的部分 start   -----------------------------------

-- 子类必须重写
function BaseGamePlay:initConfig()
	self._reelConfig = nil
end

-- 子类必须重写
function BaseGamePlay:loadGameCsb()
	
end

-- 子类必须重写
function BaseGamePlay:initReelNode()
	
end

-- 子类必须重写
function BaseGamePlay:initGameModel()
	self._gameModel = BaseGameModel.new( self._reelConfig )
end


-- 子类必须重写
function BaseGamePlay:createSingleReel( index )
	local reel = BaseReelUnit.new( self._reelConfig.level,index )
	return reel
end

-- 子类可能需要重写 单个滚轴的停止动画 
function BaseGamePlay:oneRellDoneAction( nCol )
	
end

-- 子类可能需要重写 所有滚轴的停止 
function BaseGamePlay:allRellRollDone()
	-- 1:移除所有特效
	self:removeAllEffectAction()
	-- 2:针对 scale_id 播放动画
	for i = 1,#self._reelList do
		local symbol_list = self._reelList[i]:getSymbolList()
		for k,v in pairs( symbol_list ) do
			-- 当前symbol的位置必须在显示区域
			local pos = cc.p( v:getPosition() )
			local in_view = false
			if pos.y >= -10 and pos.y <= self._reelConfig.level.symbol_height * 3 -10 then
				in_view = true
			end
			if in_view and v:getSymbolID() == self._reelConfig.level.scattle_id then
				v:playCsbAction("actionframe",true)
			end
		end
	end
	-- 3:播放连线
	local lines = self._gameModel:getLineResult()
	if #lines > 0 then
		self:drawLineAndEffect( lines )
	end
	-- 4:显示获得的金币
	self:showWinCoinUi( lines )

	-- 子类实现 重置按钮 和显示 freestart界面 和 freeover界面
end


-- 子类可能需要重写
function BaseGamePlay:showWinCoinUi( lines )
	-- local coin = self:calResultCoinByLines( lines )
	-- G_GetModel("Model_Slot"):setCoin( coin )
	-- -- bottom layer 的显示
	-- self._bottomLayer:setWinCoinUi( coin )
	-- self._topLayer:loadCoinUi()
end

-- 子类必须重写 显示FreeSpinStart界面
function BaseGamePlay:showFreeSpinStart()
end

-- 子类可能需要重写 显示FreeSpinOver界面
function BaseGamePlay:showFreeSpinOver()
end


-- 子类必须重写
function BaseGamePlay:createReel()
	for i = 1,self._reelConfig.level.reel_count do
		local reel = self:createSingleReel( i )
		self._spReelList[i]:addChild( reel )
		self._reelList[i] = reel
	end
end
-------------------------  子类必须重写的部分 end   --------------------------------------


function BaseGamePlay:calResultCoinByLines( lines )
	local coin = 0
	if #lines > 0 then
		coin = self._gameModel:getRewardCoinByLine( lines )
	end
	return coin
end





--------------------------------- 创建 监听 滚轴 start ----------------------------------------------
function BaseGamePlay:onEnter()
	BaseGamePlay.super.onEnter( self )
	self:createReel()

	performWithDelay( self,function()
		self._bottomLayer = display.getRunningScene():getBottomLayer()
		self._topLayer = display.getRunningScene():getTopLayer()
	end,0.1 )
end

function BaseGamePlay:addListener()
	-- 单个滚轴停止滚动的监听
    self:addMsgListener( InnerProtocol.INNER_EVENT_SLOT_RELL_STOP_ROLL,function( event )
        self:oneReelRollDone( event.data[1] )
    end )
end



------------------------------------------------------------------------------













---------------------------------------- 滚动相关 start ----------------------------------
function BaseGamePlay:startRoll()
	-- 1:执行开始滚动的指令
	if self:canRoll() then
		-- 停止动画
		self:stopAllActions()
		self:stopAllSymbolAction()
		self:removeAllEffectAction()
		local actions = {}
		for i,v in ipairs( self._reelList ) do
			local delay = cc.DelayTime:create( 0.1 )
			local call = cc.CallFunc:create( function()
				v:startRoll()
			end )
			table.insert( actions,delay )
			table.insert( actions,call )

			-- 3秒之后 自动停止
			if i == #self._reelList then
				local delay1 = cc.DelayTime:create( 3 )
				local call_stop = cc.CallFunc:create( function()
					self:stopRoll()
				end )
				table.insert( actions,delay1 )
				table.insert( actions,call_stop )
			end
		end
		local seq = cc.Sequence:create( actions )
		self:runAction( seq )
	end
end


function BaseGamePlay:stopRoll()
	if self:canStop() then
		-- 开始停止
		local reel_data,free_mark = self._gameModel:getRollResult()
		self._curFreeMark = free_mark
		if free_mark then
			self:freeSpinStopRoll( reel_data )
		else
			self:normalStopRoll( reel_data )
		end
	end
end

-- 停止所有信号块的csb动画
function BaseGamePlay:stopAllSymbolAction()
	for i,v in ipairs( self._reelList ) do
		local symbol_list =  v:getSymbolList()
		for a,b in ipairs( symbol_list ) do
			b:stopCsbaction()
		end
	end
end

-- 轮盘是否能滚动
function BaseGamePlay:canRoll()
	local can = true
	for i,v in ipairs( self._reelList ) do
		if not v:canRoll() then
			can = false
			break
		end
	end
	return can
end


-- 有快滚 进入freeSpin的停止
function BaseGamePlay:freeSpinStopRoll( reelData )
	local actions = {}
	local has_scattle = function( source )
		for i,v in ipairs( source ) do
			if v == self._reelConfig.level.scattle_id then
				return true
			end
		end
		return false
	end
	-- 算出第几列需要快滚
	local scattle_count = 0
	local scattle_index = 0
	for i,v in ipairs( reelData ) do
		if has_scattle( v ) then
			scattle_count = scattle_count + 1
		end
		if scattle_count == 2 then
			scattle_index = i
			break
		end
	end

	-- 普通速度
	local actions = {}
	for i = 1,scattle_index do
		local delay = cc.DelayTime:create( 0.1 )
		local call = cc.CallFunc:create( function()
			self._reelList[i]:stopRoll( reelData[i] )
		end )
		table.insert( actions,delay )
		table.insert( actions,call )
	end
	-- 快滚
	local call_quick = cc.CallFunc:create( function()
		for i = scattle_index + 1,#self._reelList do
			-- 速度
			self._reelList[i]:setQuickSpeed()
			-- 添加滚动特效
			self:addQuickEffectByStartCol( i )
		end
	end )
	local delay_quick = cc.DelayTime:create( 2 )
	local call_stop = cc.CallFunc:create( function()
		for i = scattle_index + 1,#self._reelList do
			self._reelList[i]:stopRoll( reelData[i] )
		end
	end )
	table.insert( actions,call_quick )
	table.insert( actions,delay_quick )
	table.insert( actions,call_stop )

	local seq = cc.Sequence:create( actions )
	self:runAction( seq )
end

-- 普通停止
function BaseGamePlay:normalStopRoll( reelData )
	local actions = {}
	for i,v in ipairs( self._reelList ) do
		local delay = cc.DelayTime:create( 0.1 )
		local call = cc.CallFunc:create( function()
			v:stopRoll( reelData[i] )
		end )
		table.insert( actions,delay )
		table.insert( actions,call )
	end
	local seq = cc.Sequence:create( actions )
	self:runAction( seq )
end

-- 轮盘是否能停止
function BaseGamePlay:canStop()
	local can = true
	for i,v in ipairs( self._reelList ) do
		if not v:canStop() then
			can = false
			break
		end
	end
	return can
end

--[[
	某个滚轴完全停止了滚动
	-- nCol:某个轮盘的索引
]]
function BaseGamePlay:oneReelRollDone( nCol )
	assert( nCol," !! nCol is nil !! " )
	if self._stopReelCount == nil then
		self._stopReelCount = 1
	else
		self._stopReelCount = self._stopReelCount + 1
	end
	self:oneRellDoneAction( nCol )
	-- 当所有轮盘都停止了滚动
	if self._stopReelCount >= #self._reelList then
		self._stopReelCount = nil
		self:allRellRollDone()
	end
end




----------------------------------------- 滚动相关 end ------------------------------


















-------------------------------------- 特效相关 start ------------------------------------


-- 添加跑马灯特效
function BaseGamePlay:drawLineAndEffect( lines )
	local actions = {}
	for i,v in ipairs( lines ) do
		local symbol_lines = v.line
		for a,line in ipairs( symbol_lines ) do
			local call = cc.CallFunc:create( function()
				for nCol,nRow in ipairs( line ) do
					local pos = self:getSymbolWorldPos( nCol,nRow )
					self:addPaoMaDengEffect( pos )
					local symbol = self:getSymbolByWorldPos( nCol,pos )
					symbol:playCsbAction( "actionframe" )
				end
			end )
			
			local delay_time1 = cc.DelayTime:create( 2 )
			local call_remove = cc.CallFunc:create( function()
				-- 移除跑马灯
				self:removeAllEffectAction()
				self._effectList = {}
			end )

			local delay_time2 = cc.DelayTime:create( 2 )
			table.insert( actions,call )
			table.insert( actions,delay_time1 )
			table.insert( actions,call_remove )
			table.insert( actions,delay_time2 )
		end
	end
	local seq = cc.Sequence:create( actions )
	local rep = cc.RepeatForever:create( seq )
	self:runAction( rep )
end

function BaseGamePlay:addPaoMaDengEffect( pos )
	local effect_data = EffectCsbCache:getCsbNodeByEffectName("paomadeng")
	self:addChild( effect_data.node,50 )
	effect_data.node:setPosition( pos )
	effect_data.node:runAction( effect_data.action )
	playCsbActionForKey( effect_data.action,"actionframe",true )
	table.insert( self._effectList,effect_data )
end

-- 将使用的node返回给缓存池
function BaseGamePlay:removeAllEffectAction()
	for i,v in pairs( self._effectList ) do
		self:removeEffect( v )
	end
	self._effectList = {}
end

-- 移除连线的特效
function BaseGamePlay:removeEffect( effectData )
	effectData.node:removeFromParent()
	EffectCsbCache:resetCsbNodeUsed( effectData.effectName, effectData.index )
end

-- 根据列创建快滚特效
--[[
	nCol:列 滚轴的reel的索引
]]
function BaseGamePlay:addQuickEffectByStartCol( nCol )
	assert( nCol," !! nCol is nil  !! " )
	local size = self._spReelList[nCol]:getContentSize()
	if not self._effectList[nCol] then
		local effect_data = EffectCsbCache:getCsbNodeByEffectName("kuaigun")
		self._spReelList[nCol]:addChild( effect_data.node,50 )
		effect_data.node:setPosition( cc.p( size.width / 2,size.height / 2 ) )
		effect_data.node:runAction( effect_data.action )
		playCsbActionForKey( effect_data.action,"run",true )
		self._effectList[nCol] = effect_data
	end
end
---------------------------------------- 特效相关 end  ------------------------------------





-- 根据行列获取信号快的世界坐标
function BaseGamePlay:getSymbolWorldPos( nCol,nRow )
	local pos_reel = cc.p( self._spReelList[nCol]:getPosition() )
	local world_symbol_pos = self._spReelList[nCol]:getParent():convertToWorldSpace( pos_reel )
	world_symbol_pos.x = world_symbol_pos.x + self._reelConfig.level.symbol_width / 2
	world_symbol_pos.y = world_symbol_pos.y + (nRow - 1) * self._reelConfig.level.symbol_height
	world_symbol_pos.y = world_symbol_pos.y + self._reelConfig.level.symbol_height / 2
	return world_symbol_pos
end

-- 根据坐标获取信号快
function BaseGamePlay:getSymbolByWorldPos( reelIndex,worldPos )
	local symbol_list = self._reelList[reelIndex]:getSymbolList()
	for k,v in pairs( symbol_list ) do
		local pos = cc.p( v:getPosition() )
		local symbol_worldpos = v:getParent():convertToWorldSpace( pos )
		local rect = { 
			x = symbol_worldpos.x,
			y = symbol_worldpos.y,
			width = self._reelConfig.level.symbol_width,
			height = self._reelConfig.level.symbol_height 
		}
		if cc.rectContainsPoint(rect, worldPos) then
			return v 
		end
	end
end

function BaseGamePlay:getGameModel()
	return self._gameModel
end



return BaseGamePlay