local BulletNode = class("BulletNode",BaseNode)


function BulletNode:ctor( parent,param )
	BulletNode.super.ctor( self,"BulletNode" )
	self._bulletIndex = param.index -- 子弹倍数
	self._bulletLevel = param.level -- 子弹等级
	-- self._bulletStartPoint = param.startPoint
	self._bulletRotate = param.bulletRotate -- 子弹角度
	self._fishLayer = param.layer -- 鱼层
	
	self._bullet = ccui.ImageView:create( "image/guns/Bullet"..self._bulletLevel.."_Normal_"..self._bulletIndex.."_b.png",1 )
	self:addChild( self._bullet )
	self._bullet:setRotation( self._bulletRotate )

	
end

function BulletNode:onEnter()
	BulletNode.super.onEnter( self )
	self:setPosition(0,0)
	local hypotenuse = 300 -- 子弹速度
	local radian = 2 * math.pi/360 * self._bulletRotate
	local move_x = math.sin( radian ) * hypotenuse
	local move_y = math.cos( radian ) * hypotenuse

	local move_by_pos = cc.p( move_x,move_y )
	local move_by = cc.MoveBy:create( 1,move_by_pos )
	local repeatForever = cc.RepeatForever:create(move_by )
	self:runAction( repeatForever )
	schedule( self,function()
		self:bandingBox()
		local pos = cc.p(self:getPosition())
		local world_pos = self:getParent():convertToWorldSpace( pos )
		if world_pos.x > display.width or world_pos.x < 0 or world_pos.y < 0 or world_pos.y > display.height then
			self:removeFromParent()
		end
	end,0.02 )
	
end

-- 碰撞检测
function BulletNode:bandingBox( ... )
	local bullet_box = self._bullet:getBoundingBox()
	local bullet_world_pos = self._bullet:getParent():convertToWorldSpace(cc.p( self._bullet:getPosition() ))
	bullet_box.x = bullet_world_pos.x
	bullet_box.y = bullet_world_pos.y

	local fishs = self._fishLayer:getChildren()
	dump(fishs,"----------------fishs = ")
	for i=1,#fishs do
		local fish_box = fishs[i]:getBoundingBox()
		local fish_world_pos = self._bullet:getParent():convertToWorldSpace(cc.p( fishs[i]:getPosition() ))
		fish_box.x = fish_world_pos.x
		fish_box.y = fish_world_pos.y
		if cc.rectIntersectsRect( bullet_box,fish_box ) then
			print("--------------->>>>>"..fishs[i]:getMultiple())
		end
	end
end










return BulletNode