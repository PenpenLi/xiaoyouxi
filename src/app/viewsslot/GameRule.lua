
local GameRule = class( "GameRule",BaseLayer )

function GameRule:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! ")
	GameRule.super.ctor( self,param.name )

	self:addCsb( "csbslot/wolfLighting/PayTableLayerPharaoh.csb" )

	self:addNodeClick( self.btn_back,{
		endCallBack = function ()
			self:close()
		end
	})
	self:addNodeClick( self.btn_Right,{
		endCallBack = function ()
			self:next()
		end
	})
	self:addNodeClick( self.btn_Left,{
		endCallBack = function ()
			self:theLast()
		end
	})
	self._num = 1

	self:loadUi()
end
function GameRule:loadUi()
	if self._num == 1 then
		self.child_1:setVisible( true )
		self.child_2:setVisible( false )
		self.child_3:setVisible( false )
		self.btn_Left:setBright( false )
		self.btn_Left:setTouchEnabled( false )
	end
	if self._num == 2 then
		self.child_1:setVisible( false )
		self.child_2:setVisible( true )
		self.child_3:setVisible( false )
		self.btn_Left:setBright( true )
		self.btn_Right:setBright( true )
		self.btn_Left:setTouchEnabled( true )
		self.btn_Right:setTouchEnabled( true )
	end
	if self._num == 3 then
		self.child_1:setVisible( false )
		self.child_2:setVisible( false )
		self.child_3:setVisible( true )
		self.btn_Right:setBright( false )
		self.btn_Right:setTouchEnabled( false )
	end
	
end

function GameRule:onEnter()
	GameRule.super.onEnter( self )
end

function GameRule:close()
	removeUIFromScene( UIDefine.SLOT_KEY.Rule_UI )
end
function GameRule:next()
	self._num = self._num + 1
	self:loadUi()
end
function GameRule:theLast()
	self._num = self._num - 1
	self:loadUi()
end

return GameRule