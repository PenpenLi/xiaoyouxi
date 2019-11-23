
local GameFight = class("GameFight",BaseLayer)

function GameFight:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameFight.super.ctor( self,param.name )

    self:addCsb( "csbfensuizhan/FightLayer.csb" )
end













return GameFight