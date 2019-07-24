
--
-- Author: 	刘阳
-- Date: 	2019-04-27
-- Desc:	成语接龙场景


local UIManager = import("app.framework.UIManager")

local LaBaScene = class("LaBaScene",function()
	return display.newScene("LaBaScene")
end)


function LaBaScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end



function LaBaScene:loadAppFile()
	import("app.viewslaba.config.laba_config")

	if laba_config.lang == 1 then
		cc.FileUtils:getInstance():addSearchPath("res/csblaba")
	else
		cc.FileUtils:getInstance():addSearchPath("res/csblabaenglish")
	end
end



function LaBaScene:onEnter()
	local delay = cc.DelayTime:create(0.1)
	local call = cc.CallFunc:create( function()
		-- 创建LoadingUI
		addUIToScene( UIDefine.LABA_KEY.Loading_UI )
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction(seq)
end

function LaBaScene:getSceneName()
	return "LaBaScene"
end

function LaBaScene:getUIManager()
	return self._uiManager
end



return LaBaScene