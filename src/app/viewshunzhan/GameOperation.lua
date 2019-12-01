
local LoadPeople = import(".LoadPeople")
local GameOperation = class("GameOperation",BaseLayer)

function GameOperation:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    self:addCsb("csbfensuizhan/OperationLayer.csb")
    self._people = nil -- 临时存储点击人物时候创建的新人物
    self._choosePeople = nil -- 点击选中的人物
    self._sumLoadPeople = 5 -- 控制界面创建出的人物个数
    self:registTouchEvent()--注册触摸
    self:loadUi()
end
-- 加载UI,初始化6个士兵,显示5个，第六个画面外
function GameOperation:loadUi()
	for i=1,self._sumLoadPeople do
		self:createSolider()
	end
end
--创建一个士兵
function GameOperation:createSolider()
	local peopleId = self:randomId()
	local solider = LoadPeople.new( self,peopleId )
	self.Panel_2:addChild( solider )
	self:setSoliderPosition(solider)
end
--设置士兵的位置
function GameOperation:setSoliderPosition( solider )
	local cur_num = #self.Panel_2:getChildren()
	local p_size = self.Panel_2:getContentSize()
	local size = solider:getBgSize()
	solider:setPosition( (size.width + (p_size.width - size.width*self._sumLoadPeople)/(self._sumLoadPeople + 1)) * cur_num - size.width / 2,p_size.height / 2 + 2 )
end

--随机一个士兵id
function GameOperation:randomId()
	return 1
end

function GameOperation:onEnter()
	GameOperation.super.onEnter( self )
end

function GameOperation:onTouchBegan( touch, event )
	-- 发送触摸began消息
	-- 点击开始消息
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHBEGAN )

	local location = cc.p(touch:getLocation())
	self._startPos = location
	local result = self:findLoadPeople( location )
	if result == false then
		return false
	end
    return true
end
function GameOperation:onTouchMoved( touch, event )
    local location = cc.p(touch:getLocation())
    self._people:setPosition( location )
end
function GameOperation:onTouchEnded( touch, event )
	local location = cc.p(touch:getLocation())
	self._people:removeFromParent()
	-- local result_bool = self:resultOfEnd(location)
	local result_bool = true
	-- 在可放置区域才发送消息，触摸结果需要创建士兵
	if result_bool then
		local args = {
			id = self._choosePeople:getId(),
			pos = location,
		}
		-- 点击end消息,放置成功
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHEND_TRUE,args )
		-- 重置控制界面的人物选框
		self:resetUi()
	else
		self._choosePeople:setVisible(true)
		self._choosePeople = nil -- 指针还原为空
		-- 点击end消息，放置失败
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHEND_FALSE )
	end
	
end
function GameOperation:onTouchCancelled( touch, event )
    
end
-- 判断是否点击到可选择的人物
function GameOperation:findLoadPeople( pos )
	local childs = self.Panel_2:getChildren()
	for i,v in ipairs(childs) do
		local v_box = v:getBox()
		if cc.rectContainsPoint(v_box, pos) then
			self:logicBegan(v)
			self._choosePeople = v
			return
		end
	end
	return false
end
-- 触摸began时需要实现的内容
function GameOperation:logicBegan(node)
	node:setVisible(false)
	local world_pos = node:getParent():convertToWorldSpace( cc.p(node:getPosition()))
	local c_id = node:getId()
	local people = ccui.ImageView:create("frame/role"..c_id.."/idle/1.png",1)
	self:addChild( people )
	people:setPosition( world_pos )
	self._people = people
end
-- 触摸end时，判断是否放入可放区域
function GameOperation:resultOfEnd( pos )
	local seat_boundingBox = self.LeftPanel:getBoundingBox()
	if cc.rectContainsPoint(seat_boundingBox, pos) then
		return true
	end
	return false
end
-- 放置成功后重置选择人物框
function GameOperation:resetUi()
	self:createSolider()
	local size = self._choosePeople:getBgSize() -- 人物背景大小，用于确定移动距离
	local p_size = self.Panel_2:getContentSize()
	local pos = cc.p(self._choosePeople:getPosition())
	local childs = self.Panel_2:getChildren()
	for i,v in ipairs(childs) do
		local v_pos = cc.p(v:getPosition())
		if v_pos.x > pos.x then -- 在被选择被创建的到战斗层的人物右边的所有人物向左移动
			local move_by = cc.MoveBy:create( 0.5,cc.p( - size.width - (p_size.width - size.width*self._sumLoadPeople)/(self._sumLoadPeople + 1),0))
			v:runAction(move_by)
		end
	end

	self._choosePeople:removeFromParent() -- 删除已在战斗界面创建的人物
	self._choosePeople = nil -- 指针重置为空
end




return GameOperation