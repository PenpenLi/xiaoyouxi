

local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "Start.csb" )

    self:addNodeClick(self.Image_3,{
    	endCallBack = function ()
    		self:playEight()
    	end
    })
    self:addNodeClick(self.Image_1,{
    	endCallBack = function ()
    		self:playJinNiu()
    	end
    })
    self:addNodeClick(self.Image_2,{
    	endCallBack = function ()
    		self:playJunShi()
    	end
    })
    self:addNodeClick(self.Image_4,{
    	endCallBack = function ()
    		self:playZuQiu()
    	end
    })
    self:addNodeClick(self.Image_5,{
    	endCallBack = function ()
    		self:playZhanDou()
    	end
    })
    self:addNodeClick(self.Image_6,{
    	endCallBack = function ()
    		self:playSuoHa()
    	end
    })
end




function GameStart:onEnter()
	GameStart.super.onEnter(self)
	-- local str = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
	-- print( str )
	performWithDelay(self,function ()
		--清空上个场景的资源
		cc.Director:getInstance():purgeCachedData()
		--打印内存
		local str = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
		--print( str )
	end,0.5)
end

function GameStart:playEight()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Start_UI )
	-- 停止播放背景音乐
	audio.stopMusic()
	-- 释放上一个场景的资源 内存
	cc.Director:getInstance():purgeCachedData()

	cc.FileUtils:getInstance():addSearchPath( "res" )

	local scene = require("app.viewsminigame.EightScene").new()
	-- local scene = require("app.scenes.EightScene").new()
	display.runScene(scene)

end
function GameStart:playJinNiu()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Start_UI )
	-- 停止播放背景音乐
	audio.stopMusic()
	-- 释放上一个场景的资源 内存
	cc.Director:getInstance():purgeCachedData()

	cc.FileUtils:getInstance():addSearchPath( "res" )

	local scene = require("app.viewsminigame.LiKuiScene").new()
	-- local scene = require("app.scenes.EightScene").new()
	display.runScene(scene)
end
function GameStart:playJunShi()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Start_UI )
	-- 停止播放背景音乐
	audio.stopMusic()
	-- 释放上一个场景的资源 内存
	cc.Director:getInstance():purgeCachedData()

	cc.FileUtils:getInstance():addSearchPath( "res" )

	local scene = require("app.viewsminigame.JunShiScene").new()
	-- local scene = require("app.scenes.EightScene").new()
	display.runScene(scene)
end
function GameStart:playZuQiu()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Start_UI )
	-- 停止播放背景音乐
	audio.stopMusic()
	-- 释放上一个场景的资源 内存
	cc.Director:getInstance():purgeCachedData()

	cc.FileUtils:getInstance():addSearchPath( "res" )

	local scene = require("app.viewsminigame.ZuQiuScene").new()
	-- local scene = require("app.scenes.EightScene").new()
	display.runScene(scene)
end
function GameStart:playZhanDou()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Start_UI )
	-- 停止播放背景音乐
	audio.stopMusic()
	-- 释放上一个场景的资源 内存
	cc.Director:getInstance():purgeCachedData()

	cc.FileUtils:getInstance():addSearchPath( "res" )

	local scene = require("app.viewsminigame.ZhanDouScene").new()
	-- local scene = require("app.scenes.EightScene").new()
	display.runScene(scene)
end
function GameStart:playSuoHa()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Start_UI )
	-- 停止播放背景音乐
	audio.stopMusic()
	-- 释放上一个场景的资源 内存
	cc.Director:getInstance():purgeCachedData()

	cc.FileUtils:getInstance():addSearchPath( "res" )

	local scene = require("app.viewsminigame.SuoHaScene").new()
	-- local scene = require("app.scenes.EightScene").new()
	display.runScene(scene)
end







return GameStart