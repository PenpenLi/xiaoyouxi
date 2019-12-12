local rpgfight_config = {
	[1] = {
		player = {
			[1] = { id = 1,position = { x = 1,y = 1 },mode = 1 },
			
		},
		enemy = {
			[1] = { id = 1,position = { x = 1200,y = 800 },mode = 1 },
		}
	}
}



rawset(_G, "rpgfight_config", rpgfight_config)