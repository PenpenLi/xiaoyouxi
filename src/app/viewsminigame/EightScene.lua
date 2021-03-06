

-- cc.FileUtils:getInstance():addSearchPath( "res/csbminigame/csbeight" )

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
	import( "app.viewsminigame.viewseight.config.eight_config" )
	cc.FileUtils:getInstance():addSearchPath( "res/csbminigame/csbeight" )
end

function EightScene:onEnter()
	addUIToScene( UIDefine.MINIGAME_KEY.Eight_Loading_UI )
end

function EightScene:getSceneName()
	return "EightScene"
end

function EightScene:getUIManager()
	return self._uiManager
end



return EightScene