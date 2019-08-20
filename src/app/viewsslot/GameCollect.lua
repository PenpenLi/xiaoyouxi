
local NodeCardMainstar = import( "app.viewsslot.NodeCardMainstar" )
local GameCollect = class( "GameCollect",BaseLayer )

function GameCollect:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param is nil !! " )
	GameCollect.super.ctor( self,param.name )
	self._coin = param.data.haveCoin
	self._parent = param.data.parent

	self:addCsb( "csbslot/hall/TurnReward.csb" )
	self:playCsbAction( "start",false )

	local node = NodeCardMainstar.new()
	self.OneNode:addChild( node )
	-- self.OneNode:addCsb( "csbslot/hall/CardMainstar.csb" )
	-- self:playCsbAction( "actionframe",true )


	self:addNodeClick( self.ButtonCollect,{
		endCallBack = function ()
			self:goingCollectCoin()
		end
	})
end
function GameCollect:onEnter()
	GameCollect.super.onEnter( self )
	self:loadUi()
end
function GameCollect:loadUi()
	self.TextCoin1:setString( self._coin )
end

function GameCollect:goingCollectCoin()
	if self._collect then
		return
	end
	
	self._collect = true
	-- self._parent:collectCoin()
	self:collectCoin()
	performWithDelay( self,function ()
		self._parent.ImageDiscSpinning:setVisible( false )
		removeUIFromScene( UIDefine.SLOT_KEY.Turn_UI )
		removeUIFromScene( UIDefine.SLOT_KEY.Collect_UI )
	end,1.5 )
	
end
-- 收集金币
function GameCollect:collectCoin()
	G_GetModel("Model_Slot"):getInstance():init()
	local index = G_GetModel("Model_Slot"):getInstance():getNumOfCollectTime()
	index = index + 1
	G_GetModel("Model_Slot"):getInstance():setNumOfCollectTime( index )
	-- self.GetCoinToByNode:setVisible( false )
	self._parent:resetBar()

	self:coinAction()
end
-- 金币动作
function GameCollect:coinAction()
	local num = 5 -- 动作几枚金币
	local began_pos = self.ImageCoin1:getParent():convertToWorldSpace( cc.p(self.ImageCoin1:getPosition()))
	local end_pos = cc.p( 150,display.height - 50 )
	local call = function ()
		-- local coin = G_GetModel("Model_Slot"):getInstance():getCollectCoin()
	    G_GetModel("Model_Slot"):getInstance():setCoin( self._coin )
	    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN )
	end
	coinFly( began_pos,end_pos,num,call )
end

















return GameCollect