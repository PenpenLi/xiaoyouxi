

local GameHelp = class( "GameHelp",BaseLayer )

function GameHelp:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameHelp.super.ctor( self,param.name )

    local layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "Help.csb" )

    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() 
        	self:close() 
        end
    })
end

function GameHelp:onEnter()
	GameHelp.super.onEnter( self )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )

end

function GameHelp:close()
	removeUIFromScene( UIDefine.MINIGAME_KEY.ZhanDou_Help_UI )
end



return GameHelp