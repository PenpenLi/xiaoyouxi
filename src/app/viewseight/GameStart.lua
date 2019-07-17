
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
end

function GameStart:onEnter()
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )
end

function GameStart:play()
	-- body
end

function GameStart:help()
	-- body
end

function GameStart:store()
	-- body
end






















return GameStart