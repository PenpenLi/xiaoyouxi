

local ReelUnit = import(".base.ReelUnit")
local GamePlay = class( "GamePlay",BaseLayer )


function GamePlay:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GamePlay.super.ctor( self,param.name )

	self._levelIndex = param.data[1]

	self:addCsb( "csbslot/wolfLighting/GameScreenPharaoh.csb" )

	self._reelConfig = require( "app.viewsslot.config.gameconfig"..self._levelIndex )
	self._reelList = {}
	self._effectList = {}

	self._betCoin = 1000
	self._freeCount = 0
end


function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	self:loadDataUi()
	performWithDelay( self,function()
		self._bottomLayer = display.getRunningScene():getBottomLayer()
	end,0.1 )
end

function GamePlay:addListener()
    self:addMsgListener( InnerProtocol.INNER_EVENT_SLOT_RELL_STOP_ROLL,function( event )
        self:oneReelRollDone( event.data[1] )
    end )
end

function GamePlay:loadDataUi()
	-- 创建滚轴
	self:createReel()
end

function GamePlay:createReel()
	for i = 1,5 do
		local reel = ReelUnit.new( self._reelConfig.level,i )
		self["sp_reel_"..i]:addChild( reel )
		self._reelList[i] = reel
	end
end


function GamePlay:startRoll()
	-- 1:执行开始滚动的指令
	if self:canRoll() then
		if self._curFreeMark then
		end
		-- 停止动画
		self:stopAllSymbolAction()
		self:releaseAllEffect()
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

function GamePlay:stopRoll()
	if self:canStop() then
		-- 开始停止
		local reel_data,free_mark = self:getRollResult()
		if free_mark then
			self:freeSpinStopRoll( reel_data )
		else
			self:normalStopRoll( reel_data )
		end
		self._reelResultData = reel_data
		self._curFreeMark = free_mark


	end
end


-- 有快滚 进入freeSpin的停止
function GamePlay:freeSpinStopRoll( reelData )
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
function GamePlay:normalStopRoll( reelData )
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


-- 轮盘是否能滚动
function GamePlay:canRoll()
	local can = true
	for i,v in ipairs( self._reelList ) do
		if not v:canRoll() then
			can = false
			break
		end
	end
	return can
end

-- 轮盘是否能停止
function GamePlay:canStop()
	local can = true
	for i,v in ipairs( self._reelList ) do
		if not v:canStop() then
			can = false
			break
		end
	end
	return can
end

-- 停止所有信号块的csb动画
function GamePlay:stopAllSymbolAction()
	for i,v in ipairs( self._reelList ) do
		local symbol_list =  v:getSymbolList()
		for a,b in ipairs( symbol_list ) do
			b:stopCsbaction()
		end
	end
end


--[[
	某个滚轴完全停止了滚动
	-- nCol:某个轮盘的索引
]]
function GamePlay:oneReelRollDone( nCol )
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


function GamePlay:oneRellDoneAction( nCol )
	-- 针对 scattle 播放动画
	local symbol_list = self._reelList[nCol]:getSymbolList()
	for k,v in pairs( symbol_list ) do
		local id = v:getSymbolID()
		if v:getSymbolID() == self._reelConfig.level.scattle_id then
			v:playCsbAction( "buling" )
		end
	end
end

function GamePlay:allRellRollDone()
	local actions = {}
	-- 1:移除快滚特效
	local call1 = cc.CallFunc:create( function()
		self:removeAllQuickEffect()
	end )
	table.insert( actions,call1 )
	-- 2:针对 special_id 播放金钱获取动画
	local has_special = false
	local call2 = cc.CallFunc:create( function()
		for i = 1,#self._reelList do
			local symbol_list = self._reelList[i]:getSymbolList()
			for k,v in pairs( symbol_list ) do
				if v:getSymbolID() == self._reelConfig.level.special_id then
					has_special = true
					G_GetModel("Model_Slot"):setCoin( v:getCoinNum() )

					-- local world_pos = v:getParent():convertToWorldSpace( cc.p( v:getPosition() ) )
					-- local end_pos = display
				end
			end
		end
	end )
	table.insert( actions,call2 )
	if has_special then
		local delay = cc.DelayTime:create( 1.5 )
		table.insert( actions,delay )

		-- 刷新金币

	end
	-- 3:播放连线
	local call_line = cc.CallFunc:create( function()
		local lines = self:getLineResult()
		if #lines > 0 then
			self:drawLineAndEffect( lines )
			-- 计算获得的金币
			local coin = self:getRewardCoin( lines )
			G_GetModel("Model_Slot"):setCoin( coin )
		end
	end )
	table.insert( actions,call_line )

	local seq = cc.Sequence:create( actions )
	self:runAction( seq )
	
	-- 重置按钮
	self._bottomLayer:resetButtonSpin()
