

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

    self:loadUi()
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
	self.ImageAIHand:setVisible( false )
	for i = 1,10 do
		self["ImageAIpoker"..i]:setVisible( false )
	end
	-- self.SpriteFist:setVisible( false )
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
			self:playerSendPoker( self.NodeStack,time )
			self:AISendPoker( self.NodeStack,time )
		end )
		table.insert( actions,call )
		
		if i == 10 then
			local delay2 = cc.DelayTime:create( 0.5 )
			table.insert( actions,delay2 )
			local call_sort = cc.CallFunc:create( function ()
				-- self:playerHandPokerSort()
				self:firstLaterDraw()
			end)
			table.insert( actions,call_sort )
		end
	end
	self:runAction( cc.Sequence:create( actions ) )
end

function GamePlay:AISendPoker( node,time )
	local stack_childs = node:getChildren()
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
		local ai_childs = self.AIHandPokerIn:getChildren()
		local ai_numPoker = #ai_childs
		if ai_numPoker < 11 and ai_numPoker > 1 then
			self["ImageAIpoker"..ai_numPoker]:setVisible( true )
		end
		
		if ai_numPoker == 1 then
			local hand_pos = cc.p(self.ImageAIHand1:getPosition())
			self.ImageAIHand1:setVisible( true )
			self.ImageAIHand1:setPositionX( hand_pos.x + 150 )
			self.ImageAIHand1:setRotation( -60 )
			local hand_rotate = cc.RotateTo:create( time,0 )
			local hand_move_to = cc.MoveTo:create( time,hand_pos )
			local hand_spawn = cc.Spawn:create( { hand_rotate,hand_move_to } )
			self.ImageAIHand1:runAction( hand_spawn )

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
	local ai_childs = self.AIHandPokerIn:getChildren()
	local rot = 15
	return rot - #ai_childs * 3
end

function GamePlay:playerSendPoker( node,time )
	dump( node,"----------node???????")
	local stack_childs = node:getChildren()

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

	self:playerPokerMove( node,top_poker,position_end,time )
end

function GamePlay:playerPokerMove( node,poker,position,time )

	local move_to = cc.MoveTo:create( time * 2,position )
	local call = cc.CallFunc:create( function ( ... )
		if #self.PlayerHandPoker:getChildren() >= 10 then
			self:playerHandPokerSort()-- 有点重复了
		end
	end)
	local seq = cc.Sequence:create( { move_to,call } )
	poker:runAction( seq )
	
	if node == self.NodeStack then
		poker:showObtAniUseScaleTo( time )
	end
end


-- 玩家手牌排序
function GamePlay:playerHandPokerSort()
	-- 玩家手牌排序
	local player_childs,tierce_pokers,four_pokers,three_pokers = self:HandPokerSort()
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
function GamePlay:HandPokerSort()
	local sort_childs = {}
	local tierce_ary,four_ary,three_ary,new_source = self:getPlayerEffectiveData()

	local tierce_pokers = {}
	local four_pokers = {}
	local three_pokers = {}

	local get_result_source = function( dataAry,quanSource )
		for i,v in ipairs( dataAry ) do
			local meta = {}
			for a,b in ipairs( v ) do
				local poker = self:getPlayerPokerByNumberIndex( b )
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
		local poker = self:getPlayerPokerByNumberIndex( v )
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
function GamePlay:getPlayerEffectiveData()
	local player_childs = self.PlayerHandPoker:getChildren()
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
function GamePlay:firstLaterDraw()
	local pokers = self.NodeStack:getChildren()
	local top_poker = pokers[#pokers]
	local position_began = cc.p( top_poker:getPosition()) 
	local position_world = top_poker:getParent():convertToWorldSpace( position_began )
	local position_nodeBegan = self.NodeOutCard:convertToNodeSpace( position_world )
	top_poker:retain()
	top_poker:removeFromParent()
	self.NodeOutCard:addChild( top_poker )
	top_poker:release()
	table.remove( pokers,#pokers )
	top_poker:setPosition( position_nodeBegan )
	local position_end = cc.p( 0,0 )
	self:playerPokerMove( self.NodeStack,top_poker,position_end,0.1 )
	-- 注册点击
	top_poker:addPokerClick()
	-- 显示
	self.ImagePassOrShow:setVisible( true )
	self.ImageDeadCardBg:setVisible( true )
	pokers[#pokers]:addPokerClick()
	-- top_poker:removePokerClick()
end



















function GamePlay:getPlayerPokerByNumberIndex( numIndex )
	assert( numIndex," !! numIndex is nil !! " )
	local player_childs = self.PlayerHandPoker:getChildren()
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
	assert( pos," !! num is nil !! ")
	assert( pos >= 0 and pos <= 11," !! pos is error pos = "..pos.." !! " )
	local index = 1000

	local img = ccui.ImageView:create( "image/play/bei.png",1 )
	local size = img:getContentSize()
	-- 游戏中摸牌手上11张时
	if pos == 11 then
		local x_pos = ( index - size.width )/10 * ( pos - 1 )
		return x_pos
	end
	-- 游戏开始，初始发牌
	if pos == 10 then
		local x_pos = ( index - size.width )/9 * ( pos - 1 )
		return x_pos
	else
		local x_pos = ( index - size.width )/9 * (pos - 1 )
		return x_pos
	end
end

-- 帧动画
function GamePlay:frameAnimation()
	local index = 1
	local time = -1
	local likui = 1
	self:schedule( function()
		-- if likui == 1 then
		-- 	self.SpriteLikui:setSpriteFrame( "image/frame/likui1.png",1 )
		-- elseif likui == 3 then
		-- 	self.SpriteLikui:setSpriteFrame( "image/frame/likui2.png",1 )
		-- elseif likui == 4 then
		-- 	self.SpriteLikui:setSpriteFrame( "image/frame/likui3.png",1 )
		-- end

		-- 当AI摸牌，停止计时器，停止帧动画------------放这里好像还是有点问题，看是否放摸牌的时候
		if #self.AIHandPokerIn:getChildren() == 11 then
			-- 隐藏帧动画2的手
			self.ImageAIHand:setVisible( false )

			self:unSchedule()
			return
		end
		-- 播放人物动画
		if time == -1 then
			if #self.AIHandPokerIn:getChildren() == 10 then
				-- 隐藏帧动画2的图
				-- self.SpriteFist:setVisible( false )
				self.ImageAIHand:setVisible( false )
				-- 显示帧动画1的手
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
			-- self.SpriteFist:setVisible( true )
			self.ImageAIHand:setVisible( true )
			-- 隐藏帧动画1的手
			self.ImageAIHand1:setVisible( true )
			self._csbAct:play( "animation1",false )
			time = -3
		end

		if time ~= -1 then
			time = time + 1
		end
		-- if likui > 6 then
		-- 	likui = 1
		-- end
	end,1)
end




function GamePlay:back()
	addUIToScene( UIDefine.LIKUI_KEY.Start_UI )
	removeUIFromScene( UIDefine.LIKUI_KEY.Play_UI )
end


return GamePlay