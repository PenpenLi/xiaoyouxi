
local BaseGameModel = class("BaseGameModel")



function BaseGameModel:ctor( reelConfig )
	assert( reelConfig," !! reelConfig is nil !! " )
	self._reelConfig = reelConfig
	-- 下注的coin
	self._betCoin = 1000
	self._orgBetCoin = 1000
	-- 当前游戏的状态 1:normal 2:freespin
	self._gameStatus = 1
	self._freeSpinCount = 0
	self._freeSpinNum = 5

	self._freeSpinWinCoin = 0
end



function BaseGameModel:getBetCoin()
	return self._betCoin
end

function BaseGameModel:getOrgBetCoin()
	return self._orgBetCoin
end


function BaseGameModel:setBetCoin( coinNum )
	self._betCoin = coinNum
end




-- 结果
function BaseGameModel:getRollResult()
	self._reelResultData = {}
	local reel_data = {}
	for i = 1,self._reelConfig.level.reel_count do
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
	local free_mark = false
	if self._gameStatus == 1 then
		free_mark = random( 1,10 ) == 1
		if free_mark then
			local total_scattle = 0
			local no_scattle_reel = {}
			for i = 2,self._reelConfig.level.reel_count do
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
	end
	self._reelResultData = reel_data
	return reel_data,free_mark
end


function BaseGameModel:getGameStatus()
	return self._gameStatus
end

function BaseGameModel:isFreeSpinStatus()
	return self._gameStatus == 2
end

function BaseGameModel:isNormalSpinStatus()
	return self._gameStatus == 1
end

function BaseGameModel:changeStatusToFreeSpin()
	self._gameStatus = 2
	self._freeSpinCount = self._freeSpinNum
end

function BaseGameModel:changeStatusToNormalSpin()
	self._gameStatus = 1
	self._freeSpinCount = 0
	self._freeSpinWinCoin = 0
	self._freeSpinOverMark = false
end

function BaseGameModel:isFreeSpinStart()
	return self._freeSpinCount == self._freeSpinNum
end

function BaseGameModel:isFreeSpinEnd()
	return self._freeSpinCount == 0
end

function BaseGameModel:useFreeSpinTimes()
	self._freeSpinCount = self._freeSpinCount - 1
	if self._freeSpinCount <= 0 then
		self._freeSpinCount = 0
		self._freeSpinOverMark = true
	end
end

function BaseGameModel:getFreeSpinCount()
	return self._freeSpinCount
end

function BaseGameModel:setFreeSpinOverMark( value )
	self._freeSpinOverMark = value
end

function BaseGameModel:getFreeSpinOverMark()
	return self._freeSpinOverMark
end



function BaseGameModel:getLineResult()
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

	return valid_lines
end



function BaseGameModel:hasLineBySymbolId( symbolId )
	-- 2,3列必须有
	if not self:hasSymbolIdByReelData( symbolId,self._reelResultData[2] ) then
		return false
	end
	if not self:hasSymbolIdByReelData( symbolId,self._reelResultData[3] ) then
		return false
	end
	return true
end

function BaseGameModel:hasSymbolIdByReelData( symbolId,reelData )
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


--[[
	两个表做乘法
	source1 格式: { {1},{2} }
	source2 格式: { 1,2,3 }
]]
function BaseGameModel:twoTableMultiplication( source1,source2 )
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
function BaseGameModel:isValidLine( line )
	for i,v in ipairs( self._reelConfig.lines ) do
		if v[1] == line[1] and v[2] == line[2] and v[3] == line[3] then
			return true
		end
	end
	return false
end

function BaseGameModel:getRewardCoinByLine( lines )
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


function BaseGameModel:setFreeSpinWinCoin( coin )
	self._freeSpinWinCoin = coin
end

function BaseGameModel:getFreeSpinWinCoin()
	return self._freeSpinWinCoin
end


return BaseGameModel