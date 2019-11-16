
local Person = import(".Person")
local Soldier = class("Soldier",Person)


function Soldier:initConfig()
	self._config = chengbao_config.soldier[self._id]
end


function Soldier:getEnemyList()
	return self._gameLayer._enemyList
end


-- 死亡
function Soldier:dead()
	-- for i,v in ipairs( self._gameLayer._soldierList ) do
	-- 	if self == v.node then
	-- 		table.remove( self._gameLayer._soldierList,i )
	-- 		break
	-- 	end
	-- end
	-- self:removeFromParent()
end


return Soldier