
--
-- Author: 	刘阳
-- Date: 	2019-04-22
-- Desc:	大厅场景

local UIManager = import("app.framework.UIManager")

local HallScene = class("HallScene",function()
	return display.newScene("HallScene")
end)


function HallScene:ctor()
	-- 开启生命周期
	self:enableNodeEvents()
	-- 加载uimanager
	self._uiManager = UIManager.new( self )
end


function HallScene:onEnter()
	addUIToScene( UIDefine.SLOT_KEY.Start_UI )
end


function HallScene:getSceneName()
	return "HallScene"
end

function HallScene:onExit()
end

function HallScene:getUIManager()
	return self._uiManager
end


return HallScene