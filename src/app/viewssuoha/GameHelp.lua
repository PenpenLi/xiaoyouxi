

local GameHelp = class( "GameHelp",BaseLayer )


function GameHelp:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameHelp.super.ctor( self,param.name )

	self._layer = cc.LayerColor:create()
	self:addChild( self._layer )

	self:addCsb( "Help.csb" )



	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end
	})
end

function GameHelp:close()
	removeUIFromScene( UIDefine.SUOHA_KEY.Help_UI )
end

function GameHelp:onEnter()
	GameHelp.super.onEnter( self )
	casecadeFadeInNode( self._layer,0.5,150 )
	casecadeFadeInNode( self._csbNode,0.5 )
end



return GameHelp