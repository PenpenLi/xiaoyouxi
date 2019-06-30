

local NodeCountry = class( "NodeCountry",BaseNode )


function NodeCountry:ctor( index )
	self._config = country_config.europe

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

function NodeCountry:touchIcon( event )
	if event.name == "began" then
		self.Icon:setScale(1.2)
		return true
	elseif event.name == "moved" then
	elseif event.name == "ended" then
		self.Icon:setScale(1)
		local index = self._index
		removeUIFromScene( UIDefine.ZUQIU_KEY.Start_UI )
		addUIToScene( UIDefine.ZUQIU_KEY.Play_UI,{ country_index = index } )
	elseif event.name == "outsideend" then
	end
end



return NodeCountry