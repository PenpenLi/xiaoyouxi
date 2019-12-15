
local PeopleSolider = import(".PeopleSolider")
local EnemySolider = import(".EnemySolider")
local MainGame = class("MainGame",BaseLayer)




function MainGame:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    MainGame.super.ctor( self,param.name )

    self:addCsb( "csbrpgfight/FightLayer.csb" )
    self._brackPos = {}
    self._brackImageInformation = {}
    self._maxCol = 11
    self._maxRow = 6
    self._brackSize = cc.size(160,160)
    self._brackImgList = {}
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

	-- 注册消息监听,点击人物时，放置位置闪烁
    self:addMsgListener( InnerProtocol.INNER_EVENT_RPGFIGHT_LOADPEOPLE_TOUCHBEGAN,function ()
		self:setSeatBlink()
	end )
	-- 注册消息监听,点击人物end时，放置位置成功闪烁停止
    self:addMsgListener( InnerProtocol.INNER_EVENT_RPGFIGHT_LOADPEOPLE_TOUCHEND_TRUE,function (event)
    	self:createSoider(event.data[1].id,event.data[1].imageInformation)
		self:seatOpacity()
	end )
	-- 注册消息监听,点击人物end时，放置位置失败闪烁停止
    self:addMsgListener( InnerProtocol.INNER_EVENT_RPGFIGHT_LOADPEOPLE_TOUCHEND_FALSE,function ()
		self:seatOpacity()
	end )
	self:seatOpacity()

	-- -- 测试 检查砖块
	-- self:onUpdate( function()
	-- 	-- 砖块
	-- 	for i,v in ipairs( self._brackImgList ) do
	-- 		local img = v.img
	-- 		local sp = img:getVirtualRenderer():getSprite()
	-- 		if self._brackState[v.col][v.row] == 0 then
	-- 			-- 空闲
	-- 			-- img:loadTexture("image/box_Pass.png",1)
	-- 			ungraySprite( sp )
	-- 		elseif self._brackState[v.col][v.row] == 1 then
	-- 			-- 占用
	-- 			-- img:loadTexture("image/box_locked.png",1)
	-- 			graySprite( sp )
	-- 		elseif self._brackState[v.col][v.row] == 2 then
	-- 			-- 将被占用
	-- 			-- img:loadTexture("image/box_unlock.png",1)
	-- 			redSprite( sp )
	-- 		end
	-- 	end
	-- 	-- 射线
	-- 	for i,v in ipairs( self._peopleList ) do
	-- 		if v.xianSp == nil then
	-- 			local color_layer = cc.LayerColor:create( cc.c4b(255,0,0,255 ) )
	-- 			color_layer:setContentSize( cc.size( 20,5 ) )
	-- 			color_layer:setAnchorPoint(cc.p(0,0))
	-- 			color_layer:setRotation( 45 )
	-- 			v:addChild( color_layer )
	-- 			v.xianSp = color_layer
	-- 		end
	-- 		-- 设置长度
	-- 		if v._destEnemy then
	-- 			local my_pos = v:getParent():convertToWorldSpace( cc.p(v:getPosition()) )
	-- 			local enemy_pos = v._destEnemy:getParent():convertToWorldSpace( cc.p(v._destEnemy:getPosition()) )
	-- 			local dis = cc.pGetDistance( my_pos,enemy_pos )
	-- 			v.xianSp:setContentSize( cc.size(dis,5) )
	-- 			-- 设置角度
	-- 			local r = self:getRotationDegree( my_pos,enemy_pos )
	-- 			v.xianSp:setRotation( r )
	-- 		else
	-- 			v.xianSp:setContentSize( cc.size(20,5) )
	-- 		end
	-- 	end

	-- 	for i,v in ipairs( self._enemyList ) do
	-- 		if v.xianSp == nil then
	-- 			local color_layer = cc.LayerColor:create( cc.c4b( 0,255,0,255 ) )
	-- 			color_layer:setContentSize( cc.size( 20,5 ) )
	-- 			v:addChild( color_layer )
	-- 			color_layer:setAnchorPoint(cc.p(0,0))
	-- 			v.xianSp = color_layer
	-- 		end
	-- 		-- 设置长度
	-- 		if v._destEnemy then
	-- 			local my_pos = v:getParent():convertToWorldSpace( cc.p(v:getPosition()) )
	-- 			local enemy_pos = v._destEnemy:getParent():convertToWorldSpace( cc.p(v._destEnemy:getPosition()) )
	-- 			local dis = cc.pGetDistance( my_pos,enemy_pos )
	-- 			v.xianSp:setContentSize( cc.size(dis,5) )
	-- 			-- 设置角度
	-- 			local r = self:getRotationDegree( my_pos,enemy_pos )
	-- 			v.xianSp:setRotation( r )
	-- 		else
	-- 			v.xianSp:setContentSize( cc.size(20,5) )
	-- 		end
	-- 	end
	-- end )
