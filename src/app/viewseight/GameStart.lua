
local GameStart = class( "GameStart",BaseLayer )


function GameStart:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameStart.super.ctor( self,param.name )

	self:addCsb( "csbeight/Start.csb" )

	self:addNodeClick( self.ButtonPlay,{
		endCallBack = function ()
			self:play()
		end
	})
	self:addNodeClick( self.ButtonHelp,{
		endCallBack = function ()
			self:help()
		end
	})
	self:addNodeClick( self.ButtonStore,{
		endCallBack = function ()
			self:store()
		end
	})

	self:loadCoin()
end

function GameStart:loadCoin()
	G_GetModel("Model_Eight"):getInstance():getCoin()
end

function GameStart:onEnter()
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	G_GetModel( "Model_Sound" ):playBgMusic()

end

function GameStart:play()
	-- addUIToScene( UIDefine.EIGHT_KEY.Stop_UI )
end

function GameStart:help()
	addUIToScene( UIDefine.EIGHT_KEY.Help_UI )
end

function GameStart:store()
	addUIToScene( UIDefine.EIGHT_KEY.Shop_UI )
end






















return GameStart