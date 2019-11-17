


cc.FileUtils:getInstance():addSearchPath( "res/csbminigame/csbsuoha" )


local UIManager = import( "app.framework.UIManager" )

local SuoHaScene = class( "SuoHaScene",function ()
	return display.newScene( "SuoHaScene" )
end)

function SuoHaScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function SuoHaScene:loadAppFile()
	import( "app.viewsminigame.viewssuoha.config.suoha_config" )
end


function SuoHaScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.MINIGAME_KEY.SuoHa_Loading_UI )
end

function SuoHaScene:getSceneName()
	return "SuoHaScene"
end

function SuoHaScene:getUIManager()
	return self._uiManager
end


return SuoHaScene