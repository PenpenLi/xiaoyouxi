

local Model_ZuQiu = class( "Model_ZuQiu" )



function Model_ZuQiu:ctor()
	self:reset()
end

function Model_ZuQiu:reset()
	self._coin = nil
	self._stage = 1
end



function Model_ZuQiu:getInstance()
	if not self._instance then
		self._instance = Model_ZuQiu.new()
	end
	return self._instance
end


function Model_ZuQiu:getCoin()
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey( "zuqiucoin",0 )
		if self._coin <= 0 then
			self._coin = 20
			user_default:setIntegerForKey( "zuqiucoin",self._coin )
		end
	end
	return self._coin	
end


function Model_ZuQiu:setCoin( addCoin )
	self._coin = self:getCoin() + addCoin
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "zuqiucoin",self._coin )
end



function Model_ZuQiu:getStage()
	return self._stage
end

function Model_ZuQiu:setStage()
	self._stage = self._stage + 1
	if self._stage > 6 then
		self._stage = 1
	end
end

function Model_ZuQiu:clearStage()
	self._stage = 1
end


return Model_ZuQiu