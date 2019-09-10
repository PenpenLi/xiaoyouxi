local BulletNode = class("BulletNode",BaseNode)


function BulletNode:ctor( parent,param )
	BulletNode.super.ctor( self,"BulletNode" )
	self._parent = parent
	-- self._bulletIndex = param.index -- 子弹倍数
	self._bulletLevel = param.bulletAndBatteryLevel -- 子弹等级
	-- self._bulletStartPoint = param.startPoint
	self._bulletRotate = param.bulletRotate -- 子弹角度
	self._playLayer = param.layer -- 游戏层
	self._fishLayer = param.layer._fishLayer -- 鱼层
	self._insaneShootState = param.insaneShootState --疯狂射击状态
	self._automaticAttackState = param.automaticAttackState -- 自动攻击状态，1正常，2自动
	self._cur_point = param.fishPoint -- 自动攻击时，所攻击的鱼的位置
	-- self._targetFish = param.targetFish -- 自动攻击时，目标鱼
	-- dump(self._cur_point,"----------self._cur_point = ")
	-- if self._insaneShootState then
	-- else
	-- end
	self._state = false -- 子弹状态，控制自动攻击子弹不进行碰撞检测
	-- 子弹速度
	self._hypotenuse = 300
	-- 子弹加速
	self:setSpeed()
	-- 子弹伤害值
	-- self._harmNum = 10
	self:getBulletHarmNum() -- 子弹伤害值
	
	self._config = buyu_config.bullet
	dump( self._bulletLevel,"----------self._bulletLevel = ")
	self._bullet = ccui.ImageView:create( self._config[self._bulletLevel].bullet,1 )
	-- self._bullet = ccui.ImageView:create( "image/guns/Bullet"..self._bulletLevel.."_Normal_"..self._bulletIndex.."_b.png",1 )
	self:addChild( self._bullet )
	self._bullet:setRotation( self._bulletRotate )
	-- local x = self._bullet:getContentSize()
	-- dump( x,"--------------------x")

	
end

function BulletNode:onEnter()
	BulletNode.super.onEnter( self )
	self:setPosition(0,0)
	-- self._hypotenuse = 300 -- 子弹速度
	if self._automaticAttackState == 1 then
		self:bulletMove()
	else
		return --自动攻击时，关闭子弹移除屏幕消失
	end
	-- -- 非自动攻击时
	-- -- dump( self._automaticAttackState,"--------------self._automaticAttackState = ")
	-- if self._automaticAttackState == 1 then
		
	-- 	local radian = 2 * math.pi/360 * self._bulletRotate
	-- 	local move_x = math.sin( radian ) * self._hypotenuse
	-- 	local move_y = math.cos( radian ) * self._hypotenuse
	-- 	local move_by_pos = cc.p( move_x,move_y )
	-- 	local move_by = cc.MoveBy:create( 1,move_by_pos )
	-- 	local repeatForever = cc.RepeatForever:create( move_by )
	-- 	self:runAction( repeatForever )
	-- else
	-- 	-- 自动攻击时
	-- 	self._state = true
	-- 	local start_pos =cc.p( self._parent.BulletNode:getPosition())
		
	-- 	local distance = math.sqrt(math.pow((self._cur_point.y-start_pos.y),2)+math.pow((self._cur_point.x-start_pos.x),2))
	-- 	local move_time = distance / self._hypotenuse
	-- 	local radian = 2 * math.pi/360 * self._bulletRotate
	-- 	local move_x = math.sin( radian ) * distance
	-- 	local move_y = math.cos( radian ) * distance
	-- 	local move_to_pos = cc.p( move_x,move_y )
	-- 	local move_to = cc.MoveTo:create( move_time*0.5,move_to_pos )
	-- 	local call = cc.CallFunc:create(function ()

	-- 		self:removeFromParent()
	-- 	end)
	-- 	local seq = cc.Sequence:create({ move_to,call })
	-- 	self:runAction( seq )

	-- end
	
	
	-- self:bandingBox()
	schedule( self,function()
		-- -- 自动攻击时
		-- if self._automaticAttackState == 2 then
		-- 	dump( self._automaticAttackState,"--------------automaticAttackState = ")
		-- 	self._hypotenuse = 6
		-- 	local radian = 2 * math.pi/360 * self._bulletRotate
		-- 	local move_x = math.sin( radian ) * self._hypotenuse
		-- 	local move_y = math.cos( radian ) * self._hypotenuse
		-- 	local move_by_pos = cc.p( move_x,move_y )
		-- 	local move_by = cc.MoveBy:create( 0.02,move_by_pos )
		-- 	-- local repeatForever = cc.RepeatForever:create(move_by )
		-- 	self:runAction( move_by )
		-- end


		-- self:bandingBox()
		local pos = cc.p(self:getPosition())
		local world_pos = self:getParent():convertToWorldSpace( pos )
		if world_pos.x > display.width or world_pos.x < 0 or world_pos.y < 0 or world_pos.y > display.height then
			self:removeFromParent()
		end
	end,0.02 )
	
