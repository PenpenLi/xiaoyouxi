
cc.FileUtils:getInstance():addSearchPath( "res/csbheji" )
cc.FileUtils:getInstance():addSearchPath( "res/csbheji/csbdating" )
cc.FileUtils:getInstance():addSearchPath( "res/csbheji/csbsanguo" )
cc.FileUtils:getInstance():addSearchPath( "res/csbheji/csbtwentyone" )
cc.FileUtils:getInstance():addSearchPath( "res/csbheji/csbzhipai" )

local UIManager = import( "app.framework.UIManager" )

local HeJiScene = class( "HeJiScene",function ()
	return display.newScene( "HeJiScene" )
end)

function HeJiScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function HeJiScene:loadAppFile()
	import( "app.viewsheji.config.sanguo_config" )
	import( "app.viewsheji.config.twenty_one_poker_config" )
	import( "app.viewsheji.config.zhipai_config" )
end

function HeJiScene:onEnter()
	addUIToScene( UIDefine.HEJI_KEY.Loading_UI )
end

function HeJiScene:getSceneName()
	return "HeJiScene"
end

function HeJiScene:getUIManager()
	return self._uiManager
end

return HeJiScene