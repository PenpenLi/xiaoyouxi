
local NodeCoin = import( "app.viewsslot.NodeCardDraw" )
local GameCoinDraw = class( "GameCoinDraw",BaseLayer )

function GameCoinDraw:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameCoinDraw.super.ctor( self,param.name )
	-- self._parent = param.data

	self:addCsb( "csbslot/hall/CardDraw.csb" )
	self:playCsbAction( "start",false )

	self._node_pos = {
		579,
		386,
		193,
		0,
		-193
	}

	self:addNodeClick( self.ButtonSpin,{
		endCallBack = function ()
			self:beganGame()
		end
	})
	self._start = 0 -- 点击状态，0可以点击，1不能点击
end

function GameCoinDraw:loadUi()
	for i=1,5 do
		local node = NodeCoin.new( )
		self.ReelPanel:addChild( node )
		node:setPosition( cc.p( 88,self._node_pos[i] ))
	end
end

function GameCoinDraw:onEnter()
	GameCoinDraw.super.onEnter( self )
	self:loadUi()
end

function GameCoinDraw:beganGame()
	if self._start == 1 then
		return
	end
	self._start = 1
	self:playCsbAction( "yaogan",false )
	-- 设置滚动时间
	local time = 3
	-- 暂停帧调用，移动到位
	performWithDelay( self,function ()
		self:unscheduleUpdate()
		self:moveToEndPosition()
	end,time )
	-- 打开收集界面
	performWithDelay( self,function ()
		self:getCoinAndOneTime()
		-- self:resetOneDayOneDraw()--进入每日抽奖界面后，如果玩家直接退出游戏将失去一次每日抽奖
		self:openCollect()
	end,time + 0.5)
	
	-- 开启帧调用
	self:onUpdate( function( dt ) 
		-- 更新信号块位置 --
		self:updataSymbolUnit(dt)
	end)
end
-- 滚动
function GameCoinDraw:updataSymbolUnit( dt )
	local childs = self.ReelPanel:getChildren()
	for i=1,#childs do
		local y = childs[i]:getPositionY()
		y = y - 20
		childs[i]:setPositionY( y )
		-- print("---------------y = "..y)
		if y <= -386 then
			y = y + 965
			-- 更新node内容
			-- local node = NodeCoin.new( )
			-- self.ReelPanel:addChild( node )
			childs[i]:loadUi()
			childs[i]:setPositionY( y )
		end
	end
end
-- 暂停后移动到准确位置
function GameCoinDraw:moveToEndPosition()
	local childs = self.ReelPanel:getChildren()
	local y = nil
	for i=1,#childs do
		y = childs[i]:getPositionY()
		if y >= 193 and y <= 386 then
			break
		end
	end
	for i=1,#childs do
		local move_by = cc.MoveBy:create( 0.1,cc.p( 0,-y + 193 ) )
		local easeSineOut = cc.EaseSineOut:create(move_by)
		childs[i]:runAction( easeSineOut )
	end
end
-- 结算获取的金币和再来一次机会
function GameCoinDraw:getCoinAndOneTime( ... )
	local childs = self.ReelPanel:getChildren()
	for i=1,#childs do
		local y = childs[i]:getPositionY()
		if y == 193 then
			self._coin = childs[i]:getCoin()
			self._keepOn = childs[i]:getKeepOn()
		end
	end
	if self._keepOn == 1 then
		self._start = 0
	end
end
-- -- 重置每日抽奖
-- function GameCoinDraw:resetOneDayOneDraw()
-- 	G_GetModel("Model_Slot"):getInstance():setOneDayOneDraw()
-- 	self._parent:loadEveryDayDraw()
-- end

function GameCoinDraw:openCollect( ... )
	-- dump( self._coin,"--------------------coin = ")
	addUIToScene( UIDefine.SLOT_KEY.Collect_UI,{haveCoin = self._coin,keepOn = self._keepOn} )
end















return GameCoinDraw