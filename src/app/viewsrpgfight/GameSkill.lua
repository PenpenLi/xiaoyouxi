

local GameSkill = class("GameSkill",BaseLayer)

function GameSkill:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameSkill.super.ctor( self,param.name )

    self._enemyList = param.data.enemyList
    self._peopleList = param.data.peopleList
    self._skillFirstStatus = false
	self._skillSecondStatus = false
	self._skillThirdStatus = false
	self._hero = nil -- 英雄指针
	----技能1
	self._skillOneJianTou = nil -- 英雄1技能箭头
	self._skillOneButtonQuan = nil -- 1技能按钮的圈
	self._skillOneButtonControl = nil
	self._skillButtonQuanSize = 300 -- 技能控制圈的直径
	self._skillOneRadian = nil -- 技能1的释放角度
	self._skillOneDistance = 2000 -- 技能1攻击距离
	----技能2
	self._skillTwoButtonQuan = nil -- 2技能按钮的圈
	self._skillTwoButtonControl = nil
	self._skillTwoScope = nil -- 2技能施法范围
	self._skillTwoScopeHurt = nil -- 2技能作用范围
	self._skillTwoRadian = nil -- 技能2的释放角度
	self._skillTwoMaxDistance = 400 -- 技能2释放距离，半径
	self._skillTwoHurtRatian = 200 -- 技能2，作用范围直径
	--
    self:addCsb("csbhunzhan/SkillLayer.csb")

    self._scheduleTime = 0.02

    self:addNodeClick(self.ButtonSkill1,{
    	beganCallBack = function ( ... )
    		self:skillOneBegan()
    	end,
    	moveCallBack = function ( ... )
    		self:skillOneMove()
    	end,
    	endCallBack = function ()
    		self:skillOneEnd()
    	end,
    	cancelCallBack = function ()
    		self:skillOneEnd()
    	end,
    })
    self:addNodeClick(self.ButtonSkill2,{
    	beganCallBack = function ( ... )
    		self:skillTwoBegan()
    	end,
    	moveCallBack = function ( ... )
    		self:skillTwoMove()
    	end,
    	endCallBack = function ()
    		self:skillTwoEnde()
    	end,
    	cancelCallBack = function ()
    		self:skillTwoEnde()
    	end
    })
    self:addNodeClick(self.ButtonAddHp,{
    	endCallBack = function ()
    		self:skillAddHp()
    	end
    })
    self:loadUi()
end
function GameSkill:loadUi()
	-- 第一技能
	self:loadSkill1()
	-- 第二技能
	self:loadSkill2()
	-- 第三技能
	self:loadSkill3()
	-- 找到英雄
	self:loadHero()
end
-- 找到英雄
function GameSkill:loadHero()
	self._hero = nil
	for i,v in ipairs(self._peopleList) do
		if v._mode == 2 then
			self._hero = v
		end
	end
end
-- 技能CD
function GameSkill:loadSkill1( ... )
	if self._skillFirstLoadingBar == nil then
		self._skillFirstLoadingBar = self:createSkillLoadingBar("skill/skill1.png")
		self.ButtonSkill1:addChild(self._skillFirstLoadingBar)
	end
	self._skillFirstLoadingBar:setVisible(true)
	
	graySprite( self.ButtonSkill1:getVirtualRenderer():getSprite() )
	local size_skill1 = self.ButtonSkill1:getContentSize()
	self._skillFirstLoadingBar:setPosition( cc.p( size_skill1.width/2,size_skill1.height/2 ))
	self:skillSchedule(self.ButtonSkill1,1,self._skillFirstLoadingBar)
end
function GameSkill:loadSkill2( ... )
	if self._skillSecondLoadingBar == nil then
		self._skillSecondLoadingBar = self:createSkillLoadingBar("skill/skill2.png")
		self.ButtonSkill2:addChild(self._skillSecondLoadingBar)
	end
	self._skillSecondLoadingBar:setVisible(true)
	
	graySprite( self.ButtonSkill2:getVirtualRenderer():getSprite() )
	local size_skill2 = self.ButtonSkill2:getContentSize()
	self._skillSecondLoadingBar:setPosition( cc.p( size_skill2.width/2,size_skill2.height/2 ))
	self:skillSchedule(self.ButtonSkill2,2,self._skillSecondLoadingBar)