end

function GamePlay:getLineResult()
	local lines = {}
	for i,v in ipairs( self._reelResultData[1] ) do
		if self:hasLineBySymbolId( v ) then
			local meta = { {i} }
			local has,index_list2 = self:hasSymbolIdByReelData( v,self._reelResultData[2] )
			local new_data = self:twoTableMultiplication( meta,index_list2 )
			local has,index_list3 = self:hasSymbolIdByReelData( v,self._reelResultData[3] )
			new_data = self:twoTableMultiplication( new_data,index_list3 )
			
			local has,index_list4 = self:hasSymbolIdByReelData( v,self._reelResultData[4] )
			if has then
				new_data = self:twoTableMultiplication( new_data,index_list4 )
				local has,index_list5 = self:hasSymbolIdByReelData( v,self._reelResultData[5] )
				if has then
					new_data = self:twoTableMultiplication( new_data,index_list5 )
				end
			end
			table.insert( lines,{ symbolId = v,line = new_data })
		end
	end

	-- 根据配置 筛选可用的连线

	dump( lines,"----------------> lines = ",5 )

	local valid_lines = {}

	for i,v in ipairs( lines ) do
		local meta = {}
		meta.symbolId = v.symbolId
		meta.line = {}

		local symbol_lines = v.line
		for a,line in ipairs( symbol_lines ) do
			if self:isValidLine( line ) then
				table.insert( meta.line,line )
			end
		end
		if #meta.line > 0 then
			table.insert( valid_lines,meta )
		end
	end

	dump( valid_lines,"----------------> valid_lines = ",5 )


	return valid_lines
end

function GamePlay:getRewardCoin( lines )
	local bet = self._reelConfig.bet
	local total_coin = 0
	for i,v in ipairs( lines ) do
		local symbol_id = v.symbolId
		local symbol_lines = v.line
		local bet_config = bet[symbol_id]
		for a,line in ipairs( symbol_lines ) do
			local count = #line
			for o,p in ipairs( bet_config ) do
				if p.count == count then
					total_coin = total_coin + p.bet * self._betCoin
				end
			end
		end
	end
	return total_coin
end

function GamePlay:hasLineBySymbolId( symbolId )
	-- 2,3列必须有
	if not self:hasSymbolIdByReelData( symbolId,self._reelResultData[2] ) then
		return false
	end
	if not self:hasSymbolIdByReelData( symbolId,self._reelResultData[3] ) then
		return false
	end
	return true
end

function GamePlay:hasSymbolIdByReelData( symbolId,reelData )
	local has = false
	local index_list = {}
	for i,v in ipairs( reelData ) do
		if symbolId == v or v == self._reelConfig.level.wild_id then
			has = true
			table.insert( index_list,i )
		end
	end
	return has,index_list
end

-- 结果
function GamePlay:getRollResult()
	local reel_data = {}
	for i = 1,#self._reelList do
		local meta = {}
		for j = 1,self._reelConfig.level.view_count do
			if i == 1 then
				table.insert( meta,random(0,8))
			else
				table.insert( meta,random(0,11))
			end
		end
		table.insert( reel_data,meta )
	end

	-- 设置freespin的数据 ( 每列至少有1个scattle 至少有3列 )
	local free_mark = (random( 1,5 )) == 1 and (not self._curFreeMark)
	if free_mark then
		local total_scattle = 0
		local no_scattle_reel = {}
		for i = 2,#self._reelList do
			local has_scattle = false
			for a,b in ipairs( reel_data[i] ) do
				if b == self._reelConfig.level.scattle_id then
					has_scattle = true
					total_scattle = total_scattle + 1
					break
				end
			end

			if not has_scattle then
				table.insert( no_scattle_reel,i )
			end
		end

		-- 设置scattle数据
		if total_scattle < 3 then
			local need_count = 3 - total_scattle
			for i = 1,need_count do
				local pos = random(1,3)
				reel_data[no_scattle_reel[i]][pos] = self._reelConfig.level.scattle_id
			end
		end
	end
	return reel_data,free_mark
