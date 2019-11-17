
--
-- Author: 	刘阳
-- Date: 	2019-04-27
-- Desc:	成语接龙场景


-- cc.FileUtils:getInstance():addSearchPath("res/csbjunshi")


local UIManager = import("app.framework.UIManager")

local JunShiScene = class("JunShiScene",function()
	return display.newScene("JunShiScene")
end)


function JunShiScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end



function JunShiScene:loadAppFile()
	import("app.viewsminigame.viewsjunshi.config.js_config")
	if js_card_lang == 1 then
		cc.FileUtils:getInstance():addSearchPath("res/csbminigame/csbjunshi")
	else
		cc.FileUtils:getInstance():addSearchPath("res/csbjinniu")
	end
end



function JunShiScene:onEnter()
	local delay = cc.DelayTime:create(0.1)
	local call = cc.CallFunc:create( function()
		-- 创建LoadingUI
		addUIToScene( UIDefine.MINIGAME_KEY.JunShi_Loading_UI )
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction(seq)
end

function JunShiScene:getSceneName()
	return "JunShiScene"
end

function JunShiScene:getUIManager()
	return self._uiManager
end



return JunShiScene