end
function GameSkill:loadSkill3( ... )
	if self._skillThirdLoadingBar == nil then
		self._skillThirdLoadingBar = self:createSkillLoadingBar("skill/add_hp.png")
		self.ButtonAddHp:addChild(self._skillThirdLoadingBar)
	end
	self._skillThirdLoadingBar:setVisible(true)
	
	graySprite( self.ButtonAddHp:getVirtualRenderer():getSprite() )
	local size_skill3 = self.ButtonAddHp:getContentSize()
	self._skillThirdLoadingBar:setPosition( cc.p( size_skill3.width/2,size_skill3.height/2 ))
	self:skillSchedule(self.ButtonAddHp,3,self._skillThirdLoadingBar)
end
function GameSkill:skillSchedule( node,skillId,loadingBar )
	local index = 0
	node:stopAllActions()
	schedule(node,function ()
		local percentage = index / ( rpgSkill_config[skillId].cd / self._scheduleTime )
		loadingBar:setPercentage( percentage * 100 )
		if percentage >= 1 then
			if skillId == 1 then
				self._skillFirstStatus = true
			elseif skillId == 2 then
				self._skillSecondStatus = true
			elseif skillId == 3 then
				self._skillThirdStatus = true
			end
			-- node:unSchedule()
			node:stopAllActions()
			loadingBar:setVisible( false )
			ungraySprite( node:getVirtualRenderer():getSprite() )
		end
		index = index + 1
	end,self._scheduleTime)
end
-- 创建进度条
function GameSkill:createSkillLoadingBar(path)
	local skill = ccui.ImageView:create(path)
	-- 创建进度条
	local circleProgressBar = cc.ProgressTimer:create( skill:getVirtualRenderer():getSprite() )
	-- 设置类型，圆形
	circleProgressBar:setType( cc.PROGRESS_TIMER_TYPE_RADIAL )
	-- 设置进度
	circleProgressBar:setPercentage( 0 )
	-- circleProgressBar:setVisible(true)
	return circleProgressBar
end
--------------------------技能1-----------------------------
-- 技能1，点击开始
function GameSkill:skillOneBegan()
	if self._hero == nil then
		self._skillFirstStatus = false
		return
	end
	if self._skillFirstStatus == false then
		return
	end
	self:loadHero()
	if self._hero == nil then
		return
	end
	if self._skillOneButtonQuan == nil then
		-- 添加圈
		self._skillOneButtonQuan = ccui.ImageView:create("skill/quan3.png")
		self:addChild(self._skillOneButtonQuan)
		-- local button_size = self.ButtonSkill1:getContentSize()
		local button_pos = cc.p(self.ButtonSkill1:getPosition())
		local quan_size = self._skillOneButtonQuan:getContentSize()
		self._skillOneButtonQuan:setScaleX( self._skillButtonQuanSize / quan_size.width )
		self._skillOneButtonQuan:setScaleY( self._skillButtonQuanSize / quan_size.height )
		self._skillOneButtonQuan:setPosition(button_pos.x,button_pos.y)
		-- 添加控制按钮
		self._skillOneButtonControl = ccui.ImageView:create("skill/skill_control.png")
		self:addChild(self._skillOneButtonControl)
		self._skillOneButtonControl:setPosition(button_pos.x,button_pos.y)
	end
	self._skillOneButtonQuan:setVisible(true)
	self._skillOneButtonControl:setVisible(true)
	
	self:createJianTouOnHero(0)

	-- local location = cc.p(self._skillOneButtonQuan:getTouchBeganPosition())
	-- dump(location)
end
-- 技能1，箭头
function GameSkill:createJianTouOnHero( radian )

	if self._skillOneJianTou == nil then
		self._skillOneJianTou = ccui.ImageView:create("skill/direction.png")
		self._hero:addChild(self._skillOneJianTou)
		self._skillOneJianTou:setAnchorPoint(0,0.5)
	end
	self._skillOneJianTou:setVisible(true)
	self._skillOneJianTou:setRotation(radian)
end
-- 技能1，move
function GameSkill:skillOneMove( ... )
	
	if self._skillFirstStatus == false then
		return
	end
	self:loadHero()
	if self._hero == nil then
		self:resetOfHeroDead()
		return
	end
	local location = cc.p(self.ButtonSkill1:getTouchMovePosition())
	local button_pos = cc.p(self.ButtonSkill1:getPosition())
	local radian = self:getTwoPosRotation( button_pos,location )
	self._skillOneRadian = radian
	self:createJianTouOnHero(radian)
	local buttonControl_pos = location -- 控制按钮坐标
	local radius = self._skillButtonQuanSize/2
	
	if cc.pGetDistance(location,button_pos) > radius then
		buttonControl_pos = self:getSkillControlPositon( button_pos,radian,radius )
	end
	
	self._skillOneButtonControl:setPosition( buttonControl_pos )
