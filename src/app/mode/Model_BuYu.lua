

local Model_BuYu = class( "Model_BuYu" )

function Model_BuYu:ctor()
	self._recordList = nil
	self._coin = nil
	self._level = nil
	self._multiple = nil -- 子弹消耗倍数索引值
	-- self:reset()
	self._signIn = nil -- 签到日
	self._signInTime = nil -- 签到时间
end

-- function Model_BuYu:reset()
-- 	self._coin = nil
-- end

function Model_BuYu:getInstance()
	if not self._instance then
		self._instance = Model_BuYu.new()
	end
	return self._instance
	
end

function Model_BuYu:getCoin()
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey( "buyuCoin",50 )
		user_default:setIntegerForKey( "buyuCoin",self._coin )
	end
	return self._coin
end

function Model_BuYu:setCoin( addCoin )
	assert( addCoin," !! addCoin is nil !! " )
	self._coin = self:getCoin() + addCoin
	if self._coin <= 0 then
		self._coin = 0
	end
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "buyuCoin",self._coin )
end

function Model_BuYu:initCoin( coin )
	self._coin = coin
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "buyuCoin",self._coin )
end

function Model_BuYu:getLevel()
	if self._level == nil then
		local user_default = cc.UserDefault:getInstance()
		self._level = user_default:getIntegerForKey( "buyulevel",1 )
		user_default:setIntegerForKey( "buyulevel",self._level )
	end
	return self._level
end
function Model_BuYu:setLevel()
	self._level = self:getLevel() + 1
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "buyulevel",self._level )
end
-- 子弹消耗倍数索引值
function Model_BuYu:getMultiple( ... )
	return self._multiple
end
function Model_BuYu:setMultiple( multiple )
	self._multiple = multiple
end


-- 签到
function Model_BuYu:getSignIndex( ... )
	if self._signIn == nil then
		local user_default = cc.UserDefault:getInstance()
		self._signIn = user_default:getIntegerForKey( "buyusignin",0 )
		-- user_default:setIntegerForKey( "buyusignin",self._signIn )
	end
	return self._signIn
end
function Model_BuYu:setSignIndex()
	local user_default = cc.UserDefault:getInstance()
	self._signIn = user_default:getIntegerForKey( "buyusignin",0 )
	self._signIn = self._signIn + 1
	if self._signIn > 7 then
		self._signIn = 0
	end
	user_default:setIntegerForKey( "buyusignin",self._signIn )
end
function Model_BuYu:getSignIndexState( ... )
	if self._signInTime == nil then
		local user_default = cc.UserDefault:getInstance()
		self._signInTime = user_default:getIntegerForKey( "buyusigninstate",0 )
		user_default:setIntegerForKey( "buyusigninstate",self._signInTime )
	end
	local time = os.time() - self._signInTime + 1
	dump( time,"------------time = ")
	if time > 0 then
		return true
	else
		return false
	end	
end
function Model_BuYu:setSignIndexState()
	local toYear = os.date("*t").year
	local toMonth = os.date("*t").month
	local toDay = os.date("*t").day
	self._signInTime = os.time({year =toYear, month = toMonth, day =toDay, hour =23, min =59, sec = 59})
	dump( self._signInTime,"------------time = ")
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "buyusigninstate",self._signInTime )
	-- local user_default = cc.UserDefault:getInstance()
	-- self._signInTime = os.time()
	-- user_default:setIntegerForKey( "buyusigninstate",self._signInTime )
end


return Model_BuYu