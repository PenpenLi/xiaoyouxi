
local solider_config = {
	[1] = {
		id = 1,
		name = "guanyu",
		idle_frame = { fstart = 1,fend = 4,path = "frame/role1/idle" },
		move_frame = { fstart = 1,fend = 8,path = "frame/role1/move" },
		attack_frame = { fstart = 1,fend = 10,path = "frame/role1/attack" },
		dead_frame = { fstart = 1,fend = 8,path = "frame/role1/dead" }
	}
}


rawset(_G, "solider_config", solider_config)
