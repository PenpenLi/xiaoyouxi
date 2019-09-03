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
	[23] = { startNum = 0,endNum = 18, path = "image/fish23/",dir = "all",			angle = 0,	imageScheduleTime = 0.12,Multiple = 33,weight = 40,blood = 330   	},
	[24] = { startNum = 0,endNum = 18, path = "image/fish24/",dir = "all",			angle = 0,	imageScheduleTime = 0.15,multiple = 36,weight = 40,blood = 360   	},
	[25] = { startNum = 0,endNum = 29, path = "image/fish25/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.16,multiple = 50,weight = 10,blood = 500   	},
	[26] = { startNum = 0,endNum = 13, path = "image/fish26/",dir = "all",			angle = 0,	imageScheduleTime = 0.15,multiple = 34,weight = 20,blood = 340   	},
	[27] = { startNum = 0,endNum = 18, path = "image/fish27/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.16,multiple = 40,weight = 20,blood = 400   	},
	[28] = { startNum = 0,endNum = 14, path = "image/fish28/",dir = "left_right",	angle = 0,	imageScheduleTime = 0.12,multiple = 65,weight = 10,blood = 650   	},
	[29] = { startNum = 0,endNum = 8,  path = "image/fish29/",dir = "all",			angle = 0,	imageScheduleTime = 0.03,multiple = 3, weight = 100,blood = 30   	},


}
-- 炮台和子弹
buyu_config.bullet = {
	[1]  = { beganLevel = 1,	endLevel = 5,	harm = 10,	exp = 100,	bullet = "image/guns/Bullet1_Normal_1_b.png",battery = "image/guns/gun_1_1.png" },
	[2]  = { beganLevel = 6,	endLevel = 10,	harm = 10,	exp = 200,	bullet = "image/guns/Bullet1_Normal_2_b.png",battery = "image/guns/gun_1_1.png" },
	[3]  = { beganLevel = 11,	endLevel = 15,	harm = 10,	exp = 300,	bullet = "image/guns/Bullet1_Normal_3_b.png",battery = "image/guns/gun_1_1.png" },
	[4]  = { beganLevel = 16,	endLevel = 20,	harm = 10,	exp = 400,	bullet = "image/guns/Bullet1_Normal_4_b.png",battery = "image/guns/gun_1_1.png" },
	[5]  = { beganLevel = 21,	endLevel = 25,	harm = 10,	exp = 500,	bullet = "image/guns/Bullet1_Normal_5_b.png",battery = "image/guns/gun_1_1.png" },
	[6]  = { beganLevel = 26,	endLevel = 30,	harm = 10,	exp = 600,	bullet = "image/guns/Bullet1_Normal_6_b.png",battery = "image/guns/gun_1_1.png" },
	[7]  = { beganLevel = 31,	endLevel = 35,	harm = 10,	exp = 700,	bullet = "image/guns/Bullet1_Specialt_a.png",battery = "image/guns/gun_1_2.png" },
	[8]  = { beganLevel = 36,	endLevel = 40,	harm = 10,	exp = 800,	bullet = "image/guns/Bullet1_Specialt_b.png",battery = "image/guns/gun_1_2.png" },
	[9]  = { beganLevel = 41,	endLevel = 45,	harm = 10,	exp = 900,	bullet = "image/guns/Bullet2_Normal_1_b.png",battery = "image/guns/gun_2_1.png" },
	[10] = { beganLevel = 46,	endLevel = 50,	harm = 10,	exp = 1000,	bullet = "image/guns/Bullet2_Normal_2_b.png",battery = "image/guns/gun_2_1.png" },
	[11] = { beganLevel = 51,	endLevel = 55,	harm = 10,	exp = 1100,	bullet = "image/guns/Bullet2_Normal_3_b.png",battery = "image/guns/gun_2_1.png" },
	[12] = { beganLevel = 56,	endLevel = 60,	harm = 10,	exp = 1200,	bullet = "image/guns/Bullet2_Normal_4_b.png",battery = "image/guns/gun_2_1.png" },
	[13] = { beganLevel = 61,	endLevel = 65,	harm = 10,	exp = 1300,	bullet = "image/guns/Bullet2_Normal_5_b.png",battery = "image/guns/gun_2_1.png" },
	[14] = { beganLevel = 66,	endLevel = 70,	harm = 10,	exp = 1400,	bullet = "image/guns/Bullet2_Normal_6_b.png",battery = "image/guns/gun_2_1.png" },
	[15] = { beganLevel = 71,	endLevel = 75,	harm = 10,	exp = 1500,	bullet = "image/guns/Bullet2_Specialt_a.png",battery = "image/guns/gun_2_2.png" },
	[16] = { beganLevel = 76,	endLevel = 80,	harm = 10,	exp = 1600,	bullet = "image/guns/Bullet2_Specialt_b.png",battery = "image/guns/gun_2_2.png" },
	[17] = { beganLevel = 81,	endLevel = 85,	harm = 10,	exp = 1700,	bullet = "image/guns/Bullet3_Normal_1_b.png",battery = "image/guns/gun_3_1.png" },
	[18] = { beganLevel = 86,	endLevel = 90,	harm = 10,	exp = 1800,	bullet = "image/guns/Bullet3_Normal_2_b.png",battery = "image/guns/gun_3_1.png" },
	[19] = { beganLevel = 91,	endLevel = 95,	harm = 10,	exp = 1900,	bullet = "image/guns/Bullet3_Normal_3_b.png",battery = "image/guns/gun_3_1.png" },
	[20] = { beganLevel = 96,	endLevel = 100,	harm = 10,	exp = 2000,	bullet = "image/guns/Bullet3_Normal_4_b.png",battery = "image/guns/gun_3_1.png" },
	[21] = { beganLevel = 101,	endLevel = 105,	harm = 10,	exp = 2100,	bullet = "image/guns/Bullet3_Normal_5_b.png",battery = "image/guns/gun_3_1.png" },
	[22] = { beganLevel = 106,	endLevel = 110,	harm = 10,	exp = 2200,	bullet = "image/guns/Bullet3_Normal_6_b.png",battery = "image/guns/gun_3_1.png" },
	[23] = { beganLevel = 111,	endLevel = 115,	harm = 10,	exp = 2300,	bullet = "image/guns/Bullet3_Specialt_a.png",battery = "image/guns/gun_3_2.png" },
	[24] = { beganLevel = 116,	endLevel = 999,	harm = 10,	exp = 2400,	bullet = "image/guns/Bullet3_Specialt_b.png",battery = "image/guns/gun_3_2.png" },
}

-- 捕鱼倍数
buyu_config.multiple = {
	[1] = 1,
	[2] = 2,
	[3] = 5,
	[4] = 10,
	[5] = 20,
	[6] = 50,
	[7] = 100,
	[8] = 200,
	[9] = 500,
	[10] = 1000
}

rawset(_G,"buyu_config",buyu_config)