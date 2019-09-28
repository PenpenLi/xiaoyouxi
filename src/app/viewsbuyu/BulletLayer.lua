
local BulletNode = import( ".BulletNode" )
local BulletLayer = class( "BulletLayer",BaseLayer )


function BulletLayer:ctor( gameLayer )
    BulletLayer.super.ctor( self,"BulletLayer" )
    self:addCsb( "csbbuyu/Bullet.csb" )

    self._gameLayer = gameLayer
    self._bulletList = {}

    self._bulletStartPoint = self.BulletNode:getParent():convertToWorldSpace( cc.p( self.BulletNode:getPosition() ) )

    -- self._bulletIndex = 6 -- 子弹倍数
    self._level = nil -- 等级
    self._multiple = 1 -- 开局初始倍数
    -- 子弹等级/炮台等级
	self._bulletAndBatteryLevel = nil
	self._upLevelState = false -- 升级子弹状态
	self._harmNum = 5 -- 子弹伤害值

	self._insaneShootState = 1 -- 疯狂射击状态，1，正常，2，开启，3，关闭，关闭针对连续射击
	self._automaticAttackState = 1 -- 自动公家，1，正常，2，开启，3，关闭
	

    self:addNodeClick( self.ButtonAdd,{
    	endCallBack = function ()
    		self:addMultiple()
    	end
    })
    self:addNodeClick( self.ButtonSubtract,{
    	endCallBack = function ()
    		self:subtractMultiple()
    	end
    })
    -- 冰封
    self:addNodeClick( self.ButtonCongelation,{
    	endCallBack = function ()
    		self:iceCapped()
    	end
    })
    -- 疯狂射击
    self:addNodeClick( self.ButtonInsane,{
    	endCallBack = function ()
    		self:insaneShoot()
    	end
    })
    -- 自动攻击
    self:addNodeClick( self.ButtonTarget,{
    	endCallBack = function ()
    		self:automaticAttack()
    	end
    })

    self:addNodeClick( self.ButtonReturn,{
		endCallBack = function ()
			self:back()
		end
	})
    
    -- -- 商店
    -- self:addNodeClick( self.ButtonShop,{
    -- 	endCallBack = function ()
    -- 		self:shop()
    -- 	end
    -- })
    self:loadUi()
end
-- 子弹炮台等级
function BulletLayer:bulletHarmNum()
	local config = buyu_config.bullet
	local num = 0
	for i=1,#config do
		num = num + 5
		if self._level <= num then
			self._bulletAndBatteryLevel = i
			break
		end
	end
	-- self._harmNum = 5
	-- GODO


	return self._bulletAndBatteryLevel
end
function BulletLayer:loadLvAndExp( ... )
	self.TextLvNum:setString(G_GetModel("Model_BuYu"):getLevel())
	local exp = G_GetModel("Model_BuYu"):getExp()
	dump( exp,"----------exp = ")
	local targetExp = buyu_config.bullet[self._bulletAndBatteryLevel].exp

	self.LoadingBar_1:setPercent( exp / targetExp * 100)
end
function BulletLayer:loadUi()
	self._level = G_GetModel("Model_BuYu"):getLevel()
	local coin = G_GetModel("Model_BuYu"):getCoin()
	self.TextCoin:setString( coin )
	-- 子弹炮台等级
	self:bulletHarmNum()
	-- 等级经验
	self:loadLvAndExp()
	-- 子弹倍数
	G_GetModel("Model_BuYu"):setMultiple( self._multiple )
	
	-- local level = G_GetModel("Model_BuYu"):getLevel()
	-- local config = buyu_config.bullet
	-- local index = nil
	-- local num = 0
	-- -- local level_end = nil
	-- for i=1,#config do
	-- 	num = num + 5
	-- 	if level <= num then
	-- 		index = i
	-- 		break
	-- 	end
	-- end
	self.ImageGun:ignoreContentAdaptWithSize( true )
	self.ImageGun:loadTexture( buyu_config.bullet[self._bulletAndBatteryLevel].battery,1 )
	self.TextMultiple:setString( buyu_config.multiple[self._multiple] )
end
-- --升级更换炮台
-- function BulletLayer:upBulletAndBattery()
-- 	self._level = G_GetModel("Model_BuYu"):getLevel()
-- 	-- 子弹炮台等级
-- 	self:bulletHarmNum()
-- 	-- 子弹倍数
-- 	G_GetModel("Model_BuYu"):setMultiple( self._multiple )
	
