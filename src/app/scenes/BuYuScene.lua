
--
-- Author: 	刘智勇
-- Date: 	2019-06-22
-- Desc:	李逵场景


cc.FileUtils:getInstance():addSearchPath( "res/csbbuyu" )

local UIManager = import( "app.framework.UIManager" )

local BuYuScene = class( "BuYuScene",function ()
	return display.newScene( "BuYuScene" )
end)


function BuYuScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function BuYuScene:loadAppFile()
	import( "app.viewsbuyu.config.buyu_config" )
end

function BuYuScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.BUYU_KEY.Loading_UI )
end

function BuYuScene:getSceneName()
	return "BuYuScene"
end

function BuYuScene:getUIManager()
	return self._uiManager
end

return BuYuScene