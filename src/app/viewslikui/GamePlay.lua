

local NodePoker = import( "app.viewslikui.NodePoker" )
local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )

    self:addCsb( "Play.csb" )

    self._pokerStack = getRandomArray( 1,52 )-- 随机一副牌
    -- self._pokerStack = {14,22,2,1,25,23,26,3,15,4,18,5,19,6,51,7,32,8,33,9,52,10,29,11}
    -- self._pokerStack = {50,17,51,16,38,15,25,13,12,11,5,10,31,9,44,7,46,4,33,2,20,1,52}
    -- test
    -- self._pokerStack = {1,2,4,5,7,9,20,33,46,52}
    
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

    -- 点击过牌
    self:addNodeClick( self.ButtonPass,{
    	endCallBack = function ()
    		self:pass()
    	end
    })
    -- 点击摊牌
    self:addNodeClick( self.ButtonShow,{
    	endCallBack = function ()
    		self:over_show( 1 )
    	end
    })

    self:addNodeClick( self.ButtonSound,{
    	endCallBack = function ()
    		self:setSound()
    	end
    })
    self:addNodeClick( self.ButtonMusic,{
    	endCallBack = function ()
    		self:setMusic()
    	end
    })

    self:loadUi()

    self._moState = 1 -- 1:只能摸出牌 2:出牌和牌堆都可以摸 3:都不能摸，玩家手牌可出牌，4:关闭所有触摸 等待ai的逻辑,5:只能从牌堆摸牌 6:摊牌，7:初次pass状态
    self._playerTanPaiGroupIndex = 0
    self._aiTanPaiGroupIndex = 0
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

	self:likuiIconAction()

	-- 设置按钮
	local state = G_GetModel("Model_Sound"):isVoiceOpen()
	if state then
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
	else
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
		-- 变灰
		graySprite( self.ButtonSound:getVirtualRenderer():getSprite() )
	end
	state = G_GetModel("Model_Sound"):isMusicOpen()
	if state then
		self.ButtonMusic:loadTexture( "image/start/music.png",1 )
	else
		self.ButtonMusic:loadTexture( "image/start/music.png",1 )
		-- 变灰
		graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )
	end

	-- 显示金币
	local coin = G_GetModel("Model_LiKui"):getInstance():getCoin()
	self.TextCoin:setString( coin )
end

function GamePlay:likuiIconAction()
	local actions = {}
	local delay_time = 0.5
	local call_sp1 = cc.CallFunc:create( function()
		self.SpriteLikui:setSpriteFrame( "image/frame/likui1.png" )
	end )
	local delay1 =  cc.DelayTime:create( delay_time )
	local call_sp2 = cc.CallFunc:create( function()
		self.SpriteLikui:setSpriteFrame( "image/frame/likui2.png" )
	end )
	local delay2 =  cc.DelayTime:create( delay_time )
	local call_sp3 = cc.CallFunc:create( function()
		self.SpriteLikui:setSpriteFrame( "image/frame/likui3.png" )
	end )
	local delay3 =  cc.DelayTime:create( delay_time )
	local call_sp4 = cc.CallFunc:create( function()
		self.SpriteLikui:setSpriteFrame( "image/frame/likui2.png" )
	end )
	local delay4 =  cc.DelayTime:create( delay_time )

	table.insert( actions,call_sp1 )
	table.insert( actions,delay1 )
	table.insert( actions,call_sp2 )
	table.insert( actions,delay2 )
	table.insert( actions,call_sp3 )
	table.insert( actions,delay3 )
	table.insert( actions,call_sp4 )
	table.insert( actions,delay4 )

	local seq = cc.Sequence:create( actions )
	local rep = cc.RepeatForever:create( seq )
	self.SpriteLikui:runAction( rep )
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
	self.ButtonPass:setVisible( false )
	self.ButtonShow:setVisible( false )
	self.ImageDeadCardBg:setVisible( false )
	self.TextAIPass:setVisible( false )

	self.ImageResultAi:setVisible( false )
	self.ImageResultPlayer:setVisible( false )

	self.NodeStack:setLocalZOrder( 5 )
	self.NodeOutCard:setLocalZOrder( 10 )
	self.AIHandPokerIn:setLocalZOrder( 50 )
	self.PlayerHandPoker:setLocalZOrder( 51 )
end

