
--
-- Author: 	刘智勇
-- Date: 	2019-06-22
-- Desc:	李逵场景


-- cc.FileUtils:getInstance():addSearchPath( "res/csblikui" )

local UIManager = import( "app.framework.UIManager" )

local LiKuiMaJiangScene = class( "LiKuiMaJiangScene",function ()
	return display.newScene( "LiKuiMaJiangScene" )
end)


function LiKuiMaJiangScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function LiKuiMaJiangScene:loadAppFile()
	import( "app.viewslikuimajiang.config.likui_config" )

	cc.FileUtils:getInstance():addSearchPath( "res/csblikuimajiang" )

end

function LiKuiMaJiangScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.LIKUI_KEY.Loading_UI )
end

function LiKuiMaJiangScene:getSceneName()
	return "LiKuiMaJiangScene"
end

function LiKuiMaJiangScene:getUIManager()
	return self._uiManager
end

return LiKuiMaJiangScene