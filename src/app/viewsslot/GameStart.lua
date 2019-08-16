

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
end

function GameStart:loadCoin(  )
	-- local coin = G_GetModel("Model_SuoHa"):getInstance():getCoin()
end
function GameStart:onEnter( ... )
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	self:loadCoin()
	self:loadMusic()

	self:resetBar()
	G_GetModel("Model_Slot"):getInstance():getCountDown()
	self.ImageBigCoin:setVisible( false )
	self.ImageDiscSpinning:setVisible( false )
	self:schedule( function ()
		self:countDown()
		-- index = index + 1
		-- if index > #self._sound then
		-- 	self:unSchedule()
		-- 	self:loadStart()
		-- end
	end,0.1)
	-- self:countDown()
end
-- 进度条加载状态
function GameStart:resetBar( ... )
	local index = G_GetModel("Model_Slot"):getInstance():getNumOfCollectTime()
	-- index = index + 1
	for i=1,index do
		self:setLoadingBar( self["LoadingBar"..i],3600 )
	end
	for i=index,4 do
		local j = i + 1
		self:setLoadingBar( self["LoadingBar"..j],0 )
	end
end
-- 倒计时
function GameStart:countDown( )

	local time_began = G_GetModel("Model_Slot"):getInstance():getCountDown()
	local time_end = os.time()
	local time_long = time_end - time_began
	local index = G_GetModel("Model_Slot"):getInstance():getNumOfCollectTime()
	index = index + 1
	self:setLoadingBar( self["LoadingBar"..index],time_long )
	local time_count = 10 - time_long
	if time_count <= 0 then
		self.TextTimeCountDown:setString( os.date("%M:%S",0 ))
		if index == 5 then
			self.ImageDiscSpinning:setVisible( true )
		else
			self.ImageBigCoin:setVisible( true )
		end
		
		return
	end
	self.TextTimeCountDown:setString( os.date("%M:%S",time_count ))
end
-- 收集金币进度条
function GameStart:setLoadingBar( node,num )
	local rate = math.floor( num / 10 * 100)
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
	self.ImageBigCoin:setVisible( false )
	self:resetBar()
	self:coinFly()
end
-- 转盘抽奖
function GameStart:discSpinning()
	self.ImageDiscSpinning:setVisible( false )

	addUIToScene( UIDefine.SLOT_KEY.Turn_UI )
end
-- 收集金币飞舞
function GameStart:coinFly()

	local began_pos = self.ImageBigCoin:getParent():convertToWorldSpace( cc.p(self.ImageBigCoin:getPosition()))
	local first_pos = cc.p( 0,0 )
	local second_pos = cc.p( 400,500 )
	local third_pos = self.ImageCoinDollar:getParent():convertToWorldSpace( cc.p(self.ImageCoinDollar:getPosition()))
	
	for i=1,6 do
		local coin = ccui.ImageView:create( "image/ui/coin_dollar2.png",1 )
		self:addChild( coin )
		coin:setPosition( began_pos )
		local bz = cc.BezierTo:create(1,{ first_pos,second_pos,third_pos })
		local delay = cc.DelayTime:create( 0.1 * i )
		local seq = cc.Sequence:create({ delay,bz })
		coin:runAction( seq )
	end

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