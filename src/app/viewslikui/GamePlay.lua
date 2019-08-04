

local NodePoker = import( "app.viewslikui.NodePoker" )
local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )

    self:addCsb( "Play.csb" )
    -- self._poker = likui_config.poker

    self._pokerStack = getRandomArray( 1,52 )-- 随机一副牌

    self:addNodeClick( self.ImageBack,{
    	endCallBack = function ()
    		self:back()
    	end
    })

    self:loadUi()
end

function GamePlay:loadUi()
	self:createPokerStack()
	self:firstSendPoker()
	self:hideAIHandAndPoker()
end
-- 隐藏AI的牌和手
function GamePlay:hideAIHandAndPoker()
	self.ImageAIHand:setVisible( false )
	for i = 1,10 do
		self["ImageAIpoker"..i]:setVisible( false )
	end
	self.SpriteFist:setVisible( false )
	self.ImageAIHand1:setVisible( false )
end
-- 初次发牌
function GamePlay:firstSendPoker()
	local time = 0.1
	local actions = {}
	for i=1,10 do
		local delay = cc.DelayTime:create( 0.3 )
		table.insert( actions,delay )
		local call = cc.CallFunc:create( function()
			self:playerSendPoker( time )
		end )
		table.insert( actions,call )
		local call_AI = cc.CallFunc:create( function ()
			self:AISendPoker( time )
		end)
		table.insert( actions,delay )
		table.insert( actions,call_AI )
	end
	self:runAction( cc.Sequence:create( actions ) )

	
	
	
end



