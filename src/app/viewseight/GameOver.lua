
local NodePoker = import(".NodePoker")
local NodePlayer = import( ".NodePlayer" )
local GameOver = class( "GameOver",BaseLayer )

function GameOver:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameOver.super.ctor( self,param.name )

	self:addCsb( "csbeight/Over.csb" )

	self._result = param.data.result

	self:addNodeClick( self.ButtonNext,{
		endCallBack = function ()
			self:next()
		end
	})

	self:loadUi()
end

function GameOver:loadUi()
	for i = 1,4 do
		local player = NodePlayer.new( i )
		self["NodeJqr"..i]:addChild( player )
		if #self._result[i] == 0 then
			player:setCoinString( 30 )
		else
			local addCoin = #self._result[i] * 5
			player:setCoinString( -addCoin )
		end
	end
	for i = 1,4 do
		for j = 1,#self._result[i] do
			local poker = NodePoker.new( self,self._result[i][j] )
			self["NodePoker"..i]:addChild( poker )
			poker:setPositionX( ( j - 1 ) * 20 )
			poker:showPoker()
		end
	end
end

function GameOver:onEnter()
	GameOver.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
end

function GameOver:next()
	local coin = G_GetModel("Model_Eight"):getCoin()
	if coin > 0 then
		removeUIFromScene( UIDefine.EIGHT_KEY.Over_UI )
		removeUIFromScene( UIDefine.EIGHT_KEY.Play_UI )
		addUIToScene( UIDefine.EIGHT_KEY.Play_UI )
	else
		removeUIFromScene( UIDefine.EIGHT_KEY.Over_UI )
		removeUIFromScene( UIDefine.EIGHT_KEY.Play_UI )
		addUIToScene( UIDefine.EIGHT_KEY.Start_UI )
		addUIToScene( UIDefine.EIGHT_KEY.Shop_UI )
	end
end





return GameOver