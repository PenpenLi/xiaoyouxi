
--
-- Author: 	刘智勇
-- Date: 	2019-06-29
-- Desc:	战斗场景


-- cc.FileUtils:getInstance():addSearchPath("res/csbzuqiu")


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
	import("app.viewsminigame.viewszuqiu.config.zuqiu_config")
	import("app.viewsminigame.viewszuqiu.config.country_config")
	if zuqiu_card_lang == 1 then
		cc.FileUtils:getInstance():addSearchPath("res/csbminigame/csbrehuodougongniu")
	else
		cc.FileUtils:getInstance():addSearchPath("res/csbminigame/csbzuqiu")
	end
end



function ZuQiuScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.MINIGAME_KEY.ZuQiu_Loading_UI )
end

function ZuQiuScene:getSceneName()
	return "ZuQiuScene"
end

function ZuQiuScene:getUIManager()
	return self._uiManager
end



return ZuQiuScene