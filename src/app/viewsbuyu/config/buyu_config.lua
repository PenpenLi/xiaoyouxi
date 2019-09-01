local buyu_config = {}


buyu_config.fish={
	[1] = { startNum = 0,endNum = 18, path = "image/fish1/",dir = "all",angle = 0,imageScheduleTime = 0.02,  },
	[2] = { startNum = 0,endNum = 7,  path = "image/fish2/",dir = "left_right",angle = 0,imageScheduleTime = 0.06,    },
	[3] = { startNum = 0,endNum = 11, path = "image/fish3/",dir = "all",angle = 90,imageScheduleTime = 0.1,   },
}


rawset(_G,"buyu_config",buyu_config)