
local NodePlayer = import(".NodePlayer")
local NodePoker = import(".NodePoker")
local GamePlay = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )

    self:addCsb( "csbeight/GamePlay.csb" )

    self._handPokerWidth = 326

    self.ImageJianTou:setVisible( false )
    self.TextTips:setVisible( false )
    
    self:addNodeClick( self.playerTouchPanel,{
		endCallBack = function ()
			self:playerMoPoker()
		end
	})
	self:addNodeClick( self.ButtonPause,{
		endCallBack = function ()
			self:pauseGame()
		end
	})
	self:addNodeClick( self.ButtonMusic,{
		endCallBack = function ()
			self:setMusic()
		end
	})
	self:addNodeClick( self.ButtonEffect,{
		endCallBack = function ()
			self:setEffect()
		end
	})

end



function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	-- 创建所有的牌
	self._allPokerNode = {}
	self:createBeiCard()
	--创建所有玩家
	self:createPlayer()
	-- 音乐图标
	self:loadMusicEffect()
	--出牌顺序
	self._pointer = random( 1,3 )

	-- 发牌动画
	performWithDelay( self,function()
		self:sendCardByBegan()
	end,0.2 )

	-- 注册监听
	self:addMsgListener( InnerProtocol.INNER_EVENT_EIGHT_MUSIC,function( event )
		self:loadMusicEffect()
	end )
end

function GamePlay:loadMusicEffect()
	local state = G_GetModel("Model_Sound"):isMusicOpen()
	if state then
		self.ButtonMusic:loadTexture( "image/play/music.png",1 )
	else
		self.ButtonMusic:loadTexture( "image/play/music2.png",1 )
	end
	state = G_GetModel("Model_Sound"):isVoiceOpen()
	if state then
		self.ButtonEffect:loadTexture( "image/play/sound.png",1 )
	else
		self.ButtonEffect:loadTexture( "image/play/sound2.png",1 )
	end
end

function GamePlay:createPlayer()
	for i = 1,4 do
		local play = NodePlayer.new( i )
		self["NodePlayer"..i]:addChild( play )
	end
end

function GamePlay:createBeiCard()
	local allPokerData = getRandomArray( 1,52 )

	for i = 1,#allPokerData do
		local poker = NodePoker.new( self,allPokerData[i] )
		self.PaiDuiNode:addChild( poker )
		self._allPokerNode[i] = poker
		poker:setLocalZOrder( i )
		poker:setPosition( -i * 0.5,i * 0.5 )
	end
end
--初始发牌，发完牌随机AI出牌
function GamePlay:sendCardByBegan()
	local actions = {}
	for i = 1,8 do
		local delay_time = cc.DelayTime:create( 0.3 )
		table.insert( actions,delay_time )
		local call_send = cc.CallFunc:create( function()
			-- 播放音效
			local effect_isOpen = G_GetModel("Model_Sound"):isVoiceOpen()
			if effect_isOpen then
				audio.playSound("emp3/send.mp3", false)
			end

			for j = 1,4 do
				self:sendCardToPlayer( j,nil,false )
			end
		end )
		table.insert( actions,call_send )

		if i == 8 then
			local call_pointer = cc.CallFunc:create(function ()
				self:createPointer( self._pointer )
			end)
			table.insert( actions,call_pointer )
			local delay_time2 = cc.DelayTime:create( 2 )
			table.insert( actions,delay_time2 )
			local call_out = cc.CallFunc:create(function ()
				self:aiOutCard( self._pointer )
			end)
			table.insert( actions,call_out )
		end
	end
	self:runAction( cc.Sequence:create( actions ) )
end


