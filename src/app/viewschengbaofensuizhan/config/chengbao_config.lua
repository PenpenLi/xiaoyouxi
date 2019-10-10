

local chengbao_config = {}

chengbao_config.soldier = {

	[1] = { path = "image/people/player_0001/",hp = 300, attack = 20,speed = 4,attack_dis = 100,attack_type = 1,cd = 3  },
	[2] = { path = "image/people/player_0002/",hp = 180, attack = 20,speed = 2,attack_dis = 300,attack_type = 2,cd = 3  },
	[3] = { path = "image/people/player_0005/",hp = 400, attack = 25,speed = 3,attack_dis = 100,attack_type = 1,cd = 5  },
	[4] = { path = "image/people/player_0006/",hp = 600, attack = 15,speed = 2,attack_dis = 100,attack_type = 1,cd = 4  },
	[5] = { path = "image/people/player_0007/",hp = 200, attack = 30,speed = 2,attack_dis = 300,attack_type = 2,cd = 5  },
	[6] = { path = "image/people/player_0008/",hp = 400, attack = 30,speed = 3,attack_dis = 100,attack_type = 1,cd = 6  },
	[7] = { path = "image/people/player_0009/",hp = 280, attack = 30,speed = 4,attack_dis = 100,attack_type = 1,cd = 5  },
	[8] = { path = "image/people/player_0011/",hp = 300, attack = 20,speed = 3,attack_dis = 100,attack_type = 1,cd = 3  },
	[9] = { path = "image/people/player_0013/",hp = 280, attack = 28,speed = 3,attack_dis = 100,attack_type = 1,cd = 4  },
	[10] = { path = "image/people/player_0014/",hp = 200, attack = 25,speed = 3,attack_dis = 300,attack_type = 2,cd = 5  },
	[11] = { path = "image/people/player_0015/",hp = 180, attack = 33,speed = 3,attack_dis = 400,attack_type = 2,cd = 6  },
	[12] = { path = "image/people/player_0016/",hp = 180, attack = 35,speed = 2,attack_dis = 350,attack_type = 2,cd = 6  },
	[13] = { path = "image/people/player_0017/",hp = 600, attack = 22,speed = 3,attack_dis = 100,attack_type = 1,cd = 6  },
	[14] = { path = "image/people/player_0019/",hp = 180, attack = 35,speed = 2,attack_dis = 350,attack_type = 2,cd = 7  },
	[15] = { path = "image/people/player_0022/",hp = 800, attack = 15,speed = 3,attack_dis = 100,attack_type = 1,cd = 7  },
	[16] = { path = "image/people/player_0023/",hp = 600, attack = 25,speed = 2,attack_dis = 100,attack_type = 1,cd = 7  },
	[17] = { path = "image/people/player_0025/",hp = 450, attack = 30,speed = 3,attack_dis = 100,attack_type = 1,cd = 7  },
	[18] = { path = "image/people/player_0027/",hp = 600, attack = 25,speed = 5,attack_dis = 100,attack_type = 1,cd = 7  },
	[19] = { path = "image/people/player_0028/",hp = 600, attack = 30,speed = 4,attack_dis = 100,attack_type = 1,cd = 8  },
	[20] = { path = "image/people/player_0031/",hp = 600, attack = 30,speed = 5,attack_dis = 100,attack_type = 1,cd = 8  },
	[21] = { path = "image/people/player_0032/",hp = 800, attack = 28,speed = 4,attack_dis = 100,attack_type = 1,cd = 8  },
	[22] = { path = "image/people/player_0033/",hp = 400, attack = 30,speed = 4,attack_dis = 350,attack_type = 1,cd = 8  },
	[23] = { path = "image/people/player_0034/",hp = 400, attack = 30,speed = 4,attack_dis = 350,attack_type = 1,cd = 8  },
	[24] = { path = "image/people/player_0035/",hp = 700, attack = 30,speed = 4,attack_dis = 100,attack_type = 1,cd = 8  },
	[25] = { path = "image/people/player_0038/",hp = 800, attack = 30,speed = 5,attack_dis = 100,attack_type = 1,cd = 9  },
	[26] = { path = "image/people/player_0039/",hp = 1200, attack = 20,speed = 2,attack_dis = 100,attack_type = 1,cd = 9  },
	[27] = { path = "image/people/player_0040/",hp = 600, attack = 30,speed = 3,attack_dis = 100,attack_type = 1,cd = 9  },
	[28] = { path = "image/people/player_0041/",hp = 800, attack = 40,speed = 4,attack_dis = 100,attack_type = 1,cd = 9  },
	[29] = { path = "image/people/player_0042/",hp = 1000, attack = 30,speed = 2,attack_dis = 100,attack_type = 1,cd = 9  },
	[30] = { path = "image/people/player_0043/",hp = 1000, attack = 35,speed = 3,attack_dis = 100,attack_type = 1,cd = 9  },


}


chengbao_config.build = {
	[1] = { path = "image/play/ta.png",hp = 3000 }
}

chengbao_config.enemy = {
	[1] = { path = "image/people/player_0005/",hp = 10000, attack = 20,speed = 2,attack_dis = 100,attack_type = 1 },
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