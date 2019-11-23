

local Person = class("Person",BaseNode)

Person.ACTION_TYPE = 
{
	IDLE = 0,
	RUN = 1,
	ATTACK = 2,
	DEAD = 4,
}
function Person:ctor( parent,personPath )
	-- body
end











return Person
