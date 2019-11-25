

local Solider = class("Solider",BaseNode) 




function Solider:ctor( soliderId )
	Solider.super.ctor( self,"RankCell" )
	self:addCsb( "csbfensuizhan/NodeSolider.csb" )

	self._id = soliderId
	self._config = solider_config[self._id]
end



function Solider:setDirection( strType )
	if strType == "left" then
		self.Icon:getVirtualRenderer():getSprite():setFlipX( true )
	elseif strType == "right" then
		self.Icon:getVirtualRenderer():getSprite():setFlipX( false )
	end
end


function Solider:playFrameAction( frameName )
	local index = self._config[frameName].fstart
	self.Icon:stopAllActions()
	schedule( self.Icon,function()
		local path = self._config[frameName].path..index..".png"
		self.Icon:loadTexture( path,1 )
		index = index + 1
		if index > self._config[frameName].fend then
			index = self._config[frameName].fstart
		end
	end,0.2 )
end

-- 播放idle动画
function Solider:playIdle()
	self:playFrameAction("idle_frame")
end
-- 播放移动动画
function Solider:playMove()
	self:playFrameAction("move_frame")
end
--播放攻击动画
function Solider:playAttack()
	self:playFrameAction("attack_frame")
end
-- 播放死亡动画
function Solider:playDead()
	self:playFrameAction("dead_frame")
end








return Solider