end
--子弹移动-- 非自动攻击时
function BulletNode:bulletMove( ... )
	
	-- dump( self._automaticAttackState,"--------------self._automaticAttackState = ")
	
		
	local radian = 2 * math.pi/360 * self._bulletRotate
	local move_x = math.sin( radian ) * self._hypotenuse
	local move_y = math.cos( radian ) * self._hypotenuse
	local move_by_pos = cc.p( move_x,move_y )
	local move_by = cc.MoveBy:create( 1,move_by_pos )
	local repeatForever = cc.RepeatForever:create( move_by )
	self:runAction( repeatForever )
	
end
--子弹移动-- 自动攻击时
function BulletNode:bulletMoveTarget( fish )
	-- 自动攻击时
		self._state = true
		local start_pos =cc.p( self._parent.BulletNode:getPosition())
		
		local distance = math.sqrt(math.pow((self._cur_point.y-start_pos.y),2)+math.pow((self._cur_point.x-start_pos.x),2))
		local move_time = distance / self._hypotenuse
		local radian = 2 * math.pi/360 * self._bulletRotate
		local move_x = math.sin( radian ) * distance
		local move_y = math.cos( radian ) * distance
		local move_to_pos = cc.p( move_x,move_y )
		local move_to = cc.MoveTo:create( move_time*0.5,move_to_pos )
		local call = cc.CallFunc:create(function ()
			-- print("-------------被打了")
			-- dump( fish._hp,"------------fish._hp = ")
			self._playLayer:stateOfBullet( self )
			if fish._hp == nil then
				self:removeFromParent()
			else
				fish:fishBeAttacked( self._harmNum )
				self:removeFromParent()
			end
			-- fish:fishBeAttacked( self._harmNum )
			-- self:removeFromParent()
			
		end)
		local seq = cc.Sequence:create({ move_to,call })
		self:runAction( seq )
end

-- -- 碰撞检测
-- function BulletNode:bandingBox( ... )
-- 	local bullet_box = self._bullet:getBoundingBox()
-- 	local bullet_world_pos = self._bullet:getParent():convertToWorldSpace(cc.p( self._bullet:getPosition() ))
-- 	bullet_box.x = bullet_world_pos.x
-- 	bullet_box.y = bullet_world_pos.y
-- 	-- dump(bullet_box,"----------------bullet_box = ")

-- 	local fishs = self._fishLayer._fishContainer:getChildren()
-- 	-- dump(fishs,"----------------fishs = ")
-- 	for i=1,#fishs do
-- 		local fish_box = fishs[i]._fish:getBoundingBox()
-- 		local fish_world_pos = fishs[i]._fish:getParent():convertToWorldSpace(cc.p( fishs[i]._fish:getPosition() ))
-- 		fish_box.x = fish_world_pos.x
-- 		fish_box.y = fish_world_pos.y
-- 		-- dump(fish_box,"----------------fishs = ")
-- 		if cc.rectIntersectsRect( bullet_box,fish_box ) then
-- 			-- print("--------------->>>>>"..fishs[i]:getMultiple())
-- 		end
-- 	end
-- end

-- -- 子弹碰撞效果
-- function BulletNode:stateOfBulletNode()
-- 	self._bullet
-- end


-- 疯狂射击时子弹加速
function BulletNode:setSpeed()
	if self._insaneShootState == 2 or self._automaticAttackState == 2 then
		self._hypotenuse = 600 -- 子弹速度
	end
	-- performWithDelay( self,function ()
	-- 	self._hypotenuse = 300
	-- end,time)
end
-- function BulletNode:setSpeed()
-- 	self._hypotenuse = 300 -- 子弹速度
	
-- end

-- 子弹伤害值
function BulletNode:getBulletHarmNum()
	local config = buyu_config.bullet[self._bulletLevel]
	local num = 0
	-- for i=1,#config do
	-- 	num = num + 5
	-- 	if self._level <= num then
	-- 		self._bulletLevel = i
	-- 		break
	-- 	end
	-- end
	self._harmNum = config.harm -- 伤害值
	-- GODO
	local double = random( 1,2 )
	if double == 2 then
		self._harmNum = self._harmNum * 2
	end

	return self._harmNum
end





return BulletNode