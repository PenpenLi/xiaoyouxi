

local GameLoading = class( "GameLoading",BaseLayer )


function GameLoading:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameLoading.super.ctor( self,param.name )

	self._sceneType = param.data[1]
	self._levelIndex = param.data[2]

	self:addCsb( "csbslot/hall/Loading.csb" )
end


function GameLoading:onEnter()
	GameLoading.super.onEnter( self )

	-- 卸载预加载的csb缓存池
	SymbolCsbCache:clearCache()
	EffectCsbCache:clearCache()
	-- 释放上一个场景的资源 内存
	cc.Director:getInstance():purgeCachedData()

	-- 初始化 加载 下一场景资源
	self:loadUIData()
	self:loadPlist()
	self:loadUIPercent()
end


function GameLoading:loadUIData()
	self._config = self:getLoadResConfig()
	self._curIndex = 0
	self._totalIndex = 0

	-- 是否有plist需要加载
	if self._config.plist then
		self._totalIndex = self._totalIndex + #self._config.plist
	end

	-- 是否有音乐需要加载
	if self._config.mp3 and self._config.mp3.music then
		self._totalIndex = self._totalIndex + #self._config.mp3.music
	end

	-- 是否有音效需要加载
	if self._config.mp3 and self._config.mp3.effect then
		self._totalIndex = self._totalIndex + #self._config.mp3.effect
	end

	-- 是否有普通图片需要加载
	if self._config.image then
		self._totalIndex = self._totalIndex + #self._config.image
	end

	-- 是否有csb需要加载
	if self._config.symbol_csb then
		self._totalIndex = self._totalIndex + table.nums( self._config.symbol_csb )
	end
	if self._config.effect_csb then
		self._totalIndex = self._totalIndex + table.nums( self._config.effect_csb )
	end

	self.LoadingBar:setPercent(0)
end

-- 加载Plist
function GameLoading:loadPlist()
	if not self._config.plist or #self._config.plist == 0 then
		self:loadMusic()
		return
	end

	local index = 1
	self:schedule( function()
		cc.SpriteFrameCache:getInstance():addSpriteFrames( self._config.plist[index][2] )
		self._curIndex = self._curIndex + 1
		index = index + 1
		if index > #self._config.plist then
			self:unSchedule()
			self:loadMusic()
		end
	end,0.02 )
end

-- 加载音乐
function GameLoading:loadMusic()
	if not self._config.mp3 or not self._config.mp3.music or #self._config.mp3.music == 0 then
		self:loadEffect()
		return
	end

	local index = 1
	self:schedule( function()
		audio.preloadMusic( self._config.mp3.music[index] )
		self._curIndex = self._curIndex + 1
		index = index + 1
		if index > #self._config.mp3.music then
			self:unSchedule()
			self:loadEffect()
		end
	end,0.02 )
end

-- 加载音效 
function GameLoading:loadEffect()
	if not self._config.mp3 or not self._config.mp3.effect or #self._config.mp3.effect == 0 then
		self:loadImage()
		return
	end

	local index = 1
	self:schedule( function()
		audio.preloadMusic( self._config.mp3.effect[index] )
		self._curIndex = self._curIndex + 1
		index = index + 1
		if index > #self._config.mp3.effect then
			self:unSchedule()
			self:loadImage()
		end
	end,0.02 )
end


-- 加载普通图片
function GameLoading:loadImage()
	if not self._config.image or #self._config.image == 0 then
		self:loadSymbolCsbCache()
		return
	end

	local index = 1
	self:schedule( function()
		cc.Director:getInstance():getTextureCache():addImage( self._config.image[index] )
		self._curIndex = self._curIndex + 1
		index = index + 1
		if index > #self._config.image then
			self:unSchedule()
			self:loadSymbolCsbCache()
		end
	end,0.02 )
end


-- 针对关卡 加载信号块缓存
function GameLoading:loadSymbolCsbCache()
	if not self._config.symbol_csb or table.nums(self._config.symbol_csb) == 0 then
		self:loadEffectCsbCache()
		return
	end

	SymbolCsbCache:initSymbolCsbNode( self._config.symbol_csb )
	local cc = {}
	for k,v in pairs( self._config.symbol_csb ) do
		local meta = { symbol_id = k }
		table.insert( cc,meta )
	end

	local index = 1
	self:schedule( function()
		SymbolCsbCache:createSymbolCsbNode( cc[index].symbol_id )
		self._curIndex = self._curIndex + 1
		index = index + 1
		if index > #cc then
			self:unSchedule()
			self:loadEffectCsbCache()
		end
	end,0.02 )
end



-- 针对关卡 加载特效的csb缓存
function GameLoading:loadEffectCsbCache()
	if not self._config.effect_csb or table.nums(self._config.effect_csb) == 0 then
		self:goToOtherScene()
		return
	end

	EffectCsbCache:initEffectCsbNode( self._config.effect_csb )
	local cc = {}
	for k,v in pairs( self._config.effect_csb ) do
		local meta = { effect_name = k }
		table.insert( cc,meta )
	end

	local index = 1
	self:schedule( function()
		EffectCsbCache:createEffectCsbNode( cc[index].effect_name )
		self._curIndex = self._curIndex + 1
		index = index + 1
		if index > #cc then
			self:unSchedule()
			self:goToOtherScene()
		end
	end,0.02 )
end


-- 切换scene --
function GameLoading:goToOtherScene()
	local scene_type = self._sceneType 
	local cur_index = self._curIndex
	local total_index = self._totalIndex
	
	if cur_index >= total_index then
		removeUIFromScene( UIDefine.SLOT_KEY.Loading_UI )
		if scene_type == SceneManager.SCENE_TYPE.HALL then
			-- 进入大厅 --
			local scene = require("app.viewsslot.HallScene").new()
			display.runScene(scene)
		elseif scene_type == SceneManager.SCENE_TYPE.LEVEL then
			-- 进入关卡
			local scene = require("app.viewsslot.LevelScene").new( self._levelIndex )
			display.runScene(scene)
		end
	end
end

function GameLoading:loadUIPercent()
	schedule( self.LoadingBar,function()
		local percent = math.ceil( self._curIndex / self._totalIndex * 100 )
		self.LoadingBar:setPercent( percent )
	end,0.05 )
end

-- 根据场景类型获得该场景需要预加载的资源 音效...的配置
function GameLoading:getLoadResConfig()
	local config = nil
	if self._sceneType == SceneManager.SCENE_TYPE.HALL then
		-- 大厅
		config = import( "app.viewsslot.config.HallResConfig" )
	elseif self._sceneType == SceneManager.SCENE_TYPE.LEVEL then
		config = import( "app.viewsslot.config.gameconfig"..self._levelIndex )
	end
	assert( config," !! SceneManager res config is nil !! " )
	return config
end


return GameLoading