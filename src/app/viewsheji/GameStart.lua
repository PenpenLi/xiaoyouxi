
local GameStart = class( "GameStart",BaseLayer )


function GameStart:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameStart.super.ctor( self,param.name )

	self:addCsb( "csbheji/csbdating/Hall.csb" )

	self:addNodeClick( self.ButtonSanGuo,{
		endCallBack = function ()
			self:clickSanGuo()
		end
	})

	self:addNodeClick( self.ButtonTwentyOne,{
		endCallBack = function ()
			self:clickTwentyOne()
		end
	})

	self:addNodeClick( self.ButtonGongZhu,{
		endCallBack = function ()
			self:clickZhiPai()
		end
	})
end



function GameStart:onEnter()
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	-- G_GetModel( "Model_Sound" ):playBgMusic()
end

function GameStart:clickSanGuo()
	removeUIFromScene( UIDefine.HEJI_KEY.Start_UI )
	addUIToScene( UIDefine.HEJI_KEY.SanGuo_UI )
end

function GameStart:clickTwentyOne()
	removeUIFromScene( UIDefine.HEJI_KEY.Start_UI )
	addUIToScene( UIDefine.HEJI_KEY.GameTwentyOne_UI )
end

function GameStart:clickZhiPai()
	removeUIFromScene( UIDefine.HEJI_KEY.Start_UI )
	addUIToScene( UIDefine.HEJI_KEY.GameZhiPai_UI,{ level = 1 } )
end

return GameStart