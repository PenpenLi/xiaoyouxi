

local NodePoker = import( "app.viewslikui.NodePoker" )
local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )

    self:addCsb( "Play.csb" )

    self._pokerStack = getRandomArray( 1,52 )-- 随机一副牌

    -- test
    -- self._pokerStack = {40,51,9,22,35,11,24,37,1,2,3,26}
    

    self:addNodeClick( self.ImageBack,{
    	endCallBack = function ()
    		self:back()
    	end
    })

    -- 点击牌堆
    self:addNodeClick( self.PanelTouchPaiDui,{
    	endCallBack = function ()
    		self:clickPaiDui()
    	end
    })

    -- 点击出牌
    self:addNodeClick( self.PanelTouchOut,{
    	endCallBack = function ()
    		self:clickPaiOut()
    	end
    })

    self:loadUi()

    self._moState = 1 -- 1:只能摸出牌 2:出牌和牌堆都可以摸 3:都不能摸，玩家手牌可出牌，4:关闭所有触摸
end

function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )
	-- 发牌结束播放帧动画
	self:frameAnimation()
end

function GamePlay:loadUi()
	-- 1:创建背牌
	self:createPokerStack()
	-- 2:发牌
	self:firstSendPoker()
	self:hideAIHandAndPoker()
end
-- 创建牌堆
function GamePlay:createPokerStack()
	for i = 1,#self._pokerStack do
		local img = NodePoker.new( self,self._pokerStack[i] )
		self.NodeStack:addChild( img )
		img:setPosition( -i,i )
	end
end
-- 隐藏AI的牌和手
function GamePlay:hideAIHandAndPoker()
	-- self.ImageAIHand:setVisible( false )
	for i = 1,10 do
		self["ImageAIpoker"..i]:setVisible( false )
	end
	-- self.SpriteFist:setVisible( false )
	self.ImageAIHand1:setVisible( false )
end

-- 初次发牌
function GamePlay:firstSendPoker()
	local time = 0.3
	local actions = {}
	for i=1,10 do
		local delay = cc.DelayTime:create( 0.2 )
		table.insert( actions,delay )
		local call = cc.CallFunc:create( function()
			-- 1:创建玩家手牌
			self:createPlayerPokerFromPaiDui( time )
			-- 2:创建AI手牌
			self:createAIPokerFromPaiDui( time,i )
		end )
		table.insert( actions,call )
		if i == 10 then
			local delay2 = cc.DelayTime:create( 1 )
			table.insert( actions,delay2 )
			local call_sort = cc.CallFunc:create( function ()
				-- 3:玩家手牌排序
				self:playerHandPokerSort()
				-- 4:AI手牌排序
				self:AIHandPokerSort()
			end)
			table.insert( actions,call_sort )
			local delay3 = cc.DelayTime:create( 1 )
			table.insert( actions,delay3 )
			local call_draw = cc.CallFunc:create( function ()
				-- 4:创建牌到发牌区域
				self:firstLaterDraw( 0.3 )
			end)
			table.insert( actions,call_draw )

			local delay4 = cc.DelayTime:create( 0.4 )
			table.insert( actions,delay4 )
			local call_player_click = cc.CallFunc:create( function()
				-- 5:为玩家牌创建点击
				self:addClickForAllPlayerHandPoker()
			end )
			table.insert( actions,call_player_click )
		end
	end
	self:runAction( cc.Sequence:create( actions ) )
end

