

local country_config = {}

country_config.europe  = {
	[1]		= { icon = "image/flag/Englandgq.png",		text = "image/flag/England.png" 	 },
	[2]		= { icon = "image/flag/Ltalygq.png",		text = "image/flag/Ltaly.png" 		 },
	[3]		= { icon = "image/flag/Spaingq.png",		text = "image/flag/Spain.png" 		 },
	[4]		= { icon = "image/flag/Portugalgq.png",		text = "image/flag/Portugal.png" 	 },
	[5]		= { icon = "image/flag/Germanygq.png",		text = "image/flag/Germany.png" 	 },
	[6]		= { icon = "image/flag/Swedengq.png",		text = "image/flag/Sweden.png" 		 },
	[7]		= { icon = "image/flag/Lrelandgq.png",		text = "image/flag/Lreland.png" 	 },
	[8]		= { icon = "image/flag/Croatiagq.png",		text = "image/flag/Croatia.png" 	 },
	[9]		= { icon = "image/flag/Poland-1.png",		text = "image/flag/Poland.png" 		 },
	[10]	= { icon = "image/flag/Czechgq.png",		text = "image/flag/Czech.png" 		 },
	[11]	= { icon = "image/flag/Denmarkgq.png",		text = "image/flag/Denmark.png" 	 },
	[12]	= { icon = "image/flag/Greecegq.png",		text = "image/flag/Greece.png" 		 },
	[13]	= { icon = "image/flag/Netherlandsgq.png",	text = "image/flag/Netherlands.png" },
	[14]	= { icon = "image/flag/Ukrainegq.png",		text = "image/flag/Ukraine.png" 	 },
	[15]	= { icon = "image/flag/Russiagq.png",		text = "image/flag/Russia.png" 		 },
	[16]	= { icon = "image/flag/Francegq.png",		text = "image/flag/France.png" 		 },
	
}

-- ai 随机一个国家球队 (去掉玩家选中的球队中剩余的随机)
country_config.getAiRandomCountry = function( playerCountryIndex )
	assert( playerCountryIndex," !! playerCountryIndex is nil !! " )
	local country_index = {}
	for i = 1,#country_config.europe do
		if i ~= playerCountryIndex then
			table.insert( country_index,i )
		end
	end
	local index = random( 1,#country_index )
	return country_index[index]
end

rawset(_G,"country_config",country_config)