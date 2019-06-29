
--
-- Author: 	刘智勇
-- Date: 	2019-06-29
-- Desc:	战斗场景


cc.FileUtils:getInstance():addSearchPath("res/csbzuqiu")


local UIManager = import("app.framework.UIManager")

local ZuQiuScene = class("ZuQiuScene",function()
	return display.newScene("ZuQiuScene")
end)


function ZuQiuScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end



function ZuQiuScene:loadAppFile()
	-- import("app.viewszhandou.config.zhandou_config")
end



function ZuQiuScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.ZUQIU_KEY.Loading_UI )
end

function ZuQiuScene:getSceneName()
	return "ZhanDouScene"
end

function ZuQiuScene:getUIManager()
	return self._uiManager
end



return ZuQiuScene