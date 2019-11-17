

local GameHelp = class( "GameHelp",BaseLayer )

function GameHelp:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameHelp.super.ctor( self,param.name )

	self:addCsb( "csbeight/Help.csb" )

	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end
	})
end

function GameHelp:close()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Eight_Help_UI )
end

function GameHelp:onEnter()
	GameHelp.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end

return GameHelp