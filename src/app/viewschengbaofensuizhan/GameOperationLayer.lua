
local LoadSoldierNode = import(".LoadSoldierNode")
local GameOperationLayer = class( "GameOperationLayer",BaseLayer )


function GameOperationLayer:ctor( param )
	
	GameOperationLayer.super.ctor( self,param.name )
	self._config = chengbao_config.soldier
	self._size = chengbao_config.size
	self:addCsb("csbchengbaofensuizhan/GameOperationLayer.csb")
	self:loadUi()
end

function GameOperationLayer:loadUi()
	for i = 1,4 do
		-- local random_soldierId = self:randomSoldier()
		-- self._loadSoldierNode = LoadSoldierNode.new( self,random_soldierId )
		-- self.Node:addChild( self._loadSoldierNode )
		-- local pos = cc.p( self._size.width / 2 * ( i - 2.5 ),self._size.height / 2 )
		self:createLoadSoldier( i )
		-- self._loadSoldierNode:setPosition( self._size.width / 2 * ( i - 2.5 ),self._size.height / 2 )
	end
	self:resetPosition()
end
function GameOperationLayer:createLoadSoldier()
	-- local pos = cc.p( self._size.width / 2 * ( i - 2.5 ),self._size.height / 2 )
	local random_soldierId = self:randomSoldier()
	self._loadSoldierNode = LoadSoldierNode.new( self,random_soldierId )
	self.Node:addChild( self._loadSoldierNode )
	-- self._loadSoldierNode:setPosition( pos )
end

function GameOperationLayer:randomSoldier( ... )
	local id = random( 1,#self._config )
	return id
end

function GameOperationLayer:onEnter()
	GameOperationLayer.super.onEnter( self )

	-- 添加监听
	self:addMsgListener( InnerProtocol.INNER_EVENT_CHENGBAOFENSUI_LOADSOLDIER,function( event )
		--做延迟，等移动的士兵删除再执行
		performWithDelay(self,function ()
			local childs = self.Node:getChildren()
			for i,v in ipairs(childs) do
				v:reset()
			end
			self:createLoadSoldier()
			self:resetPosition()
		end,0.05)
	end )
end

-- 士兵头像列表对齐
function GameOperationLayer:resetPosition( ... )
	local childs = self.Node:getChildren()
	for i,v in ipairs(childs) do
		local pos = cc.p( self._size.width / 2 * ( i - 2.5 ),self._size.height / 2 )
		local move_to = cc.MoveTo:create( 0.2,pos )
		v:runAction( move_to )
		-- v:setPosition( cc.p( self._size.width / 2 * ( i - 2.5 ),self._size.height / 2 ) )
	end
	
end






return GameOperationLayer