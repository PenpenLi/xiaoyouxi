

local chengbao_config = {}

chengbao_config.soldier = {

	[1] = { path = "image/people/player_0001/",hp = 10000, attack = 20,speed = 2,attack_dis = 100,attack_type = 1,cd = 3 },
	[2] = { path = "image/people/player_0002/",hp = 10000, attack = 20,speed = 2,attack_dis = 150,attack_type = 2 },


}


chengbao_config.build = {
	[1] = { path = "image/play/ta.png",hp = 3000 }
}

chengbao_config.enemy = {
	[1] = { path = "image/people/player_0005/",hp = 10000, attack = 20,speed = 2,attack_dis = 100,attack_type = 1 },
	-- [2] = { path = "image/people/player_0005/",hp = 10000, attack = 20,speed = 2,attack_dis = 20,attack_type = 1 },
}


-- chengbao_config.enemyBuild = {
-- 	[1] = { path = "image/play/ta.png",hp = 3000 }
-- }








rawset(_G,"chengbao_config",chengbao_config)