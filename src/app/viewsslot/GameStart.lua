

local GameStart = class( "GameStart",BaseLayer )

function GameStart:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameStart.super.ctor( self,param.name )

	self:addCsb( "csbslot/Start.csb" )

	-- 关卡1
	self:addNodeClick( self.ImageLevel1,{
		endCallBack = function ()
			self:clickGame1()
		end
	})

	-- --商店
	-- self:addNodeClick( self.ButtonStore,{
	-- 	endCallBack = function ()
	-- 		self:store()
	-- 	end
	-- })
end

function GameStart:loadCoin(  )
	-- local coin = G_GetModel("Model_SuoHa"):getInstance():getCoin()
end
function GameStart:onEnter( ... )
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	self:loadCoin()
	self:loadMusic()
end

function GameStart:loadMusic()
	-- local model = G_GetModel("Model_Sound"):getInstance()
	-- local is_open = model:isMusicOpen()
	-- if is_open then
	-- 	model:playBgMusic()
	-- end
end

function GameStart:clickGame1()
end

function GameStart:store()
	-- addUIToScene( UIDefine.SUOHA_KEY.Shop_UI )
end





return GameStart