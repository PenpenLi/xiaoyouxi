--[[
	Class Name :SymbolUnit
	Info : 游戏中信号块基本单位 主要处理信号块资源加载 动画播放等
]]--

local BaseSymbolUnit = class("BaseSymbolUnit",BaseNode)


function BaseSymbolUnit:ctor( size,reelConfig )
	BaseSymbolUnit.super.ctor( self )
	self._size = size
	self._reelConfig = reelConfig
	self:setContentSize( size )
end


-- 设置信号块资源 --
function BaseSymbolUnit:loadDataUI( symbolId )
	assert( symbolId," !! symbolId,is nil !! ")

	self._symbolId = symbolId
	self:setCsbNode( symbolId )
end


-- 重新设置信号块 --
function BaseSymbolUnit:setCsbNode( symbolId )
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
	
	self:addChild( self._csbNode )
end

function BaseSymbolUnit:playCsbAction( actionName,loop,func )
	playCsbActionForKey( self._symbolData.action,actionName,loop,func )
end


function BaseSymbolUnit:onExit()
	BaseSymbolUnit.super.onExit( self )
	self:backCsbNodeUsed()
end

-- 将使用的node返回给缓存池
function BaseSymbolUnit:backCsbNodeUsed()
	if self._symbolData then
		SymbolCsbCache:resetCsbNodeUsed( self._symbolData.symbolId, self._symbolData.index )
		self._symbolData = nil
	end
end


function BaseSymbolUnit:stopCsbaction()
	self._csbNode:stopAllActions()
end

function BaseSymbolUnit:getUnitSize()
	return self._size
end

function BaseSymbolUnit:getSymbolID()
	return self._symbolId
end


return BaseSymbolUnit