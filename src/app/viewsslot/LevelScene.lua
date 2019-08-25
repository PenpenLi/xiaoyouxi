
--
-- Author: 	刘阳
-- Date: 	2019-04-22
-- Desc:	关卡场景

local UIManager = import("app.framework.UIManager")

local LevelScene = class("LevelScene",function()
	return display.newScene("LevelScene")
end)


function LevelScene:ctor( levelIndex )
	assert( levelIndex," !! levelIndex is nil !! " )
	-- 开启生命周期
	self:enableNodeEvents()
	-- 加载uimanager
	self._uiManager = UIManager.new( self )
	self._levelIndex = levelIndex
end


function LevelScene:onEnter()
	self._gameLayer = nil
	if self._levelIndex == 1 then
		self._gameLayer = addUIToScene( UIDefine.SLOT_KEY.GameWolf_UI,{self._levelIndex} )
	elseif self._levelIndex == 2 then
		self._gameLayer = addUIToScene( UIDefine.SLOT_KEY.GameCandy_UI,{self._levelIndex} )
	elseif self._levelIndex == 3 then
		self._gameLayer = addUIToScene( UIDefine.SLOT_KEY.GameRedDiamond_UI,{self._levelIndex} )
	end
	
	self._bottomLayer = addUIToScene( UIDefine.SLOT_KEY.Bottom_UI )
	self._topLayer = addUIToScene( UIDefine.SLOT_KEY.Top_UI )
end

function LevelScene:getPlayLayer()
	return self._gameLayer
end

function LevelScene:getBottomLayer()
	return self._bottomLayer
end

function LevelScene:getTopLayer()
	return self._topLayer
end

function LevelScene:getSceneName()
	return "LevelScene"
end

function LevelScene:onExit()
end

function LevelScene:getUIManager()
	return self._uiManager
end

function LevelScene:getLevelIndex()
	return self._levelIndex
end


return LevelScene