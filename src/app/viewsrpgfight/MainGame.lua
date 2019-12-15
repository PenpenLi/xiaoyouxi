
local PeopleSolider = import(".PeopleSolider")
local EnemySolider = import(".EnemySolider")
local MainGame = class("MainGame",BaseLayer)




function MainGame:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    MainGame.super.ctor( self,param.name )

    self:addCsb( "csbrpgfight/FightLayer.csb" )
    self._brackPos = {}
    self._maxCol = 11
    self._maxRow = 6
    self._brackSize = cc.size(160,160)
    self:initData()
end


function MainGame:initData()
	-- 需要维护solider的指针
	self._enemyList = {}
    self._peopleList = {}
    -- 每个砖块的状态
    self._brackState = {}
end


function MainGame:onEnter()
	MainGame.super.onEnter( self )
	self:loadBrick()
	-- 当前关卡
	self._stage = 1
	-- 创建士兵
	self:createPeopleSolider()
	-- 创建一个敌人
	self:createEnemySolider()
end


-- 添加砖块
function MainGame:loadBrick()
	local brick_size = self._brackSize
	local start_x,start_y = 100 + brick_size.width / 2,100 + brick_size.height / 2
	local col = self._maxCol
	local row = self._maxRow
	for i = 1,col do
		self._brackPos[i] = {}
		self._brackState[i] = {}
		for j = 1,row do
			local img = ccui.ImageView:create("image/box_Pass.png",1)
			self:addChild( img )
			local x_pos = start_x + (i - 1) * brick_size.width
			local y_pos = start_y + (j - 1) * brick_size.height
			img:setPosition( x_pos,y_pos )
			img:setOpacity( 150 )
			self._brackPos[i][j] = cc.p( x_pos,y_pos )
			self._brackState[i][j] = 0
		end
	end
end

-- 获取砖块的坐标
function MainGame:getBrackPos( col,row )
	assert( col," !! col is nil !! " )
	assert( row," !! row is nil !! " )
	return self._brackPos[col][row]
end

-- 创建士兵
function MainGame:createPeopleSolider()
	-- body
	local stage = self._stage
	local people_list = rpgfight_config[stage].people
	for i,v in ipairs( people_list ) do
		local people = PeopleSolider.new( v.id ,self )
		local pos = self:getBrackPos( v.position.col,v.position.row )
		self:addChild( people )
		people:setPosition( pos )
		-- 初始化砖块坐标
		people:setBlockPos( v.position.col,v.position.row )

		-- 写入数据
		table.insert( self._peopleList,people )
		self._brackState[v.position.col][v.position.row] = 1
	end
end

-- 创建敌人
function MainGame:createEnemySolider()
	local stage = self._stage
	local enemy_list = rpgfight_config[stage].enemy
	for i,v in ipairs( enemy_list ) do
		local enemy = EnemySolider.new( v.id ,self )
		local pos = self:getBrackPos( v.position.col,v.position.row )
		self:addChild( enemy )
		enemy:setPosition( pos )
		-- 初始化砖块坐标
		enemy:setBlockPos( v.position.col,v.position.row )

		-- 写入数据
		table.insert( self._enemyList,enemy )
		self._brackState[v.position.col][v.position.row] = 1
	end
end


--[[
	guid:guid
	modeType:类型 people enemy
]]
function MainGame:soliderDead( guid,modeType )
	local delete_list = nil
	local reset_dest_list = nil
	if modeType == "people" then
		delete_list = self._peopleList
		reset_dest_list = self._enemyList
	elseif modeType == "enemy" then
		delete_list = self._enemyList
		reset_dest_list = self._peopleList
	end

	-- 移除指针
	for i,v in ipairs( delete_list ) do
		if v:getSoliderGUID() == guid then
			table.remove( delete_list,i )
			break
		end
	end

	-- 其他士兵 重新设置攻击目标
	for i,v in ipairs( reset_dest_list ) do
		v:clearDestByGuid( guid )
		v:removeAttackMyEnemyList( guid )
	end
end

function MainGame:getMaxCol()
	return self._maxCol
end

function MainGame:getMaxRow()
	return self._maxRow
end

--[[
	0:没有被占用 1:被占用
]]
function MainGame:isEmptyBrack( col,row )
	assert( col," !! col is nil !! ")
	assert( row," !! row is nil !! ")
	return self._brackState[col][row] == 0
end

function MainGame:setBrackStatus( col,row,value )
	self._brackState[col][row] = value
end

return MainGame