

local hunfight_config = {
	[1] = {
		player = {
			[1] = { id = 6,position = { x = 700,y = 800 },mode = 1 },
			[2] = { id = 6,position = { x = 700,y = 650 },mode = 1 },
			[3] = { id = 6,position = { x = 700,y = 500 },mode = 1 },
			[4] = { id = 6,position = { x = 700,y = 350 },mode = 1 },
			[5] = { id = 6,position = { x = 500,y = 800 },mode = 1 },
			[6] = { id = 6,position = { x = 500,y = 350 },mode = 1 },
			[7] = { id = 3,position = { x = 500,y = 580 },mode = 2 },
			[8] = { id = 8,position = { x = 300,y = 800 },mode = 1 },
			[9] = { id = 8,position = { x = 300,y = 650 },mode = 1 },
			[10] = { id = 8,position = { x = 300,y = 500 },mode = 1 },
			[11] = { id = 8,position = { x = 300,y = 350 },mode = 1 },
		},
		enemy = {
			[1] = { id = 7,position = { x = 1200,y = 800 },mode = 1 },
			[2] = { id = 7,position = { x = 1200,y = 650 },mode = 1 },
			[3] = { id = 7,position = { x = 1200,y = 500 },mode = 1 },
			[4] = { id = 7,position = { x = 1200,y = 350 },mode = 1 },
			[5] = { id = 7,position = { x = 1400,y = 800 },mode = 1 },
			[6] = { id = 7,position = { x = 1400,y = 650 },mode = 1 },
			[7] = { id = 7,position = { x = 1400,y = 500 },mode = 1 },
			[8] = { id = 7,position = { x = 1400,y = 350 },mode = 1 },
			[9] = { id = 5,position = { x = 1600,y = 500 },mode = 2 },
		}
	}
}



rawset(_G, "hunfight_config", hunfight_config)