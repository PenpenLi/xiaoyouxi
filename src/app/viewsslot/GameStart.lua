
local GameStart = class( "GameStart",BaseLayer )

function GameStart:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameStart.super.ctor( self,param.name )

	self:addCsb( "csbslot/hall/Start.csb" )

	-- 关卡1
	self:addNodeClick( self.ImageLevel1,{
		endCallBack = function ()
			self:clickGame1()
		end
	})


	self:addNodeClick( self.ImageLevel2,{
		endCallBack = function ()
			self:clickGame2()
		end
	})

	self:addNodeClick( self.ImageLevel3,{
		endCallBack = function ()
			self:clickGame3()
		end
	})


	self._timing = G_GetModel("Model_Slot"):getInstance():getTimingOfDown() -- 倒计时总时间

	self:addNodeClick( self.ImageBigCoin,{
		endCallBack = function ()
			self:collectCoin()
		end
	})
	self:addNodeClick( self.ImageDiscSpinning,{
		endCallBack = function ()
			self:discSpinning()
		end
	})
	-- 每日抽奖
	self:addNodeClick( self.ButtonChoujiangOfDay,{
		endCallBack = function ()
			self:ChoujiangOfDay()
		end
	})
	self:addNodeClick( self.ButtonBuy,{
		endCallBack = function ()
			self:store()
		end
	})
	self:addNodeClick( self.ButtonMiniGame,{
		endCallBack = function ()
			self:miniGame()
		end
	})
	
	self:addNodeClick( self.ButtonSet,{
		endCallBack = function ()
			self:setMusic()
		end
	})
end

function GameStart:loadCoin(  )
	local coin = G_GetModel("Model_Slot"):getInstance():getCoin()
	self.TextHasCoin:setString( coin )
end
-- 左下小玩法
function GameStart:loadMiniGame( ... )
	local num = G_GetModel("Model_Slot"):getInstance():getMiniGameNum()
	local num_sum = G_GetModel("Model_Slot"):getInstance():getMiniGameNumSum()
	
	if num >= num_sum then
		self.NodeMiniGameRate:setVisible( false )
		-- self.ButtonMiniGame:setVisible( true )
	else
		self.NodeMiniGameRate:setVisible( true )
		-- self.ButtonMiniGame:setVisible( false )
		self.TextMiniGameRate:setString( num )
		self.TextMiniGameRateSum:setString( num_sum )
	end
end
function GameStart:loadNowTime()
	local time = os.time()
	self.TextNowDay:setString( os.date("%Y.%m.%d",time) )
	self.TextNowTime:setString( os.date("%H:%M:%S",time) )
end
function GameStart:loadMuisc()
	local state = G_GetModel("Model_Sound"):getInstance():isMusicOpen()
	if state then
		G_GetModel("Model_Sound"):getInstance():playBgMusic()
	end
end
function GameStart:loadLevel( ... )
	local level = G_GetModel("Model_Slot"):getInstance():getLevel()
	self.TextLevel:setString( level )

	local need_exp = G_GetModel("Model_Slot"):getNeedExpForLevelUp()
	local now_exp = G_GetModel("Model_Slot"):getExpress()
	self.ExpressBar:setPercent( now_exp / need_exp * 100 )
end
function GameStart:onEnter( ... )
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	self:loadCoin()
	self:loadMiniGame()
	self:loadLevel()
	self:loadMuisc()

	-- 添加监听
	self:addMsgListener( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN,function ()
		local coin = G_GetModel("Model_Slot"):getInstance():getCoin()
		self.TextHasCoin:setString( coin )
	end )
	self:resetBar()
	G_GetModel("Model_Slot"):getInstance():getCountDown()
	self.ShowZhuanpanNode:setVisible( false )
	self.GetCoinToByNode:setVisible( false )

	self:schedule( function ()
		-- self:loadNowTime()
		self:countDown()
		-- 每日抽奖
		self:loadEveryDayDraw()
	end,0.1)
end
-- 每日抽奖倒计时
function GameStart:loadEveryDayDraw()
	local countdown = G_GetModel("Model_Slot"):getInstance():getOneDayOneDraw()
	if countdown == 0 then
		self:playEveryDayDraw()
	else
		self:countdownEveryDayDraw()
	end
end
function GameStart:playEveryDayDraw()
	self.TextEveryDayDraw:setVisible( false )
end
function GameStart:countdownEveryDayDraw()
	self.TextEveryDayDraw:setVisible( true )
	self:updataDayDraw(dt)
end
function GameStart:updataDayDraw( dt )
	local countdown = G_GetModel("Model_Slot"):getInstance():getOneDayOneDraw()
	local time = formatTimeStr( countdown,":")
	self.TextEveryDayDraw:setString( time )
