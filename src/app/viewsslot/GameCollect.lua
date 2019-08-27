
local NodeCardMainstar = import( "app.viewsslot.NodeCardMainstar" )
local GameCollect = class( "GameCollect",BaseLayer )

function GameCollect:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param is nil !! " )
	GameCollect.super.ctor( self,param.name )
	
	self._coin = param.data.haveCoin
	if param.data.keepOn then
		self._keepOn = param.data.keepOn
	end
	if param.data.parent then
		self._parent = param.data.parent
	end

	self:addCsb( "csbslot/hall/TurnReward.csb" )
	self:playCsbAction( "start",false )

	local node = NodeCardMainstar.new()
	self.OneNode:addChild( node )

	self:addNodeClick( self.ButtonCollect,{
		endCallBack = function ()
			self:goingCollectCoin()
		end
	})
	local is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		audio.playSound("csbslot/hall/hmp3/sound_daily_wheel_collect.mp3",false)
	end
end
function GameCollect:onEnter()
	GameCollect.super.onEnter( self )
	self:loadUi()
end
function GameCollect:loadUi()
	self.TextCoin1:setString( self._coin )
	if self._keepOn == 1 then
		self.ImageCoin1:ignoreContentAdaptWithSize( true )
		self.ImageCoin1:loadTexture( "image/carddraw/fortune3.png",1 )
	else
		self.ImageCoin1:ignoreContentAdaptWithSize( true )
		self.ImageCoin1:loadTexture( "image/carddraw/fortune1.png",1 )
	end
end

function GameCollect:goingCollectCoin()
	if self._collect then
		return
	end
	local is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		audio.playSound("csbslot/hall/hmp3/sound_daily_wheel_collect_click.mp3",false)
	end
	self._collect = true
	self:collectCoin()
	performWithDelay( self,function ()
		if self._parent then
			self._parent.ShowZhuanpanNode:setVisible( false )
			removeUIFromScene( UIDefine.SLOT_KEY.Turn_UI )
			removeUIFromScene( UIDefine.SLOT_KEY.Collect_UI )
		else
			if self._keepOn == 0 then
				removeUIFromScene( UIDefine.SLOT_KEY.Draw_UI )
			end
			removeUIFromScene( UIDefine.SLOT_KEY.Collect_UI )
		end
		
	end,2 )
	
end
-- 收集金币
function GameCollect:collectCoin()
	if self._parent then
		G_GetModel("Model_Slot"):getInstance():init()
		local index = G_GetModel("Model_Slot"):getInstance():getNumOfCollectTime()
		index = index + 1
		G_GetModel("Model_Slot"):getInstance():setNumOfCollectTime( index )
		self._parent:resetBar()
	end

	self:coinAction()
end
-- 金币动作
function GameCollect:coinAction()
	local num = 5 -- 动作几枚金币
	local began_pos = self.ImageCoin1:getParent():convertToWorldSpace( cc.p(self.ImageCoin1:getPosition()))
	local end_pos = cc.p( 150,display.height - 50 )
	G_GetModel("Model_Slot"):getInstance():setCoin( self._coin ) -- 直接存入，避免移除后数据为空
	if not self._parent then -- 直接重置，避免移除layer数据为空
    	self:resetOneDayOneDraw()
    end
	local call = function ()
	    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN )
	end
	coinFly( began_pos,end_pos,call )
end

-- 重置每日抽奖目标时间
function GameCollect:resetOneDayOneDraw()
	G_GetModel("Model_Slot"):getInstance():setOneDayOneDraw()
end

return GameCollect