end



--[[
	两个表做乘法
	source1 格式: { {1},{2} }
	source2 格式: { 1,2,3 }
]]
function GamePlay:twoTableMultiplication( source1,source2 )
    local new_data = {}
    for i,v in ipairs( source1 ) do
        for a,b in ipairs( source2 ) do
            local meta = clone( v )
            table.insert( meta,b )
            table.insert( new_data,meta )
        end
    end
    return new_data
end

-- 检查当前的line是否有效
function GamePlay:isValidLine( line )
	for i,v in ipairs( self._reelConfig.lines ) do
		if v[1] == line[1] and v[2] == line[2] and v[3] == line[3] then
			return true
		end
	end
	return false
end














-- 添加跑马灯特效
function GamePlay:drawLineAndEffect( lines )
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

function GamePlay:addPaoMaDengEffect( pos )
	local effect_data = EffectCsbCache:getCsbNodeByEffectName("paomadeng")
	self:addChild( effect_data.node,50 )
	effect_data.node:setPosition( pos )
	effect_data.node:runAction( effect_data.action )
	playCsbActionForKey( effect_data.action,"actionframe",true )
	table.insert( self._effectList,effect_data )
end


-- 根据列创建快滚特效
--[[
	nCol:列 滚轴的reel的索引
]]
function GamePlay:addQuickEffectByStartCol( nCol )
	assert( nCol," !! nCol is nil  !! " )
	local size = self["sp_reel_"..nCol]:getContentSize()
	if not self._effectList[nCol] then
		local effect_data = EffectCsbCache:getCsbNodeByEffectName("kuaigun")
		self["sp_reel_"..nCol]:addChild( effect_data.node,50 )
		effect_data.node:setPosition( cc.p( size.width / 2,size.height / 2 ) )
		effect_data.node:runAction( effect_data.action )
		playCsbActionForKey( effect_data.action,"run",true )
		self._effectList[nCol] = effect_data
	end
end

-- 移除快滚特效
function GamePlay:removeAllQuickEffect()
	for i = 1,#self._reelList do
		if self._effectList[i] then
			self:removeEffect( self._effectList[i] )
			self._effectList[i] = nil
		end
	end
end


-- 移除所有特效
function GamePlay:releaseAllEffect()
	-- 移除所有的特效
	self:stopAllActions()
	self:removeAllEffectAction()
	self._effectList = {}
end

-- 将使用的node返回给缓存池
function GamePlay:removeAllEffectAction( effectData )
	for i,v in pairs( self._effectList ) do
		self:removeEffect( v )
	end
end

-- 移除连线的特效
function GamePlay:removeEffect( effectData )
	effectData.node:removeFromParent()
	EffectCsbCache:resetCsbNodeUsed( effectData.effectName, effectData.index )
end


-- 根据行列获取信号快的世界坐标
function GamePlay:getSymbolWorldPos( nCol,nRow )
	local pos_reel = cc.p( self["sp_reel_"..nCol]:getPosition() )
	local world_symbol_pos = self["sp_reel_"..nCol]:getParent():convertToWorldSpace( pos_reel )
	world_symbol_pos.x = world_symbol_pos.x + self._reelConfig.level.symbol_width / 2
	world_symbol_pos.y = world_symbol_pos.y + (nRow - 1) * self._reelConfig.level.symbol_height
	world_symbol_pos.y = world_symbol_pos.y + self._reelConfig.level.symbol_height / 2
	return world_symbol_pos
end

-- 根据坐标获取信号快
function GamePlay:getSymbolByWorldPos( reelIndex,worldPos )
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


return GamePlay