
local LoadSoldierNode = import(".LoadSoldierNode")
local LoadPersonLayer = class( "LoadPersonLayer",BaseLayer )


function LoadPersonLayer:ctor( param )
	
	LoadPersonLayer.super.ctor( self,param.name )

	self:addCsb("csbchengbaofensuizhan/LoadPersonLayer.csb")
	self:loadUi()
end

function LoadPersonLayer:loadUi()
	self._loadSoldierNode = LoadSoldierNode.new(self,1)
	self.Node:addChild( self._loadSoldierNode )
end










return LoadPersonLayer