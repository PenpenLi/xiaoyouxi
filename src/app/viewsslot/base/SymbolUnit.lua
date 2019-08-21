--[[
	Class Name :SymbolUnit
	Info : 游戏中信号块基本单位 主要处理信号块资源加载 动画播放等
]]--

local SymbolUnit = class("SymbolUnit",BaseNode)


function SymbolUnit:ctor( size,reelConfig )
	SymbolUnit.super.ctor( self )
	self._size = size
	self._reelConfig = reelConfig
	self:setContentSize( size )
end


-- 设置信号块资源 --
function SymbolUnit:loadDataUI( symbolId )
	assert( symbolId," !! symbolId,is nil !! ")

	self._symbolId = symbolId
	self:setCsbNode( symbolId )

	-- 针对特殊新号块
	if self._symbolId == self._reelConfig.special_id then
		local num = random(1,9) * 100
		self._csbVar["score_lab"]:setString( num )
		self._coinNum = num
	end
end


-- 重新设置信号块 --
function SymbolUnit:setCsbNode( symbolId )
	self._csbNode = self:getChildByTag( 1115 )
	if self._csbNode then
		self._csbNode:removeFromParent()
		self._csbNode = nil
	end
	self:backCsbNodeUsed()

	-- 从缓存获取csb节点
	local symbol_data = SymbolCsbCache:getCsbNodeBySymbolId( symbolId )
	self._symbolData = symbol_data
	self._csbNode = symbol_data.node
	self._csbNode:setTag( 1115 )
	self._csbNode:setPosition( cc.p( self._size.width / 2,self._size.height / 2 ) )
	self._csbNode:runAction( self._symbolData.action )
	self._csbVar = symbol_data.csbVar

	-- 切换到静止帧
	self:playCsbAction("idleframe")
	
	self:addChild( self._csbNode )
end

function SymbolUnit:playCsbAction( actionName,loop,func )
	playCsbActionForKey( self._symbolData.action,actionName,loop,func )
end


function SymbolUnit:onExit()
	SymbolUnit.super.onExit( self )
	self:backCsbNodeUsed()
end

-- 将使用的node返回给缓存池
function SymbolUnit:backCsbNodeUsed()
	if self._symbolData then
		SymbolCsbCache:resetCsbNodeUsed( self._symbolData.symbolId, self._symbolData.index )
		self._symbolData = nil
	end
end


function SymbolUnit:stopCsbaction()
	self._csbNode:stopAllActions()
end

function SymbolUnit:getUnitSize()
	return self._size
end

function SymbolUnit:getSymbolID()
	return self._symbolId
end

function SymbolUnit:getCoinNum()
	return self._coinNum
end


return SymbolUnit