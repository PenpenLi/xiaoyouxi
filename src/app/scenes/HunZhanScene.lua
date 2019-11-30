
--
-- Author: 	刘智勇
-- Date: 	2019-11-30
-- Desc:	混战场景


cc.FileUtils:getInstance():addSearchPath( "res/csbhunzhan" )

local UIManager = import( "app.framework.UIManager" )

local HunZhanScene = class( "HunZhanScene",function ()
	return display.newScene( "HunZhanScene" )
end)


function HunZhanScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function HunZhanScene:loadAppFile()
	import( "app.viewsfensuizhan.solider_config" )
end

function HunZhanScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.FENSUIZHAN_KEY.Loading_UI )
end

function HunZhanScene:getSceneName()
	return "HunZhanScene"
end

function HunZhanScene:getUIManager()
	return self._uiManager
end

return HunZhanScene