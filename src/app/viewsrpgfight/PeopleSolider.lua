

local BaseSolider = import(".Solider")

local PeopleSolider = class("PeopleSolider",BaseSolider)

function PeopleSolider:ctor( soliderId,brickId,gameLayer )
	PeopleSolider.super.ctor( self,soliderId,brickId,gameLayer )
	-- 默认 向右边
	self._modeType = "people"
	self._enemyList = self._gameLayer._enemyList
	self._dir = 2 -- 方向 1:向左 2:向右
	self.Icon:getVirtualRenderer():getSprite():setFlippedX( false )
end


function PeopleSolider:onEnter()
	PeopleSolider.super.onEnter( self )

	
end




return PeopleSolider