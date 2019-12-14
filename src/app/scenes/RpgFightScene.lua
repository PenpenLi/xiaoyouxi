
--
-- Author: 	刘阳
-- Date: 	2019-12-08
-- Desc:	混战场景


cc.FileUtils:getInstance():addSearchPath( "res/csbrpgfight" )

local UIManager = import( "app.framework.UIManager" )

local RpgFightScene = class( "RpgFightScene",function ()
	return display.newScene( "RpgFightScene" )
end)


function RpgFightScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function RpgFightScene:loadAppFile()
	import( "app.viewsrpgfight.rpgfight_config" )
	import( "app.viewsrpgfight.rpgsolider_config" )
	import( "app.viewsrpgfight.rpgSkill_config" )
end

function RpgFightScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.RPGFIGHT_KEY.Loading_UI )
end

function RpgFightScene:getSceneName()
	return "RpgFightScene"
end

function RpgFightScene:getUIManager()
	return self._uiManager
end

return RpgFightScene