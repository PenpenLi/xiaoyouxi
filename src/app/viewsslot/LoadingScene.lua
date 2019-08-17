

--
-- Author: 	刘阳
-- Date: 	2019-05-08
-- Desc:	Loading场景


local UIManager = import("app.framework.UIManager")

local LoadingScene = class("LoadingScene",function()
	return display.newScene("LoadingScene")
end)



function LoadingScene:ctor( sceneType,levelIndex )
	assert( sceneType," !! sceneType is nil !! " )
	-- 开启生命周期
	self:enableNodeEvents()
	self._uiManager = UIManager.new( self )
	self._sceneType = sceneType
	self._levelIndex = levelIndex
end



function LoadingScene:getSceneName()
	return "LoadingScene"
end



function LoadingScene:onEnter()
	-- 加载Loading界面
	addUIToScene( UIDefine.SLOT_KEY.Loading_UI,{self._sceneType,self._levelIndex}  )
end

function LoadingScene:onExit()
end


function LoadingScene:getUIManager()
	return self._uiManager
end


return LoadingScene

