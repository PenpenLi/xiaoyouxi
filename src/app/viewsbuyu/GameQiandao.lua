


local GameQiandao = class( "GameQiandao",BaseLayer )

function GameQiandao:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameQiandao.super.ctor( self,param.name )
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer
    self:addCsb( "csbbuyu/GameQiandao.csb" )
    self._state = 1 -- 1,不能签到，2，能签到

    self:addNodeClick( self.ButtonQiandao,{
    	endCallBack = function ()
    		self:signIn()
    	end
    })
    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
    self:loadUi()
end
function GameQiandao:loadUi()
	local state = G_GetModel("Model_BuYu"):getSignIndexState()
	if state then
		self.TextSigned:setVisible( false )
	else
		self.TextSigned:setVisible( true )
	end
	local index = G_GetModel("Model_BuYu"):getSignIndex()
	for i=1,7 do
		if i <= index then
			self["Text"..i]:setVisible( false )
			self["ImageQuan"..i]:setVisible( true )
		else
			self["Text"..i]:setVisible( true )
			self["ImageQuan"..i]:setVisible( false )
		end
	end
	if index == 7 then
		self:reset()
	end
end

function GameQiandao:onEnter()
	GameQiandao.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )
    casecadeFadeInNode( self._layer,0.5,150 )
end

function GameQiandao:signIn()
	
	
	local state = G_GetModel("Model_BuYu"):getInstance():getSignIndexState()
	if state == false then
		print( "-----时间没到 ")
		return
	end
	print("-----签到")
	G_GetModel("Model_BuYu"):getInstance():setSignIndexState()
	-- self.TextSigned:setVisible( true )
	G_GetModel("Model_BuYu"):setSignIndex()
	local index = G_GetModel("Model_BuYu"):getSignIndex()
	local coin = self["Text"..index]:getString()
	G_GetModel("Model_BuYu"):setCoin( coin )
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_BUYU_BUY_COIN )
	self:loadUi()
end

function GameQiandao:reset(  )
	
	G_GetModel("Model_BuYu"):setSignIndex()
	self:loadUi()
end


function GameQiandao:close(  )
	removeUIFromScene( UIDefine.BUYU_KEY.Sign_UI )
end






return GameQiandao