function GamePlay:AISendPoker( time )
	local stack_childs = self.NodeStack:getChildren()
	local top_poker = stack_childs[#stack_childs]
	local img_startPos = cc.p( top_poker:getPosition())
	local img_startWorldPos = top_poker:getParent():convertToWorldSpace( img_startPos )
	local img_startNodePos = self.AIHandPokerIn:convertToNodeSpace( img_startWorldPos )

	top_poker:retain()
	top_poker:removeFromParent()
	self.AIHandPokerIn:addChild( top_poker )
	top_poker:release()
	top_poker:setPosition( img_startNodePos )

	self:AIPokerMove( top_poker,time )
	if #self.AIHandPokerIn:getChildren() > 10 then
		self:AIActionIn()
	end
end
-- AI手摸牌动作
function GamePlay:AIActionIn( ... )
	-- body
end
function GamePlay:AIPokerMove( top_poker,time )
	local rot = self:getiRotate()
	local move_to = cc.MoveTo:create( time * 2,cc.p( 0,0 ))
	local scale_to = cc.ScaleTo:create( time * 2,0.5 )
	local rotate = cc.RotateTo:create( time * 2,rot )
	local spawn = cc.Spawn:create( { move_to,scale_to,rotate } )
	local hide = cc.Hide:create()
	-- AI得到牌显示手和牌
	local call = cc.CallFunc:create( function ()
		local AI_childs = self.AIHandPokerIn:getChildren()
		local AI_numPoker = #AI_childs
		if AI_numPoker < 11 and AI_numPoker > 1 then
			self["ImageAIpoker"..AI_numPoker]:setVisible( true )
		end
		
		if AI_numPoker == 1 then
			local hand_pos = cc.p(self.ImageAIHand:getPosition())
			self.ImageAIHand:setVisible( true )
			self.ImageAIHand:setPositionX( hand_pos.x + 150 )
			self.ImageAIHand:setRotation( -60 )
			local hand_rotate = cc.RotateTo:create( time,0 )
			local hand_move_to = cc.MoveTo:create( time,hand_pos )
			local hand_spawn = cc.Spawn:create( { hand_rotate,hand_move_to } )
			self.ImageAIHand:runAction( hand_spawn )

			local img = ccui.ImageView:create( "image/poker/bei.png" )
			self:addChild( img )
			img:setScale( 0.4 )
			local img_beganPos = cc.p( self.AIHandPokerIn:getPosition())
			local img_endPos = cc.p( self.AIHandPokerOut:getPosition())
			img:setPosition( img_beganPos )
			-- local delay = cc.DelayTime:create( time )
			local img_move = cc.MoveTo:create( time,img_endPos)
			local img_call = cc.CallFunc:create( function ()
				img:removeFromParent()
				self.ImageAIpoker1:setVisible( true )
			end)
			local seq = cc.Sequence:create( { img_move,img_call } )
			img:runAction( seq )
		end
	end)
	local seq = cc.Sequence:create({ spawn,hide,call })
	top_poker:runAction( seq )
end
function GamePlay:getiRotate()
	local AI_childs = self.AIHandPokerIn:getChildren()
	local rot = 15
	return rot - #AI_childs * 3
end

function GamePlay:playerSendPoker( time )
	-- local player_childs = self.PlayerHandPoker:getChildren()
	-- local x_pos = self:playerHandPokerSpaceBetween( #player_childs )
	-- local position_end = cc.p( x_pos,0 )

	local stack_childs = self.NodeStack:getChildren()
	local img_startPos = cc.p(stack_childs[#stack_childs]:getPosition())
	
	local img_startWorldPos = stack_childs[#stack_childs]:getParent():convertToWorldSpace( img_startPos )
	local img_startNodePos = self.PlayerHandPoker:convertToNodeSpace( img_startWorldPos )

	local top_poker = stack_childs[#stack_childs]
	top_poker:retain()
	top_poker:removeFromParent()
	self.PlayerHandPoker:addChild( top_poker )
	top_poker:release()
	top_poker:setPosition( img_startNodePos )

	local player_childs = self.PlayerHandPoker:getChildren()
	local x_pos = self:playerHandPokerSpaceBetween( #player_childs )
	local position_end = cc.p( x_pos,0 )

	self:playerPokerMove( top_poker,position_end,time )
end

function GamePlay:playerPokerMove( poker,position,time )
	-- local time = 0.3
	local move_to = cc.MoveTo:create( time * 2,position )
	local delay = cc.DelayTime:create( 0.2 )
	-- dump( self.PlayerHandPoker:getChildren(),"---------self.PlayerHandPoker:getChildren() = ")
	local call_sort = cc.CallFunc:create( function ()

		if #self.PlayerHandPoker:getChildren() > 9 then
		 	self:playerHandPokerSort()
		 	
		end
		-- print( "---------aaaaa")
	end)
	local seq = cc.Sequence:create( { move_to,delay,call_sort })
	poker:runAction( seq )
	
	poker:showObtAniUseScaleTo( time )
end
-- 玩家手牌排序
function GamePlay:playerHandPokerSort()
	-- print( "---------kkkkk")
	local player_childs = self.PlayerHandPoker:getChildren()
	-- local num = player_childs[10]:getNumberIndex()
	-- local color = player_childs[10]:getColorIndex()

	
	-- 玩家手牌排序
	self:HandPokerSort( player_childs )
	-- 如果是AI，不需要移动

	
	-- 移动牌
	for i = 1,#player_childs do
		local index = self:playerHandPokerSpaceBetween( i )
		-- dump( index,"----------index = ")
		player_childs[i]:setLocalZOrder( i )
		-- player_childs[i]:setPosition( index,0 )
		local move_to = cc.MoveTo:create( 0.5,cc.p( index,0 ))
		-- player_childs[i]:runAction( { move_to } )
		player_childs[i]:runAction( cc.Sequence:create{ move_to,cc.CallFunc:create( function() self:playerHandPokerGetTogether( player_childs ) end)} )
	end
end
-- 玩家或AI手牌排序
function GamePlay:HandPokerSort( childs )
	assert( childs," !! hilds is nil !! " )
	table.sort( childs,function ( a,b )
		-- print( "----------ab")
		if a:getNumberOfBigOrSmall() ~= b:getNumberOfBigOrSmall() then
			return a:getNumberOfBigOrSmall() < b:getNumberOfBigOrSmall()
		end
		if a:getColorIndex() ~= b:getColorIndex() then
			return a:getColorIndex() < b:getColorIndex()
		end
	end)
end
-- 筛选同花顺
function GamePlay:choseTierce( source,tierce_ary )
	assert( source," !! source is nil !! " )
	assert( tierce_ary," !! tierce_ary is nil " )
	assert( #source >= 3," !! #source must >= 3 !! " )
	local stack = { source[1] }
	for i=2,#source do
		local top_poker = likui_config.poker[stack[#stack]]
		local poker = likui_config.poker[source[i]]
		if top_poker.num + 1 == poker.num and top_poker.color == poker.color then
			table.insert( stack,source[i] )
		end
	end
	if #stack >= 3 then
		local meta = clone( stack ) -------------为什么必须要克隆后再插入表？
		table.insert( tierce_ary,meta )
		local new_source = {}
		for i,v in ipairs( source ) do
			local has = false
			for a,b in ipairs( stack ) do
				if v == b then
					has = true
					break
				end
			end
			if not has then
				table.insert( new_source,v)
			end
		end
		if #new_source >= 3 then
			-- dump( new_source,"--------------new_source = ")
			-- dump( tierce_ary,"--------------tierce_ary = ")
			self:choseTierce( new_source,tierce_ary )
		end
	else
		local new_source = clone( source )
		table.remove( new_source,1 )
		if #new_source >= 3 then
			self:choseTierce( new_source,tierce_ary )
		else
			-- 递归结束
		end

	end
end
-- 筛选4条和3条
function GamePlay:getFourOrThree( source,num )
	local result = {}
	for i,v in ipairs( source ) do
		local pai = likui_config.poker[v]
		local pai_num = pai.num
		if result[pai_num] == nil then
			result[pai_num] = 1
		else
			result[pai_num] = result[pai_num] + 1
		end
	end
	local threeOrFour_ary = {}
	for k,v in pairs( result ) do
		if v == num then
			table.insert( threeOrFour_ary,k )
		end
	end
	local final_arry = {}
	for i,v in ipairs( threeOrFour_ary ) do
		for a,b in ipairs( source ) do
			if likui_config.poker[b].num == v then
				table.insert( final_arry,b )
			end
		end
	end
	return final_arry
end
-- 选择最优的组合牌方式
function GamePlay:optimalOfPoker( ... )
	-- body
end
-- 将一个表V值插入另一表
function GamePlay:tableInsertV( ary,ary1 )
	for i=1,#ary1 do
		table.insert( ary,ary1[i] )
	end
end
-- 手牌根据收集情况重新组合
function GamePlay:finalCombinationOfCards( ary1,ary2,ary3,ary4 )
	local result = {}
	local ary = {}
	-- for i=1,4 do
	-- 	table.insert( ary,clone( ary..i ))
	-- end
	table.insert( ary,clone( ary1 ))
	table.insert( ary,clone( ary2 ))
	table.insert( ary,clone( ary3 ))
	table.sort( ary,function ( a,b )
		return a[1] < b[1]
	end)
	-- table.insert( ary,clone( ary4 ))
	local player_childs = self.PlayerHandPoker:getChildren()
	for i = 1,#ary do
		print(i)
	end


	-- if ary1 ~= nil then
	-- 	if ary2 ~= nil then
	-- 		if ary3 ~= nil then
	-- 			if
	-- 		else
	-- 		end
	-- 	else
	-- 	end
	-- else
	-- end
end
-- 判断玩家或AI手牌收集情况，玩家或AI的node里的孩子列表(已经排序)，重新排序
function GamePlay:playerHandPokerGetTogether( player_childs )-------------这里其实调用的次数只需要1次，但是调用了10次。。。有点亏
	assert( player_childs," !! player_childs is nil !! " )
	assert( #player_childs == 10 or #player_childs == 11," !! player_childs is error !! " )
	if #player_childs < 10 then
		return
	end
	-- 提取node里面的数据，索引
	local source = {}
	
	for i=1,#player_childs do
		table.insert( source,player_childs[i]:getNumberIndex() )
	end
		
	-- dump( source," -------------source = " )
	-- source = { 1,2,3,4,5,43,30,18,29,17,6 }
	-- 1，选出同花顺
	local tierce_ary = {}
	self:choseTierce( source,tierce_ary )


	-- 去掉已筛选的同花顺
	local new_source = clone( source )
	for i,v in ipairs(source) do
		for a,b in ipairs(tierce_ary) do
			for c,d in ipairs(b) do
				table.removebyvalue( new_source,d )
			end
		end
	end
	-- dump( tierce_ary," ----------- tierce_ary = " )
	-- dump( new_source," -------------new_source =  " )

	-- 2，选出四条
	local four_ary = {}
	if #new_source >= 4 then
		four_ary = self:getFourOrThree( new_source,4 )
		for i,v in ipairs(four_ary) do
			table.removebyvalue( new_source,v )
		end
	end

	-- 3,选出三条
	local three_ary = {}
	if #new_source >= 3 then
		three_ary = self:getFourOrThree( new_source,3 )
		for i,v in ipairs(three_ary) do
			table.removebyvalue( new_source,v )
		end
	end
	
	-- 玩家手上的牌重新排序
	if tierce_ary ~= nil then
		self:HandPokerSort( tierce_ary )
	end
	if four_ary ~= nil then
		self:HandPokerSort( four_ary )
	end
	if three_ary ~= nil then
		self:HandPokerSort( three_ary )
	end
	if new_source ~= nil then
		self:HandPokerSort( new_source )
	end
	
	
	dump( HandPokerSort,"-----------HandPokerSort = ")






	-- 给手上的牌重新排序
	-- self:HandPokerSort( tierce_ary )
	-- self:HandPokerSort( four_ary )
	-- self:HandPokerSort( three_ary )
	-- self:HandPokerSort( new_source )
	-- -- 手上牌重新组合
	-- self:finalCombinationOfCards( tierce_ary,four_ary,three_ary,new_source )








	

	-- -- ############### 1，判断收集10张同花顺天胡，和11张牌时有10张同花顺 ###############
	-- local poker = player_childs
	-- -- 牌花色相同
	-- local color_bool = true
	-- -- num_from的值，0是false，1是第一张牌开始，2是第二张牌开始。。。。。10是天胡
	-- local num_from = 1
	-- -- 定义4个表，对收集牌和死牌临时存储
	-- -- local collect1 = {}-- 表1
	-- -- local collect2 = {}-- 表2
	-- -- local collect3 = {}-- 表3
	-- -- local collect4 = {}-- 表4
	-- -- local collect5 = {}-- 表5
	-- -- local collect6 = {}-- 表6
	-- -- local collect7 = {}-- 表7
	-- -- local collect8 = {}-- 表8
	-- -- local collect9 = {}-- 表9
	
	-- local deadPoker = {}-- 死牌表
	-- deadPoker = poker -- 死牌表初始赋值为玩家手牌表

	-- local collect = {} -- 临时存储的表，表里存储
	-- local index = 1
	-- -- 选出所有的同花顺
	-- for i=1,#poker - 1 do

	-- 	-- 控制表数
	-- 	for j=1,10 do
	-- 		if collect[j] == nil then
	-- 			index = j
	-- 			break
	-- 		end
	-- 	end
	-- 	if collect[index] == nil then
	-- 		collect[index] = {}
	-- 	end
	-- 	table.insert( collect[index],deadPoker[1] )
	-- 	table.remove( deadPoker,1 )
	-- 	for j=1,#deadPoker do -- 每张牌，对比是否有同花顺的牌
	-- 		if collect[index][#collect[index]]:getNumberOfBigOrSmall() + 1 == deadPoker[j]:getNumberOfBigOrSmall() 
	-- 			and collect[index][#collect[index]]:getColorIndex() == deadPoker[j]:getColorIndex() then
	-- 				table.insert( collect[index],deadPoker[j] )
	-- 				-- table.remove( deadPoker,i + 1 )
	-- 		end
	-- 	end
	-- 	if #collect[index] < 3 then
	-- 		collect[index] = nil 
	-- 	end
	-- end
	-- -- 选出所有的三条和四条
	-- index = 1
	-- deadPoker = poker
	-- for i=1,#poker - 1 do

	-- 	-- 控制表数
	-- 	for j=1,15 do
	-- 		if collect[j] == nil then
	-- 			index = j
	-- 			break
	-- 		end
	-- 	end
	-- 	table.insert( collect[index],deadPoker[1] )
	-- 	table.remove( deadPoker,1 )
	-- 	for j=1,#deadPoker do -- 每张牌，选出三条和四条
	-- 		if collect[index][#collect[index]]:getNumberOfBigOrSmall() == deadPoker[j]:getNumberOfBigOrSmall() then
	-- 				table.insert( collect[index],deadPoker[j] )
	-- 				-- table.remove( deadPoker,i + 1 )
	-- 		end
	-- 	end
	-- 	if #collect[index] < 3 then
	-- 		collect[index] = nil 
	-- 	end
	-- end
	-- -- 得到一张表，存储了所有可收集牌的方式列表
	-- -- 将表collect的每一个子表进行选择，选出最大的收集的组合牌
	-- table.sort( collect,function ( a,b )
	-- 	return #a > #b
	-- end)
	-- local collect_result = {} -- 最终所收集牌的列表
	-- for i=1,#collect do
	-- 	if collect[i]
	-- end














	-- for i=1,#poker - 1 do -- 从第一张牌开始进行一一对比
	-- 	table.insert( collect1,deadPoker[i] )
	-- 	table.remove( deadPoker,i )

	-- 	for j=1,#deadPoker-1 do -- 每张牌，与后面4张对比是否有同花顺的牌
	-- 		if deadPoker[j]:getNumberOfBigOrSmall() + 1 == deadPoker[j + 1]:getNumberOfBigOrSmall() 
	-- 			and deadPoker[j]:getColorIndex() == deadPoker[j + 1]:getColorIndex() then
	-- 				table.insert( collect1,deadPoker[i + 1] )
	-- 				table.remove( deadPoker,i + 1 )
					
	-- 		elseif deadPoker[i]:getNumberOfBigOrSmall() + 2 == deadPoker[i + 2]:getNumberOfBigOrSmall() 
	-- 			and deadPoker[i]:getColorIndex() == deadPoker[i + 2]:getColorIndex() then
	-- 				table.insert( collect1,deadPoker[i + 1] )
	-- 				table.remove( deadPoker,i + 1 )
	-- 		elseif deadPoker[i]:getNumberOfBigOrSmall() + 3 == deadPoker[i + 3]:getNumberOfBigOrSmall() 
	-- 			and deadPoker[i]:getColorIndex() == deadPoker[i + 3]:getColorIndex() then
	-- 				table.insert( collect1,deadPoker[i + 1] )
	-- 				table.remove( deadPoker,i + 1 )
	-- 		elseif deadPoker[i]:getNumberOfBigOrSmall() + 4 == deadPoker[i + 4]:getNumberOfBigOrSmall() 
	-- 			and deadPoker[i]:getColorIndex() == deadPoker[i + 4]:getColorIndex() then
	-- 				table.insert( collect1,deadPoker[i + 1] )
	-- 				table.remove( deadPoker,i + 1 )			
	-- 		end
	-- 		if #collect1 == i then
	-- 			break
	-- 		end
	-- 	end
	-- end


	-- -- 提取同花顺
	-- for i=1,#poker - 1 do -- 从第一张牌开始进行一一对比
	-- 	for j=1,#deadPoker-1 do -- 每张牌，与后面4张对比是否有同花顺的牌
	-- 		if deadPoker[j]:getNumberOfBigOrSmall() + 1 == deadPoker[j + 1]:getNumberOfBigOrSmall() 
	-- 			and deadPoker[j]:getColorIndex() == deadPoker[j + 1]:getColorIndex() then
	-- 				table.insert( collect1,deadPoker[i] )
	-- 				table.remove( deadPoker,i )
					
	-- 		elseif deadPoker[i]:getNumberOfBigOrSmall() + 2 == deadPoker[i + 2]:getNumberOfBigOrSmall() 
	-- 			and deadPoker[i]:getColorIndex() == deadPoker[i + 2]:getColorIndex() then
	-- 				table.insert( collect1,deadPoker[i] )
	-- 				table.remove( deadPoker,i )
	-- 		elseif deadPoker[i]:getNumberOfBigOrSmall() + 3 == deadPoker[i + 3]:getNumberOfBigOrSmall() 
	-- 			and deadPoker[i]:getColorIndex() == deadPoker[i + 3]:getColorIndex() then
	-- 				table.insert( collect1,deadPoker[i] )
	-- 				table.remove( deadPoker,i )
	-- 		elseif deadPoker[i]:getNumberOfBigOrSmall() + 4 == deadPoker[i + 4]:getNumberOfBigOrSmall() 
	-- 			and deadPoker[i]:getColorIndex() == deadPoker[i + 4]:getColorIndex() then
	-- 				table.insert( collect1,deadPoker[i] )
	-- 				table.remove( deadPoker,i )			
	-- 		end
	-- 	end
	-- end







	-- -- 先判断是否有顺子
	-- -- 第一个顺子插入第一张表
	-- for i = 1,#deadPoker - 2 do
	-- 	if deadPoker[i]:getNumberOfBigOrSmall() + 1 == deadPoker[i + 1]:getNumberOfBigOrSmall() then
	-- 		table.insert( collect1,deadPoker[i] )
	-- 		table.remove( deadPoker,i )
	-- 	else
	-- 		break
	-- 	end
	-- end
	-- if #collect1 < 3 then

	-- end
	-- -- 第二个顺子插入第二张表
	-- if #deadPoker > 2 then
	-- 	for i = 1,#deadPoker - 2 do
	-- 		if deadPoker[i]:getNumberOfBigOrSmall() + 1 == deadPoker[i + 1]:getNumberOfBigOrSmall() then
	-- 			table.insert( collect2,deadPoker[i] )
	-- 			table.remove( deadPoker,i )
	-- 		else
	-- 			break
	-- 		end
	-- 	end
	-- end















	-- -- 天胡
	-- if #poker == 10 then
	-- 	for i=1,#poker - 1 do
	-- 		if poker[i]:getColorIndex() ~= poker[i + 1]:getColorIndex() then
	-- 			color_bool = false
	-- 			break
	-- 		end
	-- 		if poker[i]:getNumberOfBigOrSmall() + 1 == poker[i + 1]:getNumberOfBigOrSmall() then
	-- 			num_from = 10
	-- 		else
	-- 			num_from = 0
	-- 			break
	-- 		end
	-- 	end
	-- end
	-- if color_bool == true and num_from == 10 then
	-- 	-- 天胡
	-- 	print( "-------------tianhu" )

	-- 	return
	-- end
	-- -- 10连同花顺
	-- color_bool = true
	-- num_from = 1
	-- if #poker == 11 then
	-- 	for i=1,#poker - 2 do
	-- 		if poker[i]:getColorIndex() ~= poker[i + 1]:getColorIndex() then
	-- 			color_bool = false
	-- 			break
	-- 		end
	-- 		if poker[i]:getNumberOfBigOrSmall() + 1 ~= poker[i + 1]:getNumberOfBigOrSmall() then
	-- 			num_from = 0
	-- 			break
	-- 		end
	-- 	end0
	-- 	for i=2,#poker - 1 do
	-- 		if poker[i]:getColorIndex() ~= poker[i + 1]:getColorIndex() then
	-- 			color_bool = false
	-- 			break
	-- 		end
	-- 		if poker[i]:getNumberOfBigOrSmall() + 1 ~= poker[i + 1]:getNumberOfBigOrSmall() then
	-- 			num_from = 0
	-- 			break
	-- 		else
	-- 			num_from = 2
	-- 		end
	-- 	end
	-- end
	-- if color_bool == true and num_from == 1 then
	-- 	-- 摸一张牌后，前10张同花顺，直接胡牌
	-- elseif color_bool == true and num_from == 2 then
	-- 	-- 摸一张牌后，后10张同花顺，直接胡牌
	-- end

	-- ############### 2，判断9张同花顺 #############
	-- 3，判断8张同花顺
	-- 4，判断7张同花顺
	-- 5，判断6张同花顺
	-- 6，判断5张同花顺
	-- 7，判断4张同花顺，4条
	-- 8，判断3张同花顺，3条

end


-- -- imgBack初始面，imgFace結束面，position移动终点位置，time动作延迟时间
-- function GamePlay:playPokerMove( imgBack,imgFace,position,time )
-- 	local scale = cc.ScaleTo:create( 0.2,0,1 )
-- 	local skew = cc.SkewTo:create( 0.2, 0, -20 )--倾斜
-- 	local scale1 = cc.ScaleTo:create( 0.2,1 )
-- 	local skew1 = cc.SkewTo:create( 0.2, 0, 0 )
-- 	local hide = cc.Hide:create()
-- 	local move_to = cc.MoveTo:create( 0.4,position )
-- 	local delay = cc.DelayTime:create( time * 0.5 )
-- 	local call = cc.CallFunc:create(function ()
-- 		imgBack:setLocalZOrder( 0 )
-- 	end)
-- 	local spawn1 = cc.Spawn:create({ scale1,skew1 })
-- 	local spawn = cc.Spawn:create({ scale,skew })
-- 	local seq = cc.Sequence:create({ spawn,hide,spawn1 })
-- 	local spawn2 = cc.Spawn:create({ seq,move_to })
-- 	local seq1 = cc.Sequence:create({ delay,spawn2,call })
-- 	imgBack:runAction( seq1 )
	


-- 	local scale = cc.ScaleTo:create( 0.2,0,1 )
-- 	local skew = cc.SkewTo:create( 0.2, 0, -20 )--倾斜
-- 	local scale1 = cc.ScaleTo:create( 0.2,1 )
-- 	local skew1 = cc.SkewTo:create( 0.2, 0, 0 )
-- 	local hide1 = cc.Hide:create()
-- 	local show = cc.Show:create()
-- 	local move_to = cc.MoveTo:create( 0.4,position )
-- 	local delay = cc.DelayTime:create( time * 0.5 )
-- 	local call = cc.CallFunc:create(function ()
-- 		imgFace:setLocalZOrder( 0 )
-- 	end)
-- 	local spawn1 = cc.Spawn:create({ scale1,skew1 })
-- 	local spawn = cc.Spawn:create({ scale,skew })
-- 	local seq = cc.Sequence:create({ hide1,spawn,show,spawn1 })
-- 	local spawn2 = cc.Spawn:create({ seq,move_to })
-- 	local seq1 = cc.Sequence:create({ delay,spawn2,call })
-- 	imgFace:runAction( seq1 )
-- end


-- 玩家手牌距离,handPokerNum是手上已有牌数
function GamePlay:playerHandPokerSpaceBetween( handPokerNum )
	assert( handPokerNum," !! num is nil !! ")
	assert( handPokerNum >= 0 and handPokerNum < 11," !! handPokerNum is error !! " )
	local index = 1000

	local img = ccui.ImageView:create( "image/play/bei.png",1 )
	local size = img:getContentSize()
	-- 游戏中摸牌手上11张时
	if handPokerNum == 11 then
		local x_pos = ( index - size.width )/10 * ( handPokerNum - 1 )
		return x_pos
	end
	-- 游戏开始，初始发牌
	if handPokerNum == 10 then
		local x_pos = ( index - size.width )/9 * ( handPokerNum - 1 )
		return x_pos
	else
		local x_pos = ( index - size.width )/9 * (handPokerNum - 1 )
		return x_pos
	end
end

-- 创建牌堆
function GamePlay:createPokerStack()
	-- print("------------1111")
	for i = 1,#self._pokerStack do
		local img = NodePoker.new( self,self._pokerStack[i] )
		self.NodeStack:addChild( img )
		img:setPosition( -i,i )
	end
end

function GamePlay:onEnter()
	GamePlay.super.onEnter( self )

	casecadeFadeInNode( self._csbNode,0.5 )
	-- 发牌结束播放帧动画
	self:frameAnimation()

end
-- 帧动画
function GamePlay:frameAnimation()
	-- -- 显示帧动画2的图
	-- self.SpriteFist:setVisible( false )
	-- self.ImageAIHand:setVisible( false )
	-- -- 隐藏帧动画1的手
	-- self.ImageAIHand1:setVisible( true )

	local index = 1
	local time = -1
	self:schedule( function()
		-- 当AI摸牌，停止计时器，停止帧动画------------放这里好像还是有点问题，看是否放摸牌的时候
		if #self.AIHandPokerIn:getChildren() == 11 then
			self:unSchedule()
			return
		end
		-- if #self.AIHandPokerIn:getChildren() == 11 then
		-- 	index = index + #self.AIHandPokerIn:getChildren()
		-- end
		-- if index == 12 then
		-- 	self:unSchedule()
		-- 	return
		-- end
		-- 播放人物动画
		if time == -1 then
			if #self.AIHandPokerIn:getChildren() == 10 then
				-- 显示帧动画2的图
				self.SpriteFist:setVisible( false )
				self.ImageAIHand:setVisible( false )
				-- 隐藏帧动画1的手
				self.ImageAIHand1:setVisible( true )
				self._csbAct:play( "animation0",true )
				-- index = index + #self.AIHandPokerIn:getChildren()
				time = time + 1
			end
		end
		

		-- 切换帧动画
		if time == 12 then
			-- self._csbNode:stopAllActions()
			self._csbAct:pause()

			self._csbAct:stop()
			-- print( "---------stop" )
			-- 显示帧动画2的图
			self.SpriteFist:setVisible( true )
			self.ImageAIHand:setVisible( true )
			-- 隐藏帧动画1的手
			self.ImageAIHand1:setVisible( false )
			self._csbAct:play( "animation1",false )
			time = -3
		end

		if time ~= -1 then
			time = time + 1
		end
	end,1)
end






function GamePlay:back()
	addUIToScene( UIDefine.LIKUI_KEY.Start_UI )
	removeUIFromScene( UIDefine.LIKUI_KEY.Play_UI )
end


return GamePlay