-- 	self.ImageGun:ignoreContentAdaptWithSize( true )
-- 	local x = 1
-- 	self.ImageGun:loadTexture( buyu_config.bullet[self._bulletAndBatteryLevel].battery,1 )
-- 	self.TextMultiple:setString( buyu_config.multiple[self._multiple] )
-- end
function BulletLayer:onEnter( ... )
	BulletLayer.super.onEnter( self )
	self:addMsgListener( InnerProtocol.INNER_EVENT_BUYU_KILL_COIN,function ()
		local coin = G_GetModel("Model_BuYu"):getInstance():getCoin()
		self.TextCoin:setString( coin )
	end )
	G_GetModel("Model_BuYu"):getUpgradeExp()
end
-- 创建子弹
function BulletLayer:createBullet(cur_point,targetFish)
	local upLevel = G_GetModel("Model_BuYu"):setExp()
	if upLevel then
		dump( self._level,"---------self._level = ")
		self:loadUi()
	end
	self:loadLvAndExp()
	local coin = G_GetModel("Model_BuYu"):getCoin()
	if coin < buyu_config.multiple[self._multiple] then
		if self._multiple > 1 then
			local index = self._multiple - 1
			for i=1,index do
				self._multiple = self._multiple - 1
				self.TextMultiple:setString( buyu_config.multiple[self._multiple] )
				if coin > buyu_config.multiple[self._multiple] then
					break
				end
			end
		else
			local is_open = G_GetModel("Model_Sound"):isVoiceOpen()
			if is_open then
				audio.playSound("bymp3/SmashFail.mp3", false)
			end
			self:back()
		end
		return
	end
	local useCoin = -buyu_config.multiple[self._multiple]
	G_GetModel("Model_BuYu"):setCoin( useCoin )

	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_BUYU_KILL_COIN )

	local x = cur_point.x - self._bulletStartPoint.x
	local y = cur_point.y - self._bulletStartPoint.y
	local k = math.atan2( y,x )
	local r = 90 - k * 180 / math.pi
	-- dump( cur_point,)
	self.ImageGun:setRotation( r )

	local param = {
		-- index = self._bulletIndex,
		level = self._level,
		bulletRotate = r,
		layer = self._gameLayer,
		bulletAndBatteryLevel = self._bulletAndBatteryLevel,
		insaneShootState = self._insaneShootState,
		automaticAttackState = self._automaticAttackState, -- 自动攻击状态
		fishPoint = cur_point, -- 自动攻击时需要的鱼的位置
		-- targetFish = targetFish -- 自动攻击目标鱼
	}
	local is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		audio.playSound("bymp3/special_shoot.mp3", false)
	end
	local bullet = BulletNode.new( self,param )
	self.BulletNode:addChild( bullet )
	if self._automaticAttackState == 2 then
		bullet:bulletMoveTarget( targetFish )
	end

end

function BulletLayer:onTouchBegan( touch, event )
	-- 自动攻击
	if self._automaticAttackState == 2 then
		return false
	end

	local createTime = 0.2
	-- 疯狂射击，快速发射
	if self._insaneShootState == 2 then
		createTime = 0.1
	end
	
	-- 触摸发射
	local cur_point = touch:getLocation()
	self:createBullet(cur_point)
	local coin = G_GetModel("Model_BuYu"):getCoin()
	if coin <= 0 then
		return
	end
	self:schedule( function ()
		if self._insaneShootState == 3 then
			self._insaneShootState = 1
			self:unSchedule()
			return
		end
		local cur_point = touch:getLocation()
		self:createBullet(cur_point)
	end,createTime)

	return true
end
function BulletLayer:onTouchMoved( touch, event )

end

function BulletLayer:onTouchEnded( touch, event )
	self:unSchedule()

end

-- 加倍
function BulletLayer:addMultiple()
	if self._multiple >= 10 then
		return
	end
	self._multiple = self._multiple + 1
	self.TextMultiple:setString( buyu_config.multiple[self._multiple] )
	G_GetModel("Model_BuYu"):setMultiple( self._multiple )
end
-- 减倍
function BulletLayer:subtractMultiple()
	if self._multiple <= 1 then
		return
	end
	self._multiple = self._multiple - 1
	self.TextMultiple:setString( buyu_config.multiple[self._multiple] )
	G_GetModel("Model_BuYu"):setMultiple( self._multiple )
