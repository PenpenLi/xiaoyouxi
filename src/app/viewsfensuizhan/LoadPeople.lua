

local LoadPeople = class("LoadPeople",BaseNode)

function LoadPeople:ctor( parent,id )
	LoadPeople.super.ctor( self )
	self._parent = parent
	self._id = id
	self._config = solider_config[self._id]
	self._status = false -- CD是否完成状态
	self._scheduleTime = 0.02 
	self:addCsb("csbfensuizhan/NodePeople.csb")

	-- TouchNode.extends(self.TouchPanel,function (event)
	-- 	return self:touchCard( event )
	-- end)


	self:loadUi()
end
function LoadPeople:loadUi()
	self.Icon:loadTexture("frame/role"..self._id.."/idle/1.png",1)
	-- 添加背景圆形进度
	self._circleProgressBarBg = self:createCircleLoadingBarBg()
	self.Bg:addChild( self._circleProgressBarBg )
	graySprite( self.Bg:getVirtualRenderer():getSprite() )
	local size_bg = self.Bg:getContentSize()
	self._circleProgressBarBg:setPosition( cc.p( size_bg.width/2,size_bg.height/2 ))
	-- 添加圆形进度
	self._circleProgressBar = self:createCircleLoadingBar()
	self.Icon:addChild( self._circleProgressBar )
	graySprite( self.Icon:getVirtualRenderer():getSprite() )
	local size = self.Icon:getContentSize()
	self._circleProgressBar:setPosition( cc.p( size.width/2,size.height/2 ))
	
end
function LoadPeople:createCircleLoadingBar()
	local soldier = ccui.ImageView:create("frame/role"..self._id.."/idle/1.png",1)
	-- 创建进度条
	local circleProgressBar = cc.ProgressTimer:create( soldier:getVirtualRenderer():getSprite() )
	-- 设置类型，圆形
	circleProgressBar:setType( cc.PROGRESS_TIMER_TYPE_RADIAL )
	-- 设置进度
	circleProgressBar:setPercentage( 0 )
	-- circleProgressBar:setVisible(true)
	return circleProgressBar
end
function LoadPeople:createCircleLoadingBarBg()
	local bg = ccui.ImageView:create("image/coinbg.png")
	-- 创建进度条
	local circleProgressBarBg = cc.ProgressTimer:create( bg:getVirtualRenderer():getSprite() )
	-- 设置类型，圆形
	circleProgressBarBg:setType( cc.PROGRESS_TIMER_TYPE_RADIAL )
	-- 设置进度
	circleProgressBarBg:setPercentage( 0 )
	-- circleProgressBar:setVisible(true)
	return circleProgressBarBg
end

function LoadPeople:onEnter()
	LoadPeople.super.onEnter( self )

	-- CD计时器
	local index = 0
	self:schedule(function ()
		local percentage = index / ( self._config.cd / self._scheduleTime )
		self._circleProgressBar:setPercentage( percentage * 100 )
		self._circleProgressBarBg:setPercentage( percentage * 100 )
		if percentage >= 1 then
			self._status = true
			-- self:stopAllActions()
			self:unSchedule()
			self._circleProgressBar:setVisible( false )
			ungraySprite( self.Icon:getVirtualRenderer():getSprite() )
			self._circleProgressBarBg:setVisible( false )
			ungraySprite( self.Bg:getVirtualRenderer():getSprite() )
		end
		index = index + 1
	end,self._scheduleTime)
end

function LoadPeople:getBgSize()
	local size = self.TouchPanel:getContentSize()
	return size
end
function LoadPeople:getId()
	return self._id
end
-- 返回世界坐标的boundingbox
function LoadPeople:getBox()
	local bound_box = self.TouchPanel:getBoundingBox()
	-- local size = self.TouchPanel:getContentSize()
	local world_pos = self.TouchPanel:getParent():convertToWorldSpace( cc.p(bound_box.x,bound_box.y))
	bound_box.x = world_pos.x
	bound_box.y = world_pos.y
	return bound_box
end

-- function LoadPeople:touchCard( event )
-- 	if event.name == "began" then
-- 		self._startPos = cc.p( event.x,event.y )
-- 		print("11111111")
-- 		self:touchBegan()
-- 		return true
-- 	elseif event.name == "moved" then
-- 		print("2222222222")
-- 		self:touchMove()
-- 	elseif event.name == "ended" then
-- 		self:touchEnd()
-- 	elseif event.name == "outsideend" then
-- 		self:touchCancel()
-- 	end
-- end
-- function LoadPeople:touchBegan( ... )
-- 	self:setVisible(false)
-- 	local args = {
-- 		id = self._id,
-- 		pos = self._startPos,
-- 	}
-- 	-- 点击开始消息
-- 	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHBEGAN,args )
-- end
-- function LoadPeople:touchMove( ... )
-- 	-- body
-- end
-- function LoadPeople:touchEnd( ... )
-- 	-- body
-- end
-- function LoadPeople:touchCancel( ... )
-- 	-- body
-- end




return LoadPeople