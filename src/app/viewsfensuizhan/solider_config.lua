
local solider_config = {
	[1] = {
		id = 1,
		name = "guanyu",
		idle_frame = { fstart = 1,fend = 4,path = "frame/role1/idle/" },
		move_frame = { fstart = 1,fend = 8,path = "frame/role1/move/" },
		attack_frame = { fstart = 1,fend = 10,path = "frame/role1/attack/" },
		dead_frame = { fstart = 1,fend = 8,path = "frame/role1/dead/" },
		hp = 100,
		attack_value = 2, -- 攻击力
		attack_interval = 1, -- 攻击间隔 1秒
		attack_distance = 200,-- 攻击距离 10像素 
		speed = 100, -- 移动速度 1秒移动的像素
		cd = 2 -- 刷新CD
	},
	[2] = {
		id = 2,
		name = "zhangfei",
		idle_frame = { fstart = 1,fend = 4,path = "frame/role2/idle/" },
		move_frame = { fstart = 1,fend = 8,path = "frame/role2/move/" },
		attack_frame = { fstart = 1,fend = 10,path = "frame/role2/attack/" },
		dead_frame = { fstart = 1,fend = 8,path = "frame/role2/dead/" },
		hp = 100,
		attack_value = 10, -- 攻击力
		attack_interval = 1, -- 攻击间隔 1秒
		attack_distance = 200,-- 攻击距离 10像素
		speed = 100, -- 移动速度 1秒移动的像素
		cd = 2 -- 刷新CD
	}
}


rawset(_G, "solider_config", solider_config)
