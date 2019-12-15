
local rpgsolider_config = {
	[1] = {
		id = 1,
		name = "guanyu",
		idle_frame = { frames = {1,2,3,4,1},path = "frame/role1/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role1/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,7,8,9,10,1},path = "frame/role1/attack/" },
		dead_frame = { frames = {1,2,3,4,5,6,7},path = "frame/role1/dead/" },
		hp = 50,
		size = { width = 150,height = 150 },
		image_offsetx = 0, -- 由于每个士兵的图片制作的时候 偏移了 需要一个偏移量 来设置x轴的坐标
		attack_value = 1, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 1,-- 攻击距离 单位 砖块
		attack_type = 1, -- 1:近战 2:远程
		cd = 15,
		mode = 2,-- mode 1:士兵 2:boss
		speed = 2 -- 移动速度 单位秒 移动一个单元格的花费的时间
	},
	[2] = {
		id = 2,
		name = "zhaozilong",
		idle_frame = { frames = {1,2,3,4,1},path = "frame/role2/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role2/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,7,8,9,10,1},path = "frame/role2/attack/" },
		dead_frame = { frames = {1,2,3,4},path = "frame/role2/dead/" },
		hp = 100,
		size = { width = 150,height = 150 },
		image_offsetx = 20,
		attack_value = 2, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 1,-- 攻击距离 10像素
		attack_type = 1, -- 1:近战 2:远程
		cd = 15,
		mode = 1,-- mode 1:士兵 2:boss
		speed = 2 -- 移动速度 1秒移动的像素
	},
	[3] = {
		id = 3,
		name = "zhangfei",
		idle_frame = { frames = {1,2,3,4,1},path = "frame/role3/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role3/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,7,8,1},path = "frame/role3/attack/" },
		dead_frame = { frames = {1,2,3,4},path = "frame/role3/dead/" },
		hp = 100,
		size = { width = 150,height = 150 },
		image_offsetx = 20,
		attack_value = 1, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 1,-- 攻击距离 10像素
		attack_type = 1, -- 1:近战 2:远程
		cd = 15,
		mode = 1,-- mode 1:士兵 2:boss
		speed = 2 -- 移动速度 1秒移动的像素
	},
	[4] = {
		id = 4,
		name = "huanggai",
		idle_frame = { frames = {1,2,3,1},path = "frame/role4/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role4/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,7,8,9,10,1},path = "frame/role4/attack/" },
		dead_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role4/dead/" },
		hp = 100,
		size = { width = 150,height = 150 },
		image_offsetx = 20,
		attack_value = 2, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 1,-- 攻击距离 10像素
		attack_type = 1, -- 1:近战 2:远程
		cd = 15,
		mode = 1,-- mode 1:士兵 2:boss
		speed = 2 -- 移动速度 1秒移动的像素
	},
	[5] = {
		id = 5,
		name = "zhouyu",
		idle_frame = { frames = {1,2,3,4,1},path = "frame/role5/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role5/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,7,8,9,10,11,1},path = "frame/role5/attack/" },
		dead_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role5/dead/" },
		hp = 500,
		size = { width = 150,height = 150 },
		image_offsetx = 20,
		attack_value = 2, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 5,-- 5个单元格
		attack_type = 2, -- 1:近战 2:远程
		cd = 10,
		mode = 1,-- mode 1:士兵 2:boss
		speed = 2 -- 移动速度 1秒移动的像素
	},
	[6] = {
		id = 6,
		name = "sima",
		idle_frame = { frames = {1,2,3,4,5,6,7,8,1},path = "frame/role6/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role6/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,7,8,1},path = "frame/role6/attack/" },
		dead_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role6/dead/" },
		hp = 100,
		size = { width = 150,height = 150 },
		image_offsetx = 20,
		attack_value = 1, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 1,-- 攻击距离 10像素
		attack_type = 1, -- 1:近战 2:远程
		cd = 10,
		mode = 1,-- mode 1:士兵 2:boss
		speed = 2 -- 移动速度 1秒移动的像素
	},
	[7] = {
		id = 7,
		name = "zhugeliang",
		idle_frame = { frames = {1,2,3,4,5,6,7,8,1},path = "frame/role7/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role7/move/" },
		attack_frame = { frames = {1,2,3,4,5,1},path = "frame/role7/attack/" },
		dead_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role7/dead/" },
		hp = 100,
		size = { width = 150,height = 150 },
		image_offsetx = 20,
		attack_value = 2, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 1,-- 攻击距离 10像素
		attack_type = 1, -- 1:近战 2:远程
		cd = 15,
		mode = 1,-- mode 1:士兵 2:boss
		speed = 2 -- 移动速度 1秒移动的像素
	},
	[8] = {
		id = 8,
		name = "liubei",
		idle_frame = { frames = {1,2,3,4,5,6,7,8,1},path = "frame/role8/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role8/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,1},path = "frame/role8/attack/" },
		dead_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role8/dead/" },
		hp = 100,
		size = { width = 150,height = 150 },
		image_offsetx = 20,
		attack_value = 1, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 3,-- 攻击距离 10像素
		attack_type = 2, -- 1:近战 2:远程
		cd = 15,
		mode = 1,-- mode 1:士兵 2:boss
		speed = 2 -- 移动速度 1秒移动的像素
	},
}


rawset(_G, "rpgsolider_config", rpgsolider_config)
