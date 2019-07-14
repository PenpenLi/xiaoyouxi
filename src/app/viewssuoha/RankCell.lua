

local RankCell = class( "RankCell",BaseNode )

function RankCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RankCell.super.ctor( self,"RankCell" )
	self:addCsb( "csbsuoha/NodeLeaderboard.csb" )
end

function RankCell:loadDataUi( data,index )
	assert( data," !! data is nil !! " )
	assert( index," !! data is nil !! " )
	self:clearUiState()

	if index <= 3 then
		self.ImageNum:setVisible( true )
		self.ImageNum:loadTexture( "image/leaderboard/"..index..".png",1 )
	else
		self.TextNum:setVisible( true )
		self.TextNum:setString( index )
	end
	self.TextScore:setString( data.score )
	self.TextTime:setString( os.date("%Y.%m.%d %H:%M",data.time ))-----------先看看结果？？？？？？？
end


function RankCell:clearUiState()
	self.ImageNum:setVisible( false )
	self.TextNum:setVisible( false )
end


return RankCell