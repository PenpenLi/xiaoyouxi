

local ChooseNode = class("ChooseNode",BaseNode)

function ChooseNode:ctor( id,level,parentLayer )
	assert(level," !! level must be not nil !! " )
	ChooseNode.super.ctor( self )

	self._id = id
	self._level = level
	self._parentLayer = parentLayer

	self:addCsb("csbfensuizhan/NodeLevel.csb")

	self:loadUi()
	self:addNodeClick(self.LevelBg,{ 
   		endCallBack = function()
   		 self:play() 
   		end})
end

function ChooseNode:loadUi(  )
	if self._id < self._level then
		self.LevelBg:loadTexture("choose/box_Pass.png")
		self.Text:setString(self._id)
		self.Text:setVisible(false)
		self.Learning:setVisible(true)
		self.Lock:setVisible(false)
		return
	end
	if self._id == self._level then
		self.LevelBg:loadTexture("choose/box_unlock.png")
		self.Text:setString(self._id)
		self.Text:setVisible(true)
		self.Learning:setVisible(false)
		self.Lock:setVisible(false)
		return
	end
	if self._id > self._level then
		self.LevelBg:loadTexture("choose/box_locked.png")
		self.Text:setString(self._id)
		self.Text:setVisible(false)
		self.Learning:setVisible(false)
		self.Lock:setVisible(true)
		return
	end
end

function ChooseNode:onEnter( ... )
	ChooseNode.super.onEnter(self)
end


function ChooseNode:play()
	if self._id > self._level then
		return
	end
	removeUIFromScene( UIDefine.FENSUIZHAN_KEY.Choose_UI )
	addUIToScene( UIDefine.FENSUIZHAN_KEY.Fight_UI )
	addUIToScene( UIDefine.FENSUIZHAN_KEY.Operation_UI )
end







return ChooseNode