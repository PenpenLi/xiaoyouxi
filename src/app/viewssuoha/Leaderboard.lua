

local Leaderboard = class( "Leaderboard",BaseLayer )


function Leaderboard:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    Leaderboard.super.ctor( self,param.name )

    self:addCsb( "csbsuoha/Leaderboard.csb" )


end











return Leaderboard