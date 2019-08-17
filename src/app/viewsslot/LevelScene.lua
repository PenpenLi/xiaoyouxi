
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
	self._gameLayer = addUIToScene( UIDefine.SLOT_KEY.Play_UI,{self._levelIndex} )
	self._bottomLayer = addUIToScene( UIDefine.SLOT_KEY.Bottom_UI )
end


function LevelScene:getSceneName()
	return "LevelScene"
end

function LevelScene:onExit()
end

function LevelScene:getUIManager()
	return self._uiManager
end


return LevelScene