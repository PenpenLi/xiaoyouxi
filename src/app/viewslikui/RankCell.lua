
local RancCell = class( "RancCell",BaseNode )


function RancCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RancCell.super.ctor( self,"RancCell")
	self:addCsb( "csblikui/NodeRank.csb" )
end

function RancCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUiState()
	-- index
	if index <= 3 then
		self.ImageHg:setVisible( true )
		self.ImageHg:ignoreContentAdaptWithSize( true )
		self.ImageHg:loadTexture( "image/rank/paiming"..index..".png",1 )
	else
		self.TextNum:setVisible( true )
		self.TextNum:setString( index )
	end
	
	self.TextScore:setString( data.score )
	self.TextTime:setString( os.date("%Y.%m.%d %H.%M",data.time ))
end

function RancCell:clearUiState()
	self.ImageHg:setVisible( false )
	self.TextNum:setVisible( false )
end

return RancCell