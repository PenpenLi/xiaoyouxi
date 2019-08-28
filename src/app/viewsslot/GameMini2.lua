
local NodeMiniGame2 = import( "app.viewsslot.NodeMiniGame2" )
local GameMini2 = class( "GameMini2",BaseLayer )

function GameMini2:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameMini2.super.ctor( self,param.name )
 	self:addCsb("csbslot/hall/GameMini2.csb")
 	
    self._parent = param.data
    self._coin = 0
    self:loadUi()
end

function GameMini2:loadUi( ... )
	local is_open = G_GetModel("Model_Sound"):isMusicOpen()
	if is_open then
		audio.stopMusic(false)
		audio.playMusic("csbslot/hall/hmp3/card_recovery_bgm.mp3",true)
	end

	local rotate = cc.RotateTo:create( 4,360 )
	local repeatForever = cc.RepeatForever:create( rotate )
	self.ImageLight:runAction( repeatForever )
	local size = cc.Director:getInstance():getWinSize()
	local text_pos = cc.p( size.width / 2,size.height / 2 )
	local text = ccui.Text:create()
	self:addChild( text )
	text:setPosition( text_pos )
	text:setFontSize( 150 )
	text:setTextColor( cc.c4b( 255,0,0,255 ) )
	local index = 0
	self:schedule(function ()
		if index == 0 then
			text:setString( 'READY!' )
		end
		if index == 1 then
			text:setString( 'GO!!!' )
		end
		
		if index == 2 then
			text:setVisible( false )
			self:unSchedule()
			self:play()
			self:playCsbAction( "animation0",true )
		end
		index = index + 1
	end,1)
end

function GameMini2:onEnter(  )
	GameMini2.super.onEnter( self )
end

function GameMini2:play()
	local index = 20
	self:schedule(function ()
		local move_time = nil -- 掉落时长
		local num = nil -- 金币个数
		if index > 10 then
			num = random( 1,5 )
		end
		if index <= 10 and index >= 5 then
			num = random( 4,8 )
		end
		if index < 5 then
			num = random( 10,15 )
		end
		for i=1,num do
			local coin = NodeMiniGame2.new( self )
			self:addChild( coin )
			if index > 10 then
				move_time = random( 20,30 )
			end
			if index <= 10 and index >= 5 then
				move_time = random( 10,20 )
			end
			if index < 5 then
				move_time = random( 5,15 )
			end
			coin:freeFallingBody( move_time / 10 )
		end
		index = index - 1

		if index <= 0 then
			self:unSchedule()
			performWithDelay(self,function()
				self._parent:loadMiniGame()
				local is_open = G_GetModel("Model_Sound"):isMusicOpen()
				if is_open then
					audio.stopMusic(false)
					G_GetModel("Model_Sound"):playBgMusic()
				end
				addUIToScene( UIDefine.SLOT_KEY.OverMini2_UI,self._coin )
				self:removeFromParent()
			end,2)
		end
		
	end,1.5)
end

function GameMini2:collectCoin( coin )
	self._coin = self._coin + coin
end

return GameMini2