

local chengbao_config = {}

chengbao_config.soldier = {

	[1] = { path = "image/people/player_0001/",hp = 30000, attack = 20,speed = 4,attack_dis = 100,attack_type = 1,cd = 3  },
	[2] = { path = "image/people/player_0002/",hp = 18000, attack = 20,speed = 2,attack_dis = 300,attack_type = 2,cd = 3  },
	[3] = { path = "image/people/player_0005/",hp = 40000, attack = 25,speed = 3,attack_dis = 100,attack_type = 1,cd = 5  },
	[4] = { path = "image/people/player_0006/",hp = 60000, attack = 15,speed = 2,attack_dis = 100,attack_type = 1,cd = 4  },
	[5] = { path = "image/people/player_0007/",hp = 20000, attack = 30,speed = 2,attack_dis = 300,attack_type = 2,cd = 5  },
	[6] = { path = "image/people/player_0008/",hp = 40000, attack = 30,speed = 3,attack_dis = 100,attack_type = 1,cd = 6  },
	[7] = { path = "image/people/player_0009/",hp = 28000, attack = 30,speed = 4,attack_dis = 100,attack_type = 1,cd = 5  },
	[8] = { path = "image/people/player_0011/",hp = 30000, attack = 20,speed = 3,attack_dis = 100,attack_type = 1,cd = 3  },
	[9] = { path = "image/people/player_0013/",hp = 28000, attack = 28,speed = 3,attack_dis = 100,attack_type = 1,cd = 4  },
	[10] = { path = "image/people/player_0014/",hp = 20000, attack = 25,speed = 3,attack_dis = 300,attack_type = 2,cd = 5  },
	[11] = { path = "image/people/player_0015/",hp = 18000, attack = 33,speed = 3,attack_dis = 400,attack_type = 2,cd = 6  },
	[12] = { path = "image/people/player_0016/",hp = 18000, attack = 35,speed = 2,attack_dis = 350,attack_type = 2,cd = 6  },
	[13] = { path = "image/people/player_0017/",hp = 60000, attack = 22,speed = 3,attack_dis = 100,attack_type = 1,cd = 6  },
	[14] = { path = "image/people/player_0019/",hp = 18000, attack = 35,speed = 2,attack_dis = 350,attack_type = 2,cd = 7  },
	[15] = { path = "image/people/player_0022/",hp = 80000, attack = 15,speed = 3,attack_dis = 100,attack_type = 1,cd = 7  },
	[16] = { path = "image/people/player_0023/",hp = 60000, attack = 25,speed = 2,attack_dis = 100,attack_type = 1,cd = 7  },
	[17] = { path = "image/people/player_0025/",hp = 45000, attack = 30,speed = 3,attack_dis = 100,attack_type = 1,cd = 7  },
	[18] = { path = "image/people/player_0027/",hp = 60000, attack = 25,speed = 5,attack_dis = 100,attack_type = 1,cd = 7  },
	[19] = { path = "image/people/player_0028/",hp = 60000, attack = 30,speed = 4,attack_dis = 100,attack_type = 1,cd = 8  },
	[20] = { path = "image/people/player_0031/",hp = 60000, attack = 30,speed = 5,attack_dis = 100,attack_type = 1,cd = 8  },
	[21] = { path = "image/people/player_0032/",hp = 80000, attack = 28,speed = 4,attack_dis = 100,attack_type = 1,cd = 8  },
	[22] = { path = "image/people/player_0033/",hp = 40000, attack = 30,speed = 4,attack_dis = 350,attack_type = 1,cd = 8  },
	[23] = { path = "image/people/player_0034/",hp = 40000, attack = 30,speed = 4,attack_dis = 350,attack_type = 1,cd = 8  },
	[24] = { path = "image/people/player_0035/",hp = 70000, attack = 30,speed = 4,attack_dis = 100,attack_type = 1,cd = 8  },
	[25] = { path = "image/people/player_0038/",hp = 80000, attack = 30,speed = 5,attack_dis = 100,attack_type = 1,cd = 9  },
	[26] = { path = "image/people/player_0039/",hp = 12000, attack = 20,speed = 2,attack_dis = 100,attack_type = 1,cd = 9  },
	[27] = { path = "image/people/player_0040/",hp = 60000, attack = 30,speed = 3,attack_dis = 100,attack_type = 1,cd = 9  },
	[28] = { path = "image/people/player_0041/",hp = 80000, attack = 40,speed = 4,attack_dis = 100,attack_type = 1,cd = 9  },
	[29] = { path = "image/people/player_0042/",hp = 100000, attack = 30,speed = 2,attack_dis = 100,attack_type = 1,cd = 9  },
	[30] = { path = "image/people/player_0043/",hp = 100000, attack = 35,speed = 3,attack_dis = 100,attack_type = 1,cd = 9  },


}


chengbao_config.build = {
	[1] = { path = "image/play/ta.png",hp = 30000 }
}

chengbao_config.enemy = {
	[1] = { path = "image/people/player_0005/",hp = 20000, attack = 20,speed = 2,attack_dis = 100,attack_type = 1 },
	[2] = { path = "image/people/player_0042/",hp = 20000, attack = 30,speed = 2,attack_dis = 100,attack_type = 1,cd = 9  },
	[3] = { path = "image/people/player_0043/",hp = 20000, attack = 35,speed = 3,attack_dis = 100,attack_type = 1,cd = 9  },
	-- [2] = { path = "image/people/player_0005/",hp = 10000, attack = 20,speed = 2,attack_dis = 20,attack_type = 1 },
}
chengbao_config.size = {
	width = 200,
	height = 200
}

-- chengbao_config.enemyBuild = {
-- 	[1] = { path = "image/play/ta.png",hp = 3000 }
-- }








rawset(_G,"chengbao_config",chengbao_config)