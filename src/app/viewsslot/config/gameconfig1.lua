
local gameconfig1 = {}

gameconfig1.level = {
	symbol_width		= 163,
	symbol_height       = 163,
	view_count          = 3,
	max_size_type       = 1,
	speed               = 50,	-- 每一帧移动的像素
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
		[90]    = 1, -- scattle
		[92]    = 1, -- wild
		[94]    = 1, -- special
	},
	roll_list1 = { 
		7,2,8,1,5,0,6,94,94,94,7,1,5,2,8,1,7,2,8,90,4,1,7,94,94,8,2,7,1,8,90,2,8,3,7,2,8,1,8,0,5,1,94,94,
	    94,6,2,7,0,8,3,5,7,2,5,8,94,94,94,8,2,7,5,0,5,8,1,7,4,1,5,7,90,5,0,8,2,5,8,2,94,94,8,5,2,8,3,7,2,
	    5,3,6,90,5,1,8,0,5,6,0,8,3,7,90,2,6,2,5,8,0,5,90,8,0,7,94,94,94,2,5,4,7,1,8,2,5,1,8,4,2,7,1,94,94,
	    94,1,8,2,4,5,1,8,2,5,3,7,4,8,1,94,94,2,5,1,8,2,7,4,5,2,4,7,1,5,94,94,94,5,2,8,1,7,2,5,1,7,2,5,3,7,
	    94,94,7,1,8,1,5,0,7,3,5,2,7,1,6,3,8,4,7,7
	},
	roll_list2 = { 
		7,3,4,7,90,7,0,6,3,5,1,6,4,3,5,4,0,6,3,4,94,94,94,7,92,92,92,92,92,92,92,6,3,6,90,4,1,5,3,4,1,6,3,5,
	    90,4,0,6,3,8,90,6,1,4,7,1,6,94,94,6,4,3,6,4,0,6,3,6,92,92,92,92,92,92,92,6,2,4,3,7,2,94,94,94,3,7,0,
	    4,90,1,4,0,8,2,4,3,6,0,4,1,6,92,92,92,92,92,92,92,92,0,7,3,4,1,6,3,94,94,4,0,6,1,4,0,8,2,6,0,94,94,8,
	    3,4,6,1,5,3,8,1,6,92,92,92,92,92,92,92,92,0,4,1,6,3,4,0,6,3,94,94,0,3,90,6,3,6,1,4,3,6,92,92,92,92,92,
	    92,92,4,7,3,6,1,4,6,0,94,94,4,3,6,2,4,8,3,4,8,3,8,1,4,7
	},

	roll_list3 = { 
	    6,3,6,3,4,90,1,6,3,94,94,94,3,4,6,2,3,4,0,7,3,4,2,6,92,92,92,92,92,92,92,92,5,90,4,2,94,94,4,3,6,1,4,2,
	    90,3,5,1,6,7,1,94,94,94,8,2,5,0,6,3,6,6,1,6,3,5,0,6,92,92,92,92,92,92,92,92,92,5,3,7,1,4,0,6,0,5,4,2,94,
	    94,94,2,5,2,6,3,5,6,1,4,90,6,1,4,6,3,7,2,6,1,4,5,2,6,4,92,92,92,92,92,92,92,92,4,6,0,94,94,0,8,4,2,6,3,94,
	    94,3,8,2,6,1,4,3,6,1,4,3,7,4,1,6,0,5,3,4,3,8,2,6,94,94,6,3,6,2,4,3,4,0,5,90,4,6,3,4,92,92,92,92,92,92,92,
	    92,4,7,0,2,94,94,0,6,90,3,4,2,6,1,4,3,6
	},

	roll_list4 = { 
	    8,2,4,2,5,3,8,2,94,94,1,5,90,4,1,5,3,8,3,5,94,94,94,3,7,92,92,92,92,92,92,90,4,2,6,1,4,2,5,3,6,90,5,2,6,3,
	    7,7,3,4,0,7,2,5,94,94,6,3,5,3,8,0,6,3,5,1,94,94,6,7,3,7,1,6,3,4,2,6,5,1,6,94,94,94,7,0,4,3,8,2,92,92,92,92,
	    92,92,7,1,6,3,7,3,5,1,7,3,5,2,6,1,5,3,94,94,5,0,6,2,5,4,0,7,2,6,4,0,5,2,8,1,5,1,8,92,92,92,92,92,92,92,3,5,
	    3,4,8,90,7,0,5,2,6,3,5,3,8,1,6,3,5,1,7,3,94,94,8,92,92,92,92,92,92,92,0,8,90,0,6,1,5,3,4,8,90,5,2,5,94,
	    94,2,6,1,5,4,8,2,6,2,8,3,8
	},

	roll_list5 = {
	    6,8,4,0,7,4,5,0,94,94,94,8,7,90,8,0,6,1,94,94,4,3,5,2,8,94,94,4,6,1,92,92,92,92,92,4,6,1,7,3,5,1,6,3,8,4,5,3,
	    6,92,92,92,92,92,4,5,0,7,2,6,0,8,94,94,2,5,2,7,3,8,2,6,0,7,90,1,5,2,5,1,4,7,92,92,92,92,92,2,5,4,0,90,8,0,7,3,
	    5,4,94,94,94,7,6,3,4,5,8,3,5,90,8,2,6,4,1,4,5,2,5,6,1,7,94,94,8,2,8,1,5,3,4,6,3,7,4,0,7,90,5,0,6,3,7,92,92,92,
	    92,92,5,3,8,4,7,2,6,4,0,5,2,6,4,3,7,1,90,1,8,2,3,6,2,7,4,2,90,1,8,4,7,0,94,94,2,6,3,7,3,5,3,94,94,2,6,0,92,92,
	    92,92,4,4
	},

}


