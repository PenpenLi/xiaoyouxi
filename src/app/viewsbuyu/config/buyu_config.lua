local buyu_config = {}


buyu_config.fish={
	[1]  = { startNum = 0,endNum = 18, path = "image/fish1/", dir = "all",			angle = 0,	imageScheduleTime = 0.02,multiple = 2, weight = 100,blood = 20    	},
	[2]  = { startNum = 0,endNum = 7,  path = "image/fish2/", dir = "left_right",	angle = 0,	imageScheduleTime = 0.06,multiple = 2, weight = 100,blood = 20    	},
	[3]  = { startNum = 0,endNum = 11, path = "image/fish3/", dir = "all",			angle = 90,	imageScheduleTime = 0.1, multiple = 30,weight = 40,blood = 300   	},
	[4]  = { startNum = 0,endNum = 18, path = "image/fish4/", dir = "all",			angle = 0,	imageScheduleTime = 0.08,multiple = 10,weight = 50,blood = 100   	},
	[5]  = { startNum = 0,endNum = 7,  path = "image/fish5/", dir = "left_right",	angle = 0,	imageScheduleTime = 0.04,multiple = 4, weight = 100,blood = 40  	},
	[6]  = { startNum = 0,endNum = 31, path = "image/fish6/", dir = "all",			angle = 0,	imageScheduleTime = 0.06,multiple = 5, weight = 100,blood = 50  	},
	[7]  = { startNum = 0,endNum = 18, path = "image/fish7/", dir = "all",			angle = 0,	imageScheduleTime = 0.03,multiple = 6, weight = 100,blood = 60   	},
	[8]  = { startNum = 0,endNum = 18, path = "image/fish8/", dir = "left_right",	angle = 0,	imageScheduleTime = 0.04,multiple = 6, weight = 100,blood = 60   	},
	[9]  = { startNum = 0,endNum = 7,  path = "image/fish9/", dir = "left_right",	angle = 0,	imageScheduleTime = 0.06,multiple = 6, weight = 100,blood = 60   	},
	[10] = { startNum = 0,endNum = 18, path = "image/fish10/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.3, multiple = 8, weight = 100,blood = 80   	},
	[11] = { startNum = 0,endNum = 18, path = "image/fish11/",dir = "all",			angle = 0,	imageScheduleTime = 0.04,multiple = 15,weight = 70,blood = 150   	},
	[12] = { startNum = 0,endNum = 18, path = "image/fish12/",dir = "all",			angle = 0,	imageScheduleTime = 0.1, multiple = 15,weight = 70,blood = 150   	},
	[13] = { startNum = 0,endNum = 7,  path = "image/fish13/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.1, multiple = 15,weight = 70,blood = 150   	},
	[14] = { startNum = 0,endNum = 7,  path = "image/fish14/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.06,multiple = 13,weight = 80,blood = 130   	},
	[15] = { startNum = 0,endNum = 18, path = "image/fish15/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.1, multiple = 20,weight = 60,blood = 200   	},
	[16] = { startNum = 0,endNum = 18, path = "image/fish16/",dir = "all",			angle = 0,	imageScheduleTime = 0.08,multiple = 16,weight = 70,blood = 160   	},
	[17] = { startNum = 0,endNum = 18, path = "image/fish17/",dir = "all",			angle = 0,	imageScheduleTime = 0.1, multiple = 22,weight = 60,blood = 220   	},
	[18] = { startNum = 0,endNum = 13, path = "image/fish18/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.1, multiple = 22,weight = 60,blood = 220  	},
	[19] = { startNum = 0,endNum = 18, path = "image/fish19/",dir = "all",			angle = 0,	imageScheduleTime = 0.12,multiple = 35,weight = 40,blood = 350   	},
	[20] = { startNum = 0,endNum = 7,  path = "image/fish20/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.12,multiple = 35,weight = 40,blood = 350   	},
	[21] = { startNum = 0,endNum = 18, path = "image/fish21/",dir = "all",			angle = 0,	imageScheduleTime = 0.12,multiple = 28,weight = 50,blood = 280   	},
	[22] = { startNum = 0,endNum = 18, path = "image/fish22/",dir = "all",			angle = 0,	imageScheduleTime = 0.18,multiple = 28,weight = 50,blood = 280   	},
	[23] = { startNum = 0,endNum = 18, path = "image/fish23/",dir = "all",			angle = 0,	imageScheduleTime = 0.12,multiple = 33,weight = 40,blood = 330   	},
	[24] = { startNum = 0,endNum = 18, path = "image/fish24/",dir = "all",			angle = 0,	imageScheduleTime = 0.15,multiple = 36,weight = 40,blood = 360   	},
	[25] = { startNum = 0,endNum = 29, path = "image/fish25/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.16,multiple = 50,weight = 10,blood = 500   	},
	[26] = { startNum = 0,endNum = 13, path = "image/fish26/",dir = "all",			angle = 0,	imageScheduleTime = 0.15,multiple = 34,weight = 20,blood = 340   	},
	[27] = { startNum = 0,endNum = 18, path = "image/fish27/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.16,multiple = 40,weight = 20,blood = 400   	},
	[28] = { startNum = 0,endNum = 14, path = "image/fish28/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.12,multiple = 65,weight = 10,blood = 650   	},
	[29] = { startNum = 0,endNum = 8,  path = "image/fish29/",dir = "all",			angle = 0,	imageScheduleTime = 0.03,multiple = 3, weight = 100,blood = 30   	},



}


rawset(_G,"buyu_config",buyu_config)