

local LoadPeople = class("LoadPeople",BaseNode)

function LoadPeople:ctor( parent,id )
	self._parent = parent
	self._id = id
	self:addCsb("csbfensuizhan/NodePeople.csb")

	-- TouchNode.extends(self.TouchPanel,function (event)
	-- 	return self:touchCard( event )
	-- end)


	self:loadUi()
end
function LoadPeople:loadUi()
	self.Icon:loadTexture("frame/role"..self._id.."idle/1")
end

function LoadPeople:onEnter()
	LoadPeople.super.onEnter( self )
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

function LoadPeople:touchCard( event )
	if event.name == "began" then
		self._startPos = cc.p( event.x,event.y )
		print("11111111")
		self:touchBegan()
		return true
	elseif event.name == "moved" then
		print("2222222222")
		self:touchMove()
	elseif event.name == "ended" then
		self:touchEnd()
	elseif event.name == "outsideend" then
		self:touchCancel()
	end
end
function LoadPeople:touchBegan( ... )
	self:setVisible(false)
	local args = {
		id = self._id,
		pos = self._startPos,
	}
	-- 点击开始消息
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_FENSUI_LOADPEOPLE_TOUCHBEGAN,args )
end
function LoadPeople:touchMove( ... )
	-- body
end
function LoadPeople:touchEnd( ... )
	-- body
end
function LoadPeople:touchCancel( ... )
	-- body
end




return LoadPeople