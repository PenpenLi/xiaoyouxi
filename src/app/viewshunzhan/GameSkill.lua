

local GameSkill = class("GameSkill",BaseLayer)

function GameSkill:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameSkill.super.ctor( self,param.name )

    self._enemyList = param.data.enemyList
    self._peopleList = param.data.peopleList

    self:addCsb("csbhunzhan/SkillLayer.csb")

    self._scheduleTime = 0.02

    self:addNodeClick(self.ButtonSkill1,{
    	endCallBack = function ()
    		self:skill1()
    	end
    })
    self:addNodeClick(self.ButtonSkill2,{
    	endCallBack = function ()
    		self:skill2()
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
	self._skillFirstLoadingBar = self:createSkillLoadingBar("skill/skill1.png")
	self.ButtonSkill1:addChild(self._skillFirstLoadingBar)
	-- graySprite( self.ButtonSkill1:getVirtualRenderer():getSprite() )
	local size_skill1 = self.ButtonSkill1:getContentSize()
	self._skillFirstLoadingBar:setPosition( cc.p( size_skill1.width/2,size_skill1.height/2 ))
	-- 第二技能
	self._skillSecondLoadingBar = self:createSkillLoadingBar("skill/skill2.png")
	self.ButtonSkill2:addChild(self._skillSecondLoadingBar)
	-- graySprite( self.ButtonSkill2:getVirtualRenderer():getSprite() )
	local size_skill2 = self.ButtonSkill2:getContentSize()
	self._skillSecondLoadingBar:setPosition( cc.p( size_skill2.width/2,size_skill2.height/2 ))
	-- 第三技能
	self._skillThirdLoadingBar = self:createSkillLoadingBar("skill/add_hp.png")
	self.ButtonAddHp:addChild(self._skillThirdLoadingBar)
	-- graySprite( self.ButtonAddHp:getVirtualRenderer():getSprite() )
	local size_skill3 = self.ButtonAddHp:getContentSize()
	self._skillThirdLoadingBar:setPosition( cc.p( size_skill3.width/2,size_skill3.height/2 ))
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
function GameSkill:skill1()
	local boss = nil
	for i,v in ipairs(self._peopleList) do
		if v.mode == 2 then
			self:shockWavesEffect(v)
		end
	end
end
function GameSkill:skill2()
	local boss = nil
	for i,v in ipairs(self._peopleList) do
		if v.mode == 2 then
			self:skillFireEffect( v )
		end
	end
end
function GameSkill:skillAddHp()
	local per_addHp = hunSkill_config[3].addHp / 100
	for i,v in ipairs(self._peopleList) do
		local node = cc.Node:create()
		v.Icon:addChild(node)
		local size = v.Icon:getContentSize()
		node:setPosition(size.width/2,size.height/2)
		local imageHp = ccui.ImageView:create("care/ZhiLiao1.png")
		node:addChild(imageHp)
		-- 士兵加血
		local upHp = hunsolider_config[v:getId()].hp * per_addHp
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


		-- local index = 1
		-- schedule{node,function ( ... )
		-- 	imageHp:loadTexture("care/ZhiLiao"..index..".png")
		-- 	if index == 1 then
		-- 		index = 2
		-- 	else
		-- 		index = 1
		-- 	end
		-- end,0.2}
	end
end
function GameSkill:shockWavesEffect( node )
	local imageShockWave = ccui.ImageView:create("skill/direction.png")
	node:addChild(imageShockWave)
	imageShockWave:setAnchorPoint(cc.p(0,0.5))


	-- 发射指向技能
	local pos = 1
	self:sendFireBall(node,pos)
end
function GameSkill:sendFireBall( node )
	-- body
end
function GameSkill:skillFireEffect( node )
	local imageFire = ccui.ImageView:create("fire/1.png")
	node:addChild(imageFire)
	local size = node.Icon:getContentSize()
	-- imageFire:setPosition( size.width / 2,size.height / 2 )
	local fire_size = imageFire:getContentSize()
	imageFire:setScaleX( hunSkill_config[2].width / fire_size.width )
	imageFire:setScaleY( hunSkill_config[2].height / fire_size.height )
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
	-- self:fireHurt(imageFire,hurtedList)
	schedule(imageFire,function ( ... )
		self:fireHurt(imageFire,hurtedList)
	end,0.2)
end
function GameSkill:fireHurt( imageFire,hurtedList )
	dump(hurtedList,"------------hurtedList = ")
	local pos = cc.p(imageFire:getPosition())
	local fire_world_pos = imageFire:getParent():convertToWorldSpace(pos)
	-- local hurtedList = {}
	for i,enemy in ipairs(self._enemyList) do
		local e_pos = cc.p(enemy:getPosition())
		local e_world_pos = enemy:getParent():convertToWorldSpace(e_pos)
		if cc.pGetDistance( e_world_pos,fire_world_pos ) < hunSkill_config[2].dis then
			local enemyIsHurt = false
			for j,hurted_enemy in ipairs(hurtedList) do
				if hurted_enemy == enemy then
					enemyIsHurt = true
					break
				end
			end
			if enemyIsHurt == false then
				table.insert(hurtedList,enemy)
				local hurtNum = hunSkill_config[2].perHurt / 100 * hunsolider_config[enemy:getId()].hp
				enemy:setHpByHurt(hurtNum)
			end
		end
	end
end

function GameSkill:onEnter()
	GameSkill.super.onEnter(self)

	-- -- CD计时器
	-- local index = 0
	-- self:schedule(function ()
	-- 	local percentage = index / ( self._cd / self._scheduleTime )
	-- 	self._circleProgressBar:setPercentage( percentage * 100 )
	-- 	self._circleProgressBarBg:setPercentage( percentage * 100 )
	-- 	if percentage >= 1 then
	-- 		self._status = true
	-- 		-- self:stopAllActions()
	-- 		self:unSchedule()
	-- 		self._circleProgressBar:setVisible( false )
	-- 		ungraySprite( self.Icon:getVirtualRenderer():getSprite() )
	-- 		self._circleProgressBarBg:setVisible( false )
	-- 		ungraySprite( self.Bg:getVirtualRenderer():getSprite() )
	-- 	end
	-- 	index = index + 1
	-- end,self._scheduleTime)
end






















return GameSkill