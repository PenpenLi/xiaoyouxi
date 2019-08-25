
local NodeMiniGame = import( "app.viewsslot.NodeMiniGame" )
local GameMini = class( "GameMini",BaseLayer )

function GameMini:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameMini.super.ctor( self,param.name )

	local layer = cc.LayerColor:create( cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer

    self._coin = 0

    self._num = {
    	3,
    	2,
    	1,
    	0
    }

    self:addCsb( "csbslot/hall/GameMini.csb")
    self:loadUi()
end

function GameMini:loadUi( ... )
	self:setTextCoin( self._coin )
	local index = 0
	self:schedule(function ()
		-- self.TextTimeDown:setString( 3 )
		if index == 0 then
			self.TextTimeDown:setString( 'READY!' )
		end
		if index == 1 then
			self.TextTimeDown:setString( 'GO!!!' )
		end
		-- if index == 2 then
		-- 	self.TextTimeDown:setString( 3 )
		-- end
		-- if index == 3 then
		-- 	self.TextTimeDown:setString( 2 )
		-- end
		-- if index == 4 then
		-- 	self.TextTimeDown:setString( 1 )
		-- end
		-- if index == 5 then
		-- 	self.TextTimeDown:setString( 0 )
		-- end
		if index == 2 then
			self.TextTimeDown:setVisible( false )
			self:unSchedule()
			self:play()
		end
		index = index + 1
	end,1)
end

function GameMini:onEnter()
	GameMini.super.onEnter( self )
	casecadeFadeInNode( self._layer,0.5,150 )
	casecadeFadeInNode( self._csbNode,0.5 )
end


function GameMini:play( ... )
	print("-----------------hahahahaha")
	
	self:loadPlay()

	performWithDelay( self,function ()
		G_GetModel("Model_Slot"):getInstance():setCoin( self._coin )
		local node_pos = cc.p( self.TextCoin:getPosition())
		local world_pos = self.TextCoin:getParent():convertToWorldSpace( node_pos )
		local end_pos = cc.p( 155,display.height - 33 )
		local call = function ()
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN )
		end
		coinFly( world_pos,end_pos,call )
		removeUIFromScene( UIDefine.SLOT_KEY.Mini_UI )
	end,4)
	-- performWithDelay( self,function ()
	-- 	removeUIFromScene( UIDefine.SLOT_KEY.Mini_UI )
	-- end,6)
end

function GameMini:loadPlay()
	for i=1,7 do
		for j=1,4 do
			local node = NodeMiniGame.new( self )
			self.bg:addChild( node )
			node:setPosition( i * 130 - 30,j * 100 )
		end
	end
end
function GameMini:setTextCoin( coin )
	self._coin = self._coin + coin
	self.TextCoin:setString( self._coin )
end











return GameMini