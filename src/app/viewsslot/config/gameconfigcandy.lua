
local gameconfigcandy = {}

gameconfigcandy.level = {
	reel_count          = 5,
	symbol_width		= 208,
	symbol_height       = 163,
	view_count          = 3,
	max_size_type       = 1,
	speed               = 25,	-- 每一帧移动的像素
	scattle_id          = 9,
	wild_id             = 10,
	special_id          = 11,
	size_type           = {
		[0]		= 1,
		[1]     = 1,
		[2]     = 1,
		[3]		= 1,
		[4]     = 1,
		[5]     = 1,
		[6]     = 1,
		[7]     = 1,
		[8]     = 1,
		[9]     = 1, -- scattle
		[10]    = 1, -- wild
		[11]    = 1, -- special
	},
	roll_list1 = { 
		7,2,8,1,5,0,6,11,11,11,7,1,5,2,8,1,7,2,8,9,4,1,7,11,11,8,2,7,1,8,9,2,8,3,7,2,8,1,8,0,5,1,11,11,
	    11,6,2,7,0,8,3,5,7,2,5,8,11,11,11,8,2,7,5,0,5,8,1,7,4,1,5,7,9,5,0,8,2,5,8,2,11,11,8,5,2,8,3,7,2,
	    5,3,6,9,5,1,8,0,5,6,0,8,3,7,9,2,6,2,5,8,0,5,9,8,0,7,11,11,11,2,5,4,7,1,8,2,5,1,8,4,2,7,1,11,11,
	    11,1,8,2,4,5,1,8,2,5,3,7,4,8,1,11,11,2,5,1,8,2,7,4,5,2,4,7,1,5,11,11,11,5,2,8,1,7,2,5,1,7,2,5,3,7,
	    11,11,7,1,8,1,5,0,7,3,5,2,7,1,6,3,8,4,7,7
	},
	roll_list2 = { 
		7,3,4,7,9,7,0,6,3,5,1,6,4,3,5,4,0,6,3,4,11,11,11,7,10,10,10,10,10,10,10,6,3,6,9,4,1,5,3,4,1,6,3,5,
	    9,4,0,6,3,8,9,6,1,4,7,1,6,11,11,6,4,3,6,4,0,6,3,6,10,10,10,10,10,10,10,6,2,4,3,7,2,11,11,11,3,7,0,
	    4,9,1,4,0,8,2,4,3,6,0,4,1,6,10,10,10,10,10,10,10,10,0,7,3,4,1,6,3,11,11,4,0,6,1,4,0,8,2,6,0,11,11,8,
	    3,4,6,1,5,3,8,1,6,10,10,10,10,10,10,10,10,0,4,1,6,3,4,0,6,3,11,11,0,3,9,6,3,6,1,4,3,6,10,10,10,10,10,
	    10,10,4,7,3,6,1,4,6,0,11,11,4,3,6,2,4,8,3,4,8,3,8,1,4,7
	},

	roll_list3 = { 
	    6,3,6,3,4,9,1,6,3,11,11,11,3,4,6,2,3,4,0,7,3,4,2,6,10,10,10,10,10,10,10,10,5,9,4,2,11,11,4,3,6,1,4,2,
	    9,3,5,1,6,7,1,11,11,11,8,2,5,0,6,3,6,6,1,6,3,5,0,6,10,10,10,10,10,10,10,10,10,5,3,7,1,4,0,6,0,5,4,2,11,
	    11,11,2,5,2,6,3,5,6,1,4,9,6,1,4,6,3,7,2,6,1,4,5,2,6,4,10,10,10,10,10,10,10,10,4,6,0,11,11,0,8,4,2,6,3,11,
	    11,3,8,2,6,1,4,3,6,1,4,3,7,4,1,6,0,5,3,4,3,8,2,6,11,11,6,3,6,2,4,3,4,0,5,9,4,6,3,4,10,10,10,10,10,10,10,
	    10,4,7,0,2,11,11,0,6,9,3,4,2,6,1,4,3,6
	},

	roll_list4 = { 
	    8,2,4,2,5,3,8,2,11,11,1,5,9,4,1,5,3,8,3,5,11,11,11,3,7,10,10,10,10,10,10,9,4,2,6,1,4,2,5,3,6,9,5,2,6,3,
	    7,7,3,4,0,7,2,5,11,11,6,3,5,3,8,0,6,3,5,1,11,11,6,7,3,7,1,6,3,4,2,6,5,1,6,11,11,11,7,0,4,3,8,2,10,10,10,10,
	    10,10,7,1,6,3,7,3,5,1,7,3,5,2,6,1,5,3,11,11,5,0,6,2,5,4,0,7,2,6,4,0,5,2,8,1,5,1,8,10,10,10,10,10,10,10,3,5,
	    3,4,8,9,7,0,5,2,6,3,5,3,8,1,6,3,5,1,7,3,11,11,8,10,10,10,10,10,10,10,0,8,9,0,6,1,5,3,4,8,9,5,2,5,11,
	    11,2,6,1,5,4,8,2,6,2,8,3,8
	},

	roll_list5 = {
	    6,8,4,0,7,4,5,0,11,11,11,8,7,9,8,0,6,1,11,11,4,3,5,2,8,11,11,4,6,1,10,10,10,10,10,4,6,1,7,3,5,1,6,3,8,4,5,3,
	    6,10,10,10,10,10,4,5,0,7,2,6,0,8,11,11,2,5,2,7,3,8,2,6,0,7,9,1,5,2,5,1,4,7,10,10,10,10,10,2,5,4,0,9,8,0,7,3,
	    5,4,11,11,11,7,6,3,4,5,8,3,5,9,8,2,6,4,1,4,5,2,5,6,1,7,11,11,8,2,8,1,5,3,4,6,3,7,4,0,7,9,5,0,6,3,7,10,10,10,
	    10,10,5,3,8,4,7,2,6,4,0,5,2,6,4,3,7,1,9,1,8,2,3,6,2,7,4,2,9,1,8,4,7,0,11,11,2,6,3,7,3,5,3,11,11,2,6,0,10,10,
	    10,10,4,4
	},

}

