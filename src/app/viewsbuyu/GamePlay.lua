
local CoinNode = import(".CoinNode")
local FishLayer   = import(".FishLayer")
local BulletLayer = import(".BulletLayer")

local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbbuyu/Play.csb" )
    self._playLevel = param.data
    if G_GetModel("Model_Sound"):isMusicOpen() then
    	if self._playLevel == 1 then
    		audio.playMusic("bymp3/MUSIC_BACK_01.mp3",true)
    	else
    		audio.playMusic("bymp3/MUSIC_BACK_02.mp3",true)
    	end
    end

    -- 1:创建鱼层
	local fish_layer = FishLayer.new( self )
	self:addChild( fish_layer,1 )
	self._fishLayer = fish_layer
	-- 2:子弹层
	local bullet_layer = BulletLayer.new( self )
	self:addChild( bullet_layer,2 )
	self._bulletLayer = bullet_layer

	-- self._deadFishIndex = nil -- 标记死亡鱼
	

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
	-- 自动攻击时，不进行碰撞检测
	if self._bulletLayer._automaticAttackState == 2 then
		return
	end
	local node_pos = cc.p( self._bulletLayer.BulletNode:getPosition())

	
	-- 非自动攻击时碰撞检测
	-- local bullets_node = self._bulletLayer:getBulletNode()
	local bullets = self._bulletLayer.BulletNode:getChildren()
	local fishs = self._fishLayer._fishContainer:getChildren()

	for i=1,#bullets do
		-- 自动攻击状态的子弹，不进行碰撞检测
		if bullets[i]._state then
			-- 自动攻击状态，不执行碰撞检测
		else

			local bullet_box = bullets[i]._bullet:getBoundingBox()
			local bullet_world_pos = bullets[i]._bullet:getParent():convertToWorldSpace(cc.p( bullets[i]._bullet:getPosition() ))
			-- 子弹在炮台内部不检测，好看点
			if bullet_world_pos.x < node_pos.x + 60 and bullet_world_pos.x > node_pos.x - 60 and bullet_world_pos.y < node_pos.y + 50 then
				return
			end
			bullet_box.x = bullet_world_pos.x - bullet_box.width / 2
			bullet_box.y = bullet_world_pos.y - bullet_box.height / 2
			bullet_box.width = bullet_box.width * 0.8
			bullet_box.height = bullet_box.height * 0.8
			-- local bullet_pos = cc.p( bullets[i]._bullet:getParent() ) 
			local harmNum = bullets[i]._harmNum

			for j=1,#fishs do
				local fish_box = fishs[j]:getFish():getBoundingBox()
				local fish_world_pos = fishs[j]:getFish():getParent():convertToWorldSpace(cc.p( fishs[j]:getFish():getPosition() ))
				fish_box.x = fish_world_pos.x - fish_box.width / 2
				fish_box.y = fish_world_pos.y - fish_box.height / 2

				-- fish_box.width = fish_box.width * 0.8
				-- fish_box.height = fish_box.height * 0.8
				
				if cc.rectIntersectsRect( bullet_box,fish_box ) then
				-- if cc.rectContainsPoint( fish_box,bullet_pos ) then
					-- print("----------------------------打中鱼了~！！！")
					self:stateOfBullet( bullets[i] )     -------------------------------------这里传参bullets[i]._bullet，45行出问题是什么鬼？？
					-- self:stateOfFish( fishs[j] )
					-- print( "-----------------111111111111")
					-- dump( bullets[i]._harmNum,"--------------bullets[i]._harmNum = ")
					fishs[j]:fishBeAttacked( harmNum )
					-- dump( fishs[j]._hp,"---------------fishs[j]._hp = ")
					-- self:fishBeAttacked( fishs[j],1000 )
					-- self._deadFishIndex = fishs[j]:getFishGetCoin()

					break
				end
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
	self:addChild( fishNet,1001 )
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

-- 创建金币
function GamePlay:createCoin( pos,coin )
	-- local start_nodePos = cc.p( node:getPosition())
	-- local start_worldPos = node:getParent():convertToWorldSpace( start_nodePos )
	local start_worldPos = pos
	-- dump( start_worldPos,"-----------start_worldPos = ")
	local end_nodePos = cc.p( self._bulletLayer.ImageCoin:getPosition())
	local end_worldPos = self._bulletLayer.ImageCoin:getParent():convertToWorldSpace( end_nodePos )
	-- dump( end_worldPos,"-----------end_worldPos = ")
	-- dump(coin,"--------------coin = ")
	local textCoin = ccui.Text:create()
	self:addChild( textCoin,4 )
	textCoin:setString( coin )
	textCoin:setPosition( start_worldPos )
	textCoin:setFontSize( 50 )
	textCoin:setTextColor( cc.c4b( 214,238,30,255 ))
	local fadeout = cc.FadeOut:create(1)
	local move_by = cc.MoveBy:create( 1,cc.p( 0,15 ))
	local spawn = cc.Spawn:create({ fadeout,move_by })
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ spawn,remove })
	textCoin:runAction( seq )
	local index = 0
	self:schedule( function ()
		local coin = CoinNode.new( self,start_worldPos,end_worldPos )
		self:addChild( coin,3 )
		coin:setPosition( start_worldPos )
		index = index + 1
		if index == 5 then
			self:unSchedule()
		end
	end,0.2)
	
	-- coin:coinMove()
end





return GamePlay