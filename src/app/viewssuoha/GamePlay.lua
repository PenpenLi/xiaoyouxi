
local NodePoker = import( ".NodePoker" ) 
local GamePlay = class( "GamePlay",BaseLayer )


function GamePlay:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbsuoha/Play.csb" )

    self._pokers_stackUpData,self._pokers_stackDownData = self:toDeal()--上下牌堆
    --两堆牌
    self._pokersStackUpNode = {}--上牌堆图表
    self._pokersStackDownNode = {}--下牌堆图表

    self._panelsLogic = {
    	[1]		= { 1,2,3,4,5 		},
    	[2]		= { 6,7,8,9,10 		},
    	[3] 	= { 11,12,13,14,15  },
    	[4] 	= { 16,17,18,19,20  },
    	[5] 	= { 21,22,23,24,25  },
    	[6] 	= { 5,9,13,17,21 	},
    	[7] 	= { 1,6,11,16,21 	},
    	[8] 	= { 2,7,12,17,22 	},
    	[9] 	= { 3,8,13,18,23 	},
    	[10] 	= { 4,9,14,19,24 	},
    	[11] 	= { 5,10,15,20,25 	},
    	[12] 	= { 1,7,13,19,25 	},
    }

    
    
    --存储25个panel在世界坐标的box
    self._panel_worldBox = {}
    self:panelBoxForWorld()
    -- dump( self._panel_worldBox,"----------self._panel_worldBox = " )

    self:addNodeClick( self.ButtonSet,{
    	endCallBack = function ()
    		self:clickMusic()
    	end
    })
    self:addNodeClick( self.ButtonBack,{
    	endCallBack = function ()
    		self:clickBack()
    	end
    })
    self:addNodeClick( self.ButtonRenovate,{
    	endCallBack = function ()
    		self:clickRenovate()
    	end
    })
    -- 购买
    self:addNodeClick( self.ImageCoinBg,{
    	endCallBack = function ()
    		addUIToScene( UIDefine.SUOHA_KEY.Shop_UI )
    	end
    })

    self:loadUi()
end

