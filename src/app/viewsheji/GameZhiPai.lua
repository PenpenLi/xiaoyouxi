


local NodeCard = import(".NodeZhiPaiCard")
local GameZhiPai = class("GameZhiPai",BaseLayer)


function GameZhiPai:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameZhiPai.super.ctor( self,param.name )

    self:addCsb( "csbheji/csbzhipai/Paly.csb" )

    -- 出牌
    for i = 1,16 do
    	self:addNodeClick( self["PanelCard"..i],{ 
	        endCallBack = function() self:clickCardPanel(i) end,
            scaleAction = false
	    })
    end

    -- 刷新
    self:addNodeClick( self["ButtonRefresh"],{ 
        endCallBack = function() self:clickRefreshCard() end
    })

    -- 暂停
    self:addNodeClick( self.ButtonPause,{
        endCallBack = function() self:pauseGame() end
    })
    self.ButtonPause:setVisible( false )

    self:addNodeClick( self.ButtonHelp,{
        endCallBack = function() self:help() end
    })
    self:addNodeClick( self.ButtonBack,{
        endCallBack = function() self:back() end
    })
    self:addNodeClick( self["ButtonMusic"],{ 
        endCallBack = function() self:setMusic() end
    })
    -- self._musicStart = 1

    -- 行的node
    self._rowPanels = {
    	[1] = { self.PanelCard1,self.PanelCard2,self.PanelCard3,self.PanelCard4 },
    	[2] = { self.PanelCard5,self.PanelCard6,self.PanelCard7,self.PanelCard8 },
    	[3] = { self.PanelCard9,self.PanelCard10,self.PanelCard11,self.PanelCard12 },
    	[4] = { self.PanelCard13,self.PanelCard14,self.PanelCard15,self.PanelCard16 }
    }
    -- 列的node
    self._colPanels = {
    	[1] = { self.PanelCard1,self.PanelCard5,self.PanelCard9,self.PanelCard13 },
    	[2] = { self.PanelCard2,self.PanelCard6,self.PanelCard10,self.PanelCard14 },
    	[3] = { self.PanelCard3,self.PanelCard7,self.PanelCard11,self.PanelCard15 },
    	[4] = { self.PanelCard4,self.PanelCard8,self.PanelCard12,self.PanelCard16 }
    }

    -- 要出的牌的node
    self._outPokerNodeList = {}
    self._outPokerDataList = getRandomArray( 1,52 )

    -- 当前关卡
    self._curLevel = param.data.level
    -- 当前目标
    self._curDest = 0
    -- 总目标
    self._totalDest = 4 + self._curLevel
    if self._totalDest > 18 then
        self._totalDest = 18
    end
    -- 当前获得积分
    self._totalScore = 0

    -- 当前游戏总时间
    self._totalTime = 180
    self._time = 0
end


function GameZhiPai:onEnter()
	GameZhiPai.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
	-- 添加出牌
	self:addOutPoker()
	-- 添加放牌
	self:addPutPoker()
    -- 设置剩余牌的数量
    self:loadLeftCard()
    -- 设置关卡
    self:loadCurLevel()
    -- 设置当前目标
    self:loadDest()
    -- 设置当前的总积分
    self:loadTotalScore()
    -- 计算当前的行列的分数
    self:setRowColScore()
    -- 金币
    self:loadCoinUi()
    -- 倒计时
    local str = formatTimeStr( self._totalTime,":" )
    self.TextTime:setString(str)
    self:schedule( function()
        self._time = self._time + 1
        local left_time = self._totalTime - self._time
        local str = formatTimeStr( left_time,":" )
        self.TextTime:setString(str)
        if left_time <= 0 then
            self:gameOver()
        end
    end,1 )
    if G_GetModel("Model_Sound"):isMusicOpen() then
        audio.playMusic("csbheji/csbzhipai/zpmp3/mainScene.mp3",true)
        self.ButtonMusic:loadTexture( "imagezhipai/game/music.png",1 )
    else
        self.ButtonMusic:loadTexture( "imagezhipai/game/music2.png",1 )
        -- graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )
    end
end


