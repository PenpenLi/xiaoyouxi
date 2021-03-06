
--
-- Author: 	刘智勇
-- Date: 	2019-06-22
-- Desc:	李逵场景


-- cc.FileUtils:getInstance():addSearchPath( "res/csblikui" )

local UIManager = import( "app.framework.UIManager" )

local LiKuiScene = class( "LiKuiScene",function ()
	return display.newScene( "LiKuiScene" )
end)


function LiKuiScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function LiKuiScene:loadAppFile()
	import( "app.viewslikui.config.likui_config" )
	if likui_config.language == 1 then
		cc.FileUtils:getInstance():addSearchPath( "res/csblikui/csblikuijapanese" )
	elseif likui_config.language == 2 then
		cc.FileUtils:getInstance():addSearchPath( "res/csblikui/csblikuienglish" )
	elseif likui_config.language == 3 then
		cc.FileUtils:getInstance():addSearchPath( "res/csblikui/csblikuichinese" )
	end
end

function LiKuiScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.LIKUI_KEY.Loading_UI )
end

function LiKuiScene:getSceneName()
	return "LiKuiScene"
end

function LiKuiScene:getUIManager()
	return self._uiManager
end

return LiKuiScene