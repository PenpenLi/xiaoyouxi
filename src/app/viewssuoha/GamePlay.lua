

local GamePlay = class( "GamePlay",BaseLayer )


function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbsuoha/Play.csb" )

    self._poker = suoha_config.poker--牌总表
    --两堆牌
    self._pokerStackUp,self._pokerStackDown = self:toDeal()--上下牌堆
    self._pokerStackUpImg = {}--上牌堆图表
    self._pokerStackDownImg = {}--下牌堆图表




    self._img = ccui.ImageView:create( self._poker[self._pokerStackUp[5]].path,1 )
    self:addChild( self._img )
    self._img:setPosition( 300,300 )
    self._img:setName("asdhjfkaj")
    local a = self._img:getName()
    dump( self._img,"------------self._img = " )
    dump( a,"------------a = " )
	self:addNodeClick( self._img,{
		endCallBack = function ()
			print( "----------->>>11111111111" )
		end
	})
 --    self:buttonTouchEvent( self._img,{
 --    	movedCall = function ()
 --    		local touchPoint = touch:getLocation()
 --    		self._img:setPosition( touchPoint )
 --    		print( "-----------+++++" )
 --    	end,
	-- 	endedCall = function ()
	-- 		print( "-----------+++++" )
	-- 		-- self._layer:removeFromParent()
	-- 	end
	-- })













    self:loadUi()
end

--loadUI
function GamePlay:loadUi()
	self:setPokerStack()
	self:loadText()
	-- dump( self._pokerStackUpImg,"--------->>>self._pokerStackUpImg = ")
end

--移动牌
function GamePlay:sendPoker()
	-- body
end






--load数据
function GamePlay:loadText()
	for i=1,12 do
		self["TextScore"..i]:setString( 0 )
	end
	self.TextScoreSum:setString( 0 )
end
--设置牌堆
function GamePlay:setPokerStack()
	for i=1,#self._pokerStackUp do
		local img = ccui.ImageView:create( self._poker[self._pokerStackUp[i]].path,1 )
		self.NodeUp:addChild( img )
		img:setPositionY( -i * 3 )
		table.insert( self._pokerStackUpImg,img )


		-- img:setName( "img" )
		-- self:addNodeClick( img,{
		-- 	endCallBack = function ()
		-- 	print( "----------->>>11111111111" )
		-- end
		-- })
		-- 
		-- self:addNodeClick( img,{
		-- 	endCallBack = function ()
		-- 		print( "---------dianji" )
		-- 	end
		-- })
	end
	dump( self._pokerStackUpImg,"-------------self._pokerStackUpImg = ")
	for i=1,#self._pokerStackDown do
		local img = ccui.ImageView:create( self._poker[self._pokerStackDown[i]].path,1 )
		self.NodeDown:addChild( img )
		img:setPositionY( i * 3 )
		table.insert( self._pokerStackDownImg,img )
	end
end

--洗牌
function GamePlay:randomPoker()
	local r_poker = {}
	for i=1,52 do
		table.insert( r_poker,i )
	end
	local r_random_poker = {}
	while #r_poker > 0 do
		local index = random( 1,#r_poker )
		table.insert( r_random_poker,r_poker[index] )
		table.remove( r_poker,index )
	end
	return r_random_poker
end
--分牌
function GamePlay:toDeal()
	local t_randomPoker = self:randomPoker()
	local pokerStack1 = {}
	for i=1,26 do
		table.insert( pokerStack1,t_randomPoker[1] )
		table.remove( t_randomPoker,1)
	end
	return pokerStack1,t_randomPoker
end












--触摸
-- function GamePlay:registTouchEvent( node,param )
--     node:setTouchEnabled( true )
--     node:onTouch( function ( event )
--         if event.name == "began" then
--             if param.beganCall then
--                 param.beganCall()
--             end
--         elseif event.name == "moved" then
--             if param.movedCall then
--                 param.movedCall()
--             end
--         elseif event.name == "ended" then
--             if param.endedCall then
--                 param.endedCall()
--             end
--         elseif event.name == "cancelled" then
--             if param.cancelCall then
--                 param.cancelCall()
--             end
--         end
--     end)
-- end
-- function GamePlay:buttonTouchEvent( node,param )
--     node:setTouchEnabled( true )
--     node:onTouch( function ( event )
--         if event.name == "began" then
--             if param.beganCall then
--                 param.beganCall()
--             end
--         elseif event.name == "moved" then
--             if param.movedCall then
--                 param.movedCall()
--             end
--         elseif event.name == "ended" then
--             if param.endedCall then
--                 param.endedCall()
--             end
--         elseif event.name == "cancelled" then
--             if param.cancelCall then
--                 param.cancelCall()
--             end
--         end
--     end)
-- end














return GamePlay