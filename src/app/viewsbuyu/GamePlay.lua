

local FishLayer   = import(".FishLayer")
local BulletLayer = import(".BulletLayer")

local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbbuyu/Play.csb" )

    -- 1:创建鱼层
	local fish_layer = FishLayer.new( self )
	self:addChild( fish_layer,1 )
	self._fishLayer = fish_layer
	-- 2:子弹层
	local bullet_layer = BulletLayer.new( self )
	self:addChild( bullet_layer,2 )
	self._bulletLayer = bullet_layer



end

-- 创建鱼和控制鱼数量的方法
function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	-- 开启帧调用，检测子弹和鱼碰撞
	self:onUpdate( function( dt ) 
		self:bandingBox(dt)
	end)
end

-- 获取鱼层
function GamePlay:getFishLayer()
	return self._fishLayer
end

-- 碰撞检测
function GamePlay:bandingBox( dt )
	-- local bullets_node = self._bulletLayer:getBulletNode()
	local bullets = self._bulletLayer.BulletNode:getChildren()
	local fishs = self._fishLayer._fishContainer:getChildren()

	for i=1,#bullets do
		local bullet_box = bullets[i]._bullet:getBoundingBox()
		local bullet_world_pos = bullets[i]._bullet:getParent():convertToWorldSpace(cc.p( bullets[i]._bullet:getPosition() ))
		bullet_box.x = bullet_world_pos.x
		bullet_box.y = bullet_world_pos.y
		bullet_box.width = bullet_box.width * 0.8
		bullet_box.height = bullet_box.height * 0.8
		-- local bullet_pos = cc.p( bullets[i]._bullet:getParent() ) 
		for j=1,#fishs do
			local fish_box = fishs[j]:getFish():getBoundingBox()
			local fish_world_pos = fishs[j]:getFish():getParent():convertToWorldSpace(cc.p( fishs[j]:getFish():getPosition() ))
			fish_box.x = fish_world_pos.x
			fish_box.y = fish_world_pos.y

			-- fish_box.width = fish_box.width * 0.8
			-- fish_box.height = fish_box.height * 0.8
			
			if cc.rectIntersectsRect( bullet_box,fish_box ) then
			-- if cc.rectContainsPoint( fish_box,bullet_pos ) then
				-- print("----------------------------打中鱼了~！！！")
				self:stateOfBullet( bullets[i] )     -------------------------------------这里传参bullets[i]._bullet，45行出问题是什么鬼？？
				-- self:stateOfFish( fishs[j] )
				fishs[j]:fishBeAttacked( 1000 )
				-- self:fishBeAttacked( fishs[j],1000 )

			end
		end
	end

end

-- 子弹碰撞效果
function GamePlay:stateOfBullet( bullet )
	-- dump( bullet,"-----------bullet = ")
	-- dump( bullet._bullet,"-----------bullet._bullet = ")
	local bullet_pos = cc.p(bullet._bullet:getPosition())
	local net_pos = bullet._bullet:getParent():convertToWorldSpace( bullet_pos )
	
	local fishNet = ccui.ImageView:create( "image/net/1.png",1 )
	self:addChild( fishNet,1000 )
	fishNet:setPosition( net_pos )
	performWithDelay( self,function ()
		fishNet:removeFromParent()
	end,0.3)
	bullet:removeFromParent()
end
-- -- 鱼的碰撞效果
-- function GamePlay:fishBeAttacked( fish,harmNum )
-- 	fish:setBlood( harmNum )
-- 	local hp = fish:getBlood()
-- 	if hp <= 0 then
-- 		-- 死亡动画
-- 		self:actionOfDead( fish )
-- 		-- performWithDelay( self,function ()
-- 		-- 	fish:removeFromParent()
-- 		-- end,1)
		
-- 	else
-- 		-- 受伤动画
-- 		local index = 0 -- 控制变色时间
-- 		self:onUpdate( function( dt ) 
-- 			redSprite( fish._fish:getVirtualRenderer():getSprite() )
-- 			index = index + 1
-- 			if index >= 10 then
-- 				self:unscheduleUpdate()
-- 			end

-- 		end)

--     end
-- end
-- -- 死亡动画
-- function GamePlay:actionOfDead( fish )
-- 	-- 死亡从node移除到世界坐标，避免死了一直能攻击
-- 	local dead_pos = cc.p(fish:getPosition())
-- 	local dead_worldPos = fish:getParent():convertToWorldSpace( dead_pos )
-- 	local rot = fish:getRotation()

	
-- 	-- fish._fish:retain()
-- 	-- fish:removeFromParent()
-- 	-- self:addChild( fish._fish )
-- 	-- fish._fish:release()
-- 	-- fish._fish:setPosition( dead_worldPos )

-- 	local fishIndex = fish:getFishIndex()
-- 	self._config = buyu_config.fish[fishIndex]
-- 	local img_fish = ccui.ImageView:create( self._config.path.."0.png",1)
-- 	self:addChild( img_fish )
-- 	img_fish:setPosition( dead_worldPos )

-- 	fish:stopAllActions()
-- 	fish:unSchedule()
-- 	local index = 0
	
-- 	-- dump( rot,"------------rot = ")
-- 	schedule( img_fish,function ()
-- 		local path = self._config.path..index..".png"
-- 		redSprite( img_fish:getVirtualRenderer():getSprite() )
-- 		img_fish:loadTexture( path,1 )
-- 		img_fish:setRotation( rot )
-- 		-- local rot1 = img_fish:getRotation()
-- 		-- dump( rot1,"------------rot1 = ")
-- 		index = index + 1
-- 		if index > self._config.endNum then
-- 			index = 0
-- 		end
-- 	end,0.02)
-- 	performWithDelay( self,function ()
-- 		img_fish:removeFromParent()
-- 	end,1)
-- 	fish:removeFromParent()
-- end






return GamePlay