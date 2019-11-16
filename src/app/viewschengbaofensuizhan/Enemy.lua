
local Person = import(".Person")
local Enemy = class("Enemy",Person)



function Enemy:initConfig()
	self._config = chengbao_config.enemy[self._id]
end


function Enemy:createIcon()
	Enemy.super.createIcon( self )
	self._icon:setFlippedX( true )
end


function Enemy:getEnemyList()
	return self._gameLayer._soldierList
end


-- 死亡
function Enemy:dead()
	-- for i,v in ipairs( self._gameLayer._enemyList ) do
	-- 	if self == v.node then
	-- 		table.remove( self._gameLayer._enemyList,i )
	-- 		break
	-- 	end
	-- end
	-- self:removeFromParent()
end





return Enemy