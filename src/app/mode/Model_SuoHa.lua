


local Model_SuoHa = class( "Model_SuoHa" )


function Model_SuoHa:ctor()
	self._coin = nil
end

function Model_SuoHa:getInstance()
	if not self._instance then
		self._instance = Model_SuoHa.new()
	end
	return self._instance
end


function Model_SuoHa:getCoin()
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey( "suohaCoin",50 )
		user_default:setIntegerForKey( "suohaCoin",self._coin )
	end
	return self._coin
end

function Model_SuoHa:setCoin( addCoin )
	self._coin = self:getCoin() + addCoin
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "suohaCoin",self._coin )
end

function Model_SuoHa:get( ... )
	-- body
end







return Model_SuoHa