

local Model_Eight = class( "Model_Eight" )


function Model_Eight:ctor()
	self._coin = nil
	self:resetAICoin()
end

function Model_Eight:getInstance()
	if not self._getInstance then
		self._getInstance = Model_Eight.new()
	end
	return self._getInstance
end


function Model_Eight:getCoin()
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey( "eightCoin",50 )
		user_default:setIntegerForKey( "eightCoin",self._coin )
	end
	return self._coin
end
function Model_Eight:getCoin1()
	-- if self._coin1 == nil then
	-- 	local user_default = cc.UserDefault:getInstance()
	-- 	self._coin1 = user_default:getIntegerForKey( "eightCoin1",10000 )
	-- end
	return self._coin1
end
function Model_Eight:getCoin2()
	-- if self._coin2 == nil then
	-- 	local user_default = cc.UserDefault:getInstance()
	-- 	self._coin2 = user_default:getIntegerForKey( "eightCoin2",10000 )
	-- end
	return self._coin2
end
function Model_Eight:getCoin3()
	-- if self._coin3 == nil then
	-- 	local user_default = cc.UserDefault:getInstance()
	-- 	self._coin3 = user_default:getIntegerForKey( "eightCoin3",10000 )
	-- end
	return self._coin3
end

function Model_Eight:setCoin( addCoin )
	assert( addCoin," !! addCoin is nil !! " )
	self._coin = self:getCoin() + addCoin
	if self._coin < 0 then
		self._coin = 0
	end
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "eightCoin",self._coin )
end

function Model_Eight:setCoin1( addCoin )
	self._coin1 = self._coin1 + addCoin
end

function Model_Eight:setCoin2( addCoin )
	self._coin2 = self._coin2 + addCoin
end

function Model_Eight:setCoin3( addCoin )
	self._coin3 = self._coin3 + addCoin
end

function Model_Eight:resetAICoin()
	self._coin1 = 10000
	self._coin2 = 10000
	self._coin3 = 10000
end


return Model_Eight