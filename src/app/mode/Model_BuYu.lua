

local Model_BuYu = class( "Model_BuYu" )

function Model_BuYu:ctor()
	self._recordList = nil
	self._coin = nil
	self._level = nil
	-- self:reset()
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


return Model_BuYu