

cc.FileUtils:getInstance():addSearchPath( "res/csbeight" )

local UIManager = import( "app.framework.UIManager" )

local EightScene = class( "EightScene",function ()
	return display.newScene( "EightScene" )
end)

function EightScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function EightScene:loadAppFile()
	import( "app.viewseight.config.eight_config" )
end

function EightScene:onEnter()
	addUIToScene( UIDefine.EIGHT_KEY.Loading_UI )
end

function EightScene:getSceneName()
	return "EightScene"
end

function EightScene()
	return self._uiManager
end

return EightScene