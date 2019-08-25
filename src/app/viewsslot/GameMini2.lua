
local NodeMiniGame2 = import( "app.viewsslot.NodeMiniGame2" )
local GameMini2 = class( "GameMini2",BaseLayer )

function GameMini2:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameMini2.super.ctor( self,param.name )
	-- local layer = cc.LayerColor:create( cc.c4b(0,0,0,255))
 --    self:addChild( layer )
 --    self._layer = layer
 	self:addCsb("csbslot/hall/GameMini2.csb")
 	
    self._parent = param.data
    self._coin = 0


    -- self:addCsb( "csbslot/hall/GameMini.csb")
    self:loadUi()
end

function GameMini2:loadUi( ... )

	local rotate = cc.RotateTo:create( 4,360 )
	local repeatForever = cc.RepeatForever:create( rotate )
	self.ImageLight:runAction( repeatForever )
	-- self:setTextCoin( self._coin )
	local size = cc.Director:getInstance():getWinSize()
	local text_pos = cc.p( size.width / 2,size.height / 2 )
	local text = ccui.Text:create()
	self:addChild( text )
	text:setPosition( text_pos )
	text:setFontSize( 150 )
	-- text:setString( 222222222222 )
	text:setTextColor( cc.c4b( 255,0,0,255 ) )
	local index = 0
	self:schedule(function ()
		-- self.TextTimeDown:setString( 3 )
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
	-- print("--------------------hehehaha")
	-- local coin = NodeMiniGame2.new( self )
	-- self:addChild( coin )
	-- coin:setPosition( 500,700 )
	local index = 20
	self:schedule(function ()
		
		local move_time = nil -- 掉落时长
		local num = nil -- 金币个数
		if index > 10 then
			-- move_time = random( 20,30 )
			num = random( 1,5 )
		end
		if index <= 10 and index >= 5 then
			-- move_time = random( 10,20 )
			num = random( 4,8 )
		end
		if index < 5 then
			-- move_time = random( 5,15 )
			num = random( 10,15 )
		end
		for i=1,num do
			local coin = NodeMiniGame2.new( self )
			self:addChild( coin )
			-- local scale = random( 5,15 )
			-- coin:setScale( scale / 10 )
			if index > 10 then
				move_time = random( 20,30 )
				-- num = random( 1,3 )
			end
			if index <= 10 and index >= 5 then
				move_time = random( 10,20 )
				-- num = random( 2,4 )
			end
			if index < 5 then
				move_time = random( 5,15 )
				-- num = random( 5,10 )
			end
			coin:freeFallingBody( move_time / 10 )
		end
		index = index - 1
		-- print("---------------index = "..index)

		if index <= 0 then
			self:unSchedule()
			performWithDelay(self,function()
				self._parent:loadMiniGame()
				addUIToScene( UIDefine.SLOT_KEY.OverMini2_UI,self._coin )
				self:removeFromParent()
			end,2)
		end
		
		-- if time > 0.1 then
		-- 	if time > 1 then
		-- 		time = time - 0.1
		-- 	end
			
		-- 	if time <= 1 then
		-- 		time = time - 0.2
		-- 	end
		-- end
		
		-- if time <= 0.2 then
		-- 	time = 0.05
		-- 	performWithDelay(self,function ()
		-- 		self:unSchedule()
		-- 	end,3)
		-- 	performWithDelay(self,function ()
		-- 		self:removeFromParent()
		-- 	end,6)
		-- end
		-- print("-----------------time = "..time )
	end,1.5)
end
function GameMini2:playHappy()
	-- body
end

function GameMini2:collectCoin( coin )
	self._coin = self._coin + coin
end











return GameMini2