
local RankTable = import(".RankTable")
local RankMain = class( "RankMain",BaseLayer )


function RankMain:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    RankMain.super.ctor( self,param.name )

    self:addCsb( "Rank.csb" )

    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
    self:initTalbe()
    self:loadDataUi()
end

function RankMain:onEnter()
	RankMain.super.onEnter( self )
	casecadeFadeInNode( self.bg,0.5 )
	casecadeFadeInNode( self.ImageShadow,0.5,150 )
end

function RankMain:initTalbe()
	if self._table == nil then
		local size = self.Panel:getContentSize()
		local param = {
			tableSize = size,
			parentPanel = self,
			directionType = 2
		}
		self._table = RankTable.new( param )
		self.Panel:addChild( self._table )
	end
end
function RankMain:loadDataUi()
	self._table:reload()
end

function RankMain:close()
	removeUIFromScene( UIDefine.MINIGAME_KEY.LiKui_Rank_UI )
end
























return RankMain