function GamePlay:createAIPokerFromPaiDui( time,index )
	assert( time," !! time is nil !! " )
	local stack_childs = self.NodeStack:getChildren()
	local top_poker = stack_childs[#stack_childs]
	self:createAiPokerToHand( top_poker )
	self:AIPokerMove( top_poker,time )
	-- 手的动作
	if not self._handActionMark then
		self._handActionMark = true
		performWithDelay( self.ImageAIHand1,function()
			self:AIHandAction( time )
		end,time / 2 )
	end
	-- 显示
	-- 发完牌以后AI摸牌直接返回，没有第11张显示
	if index > 10 then
		return
	end
	performWithDelay( self["ImageAIpoker"..index],function()
		self["ImageAIpoker"..index]:setVisible( true )
	end,time )
end


-- 根据现有的poker创建ai手牌
function GamePlay:createAiPokerToHand( poker )
	local img_startPos = cc.p(poker:getPosition())
	local img_startWorldPos = poker:getParent():convertToWorldSpace( img_startPos )
	local img_startNodePos = self.AIHandPokerIn:convertToNodeSpace( img_startWorldPos )
	poker:retain()
	poker:removeFromParent()
	self.AIHandPokerIn:addChild( poker )
	poker:release()
	poker:setPosition( img_startNodePos )
end

-- AI手摸牌动作
function GamePlay:AIActionIn( ... )
	-- body
end

function GamePlay:AIPokerMove( top_poker,time )
	local rot = self:getiRotate()
	local move_to = cc.MoveTo:create( time,cc.p( 0,0 ))
	local scale_to = cc.ScaleTo:create( time,0.5 )
	local rotate = cc.RotateTo:create( time,rot )
	local spawn = cc.Spawn:create( { move_to,scale_to,rotate } )
	local hide = cc.Hide:create()
	local seq = cc.Sequence:create({ spawn,hide })
	top_poker:runAction( seq )
end

-- AI 的 手的动作
function GamePlay:AIHandAction( time )
	local hand_pos = cc.p(self.ImageAIHand1:getPosition())
	self.ImageAIHand1:setVisible( true )
	self.ImageAIHand1:setPositionX( hand_pos.x + 150 )
	self.ImageAIHand1:setRotation( -60 )
	local hand_rotate = cc.RotateTo:create( time,0 )
	local hand_move_to = cc.MoveTo:create( time,hand_pos )
	local hand_spawn = cc.Spawn:create( { hand_rotate,hand_move_to } )
	self.ImageAIHand1:runAction( hand_spawn )
end



function GamePlay:getiRotate()
	local ai_childs = self.AIHandPokerIn:getChildren()
	local rot = 15
	return rot - #ai_childs * 3
end

-------------------------------------------------------------------------------------------------------------------
-- AI扑克排序
function GamePlay:AIHandPokerSort()--------------AI的排序就是在玩家的方法里面加了一个条件。不然玩家排序的方法全部复制只改一个self.AIHandPokerIn？
	-- AI的牌排序
	-- local childs = self.AIHandPokerIn:getChildren()
	-- dump( childs,"------------childs = ")
	local player_childs,tierce_pokers,four_pokers,three_pokers = self:HandPokerSort( self.AIHandPokerIn )
	-- local childs1 = self.AIHandPokerIn:getChildren()
	-- dump( childs1,"------------childs1 = ")

	-- 显示AI的牌
	self:AIShowPoker()
end
-- AI显示明牌
function GamePlay:AIShowPoker()
	local index = -950
	local player_childs,tierce_pokers,four_pokers,three_pokers = self:HandPokerSort( self.AIHandPokerIn )
	for i = 1,#player_childs do
		player_childs[i]:showQuan1( false )
		player_childs[i]:showQuan2( false )
		-- local index = self:playerHandPokerSpaceBetween( i )
		player_childs[i]:setLocalZOrder( i )
		local move_to = cc.MoveTo:create( 0.5,cc.p( index + i * 100,120 ))
		player_childs[i]:runAction( move_to )
		player_childs[i]:setVisible( true )
		player_childs[i]:setRotation( 0 )
		player_childs[i]:setScale( 0.8 )
		player_childs[i]:showPoker()
		-- local hide = cc.Show:create()
		-- player_childs[i]:runAction( hide )
	end
	-- 0.6秒之后 加圈
	performWithDelay( self,function()
		self:showPokersQuan( tierce_pokers )
		self:showPokersQuan( four_pokers )
		self:showPokersQuan( three_pokers )
	end,0.6 )	
end

-- AI从牌堆摸牌
function GamePlay:AIGetPokerFromStack()
	self:createAIPokerFromPaiDui( 0.3,11 )
	performWithDelay( self,function()
		self:AIShowPoker()
	end,1 )	
	

end
-- 从桌面摸牌
function GamePlay:AIGetPokerFromDesktop( time )
	assert( time," !! time is nil !! " )
	local stack_childs = self.NodeOutCard:getChildren()
	local top_poker = stack_childs[#stack_childs]
	self:createAiPokerToHand( top_poker )
	self:AIPokerMove( top_poker,time )

	-- AI摸牌的动作
	


end

-- AI摸牌
function GamePlay:AIGetPoker()
	local logic = self:AIGetPokerLogic()
	if logic == 1 then
		self.AIGetPokerFromDesktop()
	else
		self:AIGetPokerFromStack()
	end
	
end

-- AI摸牌逻辑
function GamePlay:AIGetPokerLogic()
	local get_desktopLogicNum = self:getAIEffectiveData()
	local tierce_ary,four_ary,three_ary,new_source = self:getPlayerEffectiveData( node )
	-- 如果桌面牌有用，返回1，否则返回0
	if #new_source >= #get_desktopLogicNum then
		return 1
	else
		return 0
	end

	
end

-- AI预算桌面的明牌是否有用
function GamePlay:getAIEffectiveData()
	local player_childs = self.AIHandPokerIn:getChildren()

	-- 将桌面的第一张牌放入AI牌里排序判断
	local childs = self.NodeOutCard:getChildren()
	local top_pokerOfDesktop = childs[#childs]
	table.insert( player_childs,top_pokerOfDesktop )


	table.sort( player_childs, function ( a,b )
		if a:getNumberOfBigOrSmall() ~= b:getNumberOfBigOrSmall() then
			return a:getNumberOfBigOrSmall() < b:getNumberOfBigOrSmall()
		elseif a:getColorIndex() ~= b:getColorIndex() then
			return a:getColorIndex() < b:getColorIndex()
		end
	end )

	-- 提取node里面的数据，索引
	local source = {}
	for i=1,#player_childs do
		table.insert( source,player_childs[i]:getNumberIndex() )
	end	
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
	-- 2，选出四条
	local four_ary = {}
	if #new_source >= 4 then
		four_ary = self:getFourOrThree( new_source,4 )
		for i,v in ipairs(four_ary) do
			for a,b in ipairs(v) do
				table.removebyvalue( new_source,b )
			end
			
		end
	end
	-- 3,选出三条
	local three_ary = {}
	if #new_source >= 3 then
		three_ary = self:getFourOrThree( new_source,3 )
		for i,v in ipairs(three_ary) do
			for a,b in ipairs(v) do
				table.removebyvalue( new_source,b )
			end
		end
	end
	-- dump( tierce_ary,"------------------> tierce_ary = " )
	-- dump( four_ary,"------------------> four_ary = " )
	-- dump( three_ary,"------------------> three_ary = " )
	-- dump( new_source,"------------------> new_source = " )
	return new_source
end



-------------------------------------------------------------------------------------------------------------------









-- 从牌堆里面发牌到玩家手牌
function GamePlay:createPlayerPokerFromPaiDui( time )
	assert( time," !! time is nil !! " )
	local stack_childs = self.NodeStack:getChildren()
	local top_poker = stack_childs[#stack_childs]
	self:createPlayerPokerToHand( top_poker )

	local player_childs = self.PlayerHandPoker:getChildren()
	local x_pos = self:playerHandPokerSpaceBetween( #player_childs )
	local position_end = cc.p( x_pos,0 )
	self:playerPokerMove( top_poker,position_end,time )
	top_poker:showObtAniUseScaleTo( time )
end

-- 根据现有的poker创建玩家手牌
function GamePlay:createPlayerPokerToHand( poker )
	local img_startPos = cc.p(poker:getPosition())
	local img_startWorldPos = poker:getParent():convertToWorldSpace( img_startPos )
	local img_startNodePos = self.PlayerHandPoker:convertToNodeSpace( img_startWorldPos )
	poker:retain()
	poker:removeFromParent()
	self.PlayerHandPoker:addChild( poker )
	poker:release()
	poker:setPosition( img_startNodePos )
end

function GamePlay:playerPokerMove( poker,position,time )
	local move_to = cc.MoveTo:create( time * 2,position )
	poker:runAction( move_to )
end

-- 为玩家的单个poker创建点击
function GamePlay:addClickForPlayerHandPoker( poker )
	assert( poker," !! poker is nil !! " )
	poker:addPokerClick()
end

-- 为玩家的所有poker创建点击
function GamePlay:addClickForAllPlayerHandPoker()
	local pokers = self.PlayerHandPoker:getChildren()
	for i,v in ipairs( pokers ) do
		self:addClickForPlayerHandPoker( v )
	end
end










-- 玩家手牌排序
function GamePlay:playerHandPokerSort()
	-- 玩家手牌排序
	local player_childs,tierce_pokers,four_pokers,three_pokers = self:HandPokerSort( self.PlayerHandPoker )
	-- 移动牌
	for i = 1,#player_childs do
		player_childs[i]:showQuan1( false )
		player_childs[i]:showQuan2( false )
		local index = self:playerHandPokerSpaceBetween( i )
		player_childs[i]:setLocalZOrder( i )
		local move_to = cc.MoveTo:create( 0.5,cc.p( index,0 ))
		player_childs[i]:runAction( move_to )
	end
	-- 0.6秒之后 加圈
	performWithDelay( self,function()
		self:showPokersQuan( tierce_pokers )
		self:showPokersQuan( four_pokers )
		self:showPokersQuan( three_pokers )
	end,0.6 )
end
-- 玩家或AI手牌排序
function GamePlay:HandPokerSort( node )
	local sort_childs = {}
	local tierce_ary,four_ary,three_ary,new_source = self:getPlayerEffectiveData( node )

	local tierce_pokers = {}
	local four_pokers = {}
	local three_pokers = {}

	local get_result_source = function( dataAry,quanSource )
		for i,v in ipairs( dataAry ) do
			local meta = {}
			for a,b in ipairs( v ) do
				local poker = self:getPlayerPokerByNumberIndex( node,b )
				table.insert( sort_childs,poker )
				table.insert( meta,poker )
			end
			table.insert( quanSource,meta )
		end
	end

	get_result_source( tierce_ary,tierce_pokers )
	get_result_source( four_ary,four_pokers )
	get_result_source( three_ary,three_pokers )
	
	-- 排序
	table.sort( new_source,function ( a,b )
		local a_config = likui_config.poker[a]
		local b_config = likui_config.poker[b]
		if a_config.num ~= b_config.num then
			return a_config.num < b_config.num
		end
		if a_config.color ~= b_config.color then
			return a_config.color < b_config.color
		end
	end)

	for i,v in ipairs( new_source ) do
		local poker = self:getPlayerPokerByNumberIndex( node,v )
		table.insert( sort_childs,poker )
	end
	return sort_childs,tierce_pokers,four_pokers,three_pokers
end

-- 显示poker的圈
function GamePlay:showPokersQuan( pokers )
	for i,v in ipairs( pokers ) do
		for a,b in ipairs(v) do
			if a ~= #v then
				b:showQuan1( true )
				b:showQuan2( true )
			else
				b:showQuan1( true )
			end
		end
	end
end

-- 判断玩家或AI手牌收集情况，玩家或AI的node里的孩子列表(已经排序)，重新排序
function GamePlay:getPlayerEffectiveData( node )
	local player_childs = node:getChildren()
	-- dump( player_childs[10],"-----------player_childs[10]:getNumberOfBigOrSmall() = ")
	-- if #player_childs == 11 then
	-- 	dump( player_childs[11],"-----------player_childs[11]:getNumberOfBigOrSmall() = ")
	-- end

	table.sort( player_childs, function ( a,b )
		if a:getNumberOfBigOrSmall() ~= b:getNumberOfBigOrSmall() then
			return a:getNumberOfBigOrSmall() < b:getNumberOfBigOrSmall()
		elseif a:getColorIndex() ~= b:getColorIndex() then
			return a:getColorIndex() < b:getColorIndex()
		end
	end )

	-- 提取node里面的数据，索引
	local source = {}
	for i=1,#player_childs do
		table.insert( source,player_childs[i]:getNumberIndex() )
	end	
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
	-- 2，选出四条
	local four_ary = {}
	if #new_source >= 4 then
		four_ary = self:getFourOrThree( new_source,4 )
		for i,v in ipairs(four_ary) do
			for a,b in ipairs(v) do
				table.removebyvalue( new_source,b )
			end
			
		end
	end
	-- 3,选出三条
	local three_ary = {}
	if #new_source >= 3 then
		three_ary = self:getFourOrThree( new_source,3 )
		for i,v in ipairs(three_ary) do
			for a,b in ipairs(v) do
				table.removebyvalue( new_source,b )
			end
		end
	end
	-- dump( tierce_ary,"------------------> tierce_ary = " )
	-- dump( four_ary,"------------------> four_ary = " )
	-- dump( three_ary,"------------------> three_ary = " )
	-- dump( new_source,"------------------> new_source = " )
	return tierce_ary,four_ary,three_ary,new_source
end

-- 初次发完牌后牌堆翻牌
function GamePlay:firstLaterDraw( time )
	assert( time," !! time is nil !! " )
	local pokers = self.NodeStack:getChildren()
	local top_poker = pokers[#pokers]
	local position_began = cc.p( top_poker:getPosition()) 
	local position_world = top_poker:getParent():convertToWorldSpace( position_began )
	local position_nodeBegan = self.NodeOutCard:convertToNodeSpace( position_world )
	top_poker:retain()
	top_poker:removeFromParent()
	self.NodeOutCard:addChild( top_poker )
	top_poker:release()

	top_poker:setPosition( position_nodeBegan )
	local position_end = cc.p( 0,0 )
	self:playerPokerMove( top_poker,position_end,time )
	top_poker:showObtAniUseScaleTo( time )
	-- 显示
	self.ImagePassOrShow:setVisible( true )
	self.ImageDeadCardBg:setVisible( true )
end




-----------------------------------------------------------------------------------------------------------------------------
-- 将玩家要出的手牌添加到出牌区域node
function GamePlay:createPlayerPokerToSend( poker )
	local img_startPos = cc.p(poker:getPosition())
	local img_startWorldPos = poker:getParent():convertToWorldSpace( img_startPos )
	local img_startNodePos = self.NodeOutCard:convertToNodeSpace( img_startWorldPos )
	poker:retain()
	poker:removeFromParent()
	self.NodeOutCard:addChild( poker )
	poker:release()
	poker:setPosition( img_startNodePos )
end

-- 玩家出牌
function GamePlay:playerSendPoker( poker )
	-- local stack_childs = self.NodeStack:getChildren()
	-- local top_poker = stack_childs[#stack_childs]
	self:createPlayerPokerToSend( poker )

	-- local player_childs = self.PlayerHandPoker:getChildren()
	-- local x_pos = self:playerHandPokerSpaceBetween( #player_childs )
	local position_end = cc.p( 0,0 )
	self:playerPokerMove( poker,position_end,0.3 )
	-- 重新排序
	self:playerHandPokerSort()
	-- 玩家出牌后，AI摸牌逻辑
	performWithDelay( self,function ()
		print( "----------------aaaaaaaaaaa" )
		self:AIGetPoker()
	end,1 )
	self._moState = 4
end





--------------------------------------------------------------------------------------------------------------------------------------










-- 用序号换成poker
function GamePlay:getPlayerPokerByNumberIndex( node,numIndex )-------------------------------------------------------这里给加一个node？还是复制一个这个方法？
	assert( numIndex," !! numIndex is nil !! " )
	-- dump( numIndex,"------------numIndex = ")
	-- local player_childs = self.PlayerHandPoker:getChildren()
	local player_childs = node:getChildren()
	for i,v in ipairs( player_childs ) do
		if v:getNumberIndex() == numIndex then
			return v
		end
	end
	assert( false," !! error not found numIndex = "..numIndex.." !! " )
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
		local meta = clone( stack )
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
		local meta = {}
		for a,b in ipairs( source ) do
			if likui_config.poker[b].num == v then
				table.insert( meta,b )
			end
		end
		table.insert( final_arry,meta )
	end
	return final_arry
end
-- 将一个表V值插入另一表
function GamePlay:tableInsertV( ary,ary1 )
	for i=1,#ary1 do
		table.insert( ary,ary1[i] )
	end
end


-- 玩家手牌距离,handPokerNum是手上已有牌数
function GamePlay:playerHandPokerSpaceBetween( pos )
	-- assert( pos," !! num is nil !! ")
	-- assert( pos >= 0 and pos <= 11," !! pos is error pos = "..pos.." !! " )
	-- local index = 1000

	-- local img = ccui.ImageView:create( "image/play/bei.png",1 )
	-- local size = img:getContentSize()
	-- -- 游戏中摸牌手上11张时
	-- if pos == 11 then
	-- 	local x_pos = ( index - size.width )/10 * ( pos - 1 )
	-- 	return x_pos
	-- end
	-- -- 游戏开始，初始发牌
	-- if pos == 10 then
	-- 	local x_pos = ( index - size.width )/9 * ( pos - 1 )
	-- 	return x_pos
	-- else
	-- 	local x_pos = ( index - size.width )/9 * (pos - 1 )
	-- 	return x_pos
	-- end

	return (pos - 1) * 100
end

-- 帧动画
function GamePlay:frameAnimation()
	self:playCsbAction( "animation0",true )
end





function GamePlay:clickPaiDui()
	-- 1:
	if self._moState == 1 or self._moState == 3 then
		return
	end
	-- 2:
	local pokers = self.NodeStack:getChildren()
	if #pokers == 0 then
		return
	end
end


function GamePlay:clickPaiOut()
	if self._moState == 3 then
		return
	end

	local pokers = self.NodeOutCard:getChildren()
	if #pokers == 0 then
		return
	end

	-- 放入牌到玩家手中
	local stack_childs = self.NodeOutCard:getChildren()
	local top_poker = stack_childs[#stack_childs]
	self:createPlayerPokerToHand( top_poker )
	local player_childs = self.PlayerHandPoker:getChildren()
	local x_pos = self:playerHandPokerSpaceBetween( #player_childs )
	local position_end = cc.p( x_pos,0 )
	top_poker:setLocalZOrder( #player_childs + 1 )
	self:playerPokerMove( top_poker,position_end,0.3 )
	performWithDelay( self,function()
		self:playerHandPokerSort()
		
	end,1 )
	
end




function GamePlay:back()
	addUIToScene( UIDefine.LIKUI_KEY.Start_UI )
	removeUIFromScene( UIDefine.LIKUI_KEY.Play_UI )
end


return GamePlay