gameconfigcandy.lines = {
	[1]  = {2,2,2,2,2},
	[2]  = {3,3,3,3,3},
	[3]  = {1,1,1,1,1},
	[4]  = {3,2,1,2,3},
	[5]  = {1,2,3,2,1},
	[6]  = {2,3,3,3,2},
	[7]  = {2,1,1,1,2},
	[8]  = {3,3,3,1,1},
	[9]  = {1,1,2,3,3},
	[10] = {2,1,2,3,2},
	[11] = {2,3,2,1,2},
	[12] = {3,2,2,2,3},
	[13] = {1,2,2,2,1},
	[14] = {3,2,3,2,3},
	[15] = {1,2,1,2,1},
	[16] = {2,2,3,2,2},
	[17] = {2,2,1,2,2},
	[18] = {3,3,1,3,3},
	[19] = {1,1,3,1,1},
	[20] = {3,1,1,1,3},
	[21] = {1,3,3,3,1},
	[22] = {2,1,3,1,2},
	[23] = {2,3,1,3,2},
	[24] = {3,1,3,1,3},
	[25] = {1,3,1,3,1},
	[26] = {1,3,2,1,3},
	[27] = {3,1,2,3,1},
	[28] = {3,1,2,1,3},
	[29] = {1,3,2,3,1},
	[30] = {1,2,3,3,1},
	[31] = {3,2,1,1,2},
	[32] = {3,3,1,1,1},
	[33] = {1,1,3,3,3},
	[34] = {2,3,1,2,1},
	[35] = {2,1,3,2,3},
	[36] = {3,2,3,2,1},
	[37] = {1,2,1,2,3},
	[38] = {2,1,1,3,3},
	[39] = {3,3,2,2,1},
	[40] = {1,1,2,2,3},
	[41] = {1,3,3,3,3},
	[42] = {3,1,1,1,1},
	[43] = {1,1,1,1,3},
	[44] = {3,3,3,3,1},
	[45] = {2,3,2,3,2},
	[46] = {2,1,2,1,2},
	[47] = {3,2,1,1,1},
	[48] = {1,2,3,3,3},
	[49] = {3,2,2,2,2},
	[50] = {1,2,2,2,2},
}