function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	-- 为上下牌堆的第一张牌创建点击
	self._pokersStackUpNode[#self._pokersStackUpNode]:addPokerClick( 1 )
	self._pokersStackDownNode[#self._pokersStackDownNode]:addPokerClick( 2 )

	-- 注册监听
	self:addMsgListener( InnerProtocol.INNER_EVENT_SUOHA_BUY_COIN,function( event )
		local coin = G_GetModel("Model_SuoHa"):getCoin()
		self.TextCoin:setString( coin )
	end )
end


--loadUI
function GamePlay:loadUi()
	self:createPaiDuiPoker()
	self:loadText()
end

--panel的25个世界坐标下的box
function GamePlay:panelBoxForWorld()
	for i=1,25 do
    	local panel_pos = cc.p( self["Panel"..i]:getPosition() )
    	-- dump( panel_pos,"-----------panel_pos" )
    	local panel_worldPos = self["Panel"..i]:getParent():convertToWorldSpace( panel_pos )
    	local panel_box = self["Panel"..i]:getBoundingBox()
    	panel_box.x = panel_worldPos.x
    	panel_box.y = panel_worldPos.y
    	table.insert( self._panel_worldBox,panel_box )
    end
end
--create牌堆
function GamePlay:createPaiDuiPoker(  )
	
	for i=1,#self._pokers_stackUpData do
		local poker = NodePoker.new( self,self._pokers_stackUpData[i] )
		self.NodeUp:addChild( poker )
		poker:setPositionY( -i * 3 )
		table.insert( self._pokersStackUpNode,poker )
	end
	
	for i=1,#self._pokers_stackDownData do
		local poker = NodePoker.new( self,self._pokers_stackDownData[i] )
		self.NodeDown:addChild( poker )
		poker:setPositionY( i * 3 )
		table.insert( self._pokersStackDownNode,poker )
	end
end

--load数据
function GamePlay:loadText()
	for i=1,12 do
		self["TextScore"..i]:setString( 0 )
	end
	self.TextScoreSum:setString( 0 )
	local coin = G_GetModel("Model_SuoHa"):getCoin()
	self.TextCoin:setString( coin )
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







function GamePlay:putPokerEnd( poker )
	assert( poker," !! poker is nil !! " )
	local poker_box = poker._img:getBoundingBox()
	local poker_newPos = cc.p(poker._img:getPosition() )
	local poker_newWorldPos = poker._img:getParent():convertToWorldSpace( poker_newPos )
	poker_box.x = poker_newWorldPos.x - poker_box.width / 2
	poker_box.y = poker_newWorldPos.y - poker_box.height / 2

	local intersection_ary = {}
	for i,v in ipairs( self._panel_worldBox ) do
		local rect = cc.rectIntersection( v, poker_box )
		if rect.width > 0 and rect.height > 0 then
			table.insert( intersection_ary,{ orgPanel = self["Panel"..i],inRect = rect } )
		end
	end
	-- 1:如果跟任何panel不相交 回到原位
	if #intersection_ary == 0 then
		-- 回到原位
		poker:backToOriginalPos()
		return
	end
	-- 2:找出最大的相交的panel
	if #intersection_ary > 0 then
		table.sort( intersection_ary,function ( a,b )
			if a.inRect.width * a.inRect.height ~= b.inRect.width * b.inRect.height then
				return a.inRect.width * a.inRect.height > b.inRect.width * b.inRect.height
			end
		end)
		local max_panel = intersection_ary[1].orgPanel
		-- 1:判断是否已经存放poker
		if max_panel:getChildByTag( 1888 ) then
			-- 回到原位
			poker:backToOriginalPos()
			return
		end

		poker:retain()
		poker:removeFromParent()
		max_panel:addChild( poker )
		poker:setTag( 1888 )
		poker._img:setPosition( cc.p(0,0) )
		poker:release()
		-- 2:移除点击监听
		poker:removePokerClick()
		-- 3:为新的poker添加监听
		if poker._state == 1 then
			table.remove( self._pokersStackUpNode,#self._pokersStackUpNode )
			self._pokersStackUpNode[#self._pokersStackUpNode]:addPokerClick( 1 )
		else
			table.remove( self._pokersStackDownNode,#self._pokersStackDownNode )
			self._pokersStackDownNode[#self._pokersStackDownNode]:addPokerClick( 2 )
		end

		local poker_panelPos = max_panel:convertToNodeSpace( poker_newWorldPos )
		poker:setPosition( poker_panelPos )

		local panel_size = max_panel:getContentSize()
		local move_to = cc.MoveTo:create( 0.2,cc.p( panel_size.width / 2,panel_size.height / 2 ))
		local call = cc.CallFunc:create(function ()
			local sum_score = self:putPokerDoneLogic()
			if self:fullPanel() then
				G_GetModel("Model_SuoHa"):getInstance():saveRecordList( sum_score )
				self:gameOver( sum_score )
			end
		end)
		local sequence = cc.Sequence:create( { move_to,call } )
		poker:runAction( sequence )
	end
end
--游戏结束，结算得分
function GamePlay:gameOver( score )
	-- local score = 0
	-- for i=1,12 do
	-- 	score = score + self["TextScore"..i]:getString()
	-- end
	addUIToScene( UIDefine.SUOHA_KEY.Over_UI,score )
end
--判断panel是否放满
function GamePlay:fullPanel()
	for i=1,25 do
		local panel_child = self["Panel"..i]:getChildByTag( 1888 )
		if not panel_child  then
			return false
		end
	end
	return true
	-- body
end

function GamePlay:putPokerDoneLogic()
	local sum_score = 0
	for i,v in ipairs( self._panelsLogic ) do
		local score = self:calScore( v )
		self["TextScore"..i]:setString( score )
		sum_score = sum_score + score
	end
	self.TextScoreSum:setString( sum_score )
	return sum_score
end

function GamePlay:calScore( panelAry )
	assert( panelAry," !! panelAry!! " )
	local score = 0
	
	local pokers = {}
	for i,v in ipairs( panelAry ) do
		local panel = self["Panel"..v]
		local poker = panel:getChildByTag( 1888 )
		if poker then
			table.insert( pokers,poker )
		end
	end
	if #pokers > 1 then
		table.sort( pokers,function ( a,b )
			return a:getCardNum() < b:getCardNum()
		end)
	end

	-- 1:先判断同花和同花顺
	if #pokers == 5 then
		if pokers[1]:getColor() == pokers[2]:getColor() and pokers[1]:getColor() == pokers[3]:getColor() 
			and pokers[1]:getColor() == pokers[4]:getColor() and pokers[1]:getColor() == pokers[5]:getColor() then
			if pokers[1]:getCardNum() + 1 == pokers[2]:getCardNum() and pokers[1]:getCardNum() + 2 == pokers[3]:getCardNum() 
				and pokers[1]:getCardNum() + 3 == pokers[4]:getCardNum() and pokers[1]:getCardNum() + 4 == pokers[5]:getCardNum() then
				return 1800
			elseif pokers[1]:getCardNum() == 1 and pokers[2]:getCardNum() == 10 and pokers[3]:getCardNum() == 11 
					and pokers[4]:getCardNum() == 12 and pokers[5]:getCardNum() == 13 then
				return 1800
			else
				return 1000
			end
		end
	end
	-- 2:判断顺子
	if #pokers == 5 then
		if (pokers[1]:getCardNum() + 1 == pokers[2]:getCardNum() and pokers[1]:getCardNum() + 2 == pokers[3]:getCardNum() 
			and pokers[1]:getCardNum() + 3 == pokers[4]:getCardNum() and pokers[1]:getCardNum() + 4 == pokers[5]:getCardNum())
			or (pokers[1]:getCardNum() == 1 and pokers[2]:getCardNum() == 10 and pokers[3]:getCardNum() == 11 
					and pokers[4]:getCardNum() == 12 and pokers[5]:getCardNum() == 13) then
			return 800
		end
	end

	local poker_same = {}
	for i,v in ipairs( pokers ) do
		local card_num = v:getCardNum()
		if poker_same[card_num] == nil then
			poker_same[card_num] = 1
		else
			poker_same[card_num] = poker_same[card_num] + 1
		end
	end
	-- 4:判断满堂红
	if #pokers == 5 and table.nums( poker_same ) == 2 then
		local temp_poker_same = {}
		for k,v in pairs( poker_same ) do
			table.insert( temp_poker_same,v )
		end
		if ( temp_poker_same[1] == 2 and temp_poker_same[2] == 3 ) or ( temp_poker_same[1] == 3 and temp_poker_same[2] == 2 ) then
			return 1200
		end
	end

	-- 5:判断4条
	for k,v in pairs( poker_same ) do
		if v == 4 then
			return 1500
		end
	end

	-- 6:判断3条----依赖前面判断
	for k,v in pairs( poker_same ) do
		if v == 3 then
			return 600
		end
	end
	--7:判断两对----依赖前面判断
	local two_pairs = {}
	for k,v in pairs( poker_same ) do
		if v == 2 then
			table.insert( two_pairs,v )
		end
	end
	if table.nums( two_pairs ) == 2 then 
		return 400
	end
	--判斷一对
	if table.nums( two_pairs ) == 1 then 
		return 200
	end



	return score
end



function GamePlay:clickMusic()
	addUIToScene( UIDefine.SUOHA_KEY.Voice_UI )
end
function GamePlay:clickBack()
	removeUIFromScene( UIDefine.SUOHA_KEY.Play_UI )
	addUIToScene( UIDefine.SUOHA_KEY.Start_UI )
end
function GamePlay:clickRenovate()
	
	local has_coin = G_GetModel("Model_SuoHa"):getCoin()
	if has_coin < 10 then
		-- 打开商店界面
		addUIToScene( UIDefine.SUOHA_KEY.Shop_UI )
		return
	end

	G_GetModel("Model_SuoHa"):setCoin( -10 )
	local coin = G_GetModel("Model_SuoHa"):getCoin()
	self.TextCoin:setString( coin )
	-- 刷新上面的
	self:refreshPoker( self._pokersStackUpNode )
	-- 刷新下面的
	self:refreshPoker( self._pokersStackDownNode )
end

function GamePlay:refreshPoker( source )
	assert( source," !! source is nil  !! " )
	if #source == 1 then
		return
	end
	local poker_data = {}
	for i,v in ipairs( source ) do
		local num_index = v:getNumIndex()
		table.insert( poker_data,num_index )
	end
	table.insert( poker_data,1,poker_data[#poker_data] )
	table.remove( poker_data,#poker_data )
	for i,v in ipairs( source ) do
		v:resetNumIndex( poker_data[i] )
	end
end

return GamePlay