end
function GameSkill:skillOneEnd()
	
	if self._skillFirstStatus == false then
		return
	end
	self:loadHero()
	if self._hero == nil then
		self:resetOfHeroDead()
		return
	end
	self._skillFirstStatus = false
	self:loadSkill1()
	-- local boss = nil
	for i,v in ipairs(self._peopleList) do
		if v._mode == 2 then
			self:shockWavesEffect(v)
		end
	end
	self:resetSkillOne()
end
function GameSkill:shockWavesEffect( node )
	-- 发射指向技能
	if node and not node:isDead() then
		local enemy = node:getDestEnemy()
		self:sendFireBall(node,enemy)
	end
end

-- 发射指向技能
function GameSkill:sendFireBall( node,enemy )
	local m_pos = cc.p(node:getPosition())
	local imageFireBall = ccui.ImageView:create("skill/skill_effect_1.png")
	self:addChild(imageFireBall)
	imageFireBall:setPosition(m_pos)
	if self._skillOneRadian == nil then
		if node:getDir() == 1 then
			self._skillOneRadian = -180
		elseif node:getDir() == 2 then
			self._skillOneRadian = 0
		end
	end
	imageFireBall:setRotation( self._skillOneRadian )
	local move_to_pos = self:getSkillControlPositon(m_pos,self._skillOneRadian,self._skillOneDistance)
	local move_to = cc.MoveTo:create( 1,move_to_pos )
	local fadeout = cc.FadeOut:create(0.2)
	local call = cc.CallFunc:create(function ()
		imageFireBall:removeFromParent()
	end)
	local seq = cc.Sequence:create(move_to,fadeout,call)
	imageFireBall:runAction(seq)
	local hurtedList = {}
	local config = rpgSkill_config[1]
	schedule(imageFireBall,function ()
		self:fireHurt(imageFireBall,hurtedList,config)
	end,0.02)
end
function GameSkill:resetSkillOne( ... )
	self._skillOneJianTou:setVisible(false) -- 英雄1技能箭头
	self._skillOneButtonQuan:setVisible(false) -- 1技能按钮的圈
	self._skillOneButtonControl:setVisible(false)
	self._skillOneRadian = nil -- 技能1的释放角度
end
function GameSkill:resetOfHeroDead()
	self._skillOneButtonQuan:setVisible(false) -- 1技能按钮的圈
	self._skillOneButtonControl:setVisible(false)
	self._skillTwoButtonQuan:setVisible(false) -- 2技能按钮的圈
	self._skillTwoButtonControl:setVisible(false)
	self._skillTwoScopeHurt:setVisible(false) -- 2技能作用范围
end
-------------------------技能2-------------------------
-- 技能2，点击开始
function GameSkill:skillTwoBegan()
	if self._hero == nil then
		self._skillSecondStatus = false
		return
	end
	if self._skillSecondStatus == false then
		return
	end
	self:loadHero()
	if self._hero == nil then
		return
	end
	if self._skillTwoButtonQuan == nil then
		-- 添加圈
		self._skillTwoButtonQuan = ccui.ImageView:create("skill/quan3.png")
		self:addChild(self._skillTwoButtonQuan)
		-- local button_size = self.ButtonSkill1:getContentSize()
		local button_pos = cc.p(self.ButtonSkill2:getPosition())
		local quan_size = self._skillTwoButtonQuan:getContentSize()
		self._skillTwoButtonQuan:setScaleX( self._skillButtonQuanSize / quan_size.width )
		self._skillTwoButtonQuan:setScaleY( self._skillButtonQuanSize / quan_size.height )
		self._skillTwoButtonQuan:setPosition(button_pos.x,button_pos.y)
		-- 添加控制按钮
		self._skillTwoButtonControl = ccui.ImageView:create("skill/skill_control.png")
		self:addChild(self._skillTwoButtonControl)
		self._skillTwoButtonControl:setPosition(button_pos.x,button_pos.y)
	end
	self._skillTwoButtonQuan:setVisible(true)
	self._skillTwoButtonControl:setVisible(true)
	
	local hero_pos = cc.p(self._hero:getPosition())
	self:createScopeOnHero(hero_pos) -- 技能范围
