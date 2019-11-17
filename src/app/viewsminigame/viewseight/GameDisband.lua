

local GameDisband = class( "GameDisband",BaseLayer )

function GameDisband:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameDisband.super.ctor( self,param.name )

	self:addCsb( "csbeight/Disband.csb" )

	self:addNodeClick( self.ButtonNext,{
		endCallBack = function ()
			self:next()
		end
	})
end

function GameDisband:next()
	removeUIFromScene( UIDefine.MINIGAME_KEY.Eight_Disband_UI )
	removeUIFromScene( UIDefine.MINIGAME_KEY.Eight_Play_UI )
	addUIToScene( UIDefine.MINIGAME_KEY.Eight_Play_UI )
end

function GameDisband:onEnter()
	GameDisband.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end







return GameDisband