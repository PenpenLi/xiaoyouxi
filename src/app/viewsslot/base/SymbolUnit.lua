--[[
	Class Name :SymbolUnit
	Info : 游戏中信号块基本单位 主要处理信号块资源加载 动画播放等
]]--

local SymbolUnit = class("SymbolUnit",BaseNode)


function SymbolUnit:ctor()
	SymbolUnit.super.ctor( self )
end


-- 设置信号块资源 --
--[[
	symbolInfo:信号块的数据 
		例如:{ 1,1 } { 13,1 }, {13,2} ,{13,3}
		说明: 第一个参数是 信号块id 第二个参数 大图标的资源索引
	isShow:是否绘制
]]
function SymbolUnit:loadDataUI( symbolId )
	assert( symbolId," !! symbolId,is nil !! ")

	self._symbolId = symbolId

	if isShow then
		self:setCsbNode( self._nSymbolID )
	end
end


-- 重新设置信号块 --
function SymbolUnit:setCsbNode( nSymbolID )
	self._csbNode = self:getChildByTag( 1115 )
	if self._csbNode then
		self._csbNode:removeFromParent()
		self._csbNode = nil
	end
	self:backCsbNodeUsed()

	-- 从缓存获取csb节点
	local symbol_data = SymbolCsbCache:getCsbNodeBySymbolId( nSymbolID )
	self._symbolData = symbol_data
	self._csbNode = symbol_data.node
	self._csbNode:setTag( 1115 )

	-- 切换到静止帧
	self:playCsbActionByName("idleframe")
	
	self:addChild( self._csbNode )
end



function SymbolUnit:onExit()
	self:backCsbNodeUsed()
end

-- 将使用的node返回给缓存池
function SymbolUnit:backCsbNodeUsed()
	if self._symbolData then
		SymbolCsbCache:resetCsbNodeUsed( self._symbolData.symbolId, self._symbolData.index )
		self._symbolData = nil
	end
end


function SymbolUnit:getUnitSize()
	return self._size
end

function SymbolUnit:getSymbolID()
	return self._symbolId
end



return SymbolUnit