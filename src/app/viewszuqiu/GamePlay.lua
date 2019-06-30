
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
	-- 先发player
	local actions = {}
	local action_time = 0.5
	for i = 1,6 do
		local delay = cc.DelayTime:create( 0.3 )
		local call_mo = cc.CallFunc:create( function()
			self:playerMoCard( 7 - i,action_time )
		end )
		table.insert( actions,delay )
		table.insert( actions,call_mo )
	end
	self:runAction( cc.Sequence:create( actions ) )
end

-- 玩家摸牌
function GamePlay:playerMoCard( numIndex,seatPos,actionTime )
	assert( numIndex," !! numIndex is nil !! " )
	assert( seatPos," !! seatPos is nil !! " )
	assert( actionTime," !! actionTime is nil !! " )
	local poker = self._playerPaiDuiCards[#self._playerPaiDuiCards]
	local num_index = poker:getNumIndex()
	self._playerPaiDuiCards[#self._playerPaiDuiCards] = nil
	poker:removeFromParent()
	local pos = cc.p( self.ImageBeiPlayer:getPosition() )
	local dest_pos = cc.p( self["PlayerPoker"..seatPos]:getPosition() )

	local new_poker = NodePoker.new( self,num_index )
	self._csbNode:addChild( new_poker )
	new_poker:showPoker()
	self._playerHandCards[#self._playerHandCards + 1] = new_poker

	new_poker:setPosition( pos )
	local move_to = cc.MoveTo:create( actionTime,dest_pos )
	local rotate_to = cc.RotateTo:create( actionTime,self._playerPokerAngle[seatPos] )
	local spawn = cc.Spawn:create( { move_to,rotate_to } )
	new_poker:runAction( spawn )
end









return GamePlay