end

-- 进度条加载状态
function GameStart:resetBar( ... )
	local index = G_GetModel("Model_Slot"):getInstance():getNumOfCollectTime()
	-- index = index + 1
	for i=1,index do
		self:setLoadingBar( self["LoadingBar"..i],3600,self._timing )
	end
	for i=index,4 do
		local j = i + 1
		self:setLoadingBar( self["LoadingBar"..j],0,self._timing )
	end
end

-- 倒计时
function GameStart:countDown( )
	local time_began = G_GetModel("Model_Slot"):getInstance():getCountDown()
	local time_end = os.time()
	local time_long = time_end - time_began
	local index = G_GetModel("Model_Slot"):getInstance():getNumOfCollectTime()
	index = index + 1
	self:setLoadingBar( self["LoadingBar"..index],time_long,self._timing )
	local time_count = self._timing - time_long
	if index < 5 then
		if time_count <= 0 then
			self.TextTimeCountDown:setVisible( false )
			self.GetCoinToByNode:setVisible( true )
			self.GetCoinNode:setVisible( false )
			self.ShowZhuanpanNode:setVisible( false )
			local coin = G_GetModel("Model_Slot"):getInstance():getCollectCoin()
			self.TextCollectCoinNum:setString( coin )
		else
			self.TextTimeCountDown:setVisible( true )
			self.TextTimeCountDown:setString( os.date("%M:%S",time_count ))
			self.GetCoinNode:setVisible( true )
			self.ShowZhuanpanNode:setVisible( false )
			self.GetCoinToByNode:setVisible( false )
		end
	else
		self.ShowZhuanpanNode:setVisible( true )
		self:discSpinningTurn()
		self.GetCoinNode:setVisible( false )
		self.GetCoinToByNode:setVisible( false )
	end
end
-- 收集金币进度条
function GameStart:setLoadingBar( node,num,timing )
	local rate = math.floor( num / timing * 100)
	node:setPercent( rate )
end
-- 收集金币
function GameStart:collectCoin()
	G_GetModel("Model_Slot"):getInstance():init()
	local index = G_GetModel("Model_Slot"):getInstance():getNumOfCollectTime()
	index = index + 1
	G_GetModel("Model_Slot"):getInstance():setNumOfCollectTime( index )
	self.GetCoinToByNode:setVisible( false )
	self:resetBar()
	self:coinAction()
end
-- 抽奖小转盘旋转
function GameStart:discSpinningTurn()
	local rotate = cc.RotateBy:create( 1,45 )
	local repeatForever = cc.RepeatForever:create( rotate )
	self.ImageDiscSpinning:runAction( repeatForever )
end
-- 转盘抽奖
function GameStart:discSpinning()
	addUIToScene( UIDefine.SLOT_KEY.Turn_UI,self )
end

-- 收集金币飞舞
function GameStart:coinAction()
	local began_pos = self.ImageBigCoin:getParent():convertToWorldSpace( cc.p(self.ImageBigCoin:getPosition()))
	local end_pos = self.ImageCoinDollar:getParent():convertToWorldSpace( cc.p(self.ImageCoinDollar:getPosition()))
	local call = function ()
		local coin = G_GetModel("Model_Slot"):getInstance():getCollectCoin()
	    G_GetModel("Model_Slot"):getInstance():setCoin( coin )
	    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN )
	end
	coinFly( began_pos,end_pos,call )
end

function GameStart:clickGame1()
	-- 进入关卡1
	SceneManager:gotoLevelScene( 1 )
end


function GameStart:clickGame2()
	-- 进入关卡1
	SceneManager:gotoLevelScene( 2 )
end

function GameStart:clickGame3()
	-- 进入关卡1
	SceneManager:gotoLevelScene( 3 )
end

function GameStart:store()
	addUIToScene( UIDefine.SLOT_KEY.Shop_UI )
end

function GameStart:ChoujiangOfDay()
	local countdown = G_GetModel("Model_Slot"):getInstance():getOneDayOneDraw()
	if countdown > 0 then
		return
	end
	addUIToScene( UIDefine.SLOT_KEY.Draw_UI )
end

function GameStart:miniGame()
	local num = G_GetModel("Model_Slot"):getInstance():getMiniGameNum()
	local num_sum = G_GetModel("Model_Slot"):getInstance():getMiniGameNumSum()
	if num < num_sum then
		return
	end
	G_GetModel("Model_Slot"):getInstance():initMiniGameNum()
	addUIToScene( UIDefine.SLOT_KEY.Mini2_UI,self )
end

function GameStart:setMusic()
	addUIToScene( UIDefine.SLOT_KEY.Set_UI )
end
return GameStart