end
-- 技能2，施法范围
function GameSkill:createScopeOnHero(pos)
	if self._skillTwoScope == nil then
		self._skillTwoScope = ccui.ImageView:create("skill/quan1.png")
		self._hero:addChild(self._skillTwoScope)
		local quan_size = self._skillTwoScope:getContentSize()
		-- self._skillTwoScope:setScaleX( self._skillTwoMaxDistance * 2 / quan_size.width )
		-- self._skillTwoScope:setScaleY( self._skillTwoMaxDistance * 2 / quan_size.height )
		self._skillTwoScopeHurt = ccui.ImageView:create("skill/quan2.png")
		self:addChild(self._skillTwoScopeHurt)
		local fire_size = self._skillTwoScopeHurt:getContentSize()
		-- self._skillTwoScopeHurt:setScaleX( self._skillTwoHurtRatian / fire_size.width )
		-- self._skillTwoScopeHurt:setScaleY( self._skillTwoHurtRatian / fire_size.height )
	end
	self._skillTwoScope:setVisible(true)
	self._skillTwoScopeHurt:setVisible(true)
	self._skillTwoScopeHurt:setPosition(pos)
end
function GameSkill:skillTwoMove()
	
	if self._skillSecondStatus == false then
		return
	end
	self:loadHero()
	if self._hero == nil then
		self:resetOfHeroDead()
		return
	end
	local location = cc.p(self.ButtonSkill2:getTouchMovePosition())
	local button_pos = cc.p(self.ButtonSkill2:getPosition())
	local radian = self:getTwoPosRotation( button_pos,location )
	self._skillTwoRadian = radian
	
	local buttonControl_pos = location -- 控制按钮坐标
	local radius = self._skillButtonQuanSize/2
	-- 显示施法位置与英雄的距离
	local dis = cc.pGetDistance(location,button_pos) / radius * (self._skillTwoMaxDistance - self._skillTwoHurtRatian / 2)
	if cc.pGetDistance(location,button_pos) > radius then
		buttonControl_pos = self:getSkillControlPositon( button_pos,radian,radius )
		dis = self._skillTwoMaxDistance - self._skillTwoHurtRatian / 2
	end
	
	self:showSkillTwoPosition(radian,dis)
	self._skillTwoButtonControl:setPosition( buttonControl_pos )
end
-- 显示技能2释放位置
function GameSkill:showSkillTwoPosition( radian,dis )
	local hero_pos = cc.p(self._hero:getPosition())
	local fire_pos = self:getSkillControlPositon(hero_pos,radian,dis)
	self._skillTwoScopeHurt:setPosition(fire_pos)
end
function GameSkill:skillTwoEnde()
	
	if self._skillSecondStatus == false then
		return
	end
	self:loadHero()
	if self._hero == nil then
		self:resetOfHeroDead()
		return
	end
	self._skillSecondStatus = false
	self:loadSkill2()
	local boss = nil
	for i,v in ipairs(self._peopleList) do
		if v._mode == 2 then
			self:skillFireEffect( v )
		end
	end
	self:resetSkillTwo()
end
function GameSkill:skillFireEffect( node )
	local imageFire = ccui.ImageView:create("fire/1.png")
	self:addChild(imageFire)
	local fire_pos = cc.p(self._skillTwoScopeHurt:getPosition())
	imageFire:setPosition( fire_pos )
	-- 技能效果
	local call1 = cc.CallFunc:create(function ( ... )
		imageFire:loadTexture("fire/1.png")
	end)
	local delay1 = cc.DelayTime:create(0.2)
	local call2 = cc.CallFunc:create(function ( ... )
		imageFire:loadTexture("fire/2.png")
	end)
	local delay2 = cc.DelayTime:create(0.2)
	local call3 = cc.CallFunc:create(function ( ... )
		imageFire:loadTexture("fire/3.png")
	end)
	local delay3 = cc.DelayTime:create(0.2)
	local seq = cc.Sequence:create(call1,delay1,call2,delay2,call3,delay3)
	local rep = cc.RepeatForever:create(seq)
	imageFire:runAction(rep)
	performWithDelay(imageFire,function ()
		imageFire:removeFromParent()
	end,5)
	-- 技能伤害
	local hurtedList = {}
	local config = rpgSkill_config[2]
	schedule(imageFire,function ( ... )
		self:fireHurt(imageFire,hurtedList,config)
	end,0.2)