gameconfig1.plist = {
	{ "csbslot/wolfLighting/Pharaoh1.png","csbslot/wolfLighting/Pharaoh1.plist" },
	{ "csbslot/wolfLighting/Pharaoh2.png","csbslot/wolfLighting/Pharaoh2.plist" },
	{ "csbslot/wolfLighting/Pharaoh3.png","csbslot/wolfLighting/Pharaoh3.plist" },
	{ "csbslot/wolfLighting/Pharaoh4.png","csbslot/wolfLighting/Pharaoh4.plist" },
	{ "csbslot/wolfLighting/Pharaoh5.png","csbslot/wolfLighting/Pharaoh5.plist" },
	{ "csbslot/wolfLighting/Pharaoh6.png","csbslot/wolfLighting/Pharaoh6.plist" },
	{ "csbslot/wolfLighting/Pharaoh7.png","csbslot/wolfLighting/Pharaoh7.plist" },
}


gameconfig1.mp3 = {
	music = {
		
	},
	effect = {
	}
}


gameconfig1.image = {
	"csbslot/wolfLighting/ui/pay_table_1.png",
	"csbslot/wolfLighting/ui/pay_table_2.png",
	"csbslot/wolfLighting/ui/pay_table_3.png",
	"csbslot/wolfLighting/ui/pay_table_4.png",
	"csbslot/wolfLighting/ui/pay_table_5.png",
	"csbslot/wolfLighting/ui/pay_table_6.png",
	"csbslot/wolfLighting/ui/pay_table_7.png",
	"csbslot/wolfLighting/ui/pay_table_bg.png",
	"csbslot/wolfLighting/ui/Wolflight_bg.png",
	"csbslot/wolfLighting/ui/wolfLight_freespin_tanban.png",
	"csbslot/wolfLighting/ui/wolfLight_freespin_tanban4.png",
}

gameconfig1.symbol_csb = {
	[8] 	 	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_1.csb", resourcetype = "csb",count = 15 },
	[7]		 	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_2.csb", resourcetype = "csb",count = 15 },
	[6]		 	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_3.csb", resourcetype = "csb",count = 15 },
	[5]		 	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_4.csb", resourcetype = "csb",count = 15 },
	[4]		 	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_5.csb", resourcetype = "csb",count = 15 },
	[3]		 	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_6.csb", resourcetype = "csb",count = 15 },
	[2]		 	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_7.csb", resourcetype = "csb",count = 15 },
	[1]		 	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_8.csb", resourcetype = "csb",count = 15 },
	[0]		 	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_9.csb", resourcetype = "csb",count = 15 },
	[90]     	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_Scatter.csb", resourcetype = "csb",count = 15 },
	[92]     	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_Wild.csb", resourcetype = "csb",count = 20 },
	[94]     	= { file =  "csbslot/wolfLighting/Socre_Pharaoh_Special_1.csb", resourcetype = "csb",count = 15 },
}

gameconfig1.effect_csb = {
	["paomadeng"] 	= { file = "csbslot/wolfLighting/WinFramePharaoh.csb",	resourcetype = "csb",count = 15 },	-- 跑马灯
	["kuaigun"]     = { file = "csbslot/wolfLighting/Pharaoh_Reel_Run.csb",resourcetype = "csb",count = 5 },    -- 快滚特效
}





return gameconfig1