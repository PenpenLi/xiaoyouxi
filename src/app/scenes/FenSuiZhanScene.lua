
--
-- Author: 	刘智勇
-- Date: 	2019-10-8
-- Desc:	城堡粉碎战场景


cc.FileUtils:getInstance():addSearchPath( "res/csbfensuizhan" )

local UIManager = import( "app.framework.UIManager" )

local FenSuiZhanScene = class( "FenSuiZhanScene",function ()
	return display.newScene( "FenSuiZhanScene" )
end)


function FenSuiZhanScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function FenSuiZhanScene:loadAppFile()
	import( "app.viewsfensuizhan.solider_config" )
end

function FenSuiZhanScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.FENSUIZHAN_KEY.Loading_UI )
end

function FenSuiZhanScene:getSceneName()
	return "FenSuiZhanScene"
end

function FenSuiZhanScene:getUIManager()
	return self._uiManager
end

return FenSuiZhanScene