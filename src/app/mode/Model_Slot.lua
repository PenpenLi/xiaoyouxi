
local CardWheelConfig = import( "app.viewsslot.config.CardWheelConfig" )
local CardWheelRewardConfig = import( "app.viewsslot.config.CardWheelRewardConfig" )
local CoinDrawConfig = import( "app.viewsslot.config.CoinDrawConfig" )
local LevelConfig = import( "app.viewsslot.config.LevelConfig" )


local Model_Slot = class( "Model_Slot" )



function Model_Slot:ctor()
	self:reset()
end

function Model_Slot:reset()
	self._coin = nil
	self._time = nil
	self._num = nil
	self._timing = 2 -- 中间倒计时时长
	self._collectCoin = 1000 -- 倒计时获取金币数
	self._level = nil
	self._toTime = nil -- 每日抽奖目标时间
	self._miniNum = nil -- 左下小游戏的累计次数
	self._miniNumSum = 30 -- 左下小游戏需要累计的总次数
	self._exp = nil
end



function Model_Slot:getInstance()
	if not self._instance then
		self._instance = Model_Slot.new()
	end
	return self._instance
end

function Model_Slot:getCoin()
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey( "slotCoin",50000 )
		user_default:setIntegerForKey( "slotCoin",self._coin )
	end
	return self._coin
end
function Model_Slot:setCoin( addCoin )
	assert( addCoin," !! addCoin is nil !! " )
	self._coin = self:getCoin() + addCoin
	if self._coin < 0 then
		self._coin = 0
	end
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "slotCoin",self._coin )
end

function Model_Slot:getCountDown()
	
	if self._time == nil then
		-- self:setCountDown()
		local user_default = cc.UserDefault:getInstance()
		self._time = user_default:getIntegerForKey( "slotcount",0 )
		user_default:setIntegerForKey( "slotcount",self._time )
		-- if self._time <= 0 then
		-- 	self._time = 20
		-- 	user_default:setIntegerForKey( "slotcount",self._time )
		-- end
	end
	return self._time	
end

function Model_Slot:setCountDown()
	local user_default = cc.UserDefault:getInstance()
	self._time = user_default:getIntegerForKey( "slotcount",0 )
	if self._time == 0 then
		self._time = os.time()
		-- self._coin = self:getCoin() + addCoin
		local user_default = cc.UserDefault:getInstance()
		user_default:setIntegerForKey( "slotcount",self._time )
	end
end

function Model_Slot:init()
	self._time = os.time()
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "slotcount",self._time )
end
function Model_Slot:getNumOfCollectTime()
	if self._num == nil then
		local user_default = cc.UserDefault:getInstance()
		self._num = user_default:getIntegerForKey( "numofcollecttime",0 )
		user_default:setIntegerForKey( "numofcollecttime",self._num )
	end
	return self._num
end
function Model_Slot:setNumOfCollectTime( num )
	self._num = num
	if self._num >= 5 then
		self._num = 0
	end
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "numofcollecttime",self._num )
end
-- 获取倒计时时间
function Model_Slot:getTimingOfDown()
	-- if self._timing == nil then
	-- 	local user_default = cc.UserDefault:getInstance()
	-- 	self._timing = user_default:getIntegerForKey( "slotTimingOfDown",20 )
	-- 	user_default:setIntegerForKey( "slotTimingOfDown",self._timing )
	-- end
	-- local user_default = cc.UserDefault:getInstance()
	-- user_default:getIntegerForKey( "slotTimingOfDown",0 )
	-- user_default:setIntegerForKey( "slotTimingOfDown",self._timing )
	return self._timing
end
-- 获取倒计时所得金币数
function Model_Slot:getCollectCoin( ... )
	return self._collectCoin
end
-- 获取当前等级
function Model_Slot:getLevel()
	if self._level == nil then
		local user_default = cc.UserDefault:getInstance()
		self._level = user_default:getIntegerForKey( "slotLevel",1 )
		user_default:setIntegerForKey( "slotLevel",self._level )
	end
	return self._level
end
-- 设置当前等级
function Model_Slot:setLevel()
	-- body
end

function Model_Slot:getExpress()
	if self._exp == nil then
		local user_default = cc.UserDefault:getInstance()
		self._exp = user_default:getIntegerForKey( "slotExp",0 )
		user_default:setIntegerForKey( "slotExp",self._exp )
	end
	return self._exp
