
local GameOperation = import(".GameOperation")
local PeopleSolider = import(".PeopleSolider")
local EnemySolider = import(".EnemySolider")

local GameFight = class("GameFight",BaseLayer)


function GameFight:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameFight.super.ctor( self,param.name )

    self:addCsb( "csbfensuizhan/FightLayer.csb" )

    self._enemyList = {}
    self._peopleList = {}

    -- 初始化战斗区域的10条轨道的坐标点
    self._battleLeftX = self.CenterPanel:getPositionX()
    self._battleRightX = self._battleLeftX + self.CenterPanel:getContentSize().width
    self._trackPosY = {}
    local center_node = self.CenterPanel
    local first_posy = center_node:getParent():convertToWorldSpace( cc.p( center_node:getPosition() ) ).y
    for i = 1,10 do
    	local posY = first_posy + (i-1) * 50
    	table.insert( self._trackPosY,posY )
    end

    self._totalEnemyCount = 30
    self._curEnemyCount = 0
end


function GameFight:onEnter()
	GameFight.super.onEnter( self )

	-- 创建敌人
	self:createEnemyByDelay()

	-- 放置位置透明
	self:setLeftPanelOpacity()
	-- 注册消息监听,点击人物时，放置位置闪烁
    self:addMsgListener( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHBEGAN,function ()
		self:setSeatBlink()
	end )
	-- 注册消息监听,点击人物end时，放置位置成功闪烁停止
    self:addMsgListener( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHEND_TRUE,function (event)
    	self:createPeopleSolider(event.data[1].id,event.data[1].pos)
		self:stopSeatBlink()
	end )
	-- 注册消息监听,点击人物end时，放置位置失败闪烁停止
    self:addMsgListener( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHEND_FALSE,function ()
		self:stopSeatBlink()
	end )
end


-- 放置位置闪烁
function GameFight:setSeatBlink()
	self:stopSeatBlink()
	local fade_in = cc.FadeIn:create( 1 )
	local fade_out = cc.FadeOut:create( 1 )
	local seq = cc.Sequence:create( fade_in,fade_out)
	local rep = cc.Repeat:create(seq, 3)
	self.LeftPanel:runAction(rep)
end
-- 放置位置闪烁停止
function GameFight:stopSeatBlink()
	self.LeftPanel:stopAllActions()
	self:setLeftPanelOpacity()
end
-- 放置位置透明
function GameFight:setLeftPanelOpacity()
	self.LeftPanel:setOpacity(0)
end


function GameFight:createEnemyByDelay( time )
	if self._curEnemyCount >= self._totalEnemyCount then
		return
	end
	local delay_time = 0.1
	if time then
		delay_time = time
	end

	performWithDelay( self,function()
		-- 创建敌人
		self._curEnemyCount = self._curEnemyCount + 1
		local id = random( 1,#hunsolider_config )
		local pos = { x = display.width + random( 50,200 ),y = self._trackPosY[random(1,10)] }
		self:createEnemySolider( id,pos )

		local random_time = random( 3,7 )
		self:createEnemyByDelay( random_time )
	end,delay_time )
end


function GameFight:createEnemySolider( id,pos )
	assert( id," !! id is nil !! " )
	assert( pos," !! pos is nil !! " )
	local solider = EnemySolider:create(id,self)
	table.insert( self._enemyList,solider )
	self:addChild( solider )
	solider:playIdle()
	solider:setPosition( pos )
	return solider
end

function GameFight:createPeopleSolider( id,pos )
	assert( id," !! id is nil !! " )
	assert( pos," !! pos is nil !! " )
	local people = PeopleSolider:create(id,self)
	table.insert( self._peopleList,people )
	self:addChild( people )
	people:playIdle()
	people:setPosition( pos )
	return people
end

-- 获得战斗区域左边的X轴边界
function GameFight:getBattleLeftX()
	return self._battleLeftX
end

-- 获得战斗区域右边的X轴边界
function GameFight:getBattleRightX()
	return self._battleRightX
end


function GameFight:soliderDead( guid,modeType )
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

return GameFight