-- 初次发牌
function GamePlay:firstSendPoker()
	local time = 0.5
	local actions = {}
	for i=1,10 do
		local delay = cc.DelayTime:create( 0.2 )
		table.insert( actions,delay )
		local call = cc.CallFunc:create( function()
			-- 1:创建玩家手牌
			self:createPlayerPokerFromPaiDui( time )
			-- 2:创建AI手牌
			self:createAIPokerFromPaiDui( time,i )

			if G_GetModel("Model_Sound"):isVoiceOpen() then
				audio.playSound("lkmp3/sendpoker.mp3", false)
			end
		end )
		table.insert( actions,call )
		if i == 10 then
			local delay2 = cc.DelayTime:create( time * 2 )
			table.insert( actions,delay2 )
			local call_sort = cc.CallFunc:create( function ()
				-- 3:玩家手牌排序
				self:playerHandPokerSort()
				-- 4:AI手牌排序
				self:AIHandPokerSort()
				self:loadDeadUi()
			end)
			table.insert( actions,call_sort )
			local delay3 = cc.DelayTime:create( time * 2 )
			table.insert( actions,delay3 )
			local call_draw = cc.CallFunc:create( function ()
				-- 4:创建牌到发牌区域
				self:firstLaterDraw( time - 0.2 )
			end)
			table.insert( actions,call_draw )

			local delay4 = cc.DelayTime:create( time )
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
	-- self.ButtonPass:setVisible( true )
	self.ImageDeadCardBg:setVisible( true )
	performWithDelay( self.ButtonPass,function ()
		self.ButtonPass:setVisible( true )
	end,0.5)
end





















-- ################################ AI 的代码区 Start ##################################################
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
	if index then
		performWithDelay( self["ImageAIpoker"..index],function()
			self["ImageAIpoker"..index]:setVisible( true )
		end,time )
	end
end


-- 根据现有的poker创建ai手牌
function GamePlay:createAiPokerToHand( poker )
	if poker == nil then
		-- 强制摊牌
		self:over_show( 0 )
		return
	end
	local img_startPos = cc.p(poker:getPosition())
	local img_startWorldPos = poker:getParent():convertToWorldSpace( img_startPos )
	local img_startNodePos = self.AIHandPokerIn:convertToNodeSpace( img_startWorldPos )
	poker:retain()
	poker:removeFromParent()
	self.AIHandPokerIn:addChild( poker )
	poker:release()
	poker:setPosition( img_startNodePos )
end


function GamePlay:AIPokerMove( top_poker,time )
	if top_poker == nil then
		return
	end
	local rot = self:getiRotate()
	local move_to = cc.MoveTo:create( time,cc.p( 0,0 ))
	local scale_to = cc.ScaleTo:create( time,0.3 )
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

-- AI扑克排序
function GamePlay:AIHandPokerSort()
	self:AIShowPoker()
end
-- AI显示明牌
function GamePlay:AIShowPoker()
	-- -- 提取node里面的数据，索引
	-- local source = self:getNumberIndexSourceByNode( self.AIHandPokerIn )
	-- -- 玩家手牌排序
	-- local sort_childs,tierce_pokers,four_pokers,three_pokers = self:handPokersGroup( self.AIHandPokerIn,source )
	-- local index = -950
	-- for i = 1,#sort_childs do
	-- 	sort_childs[i]:showQuan1( false )
	-- 	sort_childs[i]:showQuan2( false )
	-- 	sort_childs[i]:setLocalZOrder( i )
	-- 	local move_to = cc.MoveTo:create( 0.5,cc.p( index + i * 100,120 ))
	-- 	sort_childs[i]:runAction( move_to )
	-- 	sort_childs[i]:setVisible( true )
	-- 	sort_childs[i]:setRotation( 0 )
	-- 	sort_childs[i]:setScale( 1 )
	-- 	sort_childs[i]:showPoker()
	-- end
	-- -- 0.6秒之后 加圈
	-- performWithDelay( self,function()
	-- 	self:showPokersQuan( tierce_pokers )
	-- 	self:showPokersQuan( four_pokers )
	-- 	self:showPokersQuan( three_pokers )
	-- end,0.6 )	
end

-- AI从牌堆摸牌
function GamePlay:AIGetPokerFromPaiDui()
	self:createAIPokerFromPaiDui( 1 )
	-- AI摸牌的手抓动画
	self:AIMoPaiCsbAction()