end

function Model_Slot:setExpress()
	self._exp = self:getExpress() + 5
	local need_exp = self:getNeedExpForLevelUp()
	if self._exp >= need_exp then
		self._level = self._level + 1
		self._exp = 0
	end
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "slotExp",self._exp )
	user_default:setIntegerForKey( "slotLevel",self._level )
end

function Model_Slot:getNeedExpForLevelUp()
	for k,v in pairs( LevelConfig ) do
		if v.MinLevel <= self._level and self._level <= v.MaxLevel then
			return v.Express
		end
	end
end


-- 获取轮盘数据
function Model_Slot:lunpanData( parent )


	if self._wheelTable == nil then
		self._wheelTable = {}
	end

	local level = self:getLevel()
	local wheelId = nil
	local index = random( 1,3 )
	for k,v in pairs(CardWheelConfig) do
		if level >= v.MinLevel and level <= v.MaxLevel then
			wheelId = v["WheelId"..index]
		end
	end

	if self._wheelTable[wheelId] == nil then


		-- local weight = 0
		-- for a,b in pairs(CardWheelRewardConfig) do
		-- 	if wheelId == b.WheelId then
		-- 		weight = weight + b.Weight
		-- 	end
		-- end


		local coin_table = {}
		for c,d in ipairs(CardWheelRewardConfig) do
			if wheelId == d.WheelId then
				table.insert( coin_table,d )
			end
		end

		table.sort( coin_table, function( a,b)
			return a.Order < b.Order 
		end )

		self._wheelTable[wheelId] = coin_table
	end

	return self._wheelTable[wheelId]
end
-- 获取小玩法得金币数据
function Model_Slot:getCoinDrawData()
	local weightSum = 0
	for i,v in ipairs(CoinDrawConfig) do
	 	weightSum = weightSum + v.Weight
	end 
	local index = random( 0,weightSum )

	local weight_began = 0
	local weight_end = 0
	for i,v in ipairs(CoinDrawConfig) do
		weight_end = weight_end + v.Weight
		if index > weight_began and index <= weight_end then
			return v.BaseCoinReward,v.KeepOn
		end
	end
end
-- 每日抽奖时间数据
function Model_Slot:getOneDayOneDraw( ... )
	if self._toTime == nil then
		local user_default = cc.UserDefault:getInstance()
		self._toTime = user_default:getIntegerForKey( "slotOneDayOneDraw",0 )
		user_default:setIntegerForKey( "slotOneDayOneDraw",self._toTime )
	end
	-- local toYear = os.date("*t").year
	-- local toMonth = os.date("*t").month
	-- local toDay = os.date("*t").day
	-- local toTime = os.time({year =toYear, month = toMonth, day =toDay, hour =23, min =59, sec = 59})
	local time = os.time()
	local countdown = self._toTime - time + 1
	if countdown <= 0 then
		countdown = 0
	-- 	self._draw = 1
	-- 	cc.UserDefault:getInstance():setIntegerForKey( "slotOneDayOneDraw",self._draw )
	-- 	return self._draw
	end
	return countdown
end
function Model_Slot:setOneDayOneDraw()
	local toYear = os.date("*t").year
	local toMonth = os.date("*t").month
	local toDay = os.date("*t").day
	self._toTime = os.time({year =toYear, month = toMonth, day =toDay, hour =23, min =59, sec = 59})
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "slotOneDayOneDraw",self._toTime )
end
-- 左下小游戏
function Model_Slot:getMiniGameNum()
	if self._miniNum == nil then
		local user_default = cc.UserDefault:getInstance()
		self._miniNum = user_default:getIntegerForKey( "slotMiniGameNum",0 )
		user_default:setIntegerForKey( "slotMiniGameNum",self._miniNum )
	end
	return self._miniNum
end
function Model_Slot:setMiniGameNum()
	local user_default = cc.UserDefault:getInstance()
	self._miniNum = user_default:getIntegerForKey( "slotMiniGameNum",0 )
	self._miniNum = self._miniNum + 1
	user_default:setIntegerForKey( "slotMiniGameNum",self._miniNum )
end
function Model_Slot:initMiniGameNum()
	self._miniNum = 0
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "slotMiniGameNum",self._miniNum )
end
-- 需要累计的次数
function Model_Slot:getMiniGameNumSum()
	return self._miniNumSum
end

return Model_Slot