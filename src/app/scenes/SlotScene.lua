

cc.FileUtils:getInstance():addSearchPath( "res/csbslot" )

local UIManager = import( "app.framework.UIManager" )

local SlotScene = class( "SlotScene",function ()
	return display.newScene( "SlotScene" )
end)

function SlotScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function SlotScene:loadAppFile()
	import( "app.viewsslot.config.slotgameconfig" )
end

function SlotScene:onEnter()
	addUIToScene( UIDefine.SLOT_KEY.Loading_UI )
end

function SlotScene:getSceneName()
	return "SlotScene"
end

function SlotScene:getUIManager()
	return self._uiManager
end

return SlotScene