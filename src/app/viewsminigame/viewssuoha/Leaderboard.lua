
local RankTable = import(".RankTable")
local Leaderboard = class( "Leaderboard",BaseLayer )


function Leaderboard:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    Leaderboard.super.ctor( self,param.name )
    self._layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ))
    self:addChild( self._layer )

    self:addCsb( "csbsuoha/Leaderboard.csb" )

    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
    self:initTable()
    self:loadDataUi()
end

function Leaderboard:onEnter()
	Leaderboard.super.onEnter( self )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
end



function Leaderboard:initTable()
	if self._table == nil then
		local size = self.tablePanel:getContentSize()
		local param = {
			tableSize = size,
			parentPanel = self,
			directionType = 2
		}
		self._table = RankTable.new( param )
		self.tablePanel:addChild( self._table )
	end
end
function Leaderboard:loadDataUi()
	self._table:reload()
end

function Leaderboard:close()
	removeUIFromScene( UIDefine.MINIGAME_KEY.SuoHa_Rank_UI )
end









return Leaderboard