

local Model_BuYu = class( "Model_BuYu" )

function Model_BuYu:ctor()
	self._recordList = nil
	self._coin = nil
	self._exp = nil
	self._upgradeExp = nil
	self._level = nil
	self._multiple = nil -- 子弹消耗倍数索引值
	-- self:reset()
	self._signIn = nil -- 签到日
	self._signInTime = nil -- 签到时间
	self._gameLevelListOfFish = nil -- start界面用，所有鱼的表
	self._gameLevelListOfFish1 = nil -- 关卡1的鱼配置表
	self._gameLevelListOfFish2 = nil -- 关卡2的鱼配置表
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
function Model_BuYu:getExp()
	if self._exp == nil then
		local user_default = cc.UserDefault:getInstance()
		self._exp = user_default:getIntegerForKey( "buyuexp",0 )
		user_default:setIntegerForKey( "buyuexp",self._exp )
	end
	return self._exp
end
function Model_BuYu:setExp()
	self._exp = self:getExp() + 5
	if self._exp >= self._upgradeExp then
		self._exp = 0
		self:setLevel()
		self:getUpgradeExp()
		local user_default = cc.UserDefault:getInstance()
		user_default:setIntegerForKey( "buyuexp",self._exp )
		if self._level % buyu_config.bullet[1].endLevel == 1 then
			return true
		end
	end
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey( "buyuexp",self._exp )
end
function Model_BuYu:getUpgradeExp()
	local config = buyu_config.bullet
	local level = self:getLevel()
	for i,v in ipairs( config ) do
		if level >= config[i].beganLevel and level <= config[i].endLevel then
			self._upgradeExp = config[i].exp
		end
	end
	return self._upgradeExp
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

-- 读取记录数据，捕鱼任务
function Model_BuYu:getTastList()
	if not self._taskList then
		self._taskList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey( "buyu_taskList","" )
		if record_data ~= "" then
			-- self._taskList = json.decode( record_data )
			local data_list = json.decode( record_data )
			for k,v in pairs( data_list ) do
				self._taskList[v.id] = v
			end
		else
			local config = buyu_config.task
			for i = 1,#config do
				-- dump( config.fish_id,"--------------config.fish_id = ")
				-- table.insert( self._taskList,{ id = config[i].fish_id,num = 0 })
				self._taskList[config[i].fish_id] = { 
					id = config[i].fish_id,
					num = 0,
					task_num = config[i].task_num,
					coin = config[i].coin,
					state = 1 -- 状态 1：未完成 2:未领取 3:已领取
				}
			end
		end
	end
	return self._taskList
end

-- 存储记录数据,捕鱼任务,进度
function Model_BuYu:saveTaskList( fishId )
	assert( fishId," !! score is nil !! " )

	self:getTastList()

	if not self._taskList[fishId] then
		return
	end

	if self._taskList[fishId].num >= self._taskList[fishId].task_num then
		return
	end

	self._taskList[fishId].num = self._taskList[fishId].num + 1

	-- for i=1,#self._taskList do
	-- 	if self._taskList[i].id == fishIndex then
	-- 		self._taskList[i].num = self._taskList[i].num + 1
	-- 		if self._taskList[i].num > buyu_config.task[i].task_num then
	-- 			self._taskList[i].num = buyu_config.task[i].task_num
	-- 		end
	-- 	end
	-- end
	
	local json_data = json.encode( self._taskList )
	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey( "buyu_taskList",json_data )
end
-- 存储记录数据,捕鱼任务状态
function Model_BuYu:saveTaskListState( fishId )
	assert( fishId," !! score is nil !! " )

	self:getTastList()
	dump( fishId,"---------fishId = ")
	dump( self._taskList,"------self._taskList = ")
	if not self._taskList[fishId] then
		-- print("-------------123")
		return
	end

	self._taskList[fishId].state = 3

	local json_data = json.encode( self._taskList )
	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey( "buyu_taskList",json_data )
end

function Model_BuYu:getTaskById( fishId )
	assert( fishId," !! fishId is nil !! " )
	self:getTastList()
	return self._taskList[fishId]
end

function Model_BuYu:getFishList( gameLevel )
	-- assert( gameLevel == 1 or gameLevel == 2," !! gameLevel is error !! ")
	if gameLevel == nil then
		if self._gameLevelListOfFish == nil then
			self._gameLevelListOfFish = {}
			-- dump( gameLevel,"------------gameLevel = ")
			local config = buyu_config.fish
			for i=1,#config do
				
				table.insert( self._gameLevelListOfFish,i )
				
			end
		end
		return self._gameLevelListOfFish
	end
	if gameLevel == 1 then
		if self._gameLevelListOfFish1 == nil then
			self._gameLevelListOfFish1 = {}
			-- dump( gameLevel,"------------gameLevel = ")
			local config = buyu_config.fish
			for i=1,#config do
				if config[i].playLevel == gameLevel or config[i].playLevel == 3 then
					table.insert( self._gameLevelListOfFish1,i )
				end
			end
		end
		return self._gameLevelListOfFish1
	end
	if gameLevel == 2 then
		if self._gameLevelListOfFish2 == nil then
			self._gameLevelListOfFish2 = {}
			-- dump( gameLevel,"------------gameLevel = ")
			local config = buyu_config.fish
			for i=1,#config do
				if config[i].playLevel == gameLevel or config[i].playLevel == 3 then
					table.insert( self._gameLevelListOfFish2,i )
				end
			end
		end
		return self._gameLevelListOfFish2
	end
	
end



return Model_BuYu