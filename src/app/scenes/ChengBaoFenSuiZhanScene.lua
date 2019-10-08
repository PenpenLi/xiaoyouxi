
--
-- Author: 	刘智勇
-- Date: 	2019-10-8
-- Desc:	城堡粉碎战场景


cc.FileUtils:getInstance():addSearchPath( "res/csbchengbaofensuizhan" )

local UIManager = import( "app.framework.UIManager" )

local ChengBaoFenSuiZhanScene = class( "ChengBaoFenSuiZhanScene",function ()
	return display.newScene( "ChengBaoFenSuiZhanScene" )
end)


function ChengBaoFenSuiZhanScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function ChengBaoFenSuiZhanScene:loadAppFile()
	import( "app.viewschengbaofensuizhan.config.chengbao_config" )
end

function ChengBaoFenSuiZhanScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.CHENGBAOFENSUIZHAN_KEY.Loading_UI )
end

function ChengBaoFenSuiZhanScene:getSceneName()
	return "ChengBaoFenSuiZhanScene"
end

function ChengBaoFenSuiZhanScene:getUIManager()
	return self._uiManager
end

return ChengBaoFenSuiZhanScene