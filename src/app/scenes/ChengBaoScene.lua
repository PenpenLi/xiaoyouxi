


cc.FileUtils:getInstance():addSearchPath( "res/csbchengbao" )

local UIManager = import( "app.framework.UIManager" )

local ChengBaoScene = class( "ChengBaoScene",function ()
	return display.newScene( "ChengBaoScene" )
end)

function ChengBaoScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end

function ChengBaoScene:loadAppFile()
	import( "app.viewschengbao.config.chengbao_config" )
end

function ChengBaoScene:onEnter()
	--创建LoadingUI
	-- addUIToScene( UIDefine.CHENGBAO_KEY.Loading_UI )
	addUIToScene( UIDefine.CHENGBAO_KEY.Play_UI )
end

function ChengBaoScene:getSceneName()
	return "ChengBaoScene"
end

function ChengBaoScene:getUIManager()
	return self._uiManager
end


return ChengBaoScene