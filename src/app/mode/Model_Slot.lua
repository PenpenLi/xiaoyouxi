

local Model_Slot = class( "Model_Slot" )



function Model_Slot:ctor()
	self:reset()
end

function Model_Slot:reset()
	self._time = nil
	self._num = nil
end



function Model_Slot:getInstance()
	if not self._instance then
		self._instance = Model_Slot.new()
	end
	return self._instance
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











return Model_Slot