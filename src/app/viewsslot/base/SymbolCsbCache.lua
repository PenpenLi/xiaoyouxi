

--
-- Author: 	刘阳
-- Date: 	2019-05-06
-- Desc:	信号块csb的缓存


local SymbolCsbCache = class("SymbolCsbCache")

function SymbolCsbCache:ctor()
	self:reset()
end

function SymbolCsbCache:reset()
	self._symbolCsbList = {}
	self._csbConfig = nil
end

function SymbolCsbCache:getInstance()
	if not self._instance then
		self._instance = SymbolCsbCache.new()
	end
	return self._instance
end







--[[
	针对每个csb 默认初始化5个node
	csbConfig : 要加载的csb路径 
]]

function SymbolCsbCache:initSymbolCsbNode( csbConfig )
	-- 可能没有需要加载的csb
	if not csbConfig or #csbConfig == 0 then
		return
	end

	self._csbConfig = clone( csbConfig )
end


-- num:创建的个数
function SymbolCsbCache:createSymbolCsbNode( symbolId )
	assert( symbolId," !! symbolId is nil !! " )
	
	if self._symbolCsbList[symbolId] == nil then
		self._symbolCsbList[symbolId] = {}
	end

	local symbol_config = self._csbConfig[symbolId]
	assert( symbol_config," !! symbol_config is nil symbolId = "..symbolId.." !!" )

	for i = 1,symbol_config.count do
		local csb_path = symbol_config.file
		assert( csb_path," !! csb_path is nil symbolId = "..symbolId.."!! " )
		local index = #self._symbolCsbList[symbolId] + 1
		if symbol_config.resourcetype == "csb" then
			local symbol_node = cc.CSLoader:createNode(csb_path)
			symbol_node:retain()
			local symbol_action = cc.CSLoader:createTimeline(csb_path)
			symbol_action:retain()
			local owner = {}
			CSBUtil.addOwnerVariable( owner,symbol_node )
			local meta = {
				node = symbol_node,
				action = symbol_action,
				used = false,
				index = index,
				symbolId = symbolId,
				csbVar = owner,
				nodeType = "csb"
			}
			table.insert( self._symbolCsbList[symbolId],meta )
		elseif symbol_config.resourcetype == "spine" then
			local spine_node = util_spineCreateDifferentPath( symbol_config.file, symbol_config.png, true, true)
			spine_node:retain()
			local meta = {
				node = spine_node,
				used = false,
				index = index,
				symbolId = symbolId,
				nodeType = "spine"
			}
			table.insert( self._symbolCsbList[symbolId],meta )
		end
	end
end




-- 从缓存里面获取信号块的csb
function SymbolCsbCache:getCsbNodeBySymbolId( symbolId )
	assert( symbolId," !! symbolId is nil !! " )
	
	-- 创建存储的表
	if self._symbolCsbList[symbolId] == nil then
		self._symbolCsbList[symbolId] = {}
	end

	-- 找出有没有没有被占用的node
	for i,v in ipairs( self._symbolCsbList[symbolId] ) do
		if v.used == false and v.node:getParent() == nil then
			v.used = true
			return v
		end
	end
	-- 全部被占用 则创建新的
	self:createSymbolCsbNode( symbolId )
	local len = #self._symbolCsbList[symbolId]
	local meta = self._symbolCsbList[symbolId][len]
	meta.used = true
	cclog("创建新的信号块 symbolId = "..symbolId)
	return meta
end


-- 重置
function SymbolCsbCache:resetCsbNodeUsed( symbolId,index )
	assert( symbolId," !! symbolId is nil !! " )
	assert( index," !! index is nil !! " )
	self._symbolCsbList[symbolId][index].used = false
	self._symbolCsbList[symbolId][index].node:stopAllActions()
end


function SymbolCsbCache:printInfoSymbolCsbList()
	
end


function SymbolCsbCache:clearCache()
	if self._symbolCsbList then
		for i,v in pairs( self._symbolCsbList ) do
			for a,b in ipairs( v ) do
				if b.node:getParent() then
					b.node:removeFromParent()
				end
				b.node:release()
				b.action:release()
			end
		end
	end
	self:reset()
end


cc.exports.SymbolCsbCache = SymbolCsbCache:getInstance()
