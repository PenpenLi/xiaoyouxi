
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
    	table.insert( self._trackPosY,{posY = first_posy + (i-1) * 50,bool = false,posX = nil} )
    end

    self:loadUi()
end


function GameFight:loadUi()
	
end


function GameFight:onEnter()
	GameFight.super.onEnter( self )

	-- 默认初始化三个敌人
	self:schedule( function()
		if #self._enemyList < 30 then
			local solider = self:createEnemySolider()
			-- 1:移动到战斗区域
			solider:moveToBattleRegion()
		end
	end,1 )

	-- print("----------------GameFight:onEnter")
	-- local soldier = ccui.ImageView:create("frame/role".."1".."/idle/1.png",1)
	-- dump(soldier,"---------------soldier = ")
	-- -- 创建进度条
	-- local circleProgressBar = cc.ProgressTimer:create( soldier:getVirtualRenderer():getSprite() )
	-- -- 设置类型，圆形
	-- circleProgressBar:setType( cc.PROGRESS_TIMER_TYPE_RADIAL )
	-- -- 设置进度
	-- circleProgressBar:setPercentage( 100 )
	-- circleProgressBar:setPosition(500,500)
	-- self:addChild(circleProgressBar)
	-- for i = 1,3 do
	-- 	local solider = self:createEnemySolider()
	-- 	-- 1:移动到战斗区域
	-- 	solider:moveToBattleRegion()
	-- end

	-- 创建一个自己的战士
	-- local people = self:createPeopleSolider()
	-- people:setPosition( cc.p( -200,self._trackPosY[1].posY ) )
	-- people:moveToBattleRegion()
	-- -- 再创一个
	-- performWithDelay(self,function ( ... )
	-- 	local people = self:createPeopleSolider()
	-- 	people:setPosition( cc.p( -200,self._trackPosY[1].posY ) )
	-- 	people:moveToBattleRegion()
	-- end,12)
	-- -- 再创一个
	-- performWithDelay(self,function ( ... )
	-- 	local people = self:createPeopleSolider()
	-- 	people:setPosition( cc.p( -200,self._trackPosY[1].posY ) )
	-- 	people:moveToBattleRegion()
	-- end,16)






	
	-- 开启计时器，分配战斗对象
	-- self:schedule( function()
	-- 	-- self:controlCenter()
	-- end,0.1 )
	
	-- 放置位置透明
	self:seatOpacity()
	-- 注册消息监听,点击人物时，放置位置闪烁
    self:addMsgListener( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHBEGAN,function ()
		self:setSeatBlink()
	end )
	-- 注册消息监听,点击人物end时，放置位置成功闪烁停止
    self:addMsgListener( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHEND_TRUE,function (event)
    	self:createSoider(event.data[1].id,event.data[1].pos)
		self:stopSeatBlink()
	end )
	-- 注册消息监听,点击人物end时，放置位置失败闪烁停止
    self:addMsgListener( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHEND_FALSE,function ()
		self:stopSeatBlink()
	end )
	-- 注册消息监听,有士兵死亡，通知所有士兵查看是否是自己的目标
    self:addMsgListener( InnerProtocol.INNER_EVENT_FENSUI_FIGHT_DEAD,function (event)
    	for i,v in ipairs(self._enemyList) do
    		if v._hp > 0 then
    			v:enemyDeadNews(event.data[1].guid)
    		end
    	end
    	for i,v in ipairs(self._peopleList) do
    		if v._hp > 0 then
    			v:enemyDeadNews(event.data[1].guid)
    		end
    	end
		-- self:enemyDeadNews(event.data[1].guid)
	end )
end


-- 战斗控制中心
function GameFight:controlCenter()
	-- 1，选择一个玩家士兵，状态可战斗
	local people_child = nil
	local people_childs = self._peopleList:getChildren()
	if #people_childs == 0 then -- 没有士兵
		return
	end
	for i,v in ipairs(people_childs) do
		if( v:getStatus() == v.STATUS.CANFIGHT or v:getStatus() == v.STATUS.FIGHT_HALF ) then
			people_child = v
			break
		end
	end
	-- 2，选择一个敌人，状态可战斗
	local enemy_child = nil
	local enemy_childs = self._enemyList:getChildren()
	if #enemy_childs == 0 then -- 没有敌人
		return
	end
	for i,v in ipairs(enemy_childs) do
		if( v:getStatus() == v.STATUS.CANFIGHT or v:getStatus() == v.STATUS.FIGHT_HALF ) then
			enemy_child = v
			break
		end
	end
	if people_child == nil and enemy_child == nil then -- 都正在战斗状态，返回
		return
	end
	-- 3，匹配战斗对象
	-- 查找的士兵和敌人都处于可战斗状态
	-- self:fightBegan() -- 

	-- 查找的士兵或敌人有攻击对象，未被攻击，可以给他匹配

	-- 4，查看道状态
	-- 5，分配战斗道
	-- 6，战斗
end


function GameFight:createEnemySolider()
	local solider = EnemySolider:create(2,self)
	table.insert( self._enemyList,solider )
	self:addChild( solider )
	solider:playIdle()
	-- 设置坐标
	local x = display.width + random( 50,200 )
	local y = self._trackPosY[solider:getTrack()].posY
	
	-- y = self._trackPosY[10].posY -- 测试

	solider:setPosition( x,y )
	solider:setLocalZOrder( 100 - solider:getTrack() )
	return solider
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
	self:seatOpacity()
end
-- 放置位置透明
function GameFight:seatOpacity()
	self.LeftPanel:setOpacity(0)
end
-- 创建士兵
function GameFight:createSoider( id,pos )
	dump(id,"------------create of id is ------")
	dump(pos,"------------create of pos is ------")
	local people = self:createPeopleSolider( id )
	people:setPosition( pos )
	people:moveToBattleRegion()
end

function GameFight:loadStartEnemy()
	for i = 1,3 do
		local solider = EnemySolider:create(1)
		self["enemyNode"..i]:addChild( solider )
		solider:playIdle()
	end
end


function GameFight:createPeopleSolider(id)
	local people = PeopleSolider:create(id,self)
	table.insert( self._peopleList,people )
	self:addChild( people )
	people:playIdle()
	return people
end

-- 匹配战斗
function GameFight:matchFight()
	if #self._enemyList == 0 or #self._peopleList == 0 then
		return
	end
	-- 1:找出敌我双方都处于 CANFIGHT 状态的
	

end


return GameFight