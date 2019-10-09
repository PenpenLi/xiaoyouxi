
local Person = import(".Person")
local Soldier = class("Soldier",Person)


function Soldier:initConfig()
	self._config = chengbao_config.soldier[self._id]
end


function Soldier:getEnemyList()
	return self._gameLayer._enemyList
end

return Soldier