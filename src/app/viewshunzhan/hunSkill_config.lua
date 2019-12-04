
--[[
perHurt:攻击减血百分比
cd:技能冷却时间
dis_collide:攻击范围，技能所在位置作用范围的半径
]]
local hunSkill_config = {
	[1] = { path = "skill/skill1.png",perHurt = 30,cd = 5,dis_collide = 100 },
	[2] = { path = "skill/skill2.png",perHurt = 30,cd = 5,time = 5,width = 600,height = 600,dis_collide = 200 },
	[3] = { path = "skill/add_hp.png",addHp = 50,cd = 5 }
}



rawset(_G, "hunSkill_config", hunSkill_config)