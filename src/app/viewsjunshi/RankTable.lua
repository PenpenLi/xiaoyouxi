
local RankCell  = import(".RankCell")
local RankTable = class("RankTable",BaseTable)



function RankTable:setViewData()
    self._viewData = G_GetModel("Model_JunShi"):getRecordList()
end


function RankTable:cellSizeForTable(table,idx)
    return 894, 120
end


function RankTable:tableCellAtIndex(table, idx)
    local cell =  table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    end
    if cell.view == nil then
        cell.view = RankCell.new( self )
        cell:addChild(cell.view)
    end
    local data = self._viewData[ idx + 1]
    cell.view:loadDataUi( data,idx + 1 )
    self._cellList[idx+1] = cell.view
    return cell
end



return RankTable