end
-- 技能伤害，node=技能，list=已碰撞列表，config=技能配置文件
function GameSkill:fireHurt( node,list,config )
	local pos = cc.p(node:getPosition())
	local fire_world_pos = node:getParent():convertToWorldSpace(pos)
	-- local hurtedList = {}
	for i,enemy in ipairs(self._enemyList) do
		local e_pos = cc.p(enemy:getPosition())
		local e_world_pos = enemy:getParent():convertToWorldSpace(e_pos)
		if cc.pGetDistance( e_world_pos,fire_world_pos ) < config.dis_collide then
			local enemyIsHurt = false
			for j,hurted_enemy in ipairs(list) do
				if hurted_enemy == enemy then
					enemyIsHurt = true
					break
				end
			end
			if enemyIsHurt == false then
				table.insert(list,enemy)
				local hurtNum = config.perHurt / 100 * rpgsolider_config[enemy:getId()].hp
				enemy:setHpByHurt(hurtNum)
			end
		end
	end
end
function GameSkill:resetSkillTwo( ... )
	self._skillTwoButtonQuan:setVisible(false) -- 2技能按钮的圈
	self._skillTwoButtonControl:setVisible(false)
	self._skillTwoScope:setVisible(false) -- 2技能施法范围
	self._skillTwoScopeHurt:setVisible(false) -- 2技能作用范围
	self._skillTwoRadian = nil -- 技能2的释放角度
end

---------------------技能3------------------
function GameSkill:skillAddHp()
	if self._hero == nil then
		self._skillThirdStatus = false
		return
	end
	if self._skillThirdStatus == false then
		return
	end
	self:loadHero()
	if self._hero == nil then
		return
	end
	self._skillThirdStatus = false
	self:loadSkill3()
	local per_addHp = rpgSkill_config[3].addHp / 100
	for i,v in ipairs(self._peopleList) do
		local node = cc.Node:create()
		v.Icon:addChild(node)
		local size = v.Icon:getContentSize()
		node:setPosition(size.width/2,size.height/2)
		local imageHp = ccui.ImageView:create("care/ZhiLiao1.png")
		node:addChild(imageHp)
		-- 士兵加血
		local upHp = rpgsolider_config[v:getId()].hp * per_addHp
		v:addHp(upHp)

		-- 加血动画
		local call1 = cc.CallFunc:create(function ( ... )
			imageHp:loadTexture("care/ZhiLiao1.png")
		end)
		local delay1 = cc.DelayTime:create(0.2)
		local call2 = cc.CallFunc:create(function ( ... )
			imageHp:loadTexture("care/ZhiLiao2.png")
		end)
		local delay2 = cc.DelayTime:create(0.2)
		local seq = cc.Sequence:create(call1,delay1,call2,delay2)
		local rep = cc.RepeatForever:create(seq)
		node:runAction(rep)
		performWithDelay(self,function ( ... )
			node:removeFromParent()
		end,1.5)
	end
end


function GameSkill:onEnter()
	GameSkill.super.onEnter(self)
	self.listener:setSwallowTouches( false )
end


--------------------------共有方法----------------------------
-- 获得两点的角度，s_pos起始点，e_pos终止点
function GameSkill:getTwoPosRotation( s_pos,e_pos )
	local x = e_pos.x - s_pos.x
	local y = e_pos.y - s_pos.y
	local k = math.atan2( y,x )
	local r = - k * 180 / math.pi
	return r
end
-- 输入原点坐标pos，角度randian，半径radius，获得坐标 -- 技能控制
function GameSkill:getSkillControlPositon( pos,radian, radius )
    if radian == 0 then
        -- 0度
        return cc.p(pos.x + radius,pos.y + 0)
    elseif radian == 90 then
        return cc.p(pos.x + 0,pos.y + radius)
    elseif radian == 180 then
        return cc.p(pos.x -radius,pos.y + 0)
    elseif radian == -90 then
        return cc.p(pos.x + 0,pos.y -radius)
    end
	local rad = 2 * math.pi/360 * (radian + 90) -----------------------------------（ - 90 ）？
	local e_x = math.sin( rad ) * radius
	local e_y = math.cos( rad ) * radius
	local m_pos = cc.p( pos.x + e_x,pos.y + e_y )
	return m_pos
end








return GameSkill