


local GameRuleOfCandy = class( "GameRuleOfCandy",BaseLayer )

function GameRuleOfCandy:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameRuleOfCandy.super.ctor( self,param.name )
	local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer

	self:addCsb( "csbslot/newcandy/PayTableLayerNewCandy.csb" )

	self:addNodeClick( self.Button_close,{
		endCallBack = function ()
			self:close()
		end
	})
	self:addNodeClick( self.Button_right,{
		endCallBack = function ()
			self:next()
		end
	})
	self:addNodeClick( self.Button_left,{
		endCallBack = function ()
			self:theLast()
		end
	})
	self._num = 1

	self:loadUi()
end
function GameRuleOfCandy:loadUi()
	if self._num == 1 then
		self.pay_table_1:setVisible( true )
		self.pay_table_2:setVisible( false )
		self.pay_table_3:setVisible( false )
		self.Button_left:setBright( false )
		self.Button_left:setTouchEnabled( false )
	end
	if self._num == 2 then
		self.pay_table_1:setVisible( false )
		self.pay_table_2:setVisible( true )
		self.pay_table_3:setVisible( false )
		self.Button_left:setBright( true )
		self.Button_right:setBright( true )
		self.Button_left:setTouchEnabled( true )
		self.Button_right:setTouchEnabled( true )
	end
	if self._num == 3 then
		self.pay_table_1:setVisible( false )
		self.pay_table_2:setVisible( false )
		self.pay_table_3:setVisible( true )
		self.Button_right:setBright( false )
		self.Button_right:setTouchEnabled( false )
	end
	
end

function GameRuleOfCandy:onEnter()
	GameRuleOfCandy.super.onEnter( self )
	casecadeFadeInNode( self.root,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
end

function GameRuleOfCandy:close()
	removeUIFromScene( UIDefine.SLOT_KEY.RuleOfCandy_UI )
end
function GameRuleOfCandy:next()
	self._num = self._num + 1
	self:loadUi()
end
function GameRuleOfCandy:theLast()
	self._num = self._num - 1
	self:loadUi()
end

return GameRuleOfCandy