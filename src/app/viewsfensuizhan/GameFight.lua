

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