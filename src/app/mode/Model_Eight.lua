

local Model_Eight = class( "Model_Eight" )


function Model_Eight:ctor()
	self._coin = nil
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

function Model_Eight:setCoin( addCoin )
	assert( addCoin," !! addCoin is nil !! " )
	self._coin = self:getCoin() + addCoin
	if self._coin < 0 then
		self._coin = 0
	end
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "eightCoin",self._coin )
end


return Model_Eight