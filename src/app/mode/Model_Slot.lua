
local CardWheelConfig = import( "app.viewsslot.config.CardWheelConfig" )
local CardWheelRewardConfig = import( "app.viewsslot.config.CardWheelRewardConfig" )

local Model_Slot = class( "Model_Slot" )



function Model_Slot:ctor()
	self:reset()
end

function Model_Slot:reset()
	self._coin = nil
	self._time = nil
	self._num = nil
	self._timing = 2 -- 倒计时时长
	self._collectCoin = 1000 -- 倒计时获取金币数
	self._level = nil
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
		self._coin = user_default:getIntegerForKey( "slotCoin",50 )
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




return Model_Slot