

local NodeCountry = class( "NodeCountry",BaseNode )


function NodeCountry:ctor( param,index )
	self._config = country_config.europe
	-- dump( country_config,"----------------country_config = ")
	-- dump( self._config[1].icon,"-----------------country_config.europe = ")

	self._index = index
	NodeCountry.super.ctor( self,"NodeCountry" )

	self:addCsb( "csbzuqiu/Country.csb" )
	self:loadDataUi( index )

	TouchNode.extends( self.Icon,function (event)
		return self:touchIcon( event )
	end)
	
end

function NodeCountry:loadDataUi( index )
	assert( index," !! index is nil !! " )

	self.Icon:loadTexture( self._config[index].icon,1 )
	self.ImageText:loadTexture( self._config[index].text,1 )
end

function NodeCountry:touchIcon()
	-- removeUIFromScene( UIDefine.ZUQIU_KEY.Start_UI )
	-- addUIToScene( UIDefine.ZUQIU_KEY.Play_UI,self._index )
end



return NodeCountry