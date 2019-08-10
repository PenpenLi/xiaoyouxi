

local Model_LiKui = class( "Model_LiKui" )

function Model_LiKui:ctor()
	self._recordList = nil
	self._coin = nil
	self:getRecordList()
	-- self:reset()
end

-- function Model_LiKui:reset()
-- 	self._coin = nil
-- end

function Model_LiKui:getInstance()
	if not self._instance then
		self._instance = Model_LiKui.new()
	end
	return self._instance
	
end

function Model_LiKui:getCoin()
	-- print( "-----?????????")
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey( "likuiCoin",50 )
		user_default:setIntegerForKey( "likuiCoin",self._coin )
	end
	return self._coin
end

function Model_LiKui:setCoin( addCoin )
	assert( addCoin," !! addCoin is nil !! " )
	self._coin = self:getCoin() + addCoin
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "likuiCoin",self._coin )
end

-- 读取记录数据
function Model_LiKui:getRecordList()
	if not self._recordList then
		self._recordList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey( "likui_recordList","" )
		if record_data ~= "" then
			self._recordList = json.decode( record_data )
			table.sort( self._recordList,function ( a,b )
				return a.score > b.score
			end)
		end
	end
	return self._recordList
end

-- 存储记录数据
function Model_LiKui:saveRecordList( score )
	assert( score," !! score is nil !! " )
	local need_save = false
	if #self._recordList < 10 then
		local meta = {}
		meta.score = score
		meta.time = os.time()
		table.insert( self._recordList,meta )
		need_save = true
	else
		if self._recordList[#self._recordList] < score then
			self._recordList[#self._recordList] = score
			self._recordList[#self._recordList] = os.time()
			need_save = true
		end
	end
	if need_save then
		table.sort( self._recordList,function ( a,b )
			return a.score > b.score
		end)
		local json_data = json.encode( self._recordList )
		local user_default = cc.UserDefault:getInstance()
		user_default:setStringForKey( "likui_recordList",json_data )
	end
	return need_save
end




return Model_LiKui