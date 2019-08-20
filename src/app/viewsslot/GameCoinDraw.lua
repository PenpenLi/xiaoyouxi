
local NodeCoin = import( "app.viewsslot.NodeCardDraw" )
local GameCoinDraw = class( "GameCoinDraw",BaseLayer )

function GameCoinDraw:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameCoinDraw.super.ctor( self,param.name )

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
	-- 设置滚动时间
	local time = 3
	performWithDelay( self,function ()
		self:unscheduleUpdate()
		self:moveToEndPosition()
	end,time )
	
	-- 开启帧调用
	self:onUpdate( function( dt ) 
		-- 更新信号块位置 --
		self:updataSymbolUnit(dt)
	end)
end
function GameCoinDraw:updataSymbolUnit( dt )
	local childs = self.ReelPanel:getChildren()
	for i=1,#childs do
		local y = childs[i]:getPositionY()
		y = y - 20
		childs[i]:setPositionY( y )
		print("---------------y = "..y)
		if y <= -386 then
			y = 579
			childs[i]:setPositionY( y )
		end
	end
end
-- 暂停后移动到准确位置
function GameCoinDraw:moveToEndPosition( ... )
	local childs = self.ReelPanel:getChildren()
	local y = nil
	for i=1,#childs do
		y = childs[i]:getPositionY()
		if y >= 0 and y <= 193 then
			break
		end
	end
	for i=1,#childs do
		local move_by = cc.MoveBy:create( 0.1,cc.p( 0,-y ) )
		childs[i]:runAction( move_by )
	end
end

















return GameCoinDraw