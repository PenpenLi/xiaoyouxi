

local RankCell = import( ".RankCell" )
local RankTable = class( "RankTable",BaseTable )

function RankTable:reload()
	RankTable.super.reload( self )-----??
end

function RankTable:setViewData()
	self._viewData = G_GetModel("Model_SuoHa"):getRecordList()
end

function RankTable:cellSizeForTable( table,idx )------------???????????????
	return 962,92
end

function RankTable:tableCellAtIndex( table,idx )
	local cell = table:dequeueCell()-------------?????table是关键字？？
	if cell == nil then
		cell = cc.TableViewCell:new()--创建一个cell
	end
	if cell.view == nil then
		cell.view = RankCell.new( self )
		cell:addChild( cell.view )
	end
	local data = self._viewData[ idx + 1 ]
	cell.view:loadDataUi( data,idx + 1 )
	self._cellList[ idx + 1 ] = cell.view
	return cell
end




return RankTable