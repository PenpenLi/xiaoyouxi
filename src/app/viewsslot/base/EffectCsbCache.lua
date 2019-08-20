
--
-- Author: 	刘阳
-- Date: 	2019-05-06
-- Desc:	信号块csb的缓存


local EffectCsbCache = class("EffectCsbCache")




function EffectCsbCache:ctor()
	self:reset()
end

function EffectCsbCache:reset()
	self._effectCsbList = {}
	self._csbConfig = nil
end

function EffectCsbCache:getInstance()
	if not self._instance then
		self._instance = EffectCsbCache.new()
	end
	return self._instance
end

--[[
	针对每个csb 默认初始化5个node
	csbConfig : 要加载的csb路径 
]]

function EffectCsbCache:initEffectCsbNode( csbConfig )
	-- 可能没有需要加载的csb
	if not csbConfig or table.nums(csbConfig) == 0 then
		return
	end
	self._csbConfig = clone( csbConfig )
end


-- num:创建的个数
function EffectCsbCache:createEffectCsbNode( effectName )
	assert( effectName," !! effectName is nil !! " )

	if self._effectCsbList[effectName] == nil then
		self._effectCsbList[effectName] = {}
	end

	local effect_config = self._csbConfig[effectName]

	for i = 1,effect_config.count do
		if effect_config.resourcetype == "csb" then
			local csb_path = effect_config.file
			assert( csb_path," !! csb_path is nil effectName = "..effectName.."!! " )
			local effect_node = cc.CSLoader:createNode(csb_path)
			effect_node:retain()
			local effect_action = cc.CSLoader:createTimeline(csb_path)
			effect_action:retain()

			local owner = {}
			CSBUtil.addOwnerVariable( owner,effect_node )

			local index = #self._effectCsbList[effectName] + 1
			local meta = {
				node = effect_node,
				action = effect_action,
				used = false,
				index = index,
				effectName = effectName,
				csbVar = owner
			}
			table.insert( self._effectCsbList[effectName],meta )
		end
	end
end


-- 从缓存里面获取信号块的csb
function EffectCsbCache:getCsbNodeByEffectName( effectName )
	assert( effectName," !! effectName is nil !! " )
	
	-- 创建存储的表
	if self._effectCsbList[effectName] == nil then
		self._effectCsbList[effectName] = {}
	end

	-- 找出有没有没有被占用的node
	for i,v in ipairs( self._effectCsbList[effectName] ) do
		if v.used == false and v.node:getParent() == nil then
			v.used = true
			return v
		end
	end
	-- 全部被占用 则创建新的
	self:createEffectCsbNode( effectName )
	local len = #self._effectCsbList[effectName]
	local meta = self._effectCsbList[effectName][len]
	meta.used = true
	print("创建新的特效 effectName = "..effectName)
	return meta
end


-- 重置
function EffectCsbCache:resetCsbNodeUsed( effectName,index )
	assert( effectName," !! effectName is nil !! " )
	assert( index," !! index is nil !! " )
	self._effectCsbList[effectName][index].used = false
	self._effectCsbList[effectName][index].node:stopAllActions()
end


function EffectCsbCache:printInfoEffectCsbList()
	
end


function EffectCsbCache:clearCache()
	if self._effectCsbList then
		for i,v in pairs( self._effectCsbList ) do
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


cc.exports.EffectCsbCache = EffectCsbCache:getInstance()