end
-- 冰封技能
function BulletLayer:iceCapped()
	if self._gameLayer._fishLayer._iceState then
		return
	end
	self.ButtonCongelation:loadTexture( "image/particle/lock1.png",1 )

	-- 冰封，找个冰霜图片替代.....下面冰封时间到还有个layer
	local layer = cc.LayerColor:create( cc.c4b( 0,0,40,50))
	self:addChild( layer )
	-- 冰封下雪粒子
	local lizi = cc.ParticleSystemQuad:create("image/particle/skin_buyu.plist") 
	layer:addChild(lizi)

	local fishLayer = self._gameLayer._fishLayer
	local fishs = fishLayer._fishContainer:getChildren()
	fishLayer._iceState = true -- 冰封，关闭创建
	for i=1,#fishs do
		fishs[i]:pause()
		fishs[i]:stopSchedule()
	end
	performWithDelay( fishLayer._fishContainer,function ()
		layer:removeFromParent()
		fishs = fishLayer._fishContainer:getChildren()
		for i=1,#fishs do
			fishs[i]:resume()
			fishs[i]:startSchedule()
		end
		fishLayer._iceState = false
		self.ButtonCongelation:loadTexture( "image/particle/lock0.png",1 )
		print("---------------------恢复游動")
	end,10)
end
-- 疯狂射击
function BulletLayer:insaneShoot()
	if self._automaticAttackState == 2 or self._insaneShootState == 2 then -- 自动攻击时不疯狂射击
		return 
	end
	self.ButtonInsane:loadTexture( "image/particle/speed_fast.png",1 )
	self._insaneShootState = 2
	performWithDelay( self,function ()
		self._insaneShootState = 3
		self.ButtonInsane:loadTexture( "image/particle/speed_slow.png",1 )
	end,20)
end


-- 自动攻击
function BulletLayer:automaticAttack()
	if self._automaticAttackState == 2 or self._insaneShootState == 2 then
		return
	end
	self.ButtonTarget:loadTexture( "image/particle/byself1.png",1 )
	self._automaticAttackState = 2 -- 开启
	local index = 100
	self._maxFish = nil
	-- local fishs = nil
	self:schedule( function ()
		if self._maxFish == nil then
			self._maxFish = self:getFishOfDisplay()
		end

		if self._maxFish == nil then -- 屏幕内可能没鱼
			return
		end

		if self._maxFish._dead then
			self._maxFish = nil
			return
		end
		if self._maxFish._hp == nil or self._maxFish._hp <= 0 then
			self._maxFish = nil
			return
		end

		local fish_pos = cc.p( self._maxFish:getPosition())
		local fish_worldPos = self._maxFish:getParent():convertToWorldSpace( fish_pos )
		if fish_worldPos.x < 0 or fish_worldPos.y < 0 or fish_worldPos.x > display.width or fish_worldPos.y > display.height  then
			self._maxFish = nil
			return
		end

		index = index - 1
		if index == 0 then
			self._automaticAttackState = 1
			self._maxFish = nil
			self.ButtonTarget:loadTexture( "image/particle/byself0.png",1 )
			self:unSchedule()
			return
		end

		self:createBullet( fish_worldPos,self._maxFish )
	end,0.2)
	

end
-- 获取屏幕内的鱼
function BulletLayer:getFishOfDisplay( ... )
	

	local fish = nil
	local fishs = self._gameLayer._fishLayer._fishContainer:getChildren()
	-- local config = buyu_config.fish
	local fish_multipleMax = 0 --最大的倍数
	for i=1,#fishs do
		local fish_multiple = fishs[i]:getMultiple()
		if fish_multiple > fish_multipleMax then
			local fish_pos = cc.p( fishs[i]:getPosition())
			local fish_worldPos = fishs[i]:getParent():convertToWorldSpace( fish_pos )
			if fish_worldPos.x > 0 and fish_worldPos.y > 0 and fish_worldPos.x < display.width and fish_worldPos.y < display.height  then
				fish_multipleMax = fish_multiple
				fish = fishs[i]
			end

			
		end
	end
	return fish
end

function BulletLayer:back()
	removeUIFromScene( UIDefine.BUYU_KEY.Play_UI )
	addUIToScene( UIDefine.BUYU_KEY.Start_UI )
end

return BulletLayer