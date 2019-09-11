
local RenwuTable = import(".RenwuTable")
local GameRenwu = class( "GameRenwu",BaseLayer )


function GameRenwu:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameRenwu.super.ctor( self,param.name )
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer
    self:addCsb( "csbbuyu/GameAssignment.csb" )

    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
    self:initTalbe()
    self:loadDataUi()
end

function GameRenwu:onEnter()
	GameRenwu.super.onEnter( self )
	casecadeFadeInNode( self.Bg,0.5 )
    casecadeFadeInNode( self._layer,0.5,150 )
	-- casecadeFadeInNode( self.ImageShadow,0.5,150 )
end

function GameRenwu:initTalbe()
	if self._table == nil then
		local size = self.Panel:getContentSize()
		local param = {
			tableSize = size,
			parentPanel = self,
			directionType = 2
		}
		self._table = RenwuTable.new( param )
		self.Panel:addChild( self._table )
	end
end
function GameRenwu:loadDataUi()
	self._table:reload()
end

function GameRenwu:close()
	removeUIFromScene( UIDefine.BUYU_KEY.Assignment_UI )
end





return GameRenwu