

local chengbao_config = {}

chengbao_config.soldier = {
	[1] = { path = "image/people/player_0001/",hp = 100, attack = 20,speed = 5,attack_dis = 5,attack_type = 1 },
	[2] = { path = "image/people/player_0002/",hp = 100, attack = 20,speed = 5,attack_dis = 30,attack_type = 2 },

}


chengbao_config.enemy = {
	[1] = { path = "image/people/player_0004/",hp = 100, attack = 20,speed = 5,attack_dis = 10,attack_type = 1 },
	[2] = { path = "image/people/player_0005/",hp = 100, attack = 20,speed = 5,attack_dis = 5,attack_type = 1 },
}









rawset(_G,"chengbao_config",chengbao_config)