end
-- 从桌面摸牌
function GamePlay:AIGetPokerFromOut( time )
	assert( time," !! time is nil !! " )
	local stack_childs = self.NodeOutCard:getChildren()
	local top_poker = stack_childs[#stack_childs]
	self:createAiPokerToHand( top_poker )
	self:AIPokerMove( top_poker,time )
	top_poker:showBackAniUseScaleTo( time / 2 )
	-- AI摸牌的手抓动画
	self:AIMoPaiCsbAction()
end

function GamePlay:AIMoPaiCsbAction()
	performWithDelay( self,function()
		playCsbActionForIndex( self._csbAct, 361,415,false,function()
			self:frameAnimation()
		end )
	end,0.3 )
end

-- AI摸牌
function GamePlay:AIGetPoker()
	if self._moState == 6 then
		return
	end

	local logic = self:AIGetPokerLogic()
	local time = 1
	if logic == 1 then
		self:AIGetPokerFromOut( time )
	else
		if self._moState == 7 then
			-- 开局时候不能摸牌堆，提示过牌
			self._moState = 5
			self.TextAIPass:setVisible( true )
			performWithDelay( self.TextAIPass,function ()
				self.TextAIPass:setVisible( false )
			end,time )
		else
			self:AIGetPokerFromPaiDui( 0.3 )
		end
	end

	performWithDelay( self,function()
		self:AIShowPoker()
	end,0.5 )

	-- AI 出牌
	if self._moState == 5 then
		return
	else
		performWithDelay( self,function()
			self:AIOutPokerLogic()
		end,time + 0.7 )
	end
end

-- AI摸牌逻辑
function GamePlay:AIGetPokerLogic()
	local hand_souce = self:getNumberIndexSourceByNode( self.AIHandPokerIn )
	local tierce_ary,four_ary,three_ary,org_source = self:calEffectiveData( hand_souce )

	local contain_out_source = clone( hand_souce )
	local childs = self.NodeOutCard:getChildren()
	assert( #childs > 0," !! childs count must be > 0 !! " )
	table.insert( contain_out_source,childs[#childs]:getNumberIndex() )
	local tierce_ary1,four_ary1,three_ary1,new_source_mo = self:calEffectiveData( contain_out_source )

	-- 如果桌面牌有用，返回1，否则返回0
	if #new_source_mo <= #org_source then
		return 1
	else
		return 0
	end
end

-- AI 出牌的逻辑
function GamePlay:AIOutPokerLogic()
	local num_index = self:getAIOutPokerNumIndex()
	local out_poker = self:getPlayerPokerByNumberIndex( self.AIHandPokerIn,num_index )
	self:AIHanderPokerToOut( out_poker )

	if G_GetModel("Model_Sound"):isVoiceOpen() then
		audio.playSound("lkmp3/sendpoker.mp3", false)
	end
end

-- 获取ai要出的牌的numberindex
function GamePlay:getAIOutPokerNumIndex()
	local hand_souce = self:getNumberIndexSourceByNode( self.AIHandPokerIn )
	local tierce_ary,four_ary,three_ary,single_source = self:calEffectiveData( hand_souce )

	local checkIsSingle = function( numIndex )
		local new_source = clone( single_source )
		table.removebyvalue( new_source,numIndex )

		local com_config = likui_config.poker[numIndex]
		for i,v in ipairs( new_source ) do
			local oth_config = likui_config.poker[v]
			if com_config.num == oth_config.num then
				return false
			end
			if com_config.color == oth_config.color and math.abs( com_config.num - oth_config.num ) == 1 then
				return false
			end
		end
		return true
	end

	local outs = {}
	for i,v in ipairs( single_source ) do
		if checkIsSingle( v ) then
			table.insert( outs,v )
		end
	end

	if #outs > 0 then
		table.sort( outs, function( a,b ) 
			local a_config = likui_config.poker[a]
			local b_config = likui_config.poker[b]
			return a_config.num > b_config.num
		end )

		return outs[1]
	end

	if #single_source > 0 then
		table.sort( single_source, function( a,b ) 
			local a_config = likui_config.poker[a]
			local b_config = likui_config.poker[b]
			return a_config.num > b_config.num
		end )
		return single_source[1]
	end
	return hand_souce[1]
end


-- AI的手牌出牌到出牌区
function GamePlay:AIHanderPokerToOut( poker )
	local img_startPos = cc.p(poker:getPosition())
	local img_startWorldPos = poker:getParent():convertToWorldSpace( img_startPos )
	local img_startNodePos = self.NodeOutCard:convertToNodeSpace( img_startWorldPos )
	local childs = self.NodeOutCard:getChildren()
	poker:retain()
	poker:removeFromParent()
	self.NodeOutCard:addChild( poker )
	poker:release()
	poker:setPosition( img_startNodePos )
	poker:setLocalZOrder( #childs + 1 )
	poker:setVisible( true )

	local position_end = cc.p( 0,0 )

	-- 执行出牌动画
	poker:setRotation( 0 )
	local time = 0.5
	local scale_to = cc.ScaleTo:create( time,1 )
	poker:runAction( scale_to )
	self:playerPokerMove( poker,position_end,time )
	poker:showObtAniUseScaleTo( time )

	-- 轮到玩家出牌
	performWithDelay( self,function()
		-- 设置状态
		-- 检查AI是否可以摊牌
		local hand_souce = self:getNumberIndexSourceByNode( self.AIHandPokerIn )
		local tierce_ary,four_ary,three_ary,org_source = self:calEffectiveData( hand_souce )
		if #org_source <= 2 then
			-- 摊牌
			self:over_show( 0 )
		else
			self._moState = 2
			self:AIShowPoker()
		end
	end,0.7 )
end
-- AI摊牌
function GamePlay:aiOverToShowPoker()
	-- body
	self.AIHandPokerIn:setVisible( true )
	-- 提取node里面的数据，索引
	local source = self:getNumberIndexSourceByNode( self.AIHandPokerIn )
	-- 玩家手牌排序
	local sort_childs,tierce_pokers,four_pokers,three_pokers,san_pokers = self:handPokersGroup( self.AIHandPokerIn,source )

	local groups = {}
	local call_group = function( source )
		for i,v in ipairs( source ) do
			table.insert( groups,clone(v) )
		end
	end
	call_group( tierce_pokers )
	call_group( four_pokers )
	call_group( three_pokers )

	local move_time = 0.3
	self:aiTanPaiActionByGroup( groups,move_time )

	local hand_poker_index = 10
	schedule( self.bg,function()
		self["ImageAIpoker"..hand_poker_index]:setVisible( false )
		hand_poker_index = hand_poker_index - 1
		if hand_poker_index <= 0 then
			self.bg:stopAllActions()
			self.AIHandPokerOut:setVisible( false )
		end
	end,move_time - 0.1 )

	-- 移动散牌
	performWithDelay( self,function()
		local actions = {}
		local index = #groups
		for i = #san_pokers,1,-1 do
			local v = san_pokers[i]
			v:setVisible( true )
			self:createAiPokerToOverNode( v )
			v:showObtAniUseScaleTo( move_time - 0.1 )
			v:setLocalZOrder( i )
			local move_to = cc.MoveTo:create( move_time,cc.p( (index) * 150 + i * 35,-20 ) )
			local scale_to = cc.ScaleTo:create( move_time,1 )
			local spawn = cc.Spawn:create({ move_to,scale_to })
			local delay = cc.DelayTime:create( move_time / 2 * i )
			v:runAction( cc.Sequence:create( { delay,spawn }))
		end
	end,(#groups + 1) * move_time + 0.1 )
end

-- 根于一组poker执行摊牌动画( 从上向下排列)
function GamePlay:aiTanPaiActionByGroup( groups,moveTime )
	self._aiTanPaiGroupIndex = self._aiTanPaiGroupIndex + 1
	local pokers = groups[self._aiTanPaiGroupIndex]
	if pokers then
		local actions = {}
		local index = self._aiTanPaiGroupIndex
		for i,v in ipairs( pokers ) do
			v:setVisible( true )
			self:createAiPokerToOverNode( v )
			v:setLocalZOrder( i )
			v:showObtAniUseScaleTo( moveTime - 0.1 )
			local move_to = cc.MoveTo:create( moveTime,cc.p( (index - 1) * 150,-20 - (i - 1) * 35 ) )
			local scale_to = cc.ScaleTo:create( moveTime,1 )
			local spawn = cc.Spawn:create({ move_to,scale_to })
			local delay = cc.DelayTime:create( moveTime / 2 * i )
			local call_next = cc.CallFunc:create( function()
				if i == #pokers then
					self:aiTanPaiActionByGroup( groups,moveTime )
				end
			end )
			v:runAction( cc.Sequence:create( { delay,spawn,call_next }))
		end
	end
end

function GamePlay:createAiPokerToOverNode( poker )
	local childs = self.AIShowNode:getChildren()
	local began_pos = cc.p( poker:getPosition())
	local began_worldPos = poker:getParent():convertToWorldSpace( began_pos )
	local new_pos = self.AIShowNode:convertToNodeSpace(cc.p( began_worldPos))	
	poker:retain()
	poker:removeFromParent()
	self.AIShowNode:addChild( poker )
	poker:release()
	poker:setPosition( new_pos )
	poker:setLocalZOrder( 100 - #childs )
	poker:setRotation( 0 )
end

-- ################################ AI 的代码区 End ##################################################




























--########################### 玩家的代码区 Start ####################################
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
	return top_poker
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
	local parent = poker:getParent()
	local org_order = parent:getLocalZOrder()
	parent:setLocalZOrder( 200 )
	local move_to = cc.MoveTo:create( time * 2,position )
	local call_set = cc.CallFunc:create( function()
		parent:setLocalZOrder( org_order )
	end )
	poker:runAction( cc.Sequence:create({ move_to,call_set }) )
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
function GamePlay:playerHandPokerSort( poker )
	-- 提取node里面的数据，索引
	local source = self:getNumberIndexSourceByNode( self.PlayerHandPoker )
	-- 玩家手牌排序
	local sort_childs,tierce_pokers,four_pokers,three_pokers = self:handPokersGroup( self.PlayerHandPoker,source )
	-- 移动牌
	for i = 1,#sort_childs do
		sort_childs[i]:showQuan1( false )
		sort_childs[i]:showQuan2( false )

		-- 针对摸的那一张牌
		if poker and sort_childs[i] == poker then
			sort_childs[i]:setLocalZOrder( 100 )
		else
			sort_childs[i]:setLocalZOrder( i )
		end

		local index = self:playerHandPokerSpaceBetween( i )
		local move_to = cc.MoveTo:create( 0.5,cc.p( index,0 ))
		local call_set_order = cc.CallFunc:create( function()
			if poker and sort_childs[i] == poker then
				sort_childs[i]:setLocalZOrder( i )
			end
		end )
		sort_childs[i]:runAction( cc.Sequence:create({ move_to,call_set_order }) )
	end
	-- 0.6秒之后 加圈
	performWithDelay( self,function()
		self:showPokersQuan( tierce_pokers )
		self:showPokersQuan( four_pokers )
		self:showPokersQuan( three_pokers )
	end,0.6 )
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

-- 将玩家要出的手牌添加到出牌区域node
function GamePlay:createPlayerPokerToSend( poker )
	local img_startPos = cc.p(poker:getPosition())
	local img_startWorldPos = poker:getParent():convertToWorldSpace( img_startPos )
	local img_startNodePos = self.NodeOutCard:convertToNodeSpace( img_startWorldPos )
	local childs = self.NodeOutCard:getChildren()
	poker:retain()
	poker:removeFromParent()
	self.NodeOutCard:addChild( poker )
	poker:release()
	poker:setPosition( img_startNodePos )
	poker:setLocalZOrder( #childs + 1 )
end

-- 玩家出牌
function GamePlay:playerOutPoker( poker )
	if self._moState ~= 3 then
		return
	end
	if G_GetModel("Model_Sound"):isVoiceOpen() then
		audio.playSound("lkmp3/sendpoker.mp3", false)
	end

	self._moState = 4
	poker:removePokerClick()
	poker:showQuan1( false )
	poker:showQuan2( false )
	self:createPlayerPokerToSend( poker )
	local position_end = cc.p( 0,0 )
	self:playerPokerMove( poker,position_end,0.3 )
	-- 重新排序
	self:playerHandPokerSort()

	self:loadDeadUi()

	-- 玩家出牌后，轮到AI摸牌逻辑
	performWithDelay( self,function ()
		self:AIGetPoker()
	end,1 )
end

-- 玩家点击牌堆
function GamePlay:clickPaiDui()
	-- 1:
	if self._moState ~= 2 and self._moState ~= 5 then
		return
	end
	-- 2:
	local pokers = self.NodeStack:getChildren()
	if #pokers == 0 then
		-- 强制摊牌
		self:over_show( 1 )
		return
	end
	-- 设置状态，限制牌动作时候点击
	self._moState = 4
	--3:摸牌

	local time = 0.3
	local stack_childs = self.NodeStack:getChildren()

	local top_poker = self:createPlayerPokerFromPaiDui( time )
	local player_childs = self.PlayerHandPoker:getChildren()
	top_poker:setLocalZOrder( #player_childs + 1 )

	local stack_childs = self.NodeStack:getChildren()

	performWithDelay( self,function()
		self:playerHandPokerSort( top_poker )
		-- 添加点击
		top_poker:addPokerClick()
		-- 设置状态为出牌状态
		self:loadDeadUi()
	end,time * 2 + 0.1 )

	-- 等所有动作结束后设置状态
	performWithDelay( self,function ()
		-- 设置状态为出牌状态
		self._moState = 3
		-- 最后一张牌上移
		self:maxPokerMoveUp()
	end,time * 4 + 0.1 )
end

-- 玩家点击出牌区
function GamePlay:clickPaiOut()
	if self._moState ~= 1 and self._moState ~= 2 then
		return
	end

	local pokers = self.NodeOutCard:getChildren()
	if #pokers == 0 then
		return
	end
	if self._moState == 1 then
		self.ButtonPass:setVisible( false )
	end
	-- 设置状态，限制牌动作时候点击
	self._moState = 4
	-- 放入牌到玩家手中
	local stack_childs = self.NodeOutCard:getChildren()
	local top_poker = stack_childs[#stack_childs]
	self:createPlayerPokerToHand( top_poker )
	local player_childs = self.PlayerHandPoker:getChildren()
	local x_pos = self:playerHandPokerSpaceBetween( #player_childs )
	local position_end = cc.p( x_pos,0 )
	top_poker:setLocalZOrder( #player_childs + 1 )

	local time = 0.3
	self:playerPokerMove( top_poker,position_end,time )
	performWithDelay( self,function()
		self:playerHandPokerSort( top_poker )
		-- 添加点击
		top_poker:addPokerClick()
		self:loadDeadUi()
	end,time * 2 + 0.1 )
	performWithDelay( self,function ()
		-- 设置状态为出牌状态
		self._moState = 3
		-- 最后一张牌上移
		self:maxPokerMoveUp()
	end,time * 4 + 0.1 )
end

function GamePlay:loadDeadUi()
	local source = self:getNumberIndexSourceByNode( self.PlayerHandPoker )
	local sort_childs,tierce_pokers,four_pokers,three_pokers,san_pokers = self:handPokersGroup( self.PlayerHandPoker,source )
	local deadPoint = self:getDeadPoint( san_pokers )
	self.TextDeadPoint:setString( deadPoint )

	-- 显示摊牌按钮--传入收集牌的列表
	self:showTanpai( san_pokers )
end

-- 玩家点击pass
function GamePlay:pass()
	if self._moState == 1 then
		self._moState = 7
		-- 过牌
		self.ButtonPass:setVisible( false )
			performWithDelay( self,function ()
			self:AIGetPoker()
		end,1 )
	end
end
-- 玩家点击摊牌
function GamePlay:over_show( state )

	local call_tan = function()
		self._moState = 6
		performWithDelay( self,function ()
			self.PanelTouchPaiDui:setVisible( false )
			self.PanelTouchOut:setVisible( false )
			self.NodeStack:setVisible( false )
			self.NodeOutCard:setVisible( false )
			self.ImageDeadCardBg:setVisible( false )
			self.ButtonShow:setVisible( false )
			self.ButtonSound:setVisible( false )
			self.ButtonMusic:setVisible( false )

			-- 玩家
			local source = self:getNumberIndexSourceByNode( self.PlayerHandPoker )
			local sort_childs,tierce_pokers,four_pokers,three_pokers,san_pokers = self:handPokersGroup( self.PlayerHandPoker,source )
			local deadPoint = self:getDeadPoint( san_pokers )
			self.TextResultPointPlayer:setString( deadPoint )

			--  AI
			local source = self:getNumberIndexSourceByNode( self.AIHandPokerIn )
			local sort_childs,tierce_pokers,four_pokers,three_pokers,san_pokers = self:handPokersGroup( self.AIHandPokerIn,source )
			local deadPoint = self:getDeadPoint( san_pokers )
			self.TextResultPointAi:setString( deadPoint )

			-- 摊牌
			self:playerOverToShowPoker()
			self:aiOverToShowPoker()
		end,0.5)
	end

	if state == 1 then
		-- 玩家摊牌
		local childs = self.PlayerHandPoker:getChildren()
		local source = self:getNumberIndexSourceByNode( self.PlayerHandPoker )
		local sort_childs,tierce_pokers,four_pokers,three_pokers,san_pokers = self:handPokersGroup( self.PlayerHandPoker,source )
		assert( #childs == 11, " !! childs number must be 11 !! " )
		if #san_pokers > 0 then
			local poker = san_pokers[#san_pokers]
			local began_pos = cc.p( poker:getPosition())
			local began_worldPos = poker:getParent():convertToWorldSpace( began_pos )
			local new_pos = self.NodePlayerTan:convertToNodeSpace(cc.p( began_worldPos))	
			poker:retain()
			poker:removeFromParent()
			self.NodePlayerTan:addChild( poker )
			poker:release()
			poker:setPosition( new_pos )
			poker:showBackAniUseScaleTo( 0.3 )
			local move_to = cc.MoveTo:create( 0.5,cc.p(0,0 ))
			local delay = cc.DelayTime:create( 0.5 )
			local call_end = cc.CallFunc:create( function()
				call_tan()
			end )
			local seq = cc.Sequence:create({ move_to,delay,call_end })
			poker:runAction( seq )
		else
			call_tan()
		end
	else
		-- AI 摊牌
		call_tan()
	end
end
-- 摊牌
function GamePlay:playerOverToShowPoker()
	-- 提取node里面的数据，索引
	local source = self:getNumberIndexSourceByNode( self.PlayerHandPoker )
	-- 玩家手牌排序
	local sort_childs,tierce_pokers,four_pokers,three_pokers,san_pokers = self:handPokersGroup( self.PlayerHandPoker,source )

	local groups = {}
	local call_group = function( source )
		for i,v in ipairs( source ) do
			table.insert( groups,clone(v) )
		end
	end
	call_group( tierce_pokers )
	call_group( four_pokers )
	call_group( three_pokers )
	self:playerTanPaiActionByGroup( groups )

	-- 移动散牌
	performWithDelay( self,function()
		local actions = {}
		local move_time = 0.3
		local index = #groups

		local call_over = function()
			self.ImageResultAi:setVisible( true )
			self.ImageResultPlayer:setVisible( true )
			-- 显示结算界面
			self:gameOver()
		end

		if #san_pokers == 0 then
			call_over()
		else
			for i = #san_pokers,1,-1 do
				local v = san_pokers[i]
				self:createPlayerPokerToOverNode( v )
				local move_to = cc.MoveTo:create( move_time,cc.p( (index) * 150 + i * 35,20 ) )
				local delay = cc.DelayTime:create( move_time / 2 * i )
				local delay2 = cc.DelayTime:create( 1 )
				local call_result = cc.CallFunc:create( function()
					if i == 1 then
						call_over()
					end
				end )
				v:runAction( cc.Sequence:create( { delay,move_to,delay2,call_result }))
			end
		end
	end,(#groups + 1) * 0.3 + 0.1 )
end

-- 根于一组poker执行摊牌动画( 从上向下排列)
function GamePlay:playerTanPaiActionByGroup( groups )
	self._playerTanPaiGroupIndex = self._playerTanPaiGroupIndex + 1
	local pokers = groups[self._playerTanPaiGroupIndex]
	if pokers then
		local actions = {}
		local move_time = 0.3
		local index = self._playerTanPaiGroupIndex
		for i,v in ipairs( pokers ) do
			self:createPlayerPokerToOverNode( v )
			v:showQuan1( false )
			v:showQuan2( false )
			local move_to = cc.MoveTo:create( move_time,cc.p( (index - 1) * 150,20 + (i - 1) * 35 ) )
			local delay = cc.DelayTime:create( move_time / 2 * i )
			local call_next = cc.CallFunc:create( function()
				if i == #pokers then
					self:playerTanPaiActionByGroup( groups )
				end
			end )
			v:runAction( cc.Sequence:create( { delay,move_to,call_next }))
		end
	end
end


-- 结束时将分组的牌添加到结果区域
function GamePlay:createPlayerPokerToOverNode( poker )
	local childs = self.playerShowNode:getChildren()
	local began_pos = cc.p( poker:getPosition())
	local began_worldPos = poker:getParent():convertToWorldSpace( began_pos )
	local new_pos = self.playerShowNode:convertToNodeSpace(cc.p( began_worldPos))	
	poker:retain()
	poker:removeFromParent()
	self.playerShowNode:addChild( poker )
	poker:release()
	poker:setPosition( new_pos )
	poker:setLocalZOrder( 100 - #childs )
end
-- 摸牌后最大牌坐标上移
function GamePlay:maxPokerMoveUp()
	local childs = self.PlayerHandPoker:getChildren()
	local poker = childs[#childs]
	local move_to = cc.MoveBy:create( 0.1,cc.p( 0,10 ))
	poker:runAction( move_to )
end

--########################### 玩家的代码区 End ####################################









---######################### 公共代码区 Start #########################################
-- 用序号换成poker
function GamePlay:getPlayerPokerByNumberIndex( node,numIndex )
	assert( numIndex," !! numIndex is nil !! " )
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
	return (pos - 1) * 100
end

-- 帧动画
function GamePlay:frameAnimation()
	self:playCsbAction( "animation0",true )
end

-- 根据数据源计算有效的数据
function GamePlay:calEffectiveData( source )
	assert( source," !! source is nil !! " )
	-- 第一种选择:
	local tierce_ary1,four_ary1,three_ary1,new_source1 = self:calEffectiveDataByTierce( source )
	-- 第二种选择:
	local tierce_ary2,four_ary2,three_ary2,new_source2 = self:calEffectiveDataByFour( source )
	-- 第三种选择
	local tierce_ary3,four_ary3,three_ary3,new_source3 = self:calEffectiveDataByThree( source )

	local mini = new_source1
	if #new_source2 < #new_source1 then
		mini = new_source2
	end
	if #new_source3 < #mini then
		mini = new_source3
	end

	if mini == new_source1 then
		return tierce_ary1,four_ary1,three_ary1,new_source1
	end

	if mini == new_source2 then
		return tierce_ary2,four_ary2,three_ary2,new_source2
	end

	if mini == new_source3 then
		return tierce_ary3,four_ary3,three_ary3,new_source3
	end
end

function GamePlay:calEffectiveDataByTierce( source )
	-- 1，选出同花顺
	local tierce_ary = {}
	if #source >= 3 then
		self:choseTierce( source,tierce_ary )
	end

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
	return tierce_ary,four_ary,three_ary,new_source
end

function GamePlay:calEffectiveDataByFour( source )
	local new_source = clone( source )
	-- 1，选出四条
	local four_ary = {}
	if #new_source >= 4 then
		four_ary = self:getFourOrThree( new_source,4 )
		for i,v in ipairs(four_ary) do
			for a,b in ipairs(v) do
				table.removebyvalue( new_source,b )
			end
			
		end
	end
	-- 2,选出三条
	local three_ary = {}
	if #new_source >= 3 then
		three_ary = self:getFourOrThree( new_source,3 )
		for i,v in ipairs(three_ary) do
			for a,b in ipairs(v) do
				table.removebyvalue( new_source,b )
			end
		end
	end
	-- 3，选出同花顺
	local tierce_ary = {}
	if #new_source >= 3 then
		self:choseTierce( new_source,tierce_ary )
		-- 去掉已筛选的同花顺
		for i,v in ipairs(source) do
			for a,b in ipairs(tierce_ary) do
				for c,d in ipairs(b) do
					table.removebyvalue( new_source,d )
				end
			end
		end
	end
	
	return tierce_ary,four_ary,three_ary,new_source
end

function GamePlay:calEffectiveDataByThree( source )
	-- 1,选出三条
	local new_source = clone( source )
	local three_ary = {}
	if #new_source >= 3 then
		three_ary = self:getFourOrThree( new_source,3 )
		for i,v in ipairs(three_ary) do
			for a,b in ipairs(v) do
				table.removebyvalue( new_source,b )
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
	-- 3，选出同花顺
	local tierce_ary = {}
	if #new_source >= 3 then
		self:choseTierce( new_source,tierce_ary )
		-- 去掉已筛选的同花顺
		for i,v in ipairs(source) do
			for a,b in ipairs(tierce_ary) do
				for c,d in ipairs(b) do
					table.removebyvalue( new_source,d )
				end
			end
		end
	end
	return tierce_ary,four_ary,three_ary,new_source
end

-- 手牌分组 得到poker的指针 用于加圈显示
function GamePlay:handPokersGroup( node,source )
	assert( node," !! node is nil !! " )
	assert( source," !! source is nil !! " )

	local sort_childs = {}
	local tierce_ary,four_ary,three_ary,new_source = self:calEffectiveData( source )

	local tierce_pokers = {}
	local four_pokers = {}
	local three_pokers = {}
	local san_pokers = {}

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
		-- 散牌指针
		table.insert( san_pokers,poker )
	end
	return sort_childs,tierce_pokers,four_pokers,three_pokers,san_pokers
end

-- 获取死牌点数
function GamePlay:getDeadPoint( pokers )
	local deadPoint = 0
	for i,v in ipairs( pokers ) do
		deadPoint = v:getNumberOfBigOrSmall() + deadPoint
	end
	return deadPoint
end
-- 显示摊牌按钮显示状态
function GamePlay:showTanpai( group_ary )
	local childs = self.PlayerHandPoker:getChildren()
	self.ButtonShow:setVisible( #childs == 11 and #group_ary <= 4 )
end


function GamePlay:getNumberIndexSourceByNode( node )
	assert( node," !! node is nil !! " )
	local player_childs = node:getChildren()
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
	return source
end

-- 游戏结束，保存数据
function GamePlay:saveScore( score )
	G_GetModel("Model_LiKui"):getInstance():saveRecordList( score )
end





function GamePlay:gameOver( score )
	local ai_point = tonumber(self.TextResultPointAi:getString())
	local player_point = tonumber( self.TextResultPointPlayer:getString() )
	local score = ai_point - player_point

	if player_point == 0 then
		score = score + 25
	elseif ai_point == 0 then
		score = score - 25
	end

	if score >= 0 then
		-- 赢
		if G_GetModel("Model_Sound"):isVoiceOpen() then
			audio.playSound("lkmp3/win.mp3", false)
		end
	else
		-- 输
		if G_GetModel("Model_Sound"):isVoiceOpen() then
			audio.playSound("lkmp3/lose.mp3", false)
		end
	end
	-- 存储
	if score > 0 then
		self:saveScore( score )
	end
	-- 存储金币
	G_GetModel("Model_LiKui"):getInstance():setCoin( score )
	-- 显示结算界面
	performWithDelay( self,function()
		addUIToScene( UIDefine.LIKUI_KEY.Over_UI,score )
	end,5 )
end

function GamePlay:setMusic()
	local model = G_GetModel("Model_Sound"):getInstance()
	local is_open = model:isMusicOpen()
	if is_open then
		self.ButtonMusic:loadTexture( "image/start/music.png",1 )
		-- 变灰
		graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )
		model:setMusicState( model.State.Closed )
		model:stopPlayBgMusic()
	else
		self.ButtonMusic:loadTexture( "image/start/music.png",1 )
		ungraySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )
		model:setMusicState( model.State.Open )
		model:playBgMusic()
	end
end
function GamePlay:setSound()
	local model = G_GetModel("Model_Sound"):getInstance()
	local is_open = model:isVoiceOpen()
	if is_open then
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
		-- 变灰
		graySprite( self.ButtonSound:getVirtualRenderer():getSprite() )
		model:setVoiceState( model.State.Closed )
	else
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
		ungraySprite( self.ButtonSound:getVirtualRenderer():getSprite() )
		model:setVoiceState( model.State.Open )
	end
end

function GamePlay:back()
	addUIToScene( UIDefine.LIKUI_KEY.Start_UI )
	removeUIFromScene( UIDefine.LIKUI_KEY.Play_UI )
end

---######################### 公共代码区 End #########################################


return GamePlay