

--
-- Author: 	刘阳
-- Date: 	2019-05-09
-- Desc:	大厅场景需要加载的资源配置


--[[
	资源预加载的配置 数据格式必须如下:
	1:plist = {}										-- plist的预加载
	2:mp3 = { music = {},effect = {} }					-- 音乐音效的预加载
	3:image = {}										-- 普通图片的预加载
	4:csb = {}											-- csb的预加载
]]


local HallResConfig = class("HallResConfig")


HallResConfig.plist = {
	{ "csbslot/hall/SlotPlist1.png","csbslot/hall/SlotPlist1.plist" },
	{ "csbslot/hall/SlotPlist2.png","csbslot/hall/SlotPlist2.plist" },
}


HallResConfig.mp3 = {
	music = {
		-- "hall/mp3/music/SlotUltimate_reel_run.mp3"
	},
	effect = {
		-- "hall/mp3/effect/SlotUltimate_reel_stop_0.mp3",
		-- "hall/mp3/effect/SlotUltimate_reel_stop_1.mp3",
		-- "hall/mp3/effect/SlotUltimate_reel_stop_2.mp3",
		-- "hall/mp3/effect/SlotUltimate_reel_stop_3.mp3",
		-- "hall/mp3/effect/SlotUltimate_reel_stop_4.mp3",
		-- "hall/mp3/effect/SlotUltimate_reel_stop_5.mp3",
		-- "hall/mp3/effect/SlotUltimate_reel_stop_6.mp3",
		-- "hall/mp3/effect/SlotUltimate_reel_stop_8.mp3"
	}
}


HallResConfig.image = {
	
}



return HallResConfig