function GameZhiPai:addOutPoker()
    local start_posx = -30
    local start_posy = 35
	for i = 1,52 do
        local path = "imagezhipai/poker/bei.png"
        if i == 52 then
            path = zhipai_config.poker_config[self._outPokerDataList[i]]
        end

		local out_poker = ccui.ImageView:create( path,1 )
		self.NodePokerAll:addChild(out_poker)
		out_poker:setPosition( start_posx + i * 1,start_posy )
		self._outPokerNodeList[i] = out_poker
	end
end

function GameZhiPai:loadLeftCard()
    self.TextLeftCard:setString( #self._outPokerNodeList )
end

function GameZhiPai:loadCurLevel()
    self.TextGuanKa:setString( self._curLevel )
end

function GameZhiPai:loadDest()
    self.TextDest:setString( self._curDest.."/"..self._totalDest )
end

function GameZhiPai:loadTotalScore()
    self.TextTotalScore:setString( self._totalScore )
end

function GameZhiPai:setRowColScore()
    for i = 1,4 do
        local row_score = self:calPoint( self._rowPanels[i] )
        self["TextScoreRow"..i]:setString( row_score )
        local col_score = self:calPoint( self._colPanels[i] )
        self["TextScoreCol"..i]:setString( col_score )
    end
end

function GameZhiPai:loadCoinUi()
    local coin = G_GetModel("Model_Heji"):getCoin()
    self.TextCoin:setString( coin )
end


function GameZhiPai:addPutPoker()
	for i = 1,16 do
        local size = self["PanelCard"..i]:getContentSize()
		local card = NodeCard.new( self,size )
		self["PanelCard"..i]:addChild( card )
		card:loadDataUI( 0 )
        card:setTag(1156)
	end
end


function GameZhiPai:clickCardPanel( index )
    assert( index," !! index is nil !! " )
    -- 已经有牌
    local card_panel = self["PanelCard"..index]
    local child = card_panel:getChildByTag( 1156 )
    if child:getCardNum()[1] > 0 then
        return
    end
    if self._moveMark then
        return
    end
    if #self._outPokerNodeList == 0 then
        return
    end

    -- 刷新下一张
    if #self._outPokerNodeList > 1 then
        local next_index = #self._outPokerDataList - 1
        local path = zhipai_config.poker_config[self._outPokerDataList[next_index]]
        self._outPokerNodeList[ #self._outPokerNodeList - 1 ]:loadTexture( path,1 )
    end

    self._moveMark = true
    local out_card = self._outPokerNodeList[#self._outPokerNodeList]
    local end_pos = cc.p(card_panel:getPosition())
    local panel_size = card_panel:getContentSize()
    end_pos.x = end_pos.x + panel_size.width / 2
    end_pos.y = end_pos.y + panel_size.height / 2
    local world_pos = card_panel:getParent():convertToWorldSpace( end_pos )
    local node_pos = self.NodePokerAll:convertToNodeSpace( world_pos )
    local move_to = cc.MoveTo:create( 0.5,node_pos )
    local call_back = cc.CallFunc:create( function()
        -- 重置放牌区的node
        child:loadDataUI( self._outPokerDataList[#self._outPokerDataList] )
        -- 移除数据
        table.remove( self._outPokerDataList,#self._outPokerDataList )
        table.remove( self._outPokerNodeList,#self._outPokerNodeList )
        -- 设置剩余牌数
        self:loadLeftCard()
        -- 计算结果
        self:calResult( index,child )
        self._moveMark = nil
    end )
    local remove = cc.RemoveSelf:create()
    local seq = cc.Sequence:create({ move_to,call_back,remove })
    out_card:runAction( seq )
end

function GameZhiPai:calResult( index,card )
    assert( index," !! index is nil !! " )
    assert( card," !! card is nil !! " )
    -- 计算所在的行列
    local row = 0
    if index <= 4 then
        row = 1
    else
        row = math.ceil( index / 4 )
    end
    local col = 0
    if index % 4 ~= 0 then
        col = index % 4
    else
        col = 4
    end
    -- 计算该行的总分数
    local row_total = self:calPoint( self._rowPanels[row] )
    -- 计算该列的总分数
    local col_total = self:calPoint( self._colPanels[col] )

    local row_type = 0
    if row_total > 21 then
        row_type = 1
        -- 目标减1
        self._curDest = self._curDest - 1
        -- 该行其余三个数执行消失动画
        for i,v in ipairs( self._rowPanels[row] ) do
            local child_card = v:getChildByTag( 1156 )
            local child_num = child_card:getCardNum()
            if child_card ~= card and child_num[1] > 0 then
                self:excuteFadeOutAction( v )
                child_card:loadDataUI( 0 )
            end
        end
    elseif row_total == 21 then
        row_type = 2
        -- 目标加1
        self._curDest = self._curDest + 1
        -- 该行其余三个数执行飞行动画
        for i,v in ipairs( self._rowPanels[row] ) do
            local child_card = v:getChildByTag( 1156 )
            local child_num = child_card:getCardNum()
            if child_card ~= card and child_num[1] > 0 then
                self:excuteMoveAction( v )
                child_card:loadDataUI( 0 )
            end
        end
    else
        
    end

    local col_type = 0
    if col_total > 21 then
        col_type = 1
        -- 目标减1
        self._curDest = self._curDest - 1
        -- 该列其余三个数执行消失动画
        for i,v in ipairs( self._colPanels[col] ) do
            local child_card = v:getChildByTag( 1156 )
            local child_num = child_card:getCardNum()
            if child_card ~= card and child_num[1] > 0 then
                self:excuteFadeOutAction( v )
                child_card:loadDataUI( 0 )
            end
        end
    elseif col_total == 21 then
        col_type = 2
        -- 目标加1
        self._curDest = self._curDest + 1
        -- 该列其余三个数执行飞行动画
        for i,v in ipairs( self._colPanels[col] ) do
            local child_card = v:getChildByTag( 1156 )
            local child_num = child_card:getCardNum()
            if child_card ~= card and child_num[1] > 0 then
                self:excuteMoveAction( v )
                child_card:loadDataUI( 0 )
            end
        end
    else
        
    end

    -- 计算总积分
    if row_type == 2 then
        self._totalScore = self._totalScore + 450
    end

    if col_type == 2 then
        self._totalScore = self._totalScore + 450
    end

    -- 当前card的动画
    if row_type == 2 or col_type == 2 then
        performWithDelay( self.TextTotalScore,function()
            self:loadTotalScore()
            self:loadDest()
        end,0.5 )
        -- 当前的card 执行飞行动画
        self:excuteMoveAction( card:getParent() )
        card:loadDataUI( 0 )
    else
        if row_type == 1 or col_type == 1 then
            performWithDelay( self.TextTotalScore,function()
                self:loadDest()
            end,0.5 )
            -- 当前的card 执行消失动画
            self:excuteFadeOutAction( card:getParent() )
            card:loadDataUI( 0 )
        end
    end

    self:setRowColScore()
    -- 计算是否结束游戏
    performWithDelay( self,function()
        -- 1:通关
        if self._curDest >= self._totalDest then
            self:gamePass()
            return
        end
        -- 2:没有剩余的牌
        if #self._outPokerNodeList == 0 then
            self:gameOver()
            return
        end
    end,1 )
end

function GameZhiPai:calPoint( panels )
    local result = {}
    local has_a = false
    for i,v in ipairs( panels ) do
        local meta = v:getChildByTag( 1156 ):getCardNum()
        if #meta == 2 then
            if #result > 0 then
                local one_ary = clone(result)
                for c = 1,#result do
                    result[c] = result[c] + meta[1]
                end
                for c = 1,#one_ary do
                    table.insert( result,one_ary[c] + meta[2] )
                end
            else
                result[1] = meta[1]
                result[2] = meta[2]
            end
            has_a = true
        else
            if #result > 0 then
                for c = 1,#result do
                    result[c] = result[c] + meta[1]
                end
            else
                result[1] = meta[1]
            end
        end
    end
    -- 查找结果有没有等于21点的
    for i,v in ipairs( result ) do
        if v == 21 then
            return v
        end
    end

    if has_a then
        local temp_result = clone( result )
        table.sort( temp_result, function ( a,b )
            return a > b
        end )
        for i,v in ipairs( temp_result ) do
            if v > 0 and v < 21 then
                return v
            end
        end
        return result[1]
    else
        return result[1]
    end
end

-- 游戏结束
function GameZhiPai:gameOver()
    self:unSchedule()
    -- 存盘记录数据
    if self._totalScore > 0 then
        
    end
    addUIToScene( UIDefine.HEJI_KEY.ZhiPai_Over_UI,{ score = self._totalScore } )
end

-- 游戏过关
function GameZhiPai:gamePass()
    self:unSchedule()
    -- 存盘记录数据
    if self._totalScore > 0 then
        
    end
    addUIToScene( UIDefine.HEJI_KEY.ZhiPai_Pass_UI,{ level = self._curLevel + 1 } )
end

function GameZhiPai:excuteFadeOutAction( putPanel )
    assert( putPanel," !! putPanel is nil !! " )
    local child_card = putPanel:getChildByTag( 1156 )
    local num_index = child_card:getNumIndex()
    
    -- 创建一个图片
    local path = zhipai_config.poker_config[num_index]
    local image = ccui.ImageView:create(path,1)
    putPanel:addChild( image )
    image:setPosition( child_card._image:getPosition() )

    -- 移除创建的图片
    local fade_out = cc.FadeOut:create( 0.5 )
    local remove = cc.RemoveSelf:create()
    local seq = cc.Sequence:create({ fade_out,remove })
    image:runAction( seq )
end

function GameZhiPai:excuteMoveAction( putPanel )
    assert( putPanel," !! putPanel is nil !! " )
    local child_card = putPanel:getChildByTag( 1156 )
    local num_index = child_card:getNumIndex()
    -- 创建一个图片
    local path = zhipai_config.poker_config[num_index]
    local image = ccui.ImageView:create(path,1)
    putPanel:addChild( image )
    image:setPosition( child_card._image:getPosition() )

    -- 移除创建的图片
    local end_pos = self.TextTotalScore:getParent():convertToWorldSpace( cc.p( self.TextTotalScore:getPosition() ) )
    local node_pos = putPanel:convertToNodeSpace( end_pos )
    local move_to = cc.MoveTo:create( 0.5,node_pos )
    local scale_to = cc.ScaleTo:create( 0.5,0.2 )
    local spawn = cc.Spawn:create( { move_to,scale_to } )
    local remove = cc.RemoveSelf:create()
    local seq = cc.Sequence:create({ spawn,remove })
    image:runAction( seq )
end

-- 刷新
function GameZhiPai:clickRefreshCard()
    local has_coin = G_GetModel("Model_Heji"):getCoin()
    local cost_coin = 10
    if has_coin < cost_coin then
        return
    end

    -- 设置金币
    G_GetModel("Model_Heji"):setCoin( -10 )
    local has_coin = G_GetModel("Model_Heji"):getCoin()
    self.TextCoin:setString( has_coin )

	local card = self._outPokerDataList[#self._outPokerDataList]
    table.remove( self._outPokerDataList,#self._outPokerDataList )
    table.insert( self._outPokerDataList,1,card )
    local path = zhipai_config.poker_config[self._outPokerDataList[#self._outPokerDataList]]
    self._outPokerNodeList[#self._outPokerNodeList]:loadTexture( path,1 )
end

-- 暂停
function GameZhiPai:pauseGame()
    self:stopSchedule()
    addUIToScene( UIDefine.HEJI_KEY.ZhiPai_Pause_UI,{ layer = self } )
end

function GameZhiPai:help()
    addUIToScene( UIDefine.HEJI_KEY.ZhiPai_Help_UI )
end
function GameZhiPai:back()
    audio.stopMusic(false)
    removeUIFromScene( UIDefine.HEJI_KEY.GameZhiPai_UI )
    addUIToScene( UIDefine.HEJI_KEY.Start_UI )
end
function GameZhiPai:setMusic()
    if G_GetModel("Model_Sound"):isMusicOpen() then
        audio.stopMusic(false)
        G_GetModel("Model_Sound"):setMusicState( G_GetModel("Model_Sound").State.Closed )
        self.ButtonMusic:loadTexture( "imagezhipai/game/music2.png",1 )
        -- graySprite( self.ButtonMusic:getVirtualRenderer():getSprite() )
    else
        audio.playMusic("csbheji/csbzhipai/zpmp3/mainScene.mp3",true)
        G_GetModel("Model_Sound"):setMusicState( G_GetModel("Model_Sound").State.Open )
        self.ButtonMusic:loadTexture( "imagezhipai/game/music.png",1 )
    end
end
return GameZhiPai