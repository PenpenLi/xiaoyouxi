
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
    	table.insert( self._trackPosY,first_posy + (i-1) * 50 )
    end

    self:loadUi()

end



function GameFight:onEnter()
	GameFight.super.onEnter( self )
	-- 默认初始化三个敌人
	for i = 1,3 do
		self:createEnemySolider()
	end
	
	-- 创建一个自己的战士
	local people = self:createPeopleSolider()
	people:setPosition( cc.p( 20,self._trackPosY[1] ) )

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
end


function GameFight:createEnemySolider()
	local solider = EnemySolider:create(1,self)
	table.insert( self._enemyList,solider )
	self:addChild( solider )
	solider:playIdle()
	-- 设置坐标
	local x = display.width + random( 50,200 )
	local y = self._trackPosY[solider:getOrgTrack()]
	solider:setPosition( x,y )
	solider:setLocalZOrder( 100 - solider:getOrgTrack() )
	return solider
end


function GameFight:loadUi()
	
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
end

function GameFight:loadStartEnemy()
	for i = 1,3 do
		local solider = EnemySolider:create(1)
		self["enemyNode"..i]:addChild( solider )
		solider:playIdle()
	end
end


function GameFight:createPeopleSolider()
	local people = PeopleSolider:create(1,self)
	table.insert( self._peopleList,people )
	self:addChild( people )
	people:playIdle()
	return people
end

-- 匹配战斗
function GameFight:matchFight()
	
end


return GameFight