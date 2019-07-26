


local GameStart = class( "GameStart",BaseLayer )

function GameStart:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )

    self:addCsb( "csblikui/Start.csb" )

    self:addNodeClick( self.ButtonLeft,{
    	endCallBack = function ()
    		self:left()
    	end
    })
    self:addNodeClick( self.ButtonRight,{
    	endCallBack = function ()
    		self:right()
    	end
    })
    dump( self.Panel1:getPositionX(),"---------=" )

    self:loadUi()
end

function GameStart:loadUi()
	local coin = G_GetModel("Model_LiKui"):getInstance():getCoin()
	self.TextCoin:setString( coin )

	local state = G_GetModel("Model_Sound"):isMusicOpen()
	if state then
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
	else
		self.ButtonSound:loadTexture( "image/start/sound.png",1 )
		-- 变灰
	end

end

function GameStart:onEnter()
	GameStart.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )

	G_GetModel( "Model_Sound" ):playBgMusic()
	self:loadHelp()
end

-- Help显示区域
function GameStart:loadHelp()
	self:schedule(function ()
		if self.Panel_2:getPositionY() > 0 then
			local left_moveby = cc.MoveBy:create( 0.5,cc.p( 0,-150 ))
			local right_moveby = cc.MoveBy:create( 0.5,cc.p( 0,-150 ))
			self.Panel_2:runAction( left_moveby )
			self.Panel_3:runAction( right_moveby )
		end
		if self.Panel_3:getPositionY() < 0 then
			local left_moveby = cc.MoveBy:create( 0.5,cc.p( 0,150 ))
			local right_moveby = cc.MoveBy:create( 0.5,cc.p( 0,150 ))
			self.Panel_2:runAction( left_moveby )
			self.Panel_3:runAction( right_moveby )
		end
	end,2 )
end
function GameStart:left()
	if self.Panel1:getPositionX() < 0 then-----------------if self.Panel1:getPositionX() == -715 then这个条件有什么问题
		print( "-----------1111111111")
		local left_moveby = cc.MoveBy:create( 0.5,cc.p( 715,0 ))
		local right_moveby = cc.MoveBy:create( 0.5,cc.p( 715,0 ))
		-- local apawn = cc.Spawn:create( left_moveby,right_moveby )
		self.Panel1:runAction( left_moveby )
		self.Panel2:runAction( right_moveby )
	end
end
function GameStart:right()
	if self.Panel2:getPositionX() > 0 then-----------------------if self.Panel1:getPositionX() == 0 then和上面一样有什么问题，打印出来值是这个
		print( "-----------1111111111")
		local left_moveby = cc.MoveBy:create( 0.5,cc.p( -715,0 ))
		local right_moveby = cc.MoveBy:create( 0.5,cc.p( -715,0 ))
		-- local apawn = cc.Spawn:create( left_moveby,right_moveby )
		self.Panel1:runAction( left_moveby )
		self.Panel2:runAction( right_moveby )
	end
end






return GameStart