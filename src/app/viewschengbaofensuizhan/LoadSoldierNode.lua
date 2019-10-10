
local LoadSoldierNode = class( "LoadSoldierNode",BaseNode )
local Soldier = import(".Soldier")

function LoadSoldierNode:ctor( parent,personId )
	LoadSoldierNode.super.ctor( self )
	self._personId = personId
	self._parent = parent

	self._scheduleTime = 0.02
	self._config = chengbao_config.soldier[self._personId]

	--self._soldier = ccui.ImageView:create( "image/people/player_0001/01.png",1 )
	self._soldier = ccui.ImageView:create( self._config.path.."01.png",1 )
	self:addChild( self._soldier )
	--self._soldier:setPositionY( 150 )
	self:gotoLoad()
	-- self._startPosToCreate = self:getParent():convertToWorldSpace( cc.p( self:getPosition())) 
end

function LoadSoldierNode:gotoLoad()
	self._circleProgressBar = self:createCircleLoadingBar()
	self._soldier:addChild( self._circleProgressBar )
	graySprite( self._soldier:getVirtualRenderer():getSprite() )
	local size = self._soldier:getContentSize()
	self._circleProgressBar:setPosition( cc.p(size.width / 2,size.height / 2) )
end
function LoadSoldierNode:gotoLoadOver()
	if self._circleProgressBar then
		--self._circleProgressBar:removeFromParent()
		self._circleProgressBar:setVisible( false )
		--self._circleProgressBar = nil
	end
	ungraySprite( self._soldier:getVirtualRenderer():getSprite() )
end



-- 创建圆形进度条
function LoadSoldierNode:createCircleLoadingBar()
	local soldier = ccui.ImageView:create( self._config.path.."01.png",1 )
	-- local sprite = cc.Sprite:create( "#"..self._config.path.."01.png" )
	-- 创建进度条
	local circleProgressBar = cc.ProgressTimer:create( soldier:getVirtualRenderer():getSprite() )
	-- 设置类型，圆形
	circleProgressBar:setType( cc.PROGRESS_TIMER_TYPE_RADIAL )
	-- 设置进度
	circleProgressBar:setPercentage( 0 )
	return circleProgressBar
end
function LoadSoldierNode:reset()
	self:unSchedule()
	if self._soldier.listener then
		self:removeSoldierClick()
	end
	self:openSchedule()
	graySprite( self._soldier:getVirtualRenderer():getSprite() )
	self._circleProgressBar:setVisible( true )
	self._circleProgressBar:setPercentage( 0 )
	
end


-- 进度
function LoadSoldierNode:update()
	self._index = self._index + 1
	local percentage = self._index / ( self._config.cd / self._scheduleTime )
	self._circleProgressBar:setPercentage( percentage * 100 )
	if percentage >= 1 then
		self:unSchedule()
		self:gotoLoadOver()
		-- 添加点击
		self:addSoldierClick()
	end
end

function LoadSoldierNode:onEnter()
	LoadSoldierNode.super.onEnter( self )

	self:openSchedule()
	-- self._index = 0
	-- self:schedule(function ()
	-- 	self:update()
	-- end,self._scheduleTime)
end
function LoadSoldierNode:openSchedule( ... )
	self._index = 0
	self:schedule(function ()
		self:update()
	end,self._scheduleTime)
end


function LoadSoldierNode:addSoldierClick()
	assert( self._soldier.listener == nil," !! listener is exist !! " )
	TouchNode.extends( self._soldier, function(event)
		return self:touchCard( event ) 
	end )
	self._soldier.listener:setSwallowTouches(true)
end

function LoadSoldierNode:removeSoldierClick()
	TouchNode.removeListener( self._soldier )
end

function LoadSoldierNode:touchCard( event )
	if event.name == "began" then
		self._startPos = cc.p(event.x,event.y)
		
		return true
	elseif event.name == "moved" then
		local now_pos = cc.p(event.x,event.y)
		local dis_x = now_pos.x - self._startPos.x
		local dis_y = now_pos.y - self._startPos.y
		local my_pos = cc.p(self:getPosition())
		self:setPositionX( my_pos.x + dis_x )
		self:setPositionY( my_pos.y + dis_y )
		self._startPos = cc.p(event.x,event.y)
	elseif event.name == "ended" then

		self:createSoldier()
		self:removeSoldier()
	end
end


function LoadSoldierNode:createSoldier( ... )
	local args = {
		id = self._personId,
		pos = self._startPos,
		-- startPos = self._startPosToCreate,
		-- child = self
	}
	-- 通知游戏界面创建新的士兵
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_CHENGBAOFENSUI_CREATESOLDIER,args )
	-- 通知控制界面创建新的士兵LOG
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_CHENGBAOFENSUI_LOADSOLDIER,args )
end

function LoadSoldierNode:removeSoldier()
	self:removeFromParent()
end


return LoadSoldierNode