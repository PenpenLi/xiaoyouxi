

local LoadPersonLayer = class( "LoadPersonLayer",BaseLayer )


function LoadPersonLayer:ctor( param )
	
	LoadPersonLayer.super.ctor( self,param.name )

	self:addCsb("csbchengbaofensuizhan/LoadPersonLayer.csb");
end












return LoadPersonLayer