end

function MainGame:getAngleByPos(p1,p2)
    local p = {}
    p.x = p2.x - p1.x
    p.y = p2.y - p1.y
    local r = math.atan2(p.y,p.x)*180/math.pi
    return r
end

-- 获取两点之间的旋转角度
function MainGame:getRotationDegree( p1,p2 )
	local len_x = p2.x - p1.x
	local len_y = p2.y - p1.y
	local tan_yx = math.abs(len_y) / math.abs(len_x)
	local angle = 0
	if len_y > 0 and len_x < 0 then
		angle = math.atan(tan_yx)*180/math.pi - 90
		angle = angle - 90
	elseif len_y > 0 and len_x > 0 then
		angle = 90 - math.atan(tan_yx)*180/math.pi
		angle = angle - 90
	elseif len_y < 0 and len_x < 0 then
		angle = -math.atan(tan_yx)*180/math.pi - 90
		angle = angle - 90
	elseif len_y < 0 and len_x > 0 then
		angle = math.atan(tan_yx)*180/math.pi + 90
		angle = angle - 90
	elseif len_y == 0 and len_x > 0 then
		angle = 0
	elseif len_y == 0 and len_x < 0 then
		angle = 180
	elseif len_x == 0 and len_y > 0 then
		angle = -90
	elseif len_x == 0 and len_y < 0 then
		angle = 90
	end
	return angle
end
-- 创建士兵
function MainGame:createSoider(id,imageInformation)
	local people = PeopleSolider.new( id ,self )
	local pos = self:getBrackPos( imageInformation.col,imageInformation.row )
	self:addChild( people )
	people:setPosition( pos )
	-- 初始化砖块坐标
	people:setBlockPos( imageInformation.col,imageInformation.row )

	-- 写入数据
	table.insert( self._peopleList,people )
	self._brackState[imageInformation.col][imageInformation.row] = 1
end
-- 可放置位置变色
function MainGame:setSeatBlink()
	self:onUpdate( function()
		for i,v in ipairs(self._brackImageInformation) do
			if self:getBrackStatus(v.col,v.row) == 0 then
				v.img:setOpacity(150)
			else
				v.img:setOpacity(0)
			end
		end
	end )
end
-- 放置位置透明
function MainGame:seatOpacity()
	self:unscheduleUpdate()
	for i,v in ipairs(self._brackImageInformation) do
		v.img:setOpacity(0)
		-- v.img:setVisible( false )
	end
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

			-- -- 存储砖块的sprite
			-- local meta = { img = img,col = i,row = j }
			-- table.insert( self._brackImgList,meta )

			local imageInformation = { img = img,col = i,row = j }
			table.insert(self._brackImageInformation,imageInformation)
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
	for i,v in pairs( people_list ) do
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
	for i,v in pairs( enemy_list ) do
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
	0:没有被占用 1:被占用 2:将被占用
]]
function MainGame:isEmptyBrack( col,row )
	assert( col," !! col is nil !! ")
	assert( row," !! row is nil !! ")
	return self._brackState[col][row] == 0
end

function MainGame:setBrackStatus( col,row,value )
	self._brackState[col][row] = value
end
function MainGame:getBrackStatus( col,row )
	return self._brackState[col][row]
end
function MainGame:getBrackSize()
	return self._brackSize
end
function MainGame:getBrackImageInformation( ... )
	return self._brackImageInformation
end

return MainGame