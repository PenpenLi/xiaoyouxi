
local FishLine = import(".FishLine")
local FishNode = import(".FishNode")
local GameStart = class( "GameStart",BaseLayer )

function GameStart:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )

    self:addCsb( "csbbuyu/GameStart.csb" )

    self:addNodeClick( self.ButtonPlay,{
    	endCallBack = function ()
    		self:play()
    	end
    })
    self:addNodeClick( self.ButtonShop,{
    	endCallBack = function ()
    		self:shop()
    	end
    })
    -- 签到
    self:addNodeClick( self.ButtonQiandao,{
    	endCallBack = function ()
    		self:signIn ()
    	end
    })


    self:loadUi()
end
function GameStart:loadUi()
	local coin = G_GetModel("Model_BuYu"):getCoin()
	self.TextCoin:setString( coin )


	local fishContainer = cc.Node:create()
    self:addChild( fishContainer )
	self:schedule( function ()
		local childs = fishContainer:getChildren()
		dump( childs,"--------------childs = ")
		if #childs >= 5 then
			return
		end
		local fishLine = FishLine.new()
		local fish_index = random( 1,#buyu_config.fish )
		local fish = FishNode.new( self,fish_index,fishLine )
		fishContainer:addChild( fish )
	end,5 )
	
end

function GameStart:onEnter()
	GameStart.super.onEnter( self )

	self:addMsgListener( InnerProtocol.INNER_EVENT_BUYU_BUY_COIN,function ()
		local coin = G_GetModel("Model_BuYu"):getInstance():getCoin()
		self.TextCoin:setString( coin )
	end )
end

function GameStart:play( ... )
	self:unSchedule()
	addUIToScene( UIDefine.BUYU_KEY.Play_UI )
end
function GameStart:shop( ... )
	addUIToScene( UIDefine.BUYU_KEY.Shop_UI )
end
function GameStart:signIn( ... )
	addUIToScene( UIDefine.BUYU_KEY.Sign_UI )
end









return GameStart