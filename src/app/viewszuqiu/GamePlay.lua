
local NodePoker = import(".NodePoker")

local GamePlay  = class("GamePlay",BaseLayer)

local STAGE_ICON = {
	[1]  = "image/play/Groupstage1.png",
	[2]  = "image/play/Groupstage2.png",
	[3]  = "image/play/Groupstage3.png",
	[4]  = "image/pay/Quarterfinal.png",
	[5]  = "image/pay/SemiFinals.png",
	[6]  = "image/pay/Final.png"
}

function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbzuqiu/Play.csb" )

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
    self._stage = 1
    if param.data.stage then
    	self._stage = param.data.stage
    end

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
	self.ImageStage:loadTexture( STAGE_ICON[self._stage] )
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
		poker:setPosition( pos )
		poker:setLocalZOrder( i )
		poker._image:getVirtualRenderer():getSprite():setFlippedY( true )
	end
	-- player
	for i,v in ipairs( player_poker ) do
		local poker = NodePoker.new( self,v )
		self.ImageBeiPlayer:addChild( poker )
		table.insert( self._playerPaiDuiCards,poker )
		poker:setPosition( pos )
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
	new_poker:showPoker()
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
	if #self._aiOutCards == 0 then
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

		local out_poker = nil
		for i,v in ipairs( self._aiHandCards ) do
			local color = zuqiu_card_config[v:getNumIndex()].color
			if color == max_color then
				out_poker = v
				break
			end
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
		-- 创建牌 执行出牌动画
		local new_poker = NodePoker.new( self,numIndex )
		self._csbNode:addChild( new_poker )
		new_poker:setPosition( start_pos )
		new_poker:showPoker()
		self._aiOutCards[#self._aiOutCards + 1] = new_poker

		local dest_pos = cc.p( self._outAIPos.x + #self._aiOutCards * 10,self._outAIPos.y - #self._aiOutCards * 10 )
		local move_to = cc.MoveTo:create( 0.5,dest_pos )
		local call_ai_mo = cc.CallFunc:create( function()
			-- 移动牌
			local action_time = 0.5
			local num_index,insert_seatPos = self:aiMoveSortHandCard( seat_pos,action_time )
			-- 摸牌
			self:aiMoCard( num_index,insert_seatPos,action_time )
		end )
		local call_move_over = cc.CallFunc:create( function()
			-- 1:是否需要pmax
			local is_pmax = self:checkPMax()
			if is_pmax then
				-- 播放pax动画
				return
			end
			-- 2:是否赢牌( 玩家不能出牌 且大于玩家的点数 就赢牌)
			
			-- 3:刷新玩家手牌的op icon 等待玩家出牌
			self:loadPlayerOpIcon()
			self._playerCanTouch = true
		end )
		new_poker:runAction( cc.Sequence:create({ move_to,call_ai_mo,call_move_over}) )
	else
		local top_poker = self._aiOutCards[#self._aiOutCards]
		local color = zuqiu_card_config[top_poker:getNumIndex()].color
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
	if ai_total_num > poker_num + player_total_num then
		return
	end
	-- 出牌
	self._playerCanTouch = false
	self:loadPlayerOpIcon()
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

	-- 创建牌 执行出牌动画
	local new_poker = NodePoker.new( self,numIndex )
	self._csbNode:addChild( new_poker )
	new_poker:setPosition( start_pos )
	new_poker:showPoker()
	self._playerOutCards[#self._playerOutCards + 1] = new_poker

	local dest_pos = cc.p( self._outPlayerPos.x + #self._playerOutCards * 10,self._outPlayerPos.y - #self._playerOutCards * 10 )
	local move_to = cc.MoveTo:create( 0.5,dest_pos )
	local call_player_mo = cc.CallFunc:create( function()
		-- 移动牌
		local action_time = 0.5
		local num_index,insert_seatPos = self:playerMoveSortHandCard( seat_pos,action_time )
		-- 摸牌
		self:playerMoCard( num_index,insert_seatPos,action_time )
	end )
	local call_move_over = cc.CallFunc:create( function()
		-- 1:是否需要pmax
		local is_pmax = self:checkPMax()
		if is_pmax then
			-- 播放pax动画
			return
		end
		-- 2:是否赢牌( ao不能出牌 且大于ai的点数 就赢牌)
		-- 3:通知ai出牌
	end )
	local seq = cc.Sequence:create({ move_to,call_player_mo,call_move_over })
	new_poker:runAction( seq )
end

-- 在牌堆有牌的情况下 ai排序手中牌
function GamePlay:aiMoveSortHandCard( outSeatPos,actionTime )
	assert( outSeatPos," !! outSeatPos is nil !! " )
	assert( actionTime," !! actionTime is nil !! " )
	assert( #self._aiPaiDuiCards > 0," !! self._aiPaiDuiCards nums must be > 0 !! " )
	-- 获得牌堆里面的牌
	local top_poker = self._aiPaiDuiCards[#self._aiPaiDuiCards]
	local top_numIndex = top_poker:getNumIndex()
	-- 计算新牌要插入的位置
	local insert_pos = 1
	for i,v in ipairs( self._aiHandCards ) do
		if v:getNumIndex() > top_numIndex then
			insert_pos = i
			break
		end
	end
	if insert_pos > outSeatPos then
		-- 向左移动 大于 outSeatPos 并且 小于等于 insert_pos 的牌进行移动
		for i,v in ipairs( self._aiHandCards ) do
			local old_setPos = v:getSeatPos()
			if old_setPos > outSeatPos and old_setPos <= insert_pos then
				-- 左移动一位
				local new_setPos = old_setPos - 1
				v:setSeatPos( new_setPos )
				local new_pos = self._aiPokerPos[ new_setPos ]
				local move_to = cc.MoveTo:create( actionTime,new_pos )
				local rotate_to = cc.RotateTo:create( actionTime,self._aiPokerAngle[new_setPos] )
				local spawn = cc.Spawn:create({ move_to,rotate_to })
				v:runAction( spawn )
			end
		end
	elseif insert_pos == outSeatPos then
		-- 不需要移动
		insert_pos = outSeatPos
	else
		-- 向右移动 小于 outSeatPos 并且 大于等于 insert_pos 的牌进行移动
		for i,v in ipairs( self._aiHandCards ) do
			local old_setPos = v:getSeatPos()
			if old_setPos < outSeatPos and old_setPos >= insert_pos then
				-- 左移动一位
				local new_setPos = old_setPos + 1
				v:setSeatPos( new_setPos )
				local new_pos = self._aiPokerPos[ new_setPos ]
				local move_to = cc.MoveTo:create( actionTime,new_pos )
				local rotate_to = cc.RotateTo:create( actionTime,self._aiPokerAngle[new_setPos] )
				local spawn = cc.Spawn:create({ move_to,rotate_to })
				v:runAction( spawn )
			end
		end
	end
	return top_numIndex,insert_pos
end

-- 在牌堆有牌的情况下 palyer排序手中牌
function GamePlay:playerMoveSortHandCard( outSeatPos,actionTime )
	assert( outSeatPos," !! outSeatPos is nil !! " )
	assert( actionTime," !! actionTime is nil !! " )
	assert( #self._playerPaiDuiCards > 0," !! self._playerPaiDuiCards nums must be > 0 !! " )
	-- 获得牌堆里面的牌
	local top_poker = self._playerPaiDuiCards[#self._playerPaiDuiCards]
	local top_numIndex = top_poker:getNumIndex()
	-- 计算新牌要插入的位置
	local insert_pos = 1
	for i,v in ipairs( self._playerHandCards ) do
		if v:getNumIndex() < top_numIndex then
			insert_pos = i
			break
		end
	end
	if insert_pos > outSeatPos then
		-- 向左移动 大于 outSeatPos 并且 小于等于 insert_pos 的牌进行移动
		for i,v in ipairs( self._playerHandCards ) do
			local old_setPos = v:getSeatPos()
			if old_setPos > outSeatPos and old_setPos <= insert_pos then
				-- 左移动一位
				local new_setPos = old_setPos - 1
				v:setSeatPos( new_setPos )
				local new_pos = self._playerPokerPos[ new_setPos ]
				local move_to = cc.MoveTo:create( actionTime,new_pos )
				local rotate_to = cc.RotateTo:create( actionTime,self._playerPokerAngle[new_setPos] )
				local spawn = cc.Spawn:create({ move_to,rotate_to })
				v:runAction( spawn )
			end
		end
	elseif insert_pos == outSeatPos then
		-- 不需要移动
		insert_pos = outSeatPos
	else
		-- 向右移动 小于 outSeatPos 并且 大于等于 insert_pos 的牌进行移动
		for i,v in ipairs( self._playerHandCards ) do
			local old_setPos = v:getSeatPos()
			if old_setPos < outSeatPos and old_setPos >= insert_pos then
				-- 左移动一位
				local new_setPos = old_setPos + 1
				v:setSeatPos( new_setPos )
				local new_pos = self._playerPokerPos[ new_setPos ]
				local move_to = cc.MoveTo:create( actionTime,new_pos )
				local rotate_to = cc.RotateTo:create( actionTime,self._playerPokerAngle[new_setPos] )
				local spawn = cc.Spawn:create({ move_to,rotate_to })
				v:runAction( spawn )
			end
		end
	end
	return top_numIndex,insert_pos
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
		for i = 1,6 do
			local poker = self._playerHandCards[i]
			if poker then
				local player_num = zuqiu_card_config[poker:getNumIndex()].num
				if ai_total_num == player_num + player_total_num then
					self["ImagePMax"..poker:getSeatPos()]:setVisible( true )
				end
			end
		end
	end
	-- 设置canout
	if ai_total_num > 0 then
		local player_total_num = self:calPlayerOutTotalNum()
		for i = 1,6 do
			if self._playerHandCards[i] then
				local player_num = zuqiu_card_config[self._playerHandCards[i]:getNumIndex()].num
				if ai_total_num < player_num + player_total_num then
					self["ImageCanOut"..i]:setVisible( true )
				elseif ai_total_num > player_num + player_total_num then
					self._playerHandCards[i]:setYinYingVisible( true )
				end
			end
		end
	end
end

-- 计算ai出牌的总和
function GamePlay:calAiOutTotalNum()
	local ai_total_num = 0
	for i,v in ipairs( self._aiOutCards ) do
		ai_total_num = ai_total_num + zuqiu_card_config[v:getNumIndex()].num
	end
	return ai_total_num
end

-- 计算玩家出牌的总和
function GamePlay:calPlayerOutTotalNum()
	local player_total_num = 0
	for i,v in ipairs( self._playerOutCards ) do
		player_total_num = player_total_num + zuqiu_card_config[v:getNumIndex()].num
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

    	if self._playerHandCards and self._playerHandCards[i] then
    		self._playerHandCards[i]:setYinYingVisible( false )
    	end
    end
end

function GamePlay:isGameOver()
end


return GamePlay