function GamePlay:sendCardToPlayer( seatPos,callBack,isPlayerVoice )
	assert( seatPos," !! seatPos is nil !! " )
	-- assert( #self._allPokerNode > 0," !! pai dui card length must be > 0 !! " )

	-- 如果牌堆没有牌的逻辑
	-- 判断是否是流局
	if self:isGameDisband() then
		-- 弹出流局界面
		addUIToScene( UIDefine.EIGHT_KEY.Disband_UI )
		return
	end

	if #self._allPokerNode == 0 then
		-- 让下一个人出牌
		self:changePointer()
		self:aiOutCard( self._pointer )
		return
	end

	-- 播放音效
	local effect_isOpen = G_GetModel("Model_Sound"):isVoiceOpen()
	if effect_isOpen and isPlayerVoice then
		audio.playSound("emp3/send.mp3", false)
	end

	-- 有牌的逻辑
	local top_poker = self._allPokerNode[#self._allPokerNode]
	self._allPokerNode[#self._allPokerNode] = nil
	local world_pos = top_poker:getParent():convertToWorldSpace( cc.p( top_poker:getPosition() ) )
	top_poker:retain()
	top_poker:removeFromParent()
	self["AINodePoker"..seatPos]:addChild( top_poker )
	top_poker:release()
	local node_pos = self["AINodePoker"..seatPos]:convertToNodeSpace( world_pos )
	top_poker:setPosition( node_pos )
	-- 明牌
	if seatPos == 4 then
		top_poker:showPoker()
	end

	if seatPos == 1 then
		top_poker:setRotation( 90 )
	elseif seatPos == 2 then
		top_poker:setRotation( 180 )
	elseif seatPos == 3 then
		top_poker:setRotation( 270 )
	else
		top_poker:setRotation( 0 )
	end
	
	local move_to = cc.MoveTo:create( 0.3,cc.p(0,0) )
	local call_func = cc.CallFunc:create( function()
		self:sortCardPosByColor( seatPos )
		if callBack then
			callBack()
		end
	end )
	top_poker:runAction( cc.Sequence:create( { move_to,call_func } ) )
end

function GamePlay:sortCardPosByColor( seatPos )
	assert( seatPos," !! seatPos is nil !! " )
	local childs = self["AINodePoker"..seatPos]:getChildren()
	if #childs <= 1 then
		return
	end
	table.sort( childs,function( a,b )
		if a:getColor() ~= b:getColor() then
			return a:getColor() < b:getColor()
		end
		return a:getCardNum() < b:getCardNum()
	end )
	local size = childs[1]:getImageSize()
	if seatPos == 1 or seatPos == 3 then
		local meta_width = ( self._handPokerWidth - size.width ) / 7
		local start_pos = meta_width * #childs / 2
		for i,v in ipairs( childs ) do
			if seatPos == 1 then
				v:setLocalZOrder( i )
			else
				v:setLocalZOrder( 9 - i )
			end
			v:setPositionY( start_pos - (i-1) * meta_width )
		end
	end
	if seatPos == 2 or seatPos == 4 then
		local meta_width = ( self._handPokerWidth - size.width ) / 7
		local start_pos = meta_width * #childs / 2
		for i,v in ipairs( childs ) do
			if seatPos == 2 then
				v:setLocalZOrder( i )
			else
				v:setLocalZOrder( 9 - i )
			end
			v:setPositionX( start_pos - ( i - 1 ) * meta_width )
		end
	end
end


function GamePlay:aiOutCard( seatPos )
	assert( seatPos," !! seatPos is nill !! " )

	--等待玩家出牌
	if seatPos == 4 then
		-- 给玩家手牌添加点击
		self:turnPlayerOutCard()
		return
	end

	-- 播放音效
	local effect_isOpen = G_GetModel("Model_Sound"):isVoiceOpen()
	if effect_isOpen then
		audio.playSound("emp3/send.mp3", false)
	end

	local childs = self["AINodePoker"..seatPos]:getChildren()
	local out_childs = self.OutNode:getChildren()
	--1，无牌，初始第一张发牌
	if #out_childs == 0 then
		self:outPokerFromPlayer( childs[random( 1,8 )],seatPos,function ()
			self:outPokerDoneLogic( seatPos )
		end )
		return
	end
	--2，找花色相同的逻辑
	local out_poker = nil
	local new_color = out_childs[#out_childs]:getColor()
	for i,v in ipairs(childs) do
		if v:getColor() == new_color then
			out_poker = v
			break
		end
	end

	-- 3,找数字相同的逻辑
	if out_poker == nil then
		local new_number = out_childs[#out_childs]:getCardNum()
		for i,v in ipairs( childs ) do
			if v:getCardNum() == new_number then
				out_poker = v
				break
			end
		end
	end

	-- 4,找8点的逻辑
	if out_poker == nil then
		for i,v in ipairs( childs ) do
			if v:getCardNum() == 8 then
				out_poker = v
				break
			end
		end
	end

	if out_poker then
		self:outPokerFromPlayer( out_poker,seatPos,function ()
			self:outPokerDoneLogic( seatPos )
		end  )
		return
	end

	--,先摸牌 没有同花色牌的逻辑
	self:sendCardToPlayer( seatPos,function()
		self:changePointer()
		performWithDelay( self,function()
			-- 告诉下一个人出牌、
			self:aiOutCard( self._pointer )
		end,1 )
	end,true )
end

function GamePlay:playerOutCard( poker )
	-- 播放音效
	local effect_isOpen = G_GetModel("Model_Sound"):isVoiceOpen()
	if effect_isOpen then
		audio.playSound("emp3/send.mp3", false)
	end
	-- audio.playSound("emp3/send.mp3", false)
	assert( poker," !! poker is nil !! " )
	-- 先判断是否是8点
	if poker:getCardNum() == 8 then
		addUIToScene( UIDefine.EIGHT_KEY.Choice_UI,{ poker = poker,parent = self,seatPos = 4 } )
		return
	end

	local childs = self.OutNode:getChildren()
	local new_color = childs[#childs]:getColor()
	if poker:getColor() == new_color then
		self:removeTouchForPlayer()
		-- 颜色相同允许出牌
		self:outPokerFromPlayer( poker,4,function ()
			self:outPokerDoneLogic( 4 )
		end)
		return
	end
	
	local new_number = childs[#childs]:getCardNum()
	if poker:getCardNum() == new_number then
		-- 数字是否相同
		self:removeTouchForPlayer()
		self:outPokerFromPlayer( poker,4,function ()
			self:outPokerDoneLogic( 4 )
		end)
		return
	end
	
end


function GamePlay:playerMoPoker()
	-- 能出牌的话 点击无响应
	if self:isPalyerCanOut() then
		return
	end

	if self._pointer ~= 4 then
		return
	end

	self.TextTips:setVisible( false )
	self:sendCardToPlayer( 4,function ()
		self:changePointer()
		performWithDelay( self,function()
			self:aiOutCard( self._pointer )
		end,1 )
	end,true )
end

-- 轮到玩家出牌的逻辑
function GamePlay:turnPlayerOutCard()
	-- 判断玩家手牌有没有能出的牌
	if self:isPalyerCanOut() then
		-- 添加点击 让玩家出牌
		self:addTouchForPlayer()
	else
		-- 判断是否是流局
		if self:isGameDisband() then
			-- 弹出流局界面
			addUIToScene( UIDefine.EIGHT_KEY.Disband_UI )
			return
		end
		-- 判断是否是流局
		if #self._allPokerNode == 0 then
			-- 让下一个人出牌
			self:changePointer()
			self:aiOutCard( self._pointer )
			return
		end
		-- 没牌出，摸牌
		self.TextTips:setVisible( true )
	end
end

function GamePlay:isPalyerCanOut()
	local childs = self.AINodePoker4:getChildren()
	local out_childs = self.OutNode:getChildren()
	local out_color = out_childs[#out_childs]:getColor()
	local out_num = out_childs[#out_childs]:getCardNum()
	for i = 1,#childs do
		if childs[i]:getColor() == out_color or out_num == childs[i]:getCardNum() or childs[i]:getCardNum() == 8 then
			return true
		end
	end
	return false
end

function GamePlay:addTouchForPlayer()
	local childs = self.AINodePoker4:getChildren()
	for i = 1,#childs do
		childs[i]:addPokerClick()
	end
end

function GamePlay:removeTouchForPlayer()
	local childs = self.AINodePoker4:getChildren()
	for i = 1,#childs do
		childs[i]:removePokerClick()
	end
end

function GamePlay:changePointer()
	self._pointer = self._pointer + 1
	if self._pointer > 4 then
		self._pointer = 1
	end
	self:createPointer( self._pointer )
end

function GamePlay:outPokerFromPlayer( poker,seatPos,callBack )
	assert( poker," !! poker is nill !! " )
	assert( seatPos," !! seatPos is nil !! " )
	local outNode_worldPos = self.OutNode:getParent():convertToWorldSpace( cc.p( self.OutNode:getPosition() ))
	local outTo_pos = self["AINodePoker"..seatPos]:convertToNodeSpace( outNode_worldPos )
	
	
	-- poker:setRotation( 0 )
	poker:setLocalZOrder( 100 )
	poker:showPoker()
	local rotate_to = cc.RotateTo:create( 0.5,0 )
	local move_to = cc.MoveTo:create( 0.5,outTo_pos )
	local spawn = cc.Spawn:create( rotate_to,move_to )
	local call = cc.CallFunc:create(function ()
		poker:retain()
		poker:removeFromParent()
		self.OutNode:addChild( poker )
		poker:setPosition( 0,0 )
		poker:release()
		self:sortCardPosByColor( seatPos )
		if callBack then
			callBack()
		end
	end)
	poker:runAction( cc.Sequence:create({ spawn,call }))
end

function GamePlay:outPokerDoneLogic( seatPos )
	if #self["AINodePoker"..seatPos]:getChildren() == 0 then
		self:gameOver( seatPos )
		return
	end
	self:changePointer()
	performWithDelay( self,function()
		self:aiOutCard( self._pointer )
	end,1 )
end

function GamePlay:gameOver( seatPos )
	assert( seatPos," !! seatPos is nil !! " )
	local playerAllNumIndex = {}
	for i=1,4 do
		playerAllNumIndex[i] = {}
		local playerPoker = self["AINodePoker"..i]:getChildren()
		for j=1,#playerPoker do
			local playerNumIndex = playerPoker[j]:getNumIndex()
			table.insert( playerAllNumIndex[i],playerNumIndex )
		end
	end
	addUIToScene( UIDefine.EIGHT_KEY.Over_UI,{result = playerAllNumIndex} )
end

-- 判断该局是否是流局
function GamePlay:isGameDisband()
	if #self._allPokerNode ~= 0 then
		return false
	end
	-- 验证 4个玩家手上必须有牌
	for i = 1,4 do
		if #self["AINodePoker"..i]:getChildren() == 0 then
			return false
		end
	end

	local out_childs = self.OutNode:getChildren()
	local new_color = out_childs[#out_childs]:getColor()
	local new_number = out_childs[#out_childs]:getCardNum()
	for i = 1,4 do
		local childs = self["AINodePoker"..i]:getChildren()
		for k,v in ipairs( childs ) do
			if v:getColor() == new_color or v:getCardNum() == new_number or v:getCardNum() == 8 then
				return false
			end
		end
	end
	-- 提示流局
	return true
end

function GamePlay:createPointer( seatPos )
	self.ImageJianTou:setVisible( true )
	self.ImageJianTou:stopAllActions()
	if seatPos == 1 then
		self.ImageJianTou:setRotation(-180)
		self.ImageJianTou:setPosition( 260,360 )
		local move_by1 = cc.MoveBy:create( 0.5,cc.p( -20,0 ) )
		local move_by2 = cc.MoveBy:create( 0.5,cc.p( 20,0 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self.ImageJianTou:runAction( rep )
	elseif seatPos == 2 then
		self.ImageJianTou:setRotation(-90)
		self.ImageJianTou:setPosition( 640,460 )
		local move_by1 = cc.MoveBy:create( 0.5,cc.p( 0,20 ) )
		local move_by2 = cc.MoveBy:create( 0.5,cc.p( 0,-20 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self.ImageJianTou:runAction( rep )
	elseif seatPos == 3 then
		self.ImageJianTou:setRotation(0)
		self.ImageJianTou:setPosition( 910,360 )
		local move_by1 = cc.MoveBy:create( 0.5,cc.p( 20,0 ) )
		local move_by2 = cc.MoveBy:create( 0.5,cc.p( -20,0 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self.ImageJianTou:runAction( rep )
	elseif seatPos == 4 then
		self.ImageJianTou:setRotation(90)
		self.ImageJianTou:setPosition( 640,225 )
		local move_by1 = cc.MoveBy:create( 0.5,cc.p( 0,-20 ) )
		local move_by2 = cc.MoveBy:create( 0.5,cc.p( 0,20 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self.ImageJianTou:runAction( rep )
	end
end

function GamePlay:selectEightPokerDone( poker, seatPos)
	self:removeTouchForPlayer()
	self:outPokerFromPlayer( poker,seatPos,function ()
		self:outPokerDoneLogic( seatPos )
	end)
end

function GamePlay:pauseGame()
	self:pause()--暂停
	addUIToScene( UIDefine.EIGHT_KEY.Stop_UI,self )
end
function GamePlay:setMusic()
	local user_default = G_GetModel("Model_Sound"):getInstance()
	local is_open = user_default:isMusicOpen()
	if is_open then
		self.ButtonMusic:loadTexture( "image/play/music2.png",1 )
		-- graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )-----变灰
		user_default:setMusicState( G_GetModel("Model_Sound").State.Closed )
		user_default:stopPlayBgMusic()
	else
		self.ButtonMusic:loadTexture( "image/play/music.png",1 )
		user_default:setMusicState( G_GetModel("Model_Sound").State.Open )
		user_default:playBgMusic()
	end
end
function GamePlay:setEffect()
	local user_default = G_GetModel("Model_Sound"):getInstance()
	local is_open = user_default:isVoiceOpen()
	if is_open then
		self.ButtonEffect:loadTexture( "image/play/sound2.png",1 )
		user_default:setVoiceState( user_default.State.Closed )
	else
		self.ButtonEffect:loadTexture( "image/play/sound.png",1 )
		user_default:setVoiceState( user_default.State.Open )
	end
end
return GamePlay