
local hunsolider_config = {
	[1] = {
		id = 1,
		name = "guanyu",
		idle_frame = { frames = {1,2,3,4,1},path = "frame/role1/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role1/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,7,8,9,10,1},path = "frame/role1/attack/" },
		dead_frame = { frames = {1,2,3,4,5,6,7},path = "frame/role1/dead/" },
		hp = 12,
		size = { width = 150,height = 150 },
		image_offsetx = 0, -- 由于每个士兵的图片制作的时候 偏移了 需要一个偏移量 来设置x轴的坐标
		attack_value = 1, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 50,-- 攻击距离 像素 
		speed = 2 -- 移动速度 1帧移动的像素
	},
	[2] = {
		id = 2,
		name = "zhaozilong",
		idle_frame = { frames = {1,2,3,4,1},path = "frame/role2/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role2/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,7,8,9,10,1},path = "frame/role2/attack/" },
		dead_frame = { frames = {1,2,3,4},path = "frame/role2/dead/" },
		hp = 10,
		size = { width = 150,height = 150 },
		image_offsetx = 20,
		attack_value = 1, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 50,-- 攻击距离 10像素
		speed = 2 -- 移动速度 1秒移动的像素
	},
	[3] = {
		id = 3,
		name = "zhangfei",
		idle_frame = { frames = {1,2,3,4,1},path = "frame/role3/idle/" },
		move_frame = { frames = {1,2,3,4,5,6,7,8},path = "frame/role3/move/" },
		attack_frame = { frames = {1,2,3,4,5,6,7,8,1},path = "frame/role3/attack/" },
		dead_frame = { frames = {1,2,3,4},path = "frame/role3/dead/" },
		hp = 10,
		size = { width = 150,height = 150 },
		image_offsetx = 20,
		attack_value = 1, -- 攻击力
		attack_interval = 0.2, -- 攻击间隔 1秒
		attack_distance = 50,-- 攻击距离 10像素
		speed = 2 -- 移动速度 1秒移动的像素
	},
}


rawset(_G, "hunsolider_config", hunsolider_config)
