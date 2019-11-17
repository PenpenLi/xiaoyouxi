
-- cc.FileUtils:getInstance():addSearchPath( "res/csbheji" )
-- cc.FileUtils:getInstance():addSearchPath( "res/csbheji/csbdating" )
-- cc.FileUtils:getInstance():addSearchPath( "res/csbheji/csbsanguo" )
-- cc.FileUtils:getInstance():addSearchPath( "res/csbheji/csbtwentyone" )
-- cc.FileUtils:getInstance():addSearchPath( "res/csbheji/csbzhipai" )

cc.FileUtils:getInstance():addSearchPath( "res/csbminigame/csbdating" )
-- cc.FileUtils:getInstance():addSearchPath( "res" )

local UIManager = import( "app.framework.UIManager" )

local MiniGameScene = class( "MiniGameScene",function ()
	return display.newScene( "MiniGameScene" )
end)

function MiniGameScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function MiniGameScene:loadAppFile()
	-- import( "app.viewsheji.config.sanguo_config" )
	-- import( "app.viewsheji.config.twenty_one_poker_config" )
	-- import( "app.viewsheji.config.zhipai_config" )
end

function MiniGameScene:onEnter()
	addUIToScene( UIDefine.MINIGAME_KEY.Loading_UI )
end

function MiniGameScene:getSceneName()
	return "MiniGameScene"
end

function MiniGameScene:getUIManager()
	return self._uiManager
end

return MiniGameScene