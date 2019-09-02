

local BulletLayer = class( "BulletLayer",BaseLayer )


function BulletLayer:ctor( gameLayer )
    BulletLayer.super.ctor( self,"BulletLayer" )
    self:addCsb( "csbbuyu/Bullet.csb" )

    self._gameLayer = gameLayer
    self._bulletList = {}

    self._bulletStartPoint = self.BulletNode:getParent():convertToWorldSpace( cc.p( self.BulletNode:getPosition() ) )
end





function BulletLayer:onTouchEnded( touch, event )

	local cur_point = touch:getLocation()

	-- if cur_point.y <= self._bulletStartPoint.y then
	-- 	return
	-- end

	-- 创建子弹
	-- 优先从缓存中取
	local bullet = nil
	if #self._bulletList > 0 then
		bullet = self._bulletList[1]
		table.remove( self._bulletList,1 )
		print("---------------> 子弹从缓存中创建 ")
	else
		print("---------------> 创建新的子弹 ")
		bullet = ccui.ImageView:create( "image/guns/Bullet1_Normal_1_b.png",1 )
		bullet:retain()	-- 增加引用计数 为了不被删除
	end
	self.BulletNode:addChild( bullet )
	bullet:setPosition(0,0)
	-- 子弹的动作
	
	local x = cur_point.x - self._bulletStartPoint.x
	local y = cur_point.y - self._bulletStartPoint.y
	local k = math.atan2( y,x )
	local r = 90 - k * 180 / math.pi

	bullet:setRotation( r )
	self.ImageGun:setRotation( r )

	-- 计算要移动的终点
	local x1 = display.width
	local y1 = x1 * y / x
	local move_to = cc.MoveTo:create( 5,cc.p( x1,y1 ) )
	local call_remove = cc.CallFunc:create( function()
		bullet:removeFromParent()
		table.insert( self._bulletList,bullet )
	end )
	local seq = cc.Sequence:create({ move_to,call_remove })
	bullet:runAction( seq )

end





return BulletLayer