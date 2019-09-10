local RenwuCell = import( ".RenwuCell" )
local RenwuTable = class( "RenwuTable",BaseTable )



function RenwuTable:setViewData()
	self._viewData = buyu_config.task
end

function RenwuTable:cellSizeForTable( table,idx )
	return 916,76
end


function RenwuTable:tableCellAtIndex( table,idx )
	local cell = table:dequeueCell()
	if nil == cell then
		cell = cc.TableViewCell:new()
	end
	if cell.view == nil then
		cell.view = RenwuCell.new( self )
		cell:addChild( cell.view )
	end
	local data = self._viewData[ idx + 1 ]
	cell.view:loadDataUi( data,idx + 1 )
	self._cellList[ idx + 1 ] = cell.view
	return cell
end


return RenwuTable