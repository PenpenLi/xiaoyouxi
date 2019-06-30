
local NodePoker = import(".NodePoker")
local GamePlay  = class("GamePlay",BaseLayer)

function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbzuqiu/Play.csb" )
end


function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
end
















return GamePlay