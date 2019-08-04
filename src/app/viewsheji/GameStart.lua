
local GameStart = class( "GameStart",BaseLayer )


function GameStart:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameStart.super.ctor( self,param.name )

	self:addCsb( "csbheji/csbdating/Hall.csb" )

	self:addNodeClick( self.ButtonSet,{
		endCallBack = function ()
			self:musicSet()
		end
	})
	self:addNodeClick( self.ButtonCharge,{
		endCallBack = function ()
			self:store()
		end
	})
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

	
	self:loadUi()
end

function GameStart:loadUi()
	local coin = G_GetModel("Model_Heji"):getInstance():getCoin()
	self.TextCoin:setString( coin )
end



function GameStart:onEnter()
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	if G_GetModel("Model_Sound"):isMusicOpen() then
        audio.playMusic("csbheji/csbdating/dtmp3/music.mp3",true)
    end

    -- 注册监听
	self:addMsgListener( InnerProtocol.INNER_EVENT_HEJI_BUY_COIN,function( event )
		self:loadUi()
	end )
	-- G_GetModel( "Model_Sound" ):playBgMusic()
end

function GameStart:clickSanGuo()
	local coin = G_GetModel("Model_Heji"):getInstance():getCoin()
	if coin > 0 then
		G_GetModel("Model_Sound"):stopPlayBgMusic()
		removeUIFromScene( UIDefine.HEJI_KEY.Start_UI )
		addUIToScene( UIDefine.HEJI_KEY.SanGuo_UI )
	else
		addUIToScene( UIDefine.HEJI_KEY.Shop_UI )
	end
end

function GameStart:clickTwentyOne()
	G_GetModel("Model_Sound"):stopPlayBgMusic()
	removeUIFromScene( UIDefine.HEJI_KEY.Start_UI )
	addUIToScene( UIDefine.HEJI_KEY.GameTwentyOne_UI )
end

function GameStart:clickZhiPai()
	G_GetModel("Model_Sound"):stopPlayBgMusic()
	removeUIFromScene( UIDefine.HEJI_KEY.Start_UI )
	addUIToScene( UIDefine.HEJI_KEY.GameZhiPai_UI,{ level = 1 } )
end

function GameStart:musicSet()
	addUIToScene( UIDefine.HEJI_KEY.Voice_UI )
end
function GameStart:store()
	addUIToScene( UIDefine.HEJI_KEY.Shop_UI )
end

return GameStart