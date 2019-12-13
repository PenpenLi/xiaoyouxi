local rpgfight_config = {
	[1] = {
		people = {
			[1] = { id = 1,position = { col = 1,row = 1 },mode = 1 }, -- mode 1:士兵 2:boss
			
		},
		enemy = {
			[1] = { id = 1,position = { col = 11,row = 6 },mode = 1 },
		}
	}
}



rawset(_G, "rpgfight_config", rpgfight_config)