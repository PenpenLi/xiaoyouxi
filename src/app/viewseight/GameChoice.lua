
local GameChoice = class( "GameChoice",BaseLayer )

function GameChoice:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")

    assert( param.data.poker," !! param.data.poker is nil !! ")
    assert( param.data.parent," !! param.data.parent is nil !! ")
    assert( param.data.seatPos," !! param.data.seatPos is nil !! ")

	GameChoice.super.ctor( self,param.name )
	self._poker = param.data.poker
	self._parent = param.data.parent
	self._seatPos = param.data.seatPos

	if self._seatPos == 1 or self._seatPos == 2 or self._seatPos == 3 then
		local color = random( 1,4 )
		if color == 1 then
			self:touchFk( self._seatPos )
		elseif color == 2 then
			self:touchMh( self._seatPos )
		elseif color == 3 then
			self:touchHt( self._seatPos )
		elseif color == 4 then
			self:touchTx( self._seatPos )
		end
		return
	end

	self:addCsb( "csbeight/Omnipotent.csb" )

	self:addNodeClick( self.ButtonFk,{
		endCallBack = function ()
			self:touchFk( self._seatPos )
		end
	})
	self:addNodeClick( self.ButtonMh,{
		endCallBack = function ()
			self:touchMh( self._seatPos )
		end
	})
	self:addNodeClick( self.ButtonHt,{
		endCallBack = function ()
			self:touchHt( self._seatPos )
		end
	})
	self:addNodeClick( self.ButtonTx,{
		endCallBack = function ()
			self:touchTx( self._seatPos )
		end
	})
	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end
	})
end

function GameChoice:touchFk( seatPos )
	self._poker:getPokerImg():loadTexture( "image/poker/fangkuai8.png",1 )
	self._poker:setColor( 2 )
	self._parent:selectEightPokerDone( self._poker,seatPos )
	self:close()
end
function GameChoice:touchMh( seatPos )
	self._poker:getPokerImg():loadTexture( "image/poker/meihua8.png",1 )
	self._poker:setColor( 1 )
	self._parent:selectEightPokerDone( self._poker,seatPos )
	self:close()
end
function GameChoice:touchHt( seatPos )
	self._poker:getPokerImg():loadTexture( "image/poker/heitao8.png",1 )
	self._poker:setColor( 3 )
	self._parent:selectEightPokerDone( self._poker,seatPos )
	self:close()
end
function GameChoice:touchTx( seatPos )
	self._poker:getPokerImg():loadTexture( "image/poker/hongxin8.png",1 )
	self._poker:setColor( 4 )
	self._parent:selectEightPokerDone( self._poker,seatPos )
	self:close()
end

function GameChoice:close()
	removeUIFromScene( UIDefine.EIGHT_KEY.Choice_UI )
end







return GameChoice