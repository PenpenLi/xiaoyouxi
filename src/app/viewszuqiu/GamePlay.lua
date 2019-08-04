
local NodePoker = import(".NodePoker")

local GamePlay  = class("GamePlay",BaseLayer)

local STAGE_ICON = {
	[1]  = "image/play/Groupstage1.png",
	[2]  = "image/play/Groupstage2.png",
	[3]  = "image/play/Groupstage3.png",
	[4]  = "image/play/Quarterfinal.png",
	[5]  = "image/play/SemiFinals.png",
	[6]  = "image/play/Final.png"
}

function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "Play.csb" )

    -- pass 
    self:addNodeClick( self.ButtonPass,{ 
        endCallBack = function() self:clickPass() end,
    })

    -- music
    self:addNodeClick( self.ButtonYinYue,{
    	endCallBack = function() self:clickMusic() end,
    })

    -- back
    self:addNodeClick( self.ButtonBack,{
    	endCallBack = function() self:clickBack() end,
    })

    -- help
    self:addNodeClick( self.ButtonHelp,{
    	endCallBack = function() self:clickHelp() end,
    })

    -- 隐藏定位的poker
    self._playerPokerPos = {}
    self._aiPokerPos = {}
    for i = 1,6 do
    	self["PlayerPoker"..i]:setVisible( false )
    	self["AIPoker"..i]:setVisible( false )
    	table.insert( self._playerPokerPos,cc.p( self["PlayerPoker"..i]:getPosition() ) )
    	table.insert( self._aiPokerPos,cc.p( self["AIPoker"..i]:getPosition() ) )
    end

    self.ImageOutAI:setVisible( false )
    self.ImageOutPlayer:setVisible( false )
    self:hideOpIcon()
    self.ButtonPass:setVisible( false )

    self._outAIPos = cc.p( self.ImageOutAI:getPosition() )
    self._outPlayerPos = cc.p( self.ImageOutPlayer:getPosition() )

    self._playerPokerAngle = { -19,-14,-5,5,14,19 }
    self._aiPokerAngle = { 19,14,5,-5,-14,-19 }
    self._countryIndex = param.data.country_index
    self._stage = G_GetModel("Model_ZuQiu"):getStage()

    self._aiPaiDuiCards = {}
    self._playerPaiDuiCards = {}

    self._aiHandCards = {}
    self._playerHandCards = {}

    self._aiOutCards = {}
    self._playerOutCards = {}
    -- 玩家能否点击牌的标志
    self._playerCanTouch = false
end

function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
    -- 初始化数据
    self:loadDataUI()
    -- 创建 bei poker
    self:createBeiPoker()
    -- 开始发牌
    performWithDelay( self,function()
    	self:sendCardBeganAction()
    end, 0.2)
end

function GamePlay:loadDataUI()
	-- 玩家国家
	self.ImageCountry1:loadTexture( country_config.europe[self._countryIndex].icon,1 )
	-- ai随机国家
	local ai_country_index = country_config.getAiRandomCountry( self._countryIndex ) 
	self.ImageCountry2:loadTexture( country_config.europe[ai_country_index].icon,1 )
	-- 第几场
	self.ImageStage:loadTexture( STAGE_ICON[self._stage],1 )
end

function GamePlay:createBeiPoker()
	local ai_poker,player_poker = zuqiu_card_config.getRandomPokerByBegan( self._stage )
	-- ai
	local panel_size = self.ImageBeiAI:getContentSize()
	local pos = cc.p( panel_size.width / 2,panel_size.height / 2 + 7 )
	for i,v in ipairs( ai_poker ) do
		local poker = NodePoker.new( self,v )
		self.ImageBeiAI:addChild( poker )
		table.insert( self._aiPaiDuiCards,poker )
		poker:setPosition( cc.p( pos.x - i * 1,pos.y + i * 1 ) )
		poker:setLocalZOrder( i )
		poker._image:getVirtualRenderer():getSprite():setFlippedY( true )
	end
	-- player
	for i,v in ipairs( player_poker ) do
		local poker = NodePoker.new( self,v )
		self.ImageBeiPlayer:addChild( poker )
		table.insert( self._playerPaiDuiCards,poker )
		poker:setPosition( cc.p( pos.x - i * 1,pos.y + i * 1 ) )
		poker:setLocalZOrder( i )
	end
end

function GamePlay:sendCardBeganAction()
	-- player的数据
	local send_player = {}
	for i = 1,6 do
		local index = #self._playerPaiDuiCards - i + 1
		local poker = self._playerPaiDuiCards[index]
		table.insert( send_player,poker:getNumIndex() )
	end
	-- 排序
	table.sort( send_player, function( a,b )
		return a > b
	end )

	-- ai的数据
	local send_ai = {}
	for i = 1,6 do
		local index = #self._aiPaiDuiCards - i + 1
		local poker = self._aiPaiDuiCards[index]
		table.insert( send_ai,poker:getNumIndex() )
	end
	-- 排序
	table.sort( send_ai, function( a,b ) 
		return a < b
	end )

	-- 先发player
	local actions = {}
	local action_time = 0.5
	for i = 1,6 do
		local delay = cc.DelayTime:create( 0.3 )
		local call_player_mo = cc.CallFunc:create( function()
			self:playerMoCard( send_player[i],7 - i,action_time )
		end )
		table.insert( actions,delay )
		table.insert( actions,call_player_mo )
	end
	-- 再发ai
	for i = 1,6 do
		local delay = cc.DelayTime:create( 0.3 )
		local call_ai_mo = cc.CallFunc:create( function()
			self:aiMoCard( send_ai[i],7 - i,action_time )
		end )
		table.insert( actions,delay )
		table.insert( actions,call_ai_mo )
	end
	-- ai 优先出牌
	local delay1 = cc.DelayTime:create( 0.3 )
	table.insert( actions,delay1 )
	local call_ai_out = cc.CallFunc:create( function()
		self:loadPlayerOpIcon()
		self:aiOutCard()
	end )
	table.insert( actions,call_ai_out )
	self:runAction( cc.Sequence:create( actions ) )
end

