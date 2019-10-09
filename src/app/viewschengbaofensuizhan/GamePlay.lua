
local LoadPersonLayer = import(".LoadPersonLayer")
local Soldier = import(".Soldier")
local Enemy = import(".Enemy")
local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GamePlay.super.ctor( self,param.name )

	self:addCsb("csbchengbaofensuizhan/GamePlay.csb")
	self._loadPersonLayer = LoadPersonLayer.new(self)
	self:addChild( self._loadPersonLayer )

	self:loadPerson()

	-- 自己士兵的容器
	self._soldierList = {}
	-- 电脑士兵的容器
	self._enemyList = {}
end

function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	-- 创建敌人
	self._enemyScheduleTime = random( 1,3 )
	self._enemyCurrentTime = 1
	self._enemyTotalCount = 1
	self._enemyCurrentCount = 0
	self:schedule( function()
		self:createEnemy()
	end,1 )
end

function GamePlay:loadPerson()
	local soldier = Soldier.new( 1,self )
	self:addChild( soldier )
	-- soldier:playAttackAction()
	soldier:setPosition( display.cx - 200,display.cy )

	-- local soldier2 = Soldier.new( 2 )
	-- self:addChild( soldier2 )
	-- soldier2:playAttackAction()
	-- soldier2:setPosition( display.cx - 300,display.cy )
end


-- 创建自己的士兵
function GamePlay:createSoldier( soldierId,woldPos )
	local soldier = Soldier.new( soldierId )
	self:addChild( soldier )
	soldier:setPosition( woldPos )
	table.insert( self._soldierList,soldier )
end

-- 创建电脑的士兵
function GamePlay:createEnemy()
	self._enemyCurrentTime = self._enemyCurrentTime + 1
	if self._enemyCurrentTime >= self._enemyScheduleTime then
		self._enemyCurrentTime = 0
		self._enemyScheduleTime = random( 1,3 )
		-- 创建敌人 随机1-2个
		local enemy_num = random(1,2)
		for i = 1,enemy_num do
			-- 随机id
			local enemy_id = random( 1,#chengbao_config.enemy )
			local enemy_node = Enemy.new( enemy_id,self )
			self:addChild( enemy_node )
			table.insert( self._enemyList,enemy_node )

			-- enemy_node:playAttackAction()

			-- 位置也需要随机
			enemy_node:setPosition( display.cx + random(200,300),display.cy + random( -200,200 ) )
		end
		self._enemyCurrentCount = self._enemyCurrentCount + enemy_num
		if self._enemyCurrentCount >= self._enemyTotalCount then
			self:unSchedule()
		end
	end
end


function GamePlay:getEnemyList()
	return self._enemyList
end




return GamePlay