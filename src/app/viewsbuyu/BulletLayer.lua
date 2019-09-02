
local BulletNode = import( ".BulletNode" )
local BulletLayer = class( "BulletLayer",BaseLayer )


function BulletLayer:ctor( gameLayer )
    BulletLayer.super.ctor( self,"BulletLayer" )
    self:addCsb( "csbbuyu/Bullet.csb" )

    self._gameLayer = gameLayer
    self._bulletList = {}

    self._bulletStartPoint = self.BulletNode:getParent():convertToWorldSpace( cc.p( self.BulletNode:getPosition() ) )

    self._bulletIndex = 6 -- 子弹倍数
    self._level = 1 -- 子弹等级/炮台等级
end
-- 创建子弹
function BulletLayer:createBullet(cur_point)
	local x = cur_point.x - self._bulletStartPoint.x
	local y = cur_point.y - self._bulletStartPoint.y
	local k = math.atan2( y,x )
	local r = 90 - k * 180 / math.pi

	self.ImageGun:setRotation( r )

	local param = {
		index = self._bulletIndex,
		level = self._level,
		bulletRotate = r,
		layer = self._gameLayer
	}
	local bullet = BulletNode.new( self,param )
	self.BulletNode:addChild( bullet )
end

function BulletLayer:onTouchBegan( touch, event )
	local cur_point = touch:getLocation()
	self:createBullet(cur_point)
	self:schedule( function ()
		local cur_point = touch:getLocation()
		self:createBullet(cur_point)
	end,0.2)
	-- self._beganState = 1

	-- local cur_point = touch:getLocation()
	-- self:createBullet(cur_point)
	-- print("------------------------11111")

	return true
end
function BulletLayer:onTouchMoved( touch, event )
	-- self:unSchedule()
	
	-- if self._beganState == 1 then
	-- 	self:stopAllAction()
	-- 	self._beganState = 2
	-- 	dump( self._beganState,"---------------self._beganState = ")
	-- end

	-- local cur_point = touch:getLocation()
	-- self:createBullet(cur_point)

	-- self:schedule( function () ------------------为什么这里加
	-- 	local cur_point = touch:getLocation()
	-- 	self:createBullet(cur_point)
	-- 	print("---------------------222222")
	-- end,0.2)
	-- print("---------------------3333333")
end

function BulletLayer:onTouchEnded( touch, event )
	self:unSchedule()
	-- local cur_point = touch:getLocation()

	-- local x = cur_point.x - self._bulletStartPoint.x
	-- local y = cur_point.y - self._bulletStartPoint.y
	-- local k = math.atan2( y,x )
	-- local r = 90 - k * 180 / math.pi

	-- -- bullet:setRotation( r )
	-- self.ImageGun:setRotation( r )

	-- local param = {
	-- 	index = self._bulletIndex,
	-- 	level = self._level,
	-- 	-- startPoint = self._bulletStartPoint,
	-- 	bulletRotate = r
	-- }
	-- local bullet = BulletNode.new( self,param )
	-- -- local bullet = ccui.ImageView:create( "image/guns/Bullet1_Normal_1_b.png",1 )
	-- self.BulletNode:addChild( bullet )


	-- bullet:setPosition(0,0)
	-- local hypotenuse = 300
	-- local radian = 2 * math.pi/360 * r
	-- local move_x = math.sin( radian ) * hypotenuse
	-- local move_y = math.cos( radian ) * hypotenuse

	-- local move_by_pos = cc.p( move_x,move_y )
	-- dump(move_by_pos,"----------------move_by_pos = ")
	-- local move_by = cc.MoveBy:create( 1,move_by_pos )
	-- local repeatForever = cc.RepeatForever:create(move_by )
	-- bullet:runAction( repeatForever )
	-- schedule( bullet,function()
	-- 	local pos = cc.p(bullet:getPosition())
	-- 	local world_pos = bullet:getParent():convertToWorldSpace( pos )
	-- 	if world_pos.x > display.width or world_pos.x < 0 or world_pos.y < 0 or world_pos.y > display.height then
	-- 		bullet:removeFromParent()
	-- 	end
	-- end,0.02 )










	-- if cur_point.y <= self._bulletStartPoint.y then
	-- 	return
	-- end

	-- -- 创建子弹
	-- -- 优先从缓存中取
	-- local bullet = nil
	-- if #self._bulletList > 0 then
	-- 	bullet = self._bulletList[1]
	-- 	table.remove( self._bulletList,1 )
	-- 	print("---------------> 子弹从缓存中创建 ")
	-- else
	-- 	print("---------------> 创建新的子弹 ")
	-- 	bullet = ccui.ImageView:create( "image/guns/Bullet1_Normal_1_b.png",1 )
	-- 	bullet:retain()	-- 增加引用计数 为了不被删除
	-- end

	
	-- 子弹的动作
	
	
	-- -- 计算要移动的终点
	-- local x1 = display.width
	-- local y1 = x1 * y / x
	-- local move_to = cc.MoveTo:create( 5,cc.p( x1,y1 ) )
	-- local call_remove = cc.CallFunc:create( function()
	-- 	bullet:removeFromParent()
	-- 	table.insert( self._bulletList,bullet )
	-- end )
	-- local seq = cc.Sequence:create({ move_to,call_remove })
	-- bullet:runAction( seq )
	

end





return BulletLayer