-- 玩家摸牌
function GamePlay:playerMoCard( numIndex,seatPos,actionTime )
	assert( numIndex," !! numIndex is nil !! " )
	assert( seatPos," !! seatPos is nil !! " )
	assert( actionTime," !! actionTime is nil !! " )
	assert( #self._playerPaiDuiCards > 0, " !! player pai dui not has card !! " )

	if G_GetModel("Model_Sound"):isVoiceOpen() then
		audio.playSound("zqmp3/sendpoker.mp3", false)
	end

	-- 移除顶部poker
	local poker = self._playerPaiDuiCards[#self._playerPaiDuiCards]
	self._playerPaiDuiCards[#self._playerPaiDuiCards] = nil
	poker:removeFromParent()


	-- 创建poker到手牌
	local pos = cc.p( self.ImageBeiPlayer:getPosition() )
	local dest_pos = cc.p( self["PlayerPoker"..seatPos]:getPosition() )
	local new_poker = NodePoker.new( self,numIndex )
	self._csbNode:addChild( new_poker )
	new_poker:showPoker()
	new_poker:setSeatPos( seatPos )
	self._playerHandCards[#self._playerHandCards + 1] = new_poker
	new_poker:setPosition( pos )
	local move_to = cc.MoveTo:create( actionTime,dest_pos )
	local rotate_to = cc.RotateTo:create( actionTime,self._playerPokerAngle[seatPos] )
	local spawn = cc.Spawn:create( { move_to,rotate_to } )
	local call_addClick = cc.CallFunc:create( function()
		new_poker:addPokerClick()
	end )

	new_poker:runAction( cc.Sequence:create({ spawn,call_addClick }) )
end

-- ai摸牌
function GamePlay:aiMoCard( numIndex,seatPos,actionTime )
	assert( numIndex," !! numIndex is nil !! " )
	assert( seatPos," !! seatPos is nil !! " )
	assert( actionTime," !! actionTime is nil !! " )
	assert( #self._aiPaiDuiCards > 0, " !! ai pai dui not has card !! " )

	if G_GetModel("Model_Sound"):isVoiceOpen() then
		audio.playSound("zqmp3/sendpoker.mp3", false)
	end

	-- 移除顶部poker
	local poker = self._aiPaiDuiCards[#self._aiPaiDuiCards]
	self._aiPaiDuiCards[#self._aiPaiDuiCards] = nil
	poker:removeFromParent()

	-- 创建poker到手牌
	local pos = cc.p( self.ImageBeiAI:getPosition() )
	local dest_pos = cc.p( self["AIPoker"..seatPos]:getPosition() )
	local new_poker = NodePoker.new( self,numIndex )
	self._csbNode:addChild( new_poker )
	new_poker._image:getVirtualRenderer():getSprite():setFlippedY( true )
	-- new_poker:showPoker()
	new_poker:setSeatPos( seatPos )
	self._aiHandCards[#self._aiHandCards + 1] = new_poker
	new_poker:setPosition( pos )
	local move_to = cc.MoveTo:create( actionTime,dest_pos )
	local rotate_to = cc.RotateTo:create( actionTime,self._aiPokerAngle[seatPos] )
	local spawn = cc.Spawn:create( { move_to,rotate_to } )
	new_poker:runAction( spawn )
end

-- ai出牌逻辑
function GamePlay:aiOutCard()
	local out_poker = nil
	-- 是否选择花色最多的
	local select_most_huase = true
	if #self._aiOutCards > 0 then
		local top_poker = self._aiOutCards[#self._aiOutCards]
		if top_poker:isShowBei() == false then
			select_most_huase = false
		end
	end

	if select_most_huase then
		local player_total_num = self:calPlayerOutTotalNum()
		if player_total_num > 0 then
			-- 选择点数比玩家大的牌
			for i,v in pairs( self._aiHandCards ) do
				if v:getCardNum() >= player_total_num then
					out_poker = v
					break
				end
			end
			-- 如果不存在点数最大的 随机一张
			if out_poker == nil then
				out_poker = self._aiHandCards[1]
			end
		else
			-- 1: 桌面上没有牌 选择花色最多的牌出
			local hua_se = {}
			for i,v in ipairs( self._aiHandCards ) do
				local color = zuqiu_card_config[v:getNumIndex()].color
				if not hua_se[color] then
					hua_se[color] = 1
				else
					hua_se[color] = hua_se[color] + 1
				end
			end
			local max_count,max_color = 0,0
			for k,v in pairs( hua_se ) do
				if v > max_count then
					max_count = v
					max_color = k
				end
			end
			-- 在花色中选择点数最大的
			local max_card_num = 0
			for i,v in pairs( self._aiHandCards ) do
				local color = zuqiu_card_config[v:getNumIndex()].color
				if color == max_color then
					-- if v:getCardNum() > max_card_num then
					-- 	out_poker = v
					-- 	max_card_num = v:getCardNum()
					-- end
					out_poker = v
					break
				end
			end
		end
	else
		local top_poker = self._aiOutCards[#self._aiOutCards]
		local color = zuqiu_card_config[top_poker:getNumIndex()].color
		-- 选择相同花色
		local player_total_num = self:calPlayerOutTotalNum()
		local ai_total_num = self:calAiOutTotalNum()
		-- 1:优先寻找大于的
		for i,v in ipairs( self._aiHandCards ) do
			local v_color = zuqiu_card_config[v:getNumIndex()].color
			if v_color == color then
				if v:getCardNum() + ai_total_num > player_total_num then
					-- 出牌
					out_poker = v
					break
				end
			end
		end
		-- 2:寻找相等的
		if out_poker == nil then
			for i,v in ipairs( self._aiHandCards ) do
				local v_color = zuqiu_card_config[v:getNumIndex()].color
				if v_color == color then
					if v:getCardNum() + ai_total_num == player_total_num then
						-- 出牌
						out_poker = v
						break
					end
				end
			end
		end
		-- 3:寻找相同花色的
		if out_poker == nil then
			for i,v in ipairs( self._aiHandCards ) do
				local v_color = zuqiu_card_config[v:getNumIndex()].color
				if v_color == color then
					-- 出牌
					out_poker = v
					break
				end
			end
		end
	end

	if out_poker == nil then
		-- 没有牌可出 玩家赢牌
		self:excutePlayerWinPokerAction()
		return
	end

	local numIndex = out_poker:getNumIndex()
	local seat_pos = out_poker:getSeatPos()
	local start_pos = cc.p( out_poker:getPosition() )
	-- 移除手牌
	out_poker:removeFromParent()
	for i,v in ipairs( self._aiHandCards ) do
		if v == out_poker then
			table.remove( self._aiHandCards,i )
			break
		end
	end

	-- 出一张牌后 排序
	table.sort( self._aiHandCards,function( a,b )
		return a:getSeatPos() < b:getSeatPos() 
	end )

	-- 计算位置
	local move_count = 0
	for i,v in ipairs( self._aiOutCards ) do
		if not v:isShowBei() then
			move_count = move_count + 1
		end
	end
	local dest_pos = cc.p( self._outAIPos.x + move_count * 25,self._outAIPos.y - move_count * 20 )

	-- 创建牌 执行出牌动画
	local new_poker = NodePoker.new( self,numIndex )
	self._csbNode:addChild( new_poker )
	new_poker:setPosition( start_pos )
	new_poker:showPoker()
	self._aiOutCards[#self._aiOutCards + 1] = new_poker

	local move_to = cc.MoveTo:create( 0.5,dest_pos )
	local call_ai_mo = cc.CallFunc:create( function()
		if #self._aiPaiDuiCards > 0 then
			-- 有牌的情况下 移动牌
			local action_time = 0.5
			local num_index,insert_seatPos = self:aiMoveSortHandCard( seat_pos,action_time )
			-- 摸牌
			self:aiMoCard( num_index,insert_seatPos,action_time )
		else
			self:moveSortHandCardByPaiDuiNoCards( self._aiHandCards,0.5,self._aiPokerPos,self._aiPokerAngle )
		end
	end )
	local call_move_over = cc.CallFunc:create( function()
		self:aiOutCardDoneLogic()
	end )
	new_poker:runAction( cc.Sequence:create({ move_to,call_ai_mo,call_move_over}) )
end

-- ai 出完牌后的逻辑
function GamePlay:aiOutCardDoneLogic()
	-- 1:没有牌了 输牌
	if #self._aiPaiDuiCards <= 0 and #self._aiHandCards <= 0 then
		self:excutePlayerWinPokerAction()
		return
	end
	-- 2:出牌小于玩家的出牌 输牌
	local ai_total_num = self:calAiOutTotalNum()
	local player_total_num = self:calPlayerOutTotalNum()
	if ai_total_num < player_total_num then
		self:excutePlayerWinPokerAction()
		return
	end
	-- 3:是否需要pmax
	local is_pmax = self:checkPMax()
	if is_pmax then
		-- 手牌小于三张 直接输
		if #self._aiHandCards < 3 then
			self:excutePlayerWinPokerAction()
			return
		end
		-- 播放pax动画
		self:excutePMaxAction( 1 )
		return
	end
	-- 4:是否赢牌( 玩家不能出牌 且大于玩家的点数 就赢牌)
	if self:checkAIWinPoker() then
		-- 执行赢牌动画
		self:excuteAIWinPokerAction()
		return
	end
	-- 5:刷新玩家手牌的op icon 等待玩家出牌
	self:turnPlayerOutCard()
end

-- 轮到玩家出牌
function GamePlay:turnPlayerOutCard()
	self:loadPlayerOpIcon()
	self._playerCanTouch = true
	-- 显示pass按钮
	local has_out_card = false
	for i,v in ipairs( self._playerOutCards ) do
		if not v:isShowBei() then
			has_out_card = true
			break
		end
	end
	if has_out_card then
		self:showPass()
	end
end

-- 玩家点击出牌
function GamePlay:playerOutCard( poker )
	assert( poker," !! poker is nil !! " )
	if not self._playerCanTouch then
		return
	end

	local ai_total_num = self:calAiOutTotalNum()
	local player_total_num = self:calPlayerOutTotalNum()
	local poker_num = poker:getNumIndex()
	-- 不能出牌
	if player_total_num > 0 then
		local top_out_poker = self._playerOutCards[#self._playerOutCards]
		local out_color = zuqiu_card_config[top_out_poker:getNumIndex()].color
		local poker_color = zuqiu_card_config[poker:getNumIndex()].color
		-- 1:颜色不同 不能出牌
		if out_color ~= poker_color then
			return
		end
		-- -- 2:数量不足 不能出牌
		-- if ai_total_num > poker_num + player_total_num then
		-- 	return
		-- end
	end
	-- 出牌
	self._playerCanTouch = false
	self:hidePass()
	local numIndex = poker:getNumIndex()
	local seat_pos = poker:getSeatPos()
	local start_pos = cc.p( poker:getPosition() )
	-- 移除手牌
	poker:removeFromParent()
	for i,v in ipairs( self._playerHandCards ) do
		if v == poker then
			table.remove( self._playerHandCards,i )
			break
		end
	end
	-- 出一张牌后 排序
	table.sort( self._playerHandCards,function( a,b )
		return a:getSeatPos() < b:getSeatPos() 
	end )

	-- 计算位置
	local move_count = 0
	for i,v in ipairs( self._playerOutCards ) do
		if not v:isShowBei() then
			move_count = move_count + 1
		end
	end
	local dest_pos = cc.p( self._outPlayerPos.x + move_count * 25,self._outPlayerPos.y - move_count * 20 )

	-- 创建牌 执行出牌动画
	local new_poker = NodePoker.new( self,numIndex )
	self._csbNode:addChild( new_poker )
	new_poker:setPosition( start_pos )
	new_poker:showPoker()
	self._playerOutCards[#self._playerOutCards + 1] = new_poker

	local move_to = cc.MoveTo:create( 0.5,dest_pos )
	local call_player_mo = cc.CallFunc:create( function()
		if #self._playerPaiDuiCards > 0 then
			-- 有牌的情况下 移动牌
			local action_time = 0.5
			local num_index,insert_seatPos = self:playerMoveSortHandCard( seat_pos,action_time )
			-- 摸牌
			self:playerMoCard( num_index,insert_seatPos,action_time )

			performWithDelay( self,function()
				for i = 1,6 do
			    	if self._playerHandCards and self._playerHandCards[i] then
			    		self._playerHandCards[i]:setYinYingVisible( true )
			    	end
			    end
			end,action_time )
		else
			-- 没有牌的情况下移动牌
			self:moveSortHandCardByPaiDuiNoCards( self._playerHandCards,0.5,self._playerPokerPos,self._playerPokerAngle )
		end
	end )
	local delay = cc.DelayTime:create( 0.5 )
	local call_move_over = cc.CallFunc:create( function()
		self:hideOpIcon()
		self:playerOutCardDoneLogic()
	end )
	local seq = cc.Sequence:create({ move_to,call_player_mo,delay,call_move_over })
	new_poker:runAction( seq )
end

-- player 出完牌后的逻辑
function GamePlay:playerOutCardDoneLogic()
	-- 1:没有牌 自己输牌
	if #self._playerPaiDuiCards <= 0 and #self._playerHandCards <= 0 then
		self:excuteAIWinPokerAction()
		return
	end
	-- 2:ai赢牌
	local ai_total_num = self:calAiOutTotalNum()
	local player_total_num = self:calPlayerOutTotalNum()
	if ai_total_num > player_total_num then
		self:excuteAIWinPokerAction()
		return
	end
	-- 3:是否需要pmax
	local is_pmax = self:checkPMax()
	if is_pmax then
		-- 手牌小于三张 直接输
		if #self._playerHandCards < 3 then
			self:excuteAIWinPokerAction()
			return
		end
		-- 播放pax动画
		self:excutePMaxAction( 2 )
		return
	end
	-- 4:自己是否赢牌( ai不能出牌 且大于ai的点数 就赢牌)
	if self:checkPlayerWinPoker() then
		-- 执行赢牌动画
		self:excutePlayerWinPokerAction()
		return
	end
	-- 5:通知ai出牌
	self:aiOutCard()
end

-- 在牌堆有牌的情况下 ai排序手中牌
function GamePlay:aiMoveSortHandCard( outSeatPos,actionTime )
	return self:sortHandCards( self._aiPaiDuiCards,self._aiHandCards,outSeatPos,actionTime,self._aiPokerPos,self._aiPokerAngle,false )
end

-- 在牌堆有牌的情况下 palyer排序手中牌
function GamePlay:playerMoveSortHandCard( outSeatPos,actionTime )
	return self:sortHandCards( self._playerPaiDuiCards,self._playerHandCards,outSeatPos,actionTime,self._playerPokerPos,self._playerPokerAngle,true )
end

function GamePlay:sortHandCards( paiDuiCards,handCards,outSeatPos,actionTime,pokerPos,pokerAngle,isPlayer )
	assert( outSeatPos," !! outSeatPos is nil !! " )
	assert( actionTime," !! actionTime is nil !! " )
	assert( pokerPos," !! pokerPos is nil !! " )
	assert( pokerAngle," !! pokerAngle is nil !! " )
	assert( #paiDuiCards > 0," !! paiDuiCards nums must be > 0 !! " )
	-- 获得牌堆里面的牌
	local top_poker = paiDuiCards[#paiDuiCards]
	local top_numIndex = top_poker:getNumIndex()
	-- 计算新牌要插入的位置
	local insert_pos = 0
	if isPlayer then
		insert_pos = 6
		for i,v in ipairs( handCards ) do
			if top_numIndex <= v:getNumIndex() then
				insert_pos = i
				break
			end
		end
	else
		insert_pos = 6
		for i,v in ipairs( handCards ) do
			if top_numIndex >= v:getNumIndex() then
				insert_pos = i
				break
			end
		end
	end

	if insert_pos > outSeatPos then
		-- 向左移动 大于 outSeatPos 并且 小于等于 insert_pos 的牌进行移动
		for i,v in ipairs( handCards ) do
			local old_setPos = v:getSeatPos()
			if old_setPos > outSeatPos and old_setPos <= insert_pos then
				-- 左移动一位
				local new_setPos = old_setPos - 1
				v:setSeatPos( new_setPos )
				local new_pos = pokerPos[ new_setPos ]
				local move_to = cc.MoveTo:create( actionTime,new_pos )
				local rotate_to = cc.RotateTo:create( actionTime,pokerAngle[new_setPos] )
				local spawn = cc.Spawn:create({ move_to,rotate_to })
				v:runAction( spawn )
			end
		end
	elseif insert_pos == outSeatPos then
		-- 不需要移动
		insert_pos = outSeatPos
	else
		-- 向右移动 小于 outSeatPos 并且 大于等于 insert_pos 的牌进行移动
		for i,v in ipairs( handCards ) do
			local old_setPos = v:getSeatPos()
			if old_setPos < outSeatPos and old_setPos >= insert_pos then
				-- 左移动一位
				local new_setPos = old_setPos + 1
				v:setSeatPos( new_setPos )
				local new_pos = pokerPos[ new_setPos ]
				local move_to = cc.MoveTo:create( actionTime,new_pos )
				local rotate_to = cc.RotateTo:create( actionTime,pokerAngle[new_setPos] )
				local spawn = cc.Spawn:create({ move_to,rotate_to })
				v:runAction( spawn )
			end
		end
	end
	return top_numIndex,insert_pos
end

function GamePlay:moveSortHandCardByPaiDuiNoCards( source,actionTime,pokerPos,pokerAngle )
	assert( source," !! source is nil !! " )
	assert( actionTime," !! actionTime is nil !! " )
	assert( pokerPos," !! pokerPos is nil !! " )
	assert( pokerAngle," !! pokerAngle is nil !! " )
	if #source == 0 then
		return
	end
	local new_setPos = 1
	if #source == 1 or #source == 2 then
		-- 当剩一张牌的时候
		new_setPos = 3
	elseif #source == 3 then
		new_setPos = 2
	elseif #source == 4 or #source == 5 then
		new_setPos = 1
	end

	for i,v in ipairs( source ) do
		local nnew_seat_pos = new_setPos + i - 1
		v:setSeatPos( nnew_seat_pos )
		local new_pos = pokerPos[ nnew_seat_pos ]

		local move_to = cc.MoveTo:create( actionTime,new_pos )
		local rotate_to = cc.RotateTo:create( actionTime,pokerAngle[nnew_seat_pos] )
		local spawn = cc.Spawn:create({ move_to,rotate_to })
		v:runAction( spawn )
	end
end

function GamePlay:checkPMax()
	if #self._aiOutCards == 0 then
		return false
	end
	if #self._playerOutCards == 0 then
		return false
	end
	-- 计算ai出牌的总和
	local ai_total_num = self:calAiOutTotalNum()
	-- 计算player出牌的总和
	local player_total_num = self:calPlayerOutTotalNum()
	if ai_total_num == player_total_num then
		return true
	end
	return false
end

--[[
	intType 1: ai先出牌 2:玩家先出牌
]]
function GamePlay:excutePMaxAction( intType )
	local pmax_img = ccui.ImageView:create( "image/play/pax.png",1 )
	self:addChild( pmax_img )
	pmax_img:setPosition( display.cx,display.cy )
	pmax_img:setScale( 2 )
	local scale_to = cc.ScaleTo:create( 0.5,1 )
	local delay = cc.DelayTime:create(1)
	local call_set = cc.CallFunc:create( function()
		-- 显示显示为背部
		for i,v in ipairs( self._aiOutCards ) do
			v:showBei()
			local move_to = cc.MoveTo:create( 0.2,self._outAIPos )
			v:runAction( move_to )
		end
		for i,v in ipairs( self._playerOutCards ) do
			v:showBei()
			local move_to = cc.MoveTo:create( 0.2,self._outPlayerPos )
			v:runAction( move_to )
		end
		-- 先发玩家 再发ai 每人发3张
		local ai_send_call = function()
			-- 1秒之后 牌聚拢
			local call_juji = function()
				performWithDelay( self,function()
					for i,v in ipairs( self._aiOutCards ) do
						local move_to = cc.MoveTo:create( 0.3,self._outAIPos )
						local call_bei = cc.CallFunc:create( function()
							v:showBei()
						end )
						v:runAction( cc.Sequence:create( { move_to,call_bei } ) )
					end
					for i,v in ipairs( self._playerOutCards ) do
						local move_to = cc.MoveTo:create( 0.3,self._outPlayerPos )
						local call_bei = cc.CallFunc:create( function()
							v:showBei()
						end )
						v:runAction( cc.Sequence:create( { move_to,call_bei } ) )
					end

					if #self._aiPaiDuiCards <= 0 and #self._aiHandCards > 0 then
						self:moveSortHandCardByPaiDuiNoCards( self._aiHandCards,0.4,self._aiPokerPos,self._aiPokerAngle )
					end

					if #self._playerPaiDuiCards <= 0 and #self._playerHandCards > 0 then
						self:moveSortHandCardByPaiDuiNoCards( self._playerHandCards,0.4,self._playerPokerPos,self._playerPokerAngle )
					end

					if intType == 1 then
						if #self._aiHandCards > 0 then
							-- 0.5秒之后 ai出牌
							performWithDelay( self,function()
								self:aiOutCard()
							end,0.5 )
						else
							-- ai 直接输牌
							self:excutePlayerWinPokerAction()
						end
					else
						
						if #self._playerHandCards > 0 then
							-- 等待玩家出牌
							performWithDelay( self,function()
								self:turnPlayerOutCard()
							end,0.5 )
						else
							-- 玩家直接输牌
							self:excuteAIWinPokerAction()
						end
					end
				end,1 )
			end
			self:createPokerToOut( self._aiPaiDuiCards,self._aiHandCards,self._aiOutCards,self._outAIPos,call_juji )
		end
		self:createPokerToOut( self._playerPaiDuiCards,self._playerHandCards,self._playerOutCards,self._outPlayerPos,ai_send_call )
	end )
	local remove = cc.RemoveSelf:create()
	pmax_img:runAction( cc.Sequence:create( { scale_to,delay,call_set,remove } ) )
end

function GamePlay:createPokerToOut( paiDuiCards,handCards,outCards,outPos,callBack )
	assert( paiDuiCards," !! paiDuiCards is nil !! ")
	assert( handCards," !! handCards is nil !! ")
	assert( outCards," !! outCards is nil !! ")
	assert( outPos," !! outPos is nil !! ")
	local paidui_count = #paiDuiCards
	local hands_count = #handCards
	assert( paidui_count + hands_count >= 3," !! error,this logic not exist !! " )
	local hands_need_out = 3 - paidui_count
	if hands_need_out > 0 then
		-- 从手牌中发牌
		local call_send_byhand = function()
			table.sort( handCards,function( a,b )
				return a:getSeatPos() < b:getSeatPos()
			end )

			local remove_pointer = {}
			for j = 1,hands_need_out do
				if G_GetModel("Model_Sound"):isVoiceOpen() then
					audio.playSound("zqmp3/sendpoker.mp3", false)
				end
				local hand_poker = handCards[j]
				local hadNumIndex = hand_poker:getNumIndex()
				local hand_world_pos = hand_poker:getParent():convertToWorldSpace( cc.p(hand_poker:getPosition()) )
				local hand_start_pos = self._csbNode:convertToNodeSpace( hand_world_pos )
				hand_poker:removeFromParent()
				-- 记录要移除该指针
				table.insert( remove_pointer,handCards[j] )

				-- 创建牌 执行出牌动画
				local hand_new_poker = NodePoker.new( self,hadNumIndex )
				self._csbNode:addChild( hand_new_poker )
				hand_new_poker:setPosition( hand_start_pos )
				hand_new_poker:showPoker()
				outCards[#outCards + 1] = hand_new_poker

				local hand_dest_pos = cc.p( outPos.x + ( paidui_count - 1 + j ) * 35,outPos.y )
				local hand_delay = cc.DelayTime:create( 0.1 * ( paidui_count - 1 + j ) )
				local hand_move_to = cc.MoveTo:create( 0.3,hand_dest_pos )
				local call_hand_send = cc.CallFunc:create( function()
					if j == hands_need_out and callBack then
						-- 移除指针
						for q,w in ipairs( remove_pointer ) do
							for e,r in ipairs( handCards ) do
								if w == r then
									table.remove( handCards,e )
									break
								end
							end
						end
						table.sort( handCards,function( a,b )
							return a:getSeatPos() < b:getSeatPos()
						end )
						callBack()
					end
				end )
				hand_new_poker:runAction( cc.Sequence:create( { hand_delay,hand_move_to,call_hand_send } ) )
			end
		end
		if paidui_count > 0 then
			for i = 1,paidui_count do
				if G_GetModel("Model_Sound"):isVoiceOpen() then
					audio.playSound("zqmp3/sendpoker.mp3", false)
				end
				local poker = paiDuiCards[#paiDuiCards]
				paiDuiCards[#paiDuiCards] = nil
				local numIndex = poker:getNumIndex()
				local world_pos = poker:getParent():convertToWorldSpace( cc.p(poker:getPosition()) )
				local start_pos = self._csbNode:convertToNodeSpace( world_pos )
				poker:removeFromParent()

				-- 创建牌 执行出牌动画
				local new_poker = NodePoker.new( self,numIndex )
				self._csbNode:addChild( new_poker )
				new_poker:setPosition( start_pos )
				new_poker:showPoker()
				outCards[#outCards + 1] = new_poker
				local dest_pos = cc.p( outPos.x + ( i - 1 ) * 35,outPos.y )
				local delay = cc.DelayTime:create( 0.1 * ( i - 1 ) )
				local move_to = cc.MoveTo:create( 0.3,dest_pos )
				local call_send = cc.CallFunc:create( function()
					if i == paidui_count then
						call_send_byhand()
					end
				end )
				new_poker:runAction( cc.Sequence:create( { delay,move_to,call_send } ) )
			end
		else
			call_send_byhand()
		end
	else
		-- 全部从牌堆发牌
		for i = 1,3 do
			if G_GetModel("Model_Sound"):isVoiceOpen() then
				audio.playSound("zqmp3/sendpoker.mp3", false)
			end

			local poker = paiDuiCards[#paiDuiCards]
			paiDuiCards[#paiDuiCards] = nil
			local numIndex = poker:getNumIndex()
			local world_pos = poker:getParent():convertToWorldSpace( cc.p(poker:getPosition()) )
			local start_pos = self._csbNode:convertToNodeSpace( world_pos )
			poker:removeFromParent()

			-- 创建牌 执行出牌动画
			local new_poker = NodePoker.new( self,numIndex )
			self._csbNode:addChild( new_poker )
			new_poker:setPosition( start_pos )
			new_poker:showPoker()
			outCards[#outCards + 1] = new_poker
			local dest_pos = cc.p( outPos.x + ( i - 1 ) * 35,outPos.y )

			local delay = cc.DelayTime:create( 0.1 * ( i - 1 ) )
			local move_to = cc.MoveTo:create( 0.3,dest_pos )
			local call_send = cc.CallFunc:create( function()
				if i == 3 and callBack then
					callBack()
				end
			end )
			new_poker:runAction( cc.Sequence:create( { delay,move_to,call_send } ) )
		end
	end
end

function GamePlay:loadPlayerOpIcon()
	self:hideOpIcon()
	-- 设置belong
	for i = 1,5 do
		self:showBeLongIcon( i )
	end
	-- 设置Pmax
	local ai_total_num = self:calAiOutTotalNum()
	if ai_total_num > 0 then
		local player_total_num = self:calPlayerOutTotalNum()

		local top_out_poker = self._playerOutCards[#self._playerOutCards]
		local out_color = nil
		if top_out_poker and (not top_out_poker:isShowBei()) then
			out_color = zuqiu_card_config[top_out_poker:getNumIndex()].color
		end

		for i = 1,6 do
			local poker = self._playerHandCards[i]
			if poker then
				local player_num = zuqiu_card_config[poker:getNumIndex()].num
				if out_color then
					local player_color = zuqiu_card_config[poker:getNumIndex()].color
					if out_color == player_color and ai_total_num == player_num + player_total_num then
						self["ImagePMax"..poker:getSeatPos()]:setVisible( true )
					end
				else
					if ai_total_num == player_num + player_total_num then
						self["ImagePMax"..poker:getSeatPos()]:setVisible( true )
					end
				end
			end
		end
	end
	-- 重置阴影
	for i = 1,6 do
		if self._playerHandCards[i] then
			self._playerHandCards[i]:setYinYingVisible( false )
		end
	end
	-- 设置canout
	if ai_total_num > 0 then
		local player_total_num = self:calPlayerOutTotalNum()

		local top_out_poker = self._playerOutCards[#self._playerOutCards]
		local out_color = nil
		if top_out_poker and not top_out_poker:isShowBei() then
			out_color = zuqiu_card_config[top_out_poker:getNumIndex()].color
		end

		for i = 1,6 do
			if self._playerHandCards[i] then
				local player_color = zuqiu_card_config[self._playerHandCards[i]:getNumIndex()].color
				local player_num = zuqiu_card_config[self._playerHandCards[i]:getNumIndex()].num
				if out_color then
					if player_color == out_color then
						if ai_total_num < player_num + player_total_num then
							local seat_pos = self._playerHandCards[i]:getSeatPos()
							self["ImageCanOut"..seat_pos]:setVisible( true )
						end
					else
						self._playerHandCards[i]:setYinYingVisible( true )
					end
				else
					if ai_total_num < player_num + player_total_num then
						local seat_pos = self._playerHandCards[i]:getSeatPos()
						self["ImageCanOut"..seat_pos]:setVisible( true )
					end
				end
			end
		end
	end
end

-- 计算ai出牌的总和
function GamePlay:calAiOutTotalNum()
	local ai_total_num = 0
	for i,v in ipairs( self._aiOutCards ) do
		if v:isShowBei() == false then
			ai_total_num = ai_total_num + zuqiu_card_config[v:getNumIndex()].num
		end
	end
	return ai_total_num
end

-- 计算玩家出牌的总和
function GamePlay:calPlayerOutTotalNum()
	local player_total_num = 0
	for i,v in ipairs( self._playerOutCards ) do
		if v:isShowBei() == false then
			player_total_num = player_total_num + zuqiu_card_config[v:getNumIndex()].num
		end
	end
	return player_total_num
end

function GamePlay:showBeLongIcon( pos )
	assert( pos," !! pos is nil !! " )
	local cur_poker = nil
	local next_poker = nil

	for i,v in ipairs( self._playerHandCards ) do
		local seat_pos = v:getSeatPos()
		if pos == seat_pos then
			cur_poker = v
		end
		if pos + 1 == seat_pos then
			next_poker = v
		end
	end

	if cur_poker and next_poker then
		local color1 = zuqiu_card_config[cur_poker:getNumIndex()].color
		local color2 = zuqiu_card_config[next_poker:getNumIndex()].color
		if color1 == color2 then
			self["ImageLong"..pos]:setVisible( true )
			self["ImageLong"..pos]:loadTexture( "image/play/Bringalong"..color1..".png",1 )
		end
	end
end

function GamePlay:hideOpIcon()
	for i = 1,6 do
    	if i < 6 then
    		self["ImageLong"..i]:setVisible( false )
    	end
    	self["ImagePMax"..i]:setVisible( false )
    	self["ImageCanOut"..i]:setVisible( false )
    end
end

function GamePlay:checkAIWinPoker()
	if #self._playerOutCards > 0 then
		local player_total_num = self:calPlayerOutTotalNum()

		if player_total_num == 0 then
			return false
		end

		local ai_total_num = self:calAiOutTotalNum()
		local player_out_poker = self._playerOutCards[#self._playerOutCards]
		local player_out_color = zuqiu_card_config[player_out_poker:getNumIndex()].color
		for i,v in ipairs( self._playerHandCards ) do
			local color = zuqiu_card_config[v:getNumIndex()].color
			if color == player_out_color then
				-- if v:getCardNum() + player_total_num >= ai_total_num then
				-- 	return false
				-- end
				return false
			end
		end
		return true
	end
	return false
end

function GamePlay:checkPlayerWinPoker()
	if #self._aiOutCards > 0 then
		local player_total_num = self:calPlayerOutTotalNum()
		local ai_total_num = self:calAiOutTotalNum()

		if ai_total_num == 0 then
			return false
		end

		local ai_out_poker = self._aiOutCards[#self._aiOutCards]
		local ai_out_color = zuqiu_card_config[ai_out_poker:getNumIndex()].color
		for i,v in ipairs( self._aiHandCards ) do
			local color = zuqiu_card_config[v:getNumIndex()].color
			if color == ai_out_color then
				-- if v:getCardNum() + ai_total_num >= player_total_num then
				-- 	return false
				-- end
				-- 只要还有该花色 就出牌
				return false
			end
		end
		return true
	end
	return false
end

function GamePlay:excuteAIWinPokerAction()
	local call_move_player = function()
		local call_ai_out = function()
			-- 足球移动动画
			self:footBallAction()
			-- ai出牌
			-- 检查ai是否赢得游戏
			if #self._playerPaiDuiCards <= 1 then
				self:isGameOver(1)
			else
				performWithDelay( self,function()
					--检查是否需要补牌
					local call_out_back = function() self:aiOutCard() end
					self:sendCardByWin( self._aiPaiDuiCards,self._aiHandCards,call_out_back,false )
				end,0.5 )
			end
		end
		-- 移动玩家的出牌到ai的牌堆
		self:moveCardsFromOutToPaiDui( self._playerOutCards,self.ImageBeiAI,self._aiPaiDuiCards,call_ai_out,true,0.2 )
	end
	-- 移动ai的出牌到ai的牌堆
	self:moveCardsFromOutToPaiDui( self._aiOutCards,self.ImageBeiAI,self._aiPaiDuiCards,call_move_player,true,0.2 )
end

function GamePlay:excutePlayerWinPokerAction()
	local call_move_player = function()
		local call_player_out = function()
			-- 足球移动动画
			self:footBallAction()
			-- 玩家出牌
			if #self._aiPaiDuiCards <= 1 then
				self:isGameOver(2)
			else
				performWithDelay( self,function()
					local call_out_back = function() self:turnPlayerOutCard() end
					self:sendCardByWin( self._playerPaiDuiCards,self._playerHandCards,call_out_back,true )
				end,0.5 )
			end
		end
		-- 移动玩家的出牌到玩家的牌堆
		self:moveCardsFromOutToPaiDui( self._playerOutCards,self.ImageBeiPlayer,self._playerPaiDuiCards,call_player_out,false,0.2 )
	end
	-- 移动ai的出牌到玩家的牌堆
	self:moveCardsFromOutToPaiDui( self._aiOutCards,self.ImageBeiPlayer,self._playerPaiDuiCards,call_move_player,false,0.2 )
end


function GamePlay:moveCardsFromOutToPaiDui( outCards,paiDuiNode,paiDuiCards,callBack,needFlippedY,actionTime )
	assert( outCards," !! outCards is nil !! " )
	assert( paiDuiNode," !! paiDuiNode is nil !! " )
	assert( paiDuiCards," !! paiDuiCards is nil !! " )
	assert( actionTime," !! actionTime is nil !! " )
	assert( #outCards > 0," !! #outCards must be > 0 !! " )
	for i,v in ipairs( outCards ) do
		v:showBei()
		local world_pos = paiDuiNode:getParent():convertToWorldSpace( cc.p( paiDuiNode:getPosition() ) )
		local node_pos = v:getParent():convertToNodeSpace( world_pos )
		local delay = cc.DelayTime:create(0.1 * i)
		local move_to = cc.MoveTo:create( actionTime,node_pos )
		local call_set = cc.CallFunc:create( function()
			-- 创建poker
			local poker = NodePoker.new( self,v:getNumIndex() )
			paiDuiNode:addChild( poker,0 )
			table.insert( paiDuiCards,1,poker )

			local panel_size = self.ImageBeiAI:getContentSize()
			local pos = cc.p( panel_size.width / 2,panel_size.height / 2 + 7 )
			poker:setPosition( pos )

			if i == #outCards then
				-- 清除出牌
				for k,v in ipairs(outCards) do
					outCards[k] = nil
				end
				-- needFlippedY为true 表示 ai
				self:reSetZOrderAndPosCards( paiDuiCards,needFlippedY )
				if callBack then
					callBack()
				end
			end
		end )
		local remove = cc.RemoveSelf:create()
		v:runAction( cc.Sequence:create({ delay,move_to,call_set,remove }) )
	end
end

function GamePlay:reSetZOrderAndPosCards( paiDuiCards,needFlippedY )
	assert( paiDuiCards," !! paiDuiCards is nil !! " )
	local panel_size = self.ImageBeiAI:getContentSize()
	local pos = cc.p( panel_size.width / 2,panel_size.height / 2 + 7 )
	for i,v in ipairs( paiDuiCards ) do
		v:setPosition( cc.p( pos.x - i * 1,pos.y + i * 1 ) )
		v:setLocalZOrder( i )
		if needFlippedY then
			v._image:getVirtualRenderer():getSprite():setFlippedY( true )
		end
	end
end

function GamePlay:isGameOver( winType )
	if winType == 1 then
		if G_GetModel("Model_Sound"):isVoiceOpen() then
			audio.playSound("zqmp3/lose.mp3", false)
		end
		-- ai 赢
		G_GetModel("Model_ZuQiu"):setCoin( 1 )
		local call_back = function() 
			addUIToScene( UIDefine.ZUQIU_KEY.Lose_UI,{ country_index = self._countryIndex } )
		end
		self:gameOverFootBallAction( self.NodeLoseQiuPos,call_back )
	elseif winType == 2 then
		if G_GetModel("Model_Sound"):isVoiceOpen() then
			audio.playSound("zqmp3/win.mp3", false)
		end
		-- 玩家赢
		G_GetModel("Model_ZuQiu"):setCoin( 10 )
		G_GetModel("Model_ZuQiu"):setStage()
		local call_back = function()
			addUIToScene( UIDefine.ZUQIU_KEY.Win_UI,{ country_index = self._countryIndex } )
		end
		self:gameOverFootBallAction( self.NodeWinQiuPos,call_back )
	end
end

function GamePlay:showPass()
	self.ButtonPass:setVisible( true )
	if not self._schedulePassMark then
		self._schedulePassMark = true
		self._passIndex = 1
		self:schedule( function()
			local path = ""
			if self._passIndex % 2 ~= 0 then
				path = "image/play/pass.png"
			else
				path = "image/play/pass2.png"
			end
			self._passIndex = self._passIndex + 1
			self.ButtonPass:loadTexture( path,1 )
		end,0.5 )
	else
		self:startSchedule()
	end
end

function GamePlay:footBallAction()
	local meta = 146.5 / 16
	local move_dis_num = 14 - #self._playerPaiDuiCards
	local dis_y = meta * move_dis_num
	local pos_y = 146.5 - dis_y
	local pos_x = self.ImageQiu:getPositionX()
	self.ImageQiu:runAction( cc.MoveTo:create( 0.3,cc.p( pos_x,pos_y ) ))
end

function GamePlay:hidePass()
	self.ButtonPass:setVisible( false )
	if self._schedulePassMark then
		self:stopSchedule()
	end
end

function GamePlay:gameOverFootBallAction( node,callBack )
	local size = cc.Director:getInstance():getWinSize()
	local img = ccui.ImageView:create( "image/play/zq.png",1 )
	node:addChild( img )
	local stack_pos	= node:convertToNodeSpace( cc.p(size.width / 2,size.height / 2) )
	img:setPosition( stack_pos )
	local goal = size.height / 7
	local move_to = cc.MoveTo:create( 0.6,cc.p( 0,0 ))
	local move_by = cc.MoveBy:create( 0.2,cc.p( 0,-goal ))
	local move_by_1 = cc.MoveBy:create( 0.15,cc.p( 0,goal/5*4 ))
	local move_by_2 = cc.MoveBy:create( 0.1,cc.p( 0,-goal/5*3 ))
	local move_by_3 = cc.MoveBy:create( 0.05,cc.p( 0,goal/5*1 ))
	local fade_out = cc.FadeOut:create( 0.2 )
	local call_back = cc.CallFunc:create( callBack )
	local sequence = cc.Sequence:create( move_to,move_by,move_by_1,move_by_2,move_by_3,fade_out,call_back )
	img:runAction( sequence )
end

-- 每次赢牌之后 判断手牌 是否需要重新发牌
function GamePlay:sendCardByWin( paiDuiCards,hands,callBack,isPlayer )
	assert( paiDuiCards," !! paiDuiCards is nil !! " )
	assert( hands," !! hands is nil !! " )
	assert( callBack," !! callBack is nil !! " )
	-- 手牌有6张 不需要
	if #hands == 6 then
		callBack()
		return
	end
	-- 找出缺牌的位置
	local has_seat = {}
	for i,v in ipairs( hands ) do
		table.insert( has_seat,v:getSeatPos() )
	end
	local no_seat = {}
	for i = 1,6 do
		local has = false
		for a,b in ipairs( has_seat ) do
			if b == i then
				has = true
			end
		end
		if not has then
			table.insert( no_seat,i )
		end
	end
	local count = 0
	if #paiDuiCards > #no_seat then
		count = #no_seat
	else
		count = #paiDuiCards
	end
	local action_time = 0.5
	-- 为缺牌的位置执行发牌动画
	local actions = {}
	for i = 1,count do
		local top_numIndex = paiDuiCards[#paiDuiCards - (i-1)]:getNumIndex()
		local delay = cc.DelayTime:create( action_time + 0.1 )
		local call_send = cc.CallFunc:create( function()
			if isPlayer then
				-- 玩家
				self:playerMoCard( top_numIndex,no_seat[i],action_time )
			else
				-- AI
				self:aiMoCard( top_numIndex,no_seat[i],action_time )
			end
		end )
		table.insert( actions,delay )
		table.insert( actions,call_send )
		if i == count then
			local delay2 = cc.DelayTime:create( 0.6 )
			local call_bback = cc.CallFunc:create( function()
				callBack()
			end)
			table.insert( actions,delay2 )
			table.insert( actions,call_bback )
		end
	end
	self:runAction( cc.Sequence:create( actions ) )
end

function GamePlay:clickPass()
	self:hidePass()
	-- 直接ai赢
	self:excuteAIWinPokerAction()
end

function GamePlay:clickMusic()
	addUIToScene( UIDefine.ZUQIU_KEY.Voice_UI )
end

function GamePlay:clickBack()
	removeUIFromScene( UIDefine.ZUQIU_KEY.Play_UI )
	addUIToScene( UIDefine.ZUQIU_KEY.Start_UI )
end

function GamePlay:clickHelp()
	addUIToScene( UIDefine.ZUQIU_KEY.Help_UI )
end

return GamePlay