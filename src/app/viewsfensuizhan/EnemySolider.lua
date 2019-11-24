

local BaseSolider = import(".Solider")

local EnemySolider = class("EnemySolider",BaseSolider)


function EnemySolider:onEnter()
	EnemySolider.super.onEnter( self )

	-- 默认 向左边
	self:setDirection("left")
end

















return EnemySolider

















