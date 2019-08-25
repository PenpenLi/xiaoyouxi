


local GameRuleOfRed = class( "GameRuleOfRed",BaseLayer )

function GameRuleOfRed:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameRuleOfRed.super.ctor( self,param.name )

	self:addCsb( "csbslot/RedDiamond/PayTableLayerRedDiamond.csb" )

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
function GameRuleOfRed:loadUi()
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

function GameRuleOfRed:onEnter()
	GameRuleOfRed.super.onEnter( self )
	casecadeFadeInNode( self.root,0.5 )
end

function GameRuleOfRed:close()
	removeUIFromScene( UIDefine.SLOT_KEY.RuleOfRed_UI )
end
function GameRuleOfRed:next()
	self._num = self._num + 1
	self:loadUi()
end
function GameRuleOfRed:theLast()
	self._num = self._num - 1
	self:loadUi()
end

return GameRuleOfRed