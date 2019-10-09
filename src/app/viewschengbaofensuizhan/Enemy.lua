
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








return Enemy