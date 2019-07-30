

local Model_Heji = class( "Model_Heji" )


function Model_Heji:ctor()
	self._coin = nil
end

function Model_Heji:getInstance()
	if not self._getInstance then
		self._getInstance = Model_Heji.new()
	end
	return self._getInstance
end


function Model_Heji:getCoin()
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey( "hejiCoin",50 )
		user_default:setIntegerForKey( "hejiCoin",self._coin )
	end
	return self._coin
end


function Model_Heji:setCoin( addCoin )
	assert( addCoin," !! addCoin is nil !! " )
	self._coin = self:getCoin() + addCoin
	if self._coin < 0 then
		self._coin = 0
	end
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "hejiCoin",self._coin )
end


return Model_Heji