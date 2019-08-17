

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

	-- --商店
	-- self:addNodeClick( self.ButtonStore,{
	-- 	endCallBack = function ()
	-- 		self:store()
	-- 	end
	-- })

	self._timing = G_GetModel("Model_Slot"):getInstance():getTimingOfDown() -- 倒计时总时间

	self:addNodeClick( self.ImageBigCoin,{
		endCallBack = function ()
			self:collectCoin()
			print("----------------------> aaaaaaaaaaaaaaaaaa ")
			-- self:discSpinning()
		end
	})
	self:addNodeClick( self.ImageDiscSpinning,{
		endCallBack = function ()
			self:discSpinning()
		end
	})
end

function GameStart:loadCoin(  )
	-- local coin = G_GetModel("Model_SuoHa"):getInstance():getCoin()
	local coin = G_GetModel("Model_Slot"):getInstance():getCoin()
	self.TextHasCoin:setString( coin )
end
function GameStart:onEnter( ... )
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	self:loadCoin()
	-- 添加监听
	self:addMsgListener( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN,function ()
		local coin = G_GetModel("Model_Slot"):getInstance():getCoin()
		self.TextHasCoin:setString( coin )
	end )

	self:resetBar()
	G_GetModel("Model_Slot"):getInstance():getCountDown()
	-- self.ImageBigCoin:setVisible( false )
	self.ImageDiscSpinning:setVisible( false )
	self.GetCoinToByNode:setVisible( false )

	self:schedule( function ()
		self:countDown()
		-- index = index + 1
		-- if index > #self._sound then
		-- 	self:unSchedule()
		-- 	self:loadStart()
		-- end
	end,0.1)
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
	-- self._timing = 10
	local time_began = G_GetModel("Model_Slot"):getInstance():getCountDown()
	local time_end = os.time()
	local time_long = time_end - time_began
	local index = G_GetModel("Model_Slot"):getInstance():getNumOfCollectTime()
	index = index + 1
	self:setLoadingBar( self["LoadingBar"..index],time_long,self._timing )
	local time_count = self._timing - time_long
	if time_count <= 0 then
		self.TextTimeCountDown:setString( os.date("%M:%S",0 ))
		if index == 5 then
			self.ImageDiscSpinning:setVisible( true )
			self:discSpinningTurn()
		else
			self.GetCoinToByNode:setVisible( true )
			local coin = G_GetModel("Model_Slot"):getInstance():getCollectCoin()
			self.TextCollectCoinNum:setString( coin )
			-- self.GetCoinNode:setVisible( false )
		end
		
		return
	end
	self.TextTimeCountDown:setString( os.date("%M:%S",time_count ))
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
	-- if index >= 5 then
	-- end
	G_GetModel("Model_Slot"):getInstance():setNumOfCollectTime( index )
	self.GetCoinToByNode:setVisible( false )
	self:resetBar()
	self:coinFly()

	
end
-- 抽奖小转盘旋转
function GameStart:discSpinningTurn()
	local rotate = cc.RotateBy:create( 1,45 )
	local repeatForever = cc.RepeatForever:create( rotate )
	self.ImageDiscSpinning:runAction( repeatForever )
end
-- 转盘抽奖
function GameStart:discSpinning()
	self.ImageDiscSpinning:setVisible( false )
	self:collectCoin()
	addUIToScene( UIDefine.SLOT_KEY.Turn_UI )

	
end

-- 收集金币飞舞
function GameStart:coinFly()
	local index = 5 -- 飞6枚金币
	local began_pos = self.ImageBigCoin:getParent():convertToWorldSpace( cc.p(self.ImageBigCoin:getPosition()))
	local first_pos = cc.p( 0,0 )
	local second_pos = cc.p( 400,500 )
	local third_pos = self.ImageCoinDollar:getParent():convertToWorldSpace( cc.p(self.ImageCoinDollar:getPosition()))
	for i=1,index do
		local coin = ccui.ImageView:create( "image/ui/coin_dollar2.png",1 )
		self:addChild( coin )
		coin:setPosition( began_pos )
		-- coin:setVisible( false )
		local fade = cc.FadeIn:create( 0.1)
		local bz = cc.BezierTo:create(1,{ first_pos,second_pos,third_pos })
		local delay = cc.DelayTime:create( 0.05 * i )
		local call = cc.CallFunc:create(function ()
			local coin = G_GetModel("Model_Slot"):getInstance():getCollectCoin()
			G_GetModel("Model_Slot"):getInstance():setCoin( coin / index )
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_SLOT_BUY_COIN )
		end)
		
		local seq = cc.Sequence:create({ delay,fade,bz,call })
		coin:runAction( seq )
	end
end



function GameStart:clickGame1()
end

function GameStart:store()
	-- addUIToScene( UIDefine.SUOHA_KEY.Shop_UI )
end





return GameStart