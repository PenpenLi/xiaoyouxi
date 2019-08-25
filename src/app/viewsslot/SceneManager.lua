

--
-- Author: 	刘阳
-- Date: 	2019-05-09
-- Desc:	场景管理的manager 注:所有涉及到场景跳转的，必须通过scenemanager的方法来跳转


cc.FileUtils:getInstance():addSearchPath( "res/csbslot" )
cc.FileUtils:getInstance():addSearchPath( "res/csbslot/hall" )
cc.FileUtils:getInstance():addSearchPath( "res/csbslot/wolfLighting" )
cc.FileUtils:getInstance():addSearchPath( "res/csbslot/newcandy" )

require("app.viewsslot.base.SymbolCsbCache")
require("app.viewsslot.base.EffectCsbCache")

local SceneManager = class("SceneManager")

SceneManager.SCENE_TYPE = {
	HALL		= 1,			-- 大厅scene
	LEVEL       = 2,            -- 关卡scene
}


function SceneManager:ctor()
	self:reset()
end


function SceneManager:reset()
	
end

function SceneManager:getInstance()
	if not self._instance then
		self._instance = SceneManager.new()
	end
	return self._instance
end



-- 进入大厅scene
function SceneManager:goToHallScene()
	-- 必须先进入LoadingScene 预加载资源
	local loading_scene = require("app.viewsslot.LoadingScene").new( self.SCENE_TYPE.HALL )
	display.runScene( loading_scene )
end

--[[
	进入关卡scene
	levelIndex:关卡的索引
]]
function SceneManager:gotoLevelScene( levelIndex )
	assert( levelIndex," !! levelIndex is nil !! " )
	local loading_scene = require("app.viewsslot.LoadingScene").new( self.SCENE_TYPE.LEVEL,levelIndex )
	display.runScene( loading_scene )
end


cc.exports.SceneManager = SceneManager:getInstance()
