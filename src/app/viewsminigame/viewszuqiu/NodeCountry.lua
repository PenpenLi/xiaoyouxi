

local NodeCountry = class( "NodeCountry",BaseNode )


function NodeCountry:ctor( index )
	self._config = country_config.europe

	self._index = index
	NodeCountry.super.ctor( self,"NodeCountry" )

	self:addCsb( "Country.csb" )
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
		removeUIFromScene( UIDefine.MINIGAME_KEY.ZuQiu_Start_UI )
		addUIToScene( UIDefine.MINIGAME_KEY.ZuQiu_Play_UI,{ country_index = index } )
	elseif event.name == "outsideend" then
	end
end



return NodeCountry