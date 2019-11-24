


local EnemySolider = import(".EnemySolider")

local GameFight = class("GameFight",BaseLayer)


function GameFight:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameFight.super.ctor( self,param.name )

    self:addCsb( "csbfensuizhan/FightLayer.csb" )
end



function GameFight:onEnter()
	GameFight.super.onEnter( self )
	-- 默认初始化三个敌人
	self:loadStartEnemy()

	-- 创建一个自己的战士
	
end


function GameFight:loadStartEnemy()
	for i = 1,3 do
		local solider = EnemySolider:create(1)
		self["enemyNode"..i]:addChild( solider )
		solider:playIdle()
	end
end






return GameFight