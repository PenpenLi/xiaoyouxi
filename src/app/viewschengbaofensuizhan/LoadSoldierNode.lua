
local LoadSoldierNode = class( "LoadSoldierNode",BaseNode )


function LoadSoldierNode:ctor( parent,personId )
	LoadSoldierNode.super.ctor( self )
	self._personId = personId
	self._parent = parent

	self._scheduleTime = 0.02
	self._config = chengbao_config.soldier[self._personId]

	--self._soldier = ccui.ImageView:create( "image/people/player_0001/01.png",1 )
	self._soldier = ccui.ImageView:create( self._config.path.."01.png",1 )
	self:addChild( self._soldier )
	self._soldier:setPositionY( 150 )
	self:gotoLoad()
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
		self._circleProgressBar:removeFromParent()
		self._circleProgressBar = nil
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

-- 进度
function LoadSoldierNode:update()
	self._index = self._index + 1
	local percentage = self._index / ( self._config.cd / self._scheduleTime )
	self._circleProgressBar:setPercentage( self._index )
	if self._index >= 100 then
		self:unSchedule()
		self:gotoLoadOver()
		print("--------------------cd就绪")
		-- 添加点击

	end
end

function LoadSoldierNode:onEnter()
	LoadSoldierNode.super.onEnter( self )

	self._index = 0
	self:schedule(function ()
		self:update()
	end,self._scheduleTime)
end







return LoadSoldierNode