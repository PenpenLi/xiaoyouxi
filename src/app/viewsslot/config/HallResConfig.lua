

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
		"csbslot/hall/hmp3/SlotUltimate_sound_map_bgm1.mp3",
		"csbslot/hall/hmp3/bg1.mp3",
		"csbslot/hall/hmp3/bg2.mp3",
		"csbslot/hall/hmp3/bg3.mp3",
	},
	effect = {
		"csbslot/hall/hmp3/button.mp3",
		"csbslot/hall/hmp3/card_recovery_bgm.mp3",
		"csbslot/hall/hmp3/card_recovery_select_card.mp3",
		"csbslot/hall/hmp3/free_spin.mp3",
		"csbslot/hall/hmp3/quickroll.mp3",
		"csbslot/hall/hmp3/reel_stop.mp3",
		"csbslot/hall/hmp3/SlotUltimate_sound_slots_click.mp3",
		"csbslot/hall/hmp3/sound_daily_wheel_coin_fly.mp3",
		"csbslot/hall/hmp3/sound_daily_wheel_collect.mp3",
		"csbslot/hall/hmp3/sound_daily_wheel_collect_click.mp3",
		"csbslot/hall/hmp3/sound_daily_wheel_collect_click.mp3",
		"csbslot/hall/hmp3/sound_daily_wheel_roulette_end.mp3",
		"csbslot/hall/hmp3/sound_daily_wheel_show_value.mp3",
		"csbslot/hall/hmp3/sound_daily_wheel_spin.mp3",
		"csbslot/hall/hmp3/sound_daily_wheel_zhizhen.mp3",
		"csbslot/hall/hmp3/sound_draw_roll.mp3",
	}
}


HallResConfig.image = {
	
}



return HallResConfig