gameconfigcandy.plist = {
	{ "csbslot/newcandy/NewCandy_BGUI_Plist1.png",			"csbslot/newcandy/NewCandy_BGUI_Plist1.plist"     },
	{ "csbslot/newcandy/NewCandy_Effect_Plist.png",			"csbslot/newcandy/NewCandy_Effect_Plist.plist"    },
	{ "csbslot/newcandy/NewCandy_Paytable_Plist.png",		"csbslot/newcandy/NewCandy_Paytable_Plist.plist"  },
	{ "csbslot/newcandy/NewCandy_Symbol_UI_Plist.png",		"csbslot/newcandy/NewCandy_Symbol_UI_Plist.plist" },
	{ "csbslot/newcandy/NewCandy_UI_Plist1.png",			"csbslot/newcandy/NewCandy_UI_Plist1.plist"       },
	{ "csbslot/newcandy/NewCandy_UI_Plist2.png",			"csbslot/newcandy/NewCandy_UI_Plist2.plist"       },
}


gameconfigcandy.mp3 = {
	music = {
		
	},
	effect = {
	}
}


gameconfigcandy.image = {
	
}

gameconfigcandy.symbol_csb = {
	[8] 	 	= { file =  "csbslot/NewCandy/Socre_NewCandy_1.csb", resourcetype = "csb",count = 15 },
	[7]		 	= { file =  "csbslot/NewCandy/Socre_NewCandy_2.csb", resourcetype = "csb",count = 15 },
	[6]		 	= { file =  "csbslot/NewCandy/Socre_NewCandy_3.csb", resourcetype = "csb",count = 15 },
	[5]		 	= { file =  "csbslot/NewCandy/Socre_NewCandy_4.csb", resourcetype = "csb",count = 15 },
	[4]		 	= { file =  "csbslot/NewCandy/Socre_NewCandy_5.csb", resourcetype = "csb",count = 15 },
	[3]		 	= { file =  "csbslot/NewCandy/Socre_NewCandy_6.csb", resourcetype = "csb",count = 15 },
	[2]		 	= { file =  "csbslot/NewCandy/Socre_NewCandy_7.csb", resourcetype = "csb",count = 15 },
	[1]		 	= { file =  "csbslot/NewCandy/Socre_NewCandy_8.csb", resourcetype = "csb",count = 15 },
	[0]		 	= { file =  "csbslot/NewCandy/Socre_NewCandy_9.csb", resourcetype = "csb",count = 15 },
	[9]     	= { file =  "csbslot/NewCandy/Socre_NewCandy_Scattle.csb", resourcetype = "csb",count = 15 },
	[10]     	= { file =  "csbslot/NewCandy/Socre_NewCandy_Wild.csb", resourcetype = "csb",count = 20 },
	[11]     	= { file =  "csbslot/NewCandy/Socre_NewCandy_candy_1x1.csb", resourcetype = "csb",count = 15 },
}

gameconfigcandy.effect_csb = {
	["paomadeng"] 	= { file = "csbslot/newcandy/WinFrameNewCandy.csb",	resourcetype = "csb",count = 15 },	-- 跑马灯
	["kuaigun"]     = { file = "csbslot/newcandy/NewCandy_Reel_Run.csb",resourcetype = "csb",count = 5 },    -- 快滚特效
}

gameconfigcandy.bet = {
	[0]  = {
		-- { count = 2,bet = 2 },
		{ count = 3,bet = 10 },
		{ count = 4,bet = 50 },
		{ count = 5,bet = 150 }
	},
	[1]  = {
		{ count = 3,bet = 5 },
		{ count = 4,bet = 30 },
		{ count = 5,bet = 100 }
	},
	[2]  = {
		{ count = 3,bet = 5 },
		{ count = 4,bet = 25 },
		{ count = 5,bet = 100 }
	},
	[3]  = {
		{ count = 3,bet = 5 },
		{ count = 4,bet = 25 },
		{ count = 5,bet = 100 }
	},
	[4]  = {
		{ count = 3,bet = 5 },
		{ count = 4,bet = 20 },
		{ count = 5,bet = 75 }
	},
	[5]  = {
		{ count = 3,bet = 5 },
		{ count = 4,bet = 10 },
		{ count = 5,bet = 50 }
	},
	[6]  = {
		{ count = 3,bet = 5 },
		{ count = 4,bet = 10 },
		{ count = 5,bet = 50 }
	},
	[7]  = {
		{ count = 3,bet = 5 },
		{ count = 4,bet = 10 },
		{ count = 5,bet = 50 }
	},
	[8]  = {
		{ count = 3,bet = 5 },
		{ count = 4,bet = 10 },
		{ count = 5,bet = 50 }
	},
}



return gameconfigcandy