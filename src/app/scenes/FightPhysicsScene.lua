
--
-- Author: 	刘阳
-- Date: 	2019-12-08
-- Desc:	混战场景


cc.FileUtils:getInstance():addSearchPath( "res/csbfightphysics" )

local UIManager = import( "app.framework.UIManager" )

local FightPhysicsScene = class( "FightPhysicsScene",function ()
	return display.newScene( "FightPhysicsScene",{physics = 2} )
end)


function FightPhysicsScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function FightPhysicsScene:loadAppFile()
	
end

function FightPhysicsScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.FIGHTPHYSICS_KEY.Main_UI )
	-- 设置重力
	self:getPhysicsWorld():setGravity(cc.p(0,0)) 
	self:getPhysicsWorld():setDebugDrawMask( cc.PhysicsWorld.DEBUGDRAW_ALL ) 
end

function FightPhysicsScene:getSceneName()
	return "FightPhysicsScene"
end

function FightPhysicsScene:getUIManager()
	return self._uiManager
end

return FightPhysicsScene