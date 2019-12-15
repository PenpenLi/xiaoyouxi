local rpgfight_config = {
	[1] = {
		people = {
			[1] = { id = 1,position = { col = 1,row = 2 } },
			[2] = { id = 1,position = { col = 3,row = 2 } },
			[3] = { id = 5,position = { col = 2,row = 2 } },
			[4] = { id = 2,position = { col = 1,row = 5 } },
			[5] = { id = 4,position = { col = 1,row = 6 } },
			[6] = { id = 6,position = { col = 2,row = 6 } },
			[7] = { id = 7,position = { col = 3,row = 6 } },
			[8] = { id = 8,position = { col = 1,row = 3 } },
			[9] = { id = 3,position = { col = 1,row = 4 } },
		},
		enemy = {
			[1] = { id = 1,position = { col = 11,row = 1 } },
			[2] = { id = 1,position = { col = 11,row = 5 } },
			[3] = { id = 2,position = { col = 11,row = 4 } },
			[4] = { id = 2,position = { col = 11,row = 3 } },
			[5] = { id = 3,position = { col = 10,row = 3 } },
			[6] = { id = 4,position = { col = 10,row = 1 } },
			[7] = { id = 7,position = { col = 9,row = 6 } },
			[8] = { id = 8,position = { col = 9,row = 5 } },
			[9] = { id = 5,position = { col = 9,row = 4 } },
			[10] = { id = 6,position = { col = 9,row = 3 } },
		}
	}
}



rawset(_G, "rpgfight_config", rpgfight_config)