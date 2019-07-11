

local GameOver = class( "GameOver",BaseLayer )

function GameOver:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameOver.super.ctor( self,param.name )

	self._layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ))
	self:addChild( self._layer )

	self:addCsb( "End.csb" )

	self:addNodeClick( self.ButtonMenu,{
		endCallBack = function ()
			self:menu()
		end
	})
	self:addNodeClick( self.ButtonPlayAgain,{
		endCallBack = function ( )
			self:playAgain()
		end
	})

end

function GameOver:menu( ... )
	-- body
end

function GameOver:playAgain( ... )
	-- body
end

function GameOver:onEnter()
	GameOver.super.onEnter( self )
	casecadeFadeInNode( self._layer,0.5,150 )
	casecadeFadeInNode( self._csbNode,0.5 )

	self:loadUi()
end

function GameOver:loadUi( ... )
	
end


return GameOver