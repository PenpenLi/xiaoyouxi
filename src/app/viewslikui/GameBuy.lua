

local GameBuy = class( "GameBuy",BaseLayer )


function GameBuy:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameBuy.super.ctor( self,param.name )
	self._index = param.data
	self._money = {
		6,12,18
	}
	self._coin = {
		300,600,1000
	}
	
	self:addCsb( "Buy.csb" )

	

	self:addNodeClick( self.ButtonYes,{
		endCallBack = function ()
			self:yes()
		end
	})
	self:addNodeClick( self.ButtonNo,{
		endCallBack = function ()
			self:no()
		end
	})

	self:loadUi()
end

function GameBuy:loadUi()
	-- print( "--------------= "..self._money[self._index] )
	if likui_config.language == 1 then
		self.Text:setString( string.format("%s元で%s円を買います？",self._money[self._index],self._coin[self._index]) )
	elseif likui_config.language == 2 then
		self.Text:setString( string.format("You will spend %s dollor \n to buy %s coin",self._money[self._index],self._coin[self._index]) )
	elseif likui_config.language == 3 then
		self.Text:setString( string.format("您将花费%s元购买%s金币",self._money[self._index],self._coin[self._index]) )
	end
	
end

function GameBuy:onEnter()
	GameBuy.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )

end

function GameBuy:yes()
	-- 调用sdk

    -- 这里是用于测试 请在调用完sdk后 回调 buyCoinCallBack 
    self:buyCoinCallBack()
end

function GameBuy:no()
	-- removeUIFromScene( UIDefine.LIKUI_KEY.Shop_UI )
	removeUIFromScene( UIDefine.LIKUI_KEY.Buy_UI )
end

function GameBuy:buyCoinCallBack()
	G_GetModel("Model_LiKui"):getInstance():setCoin( self._coin[self._index] )
	-- local coin = G_GetModel("Model_LiKui"):Instance():getCoin()
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_LIKUI_BUY )
end

return GameBuy