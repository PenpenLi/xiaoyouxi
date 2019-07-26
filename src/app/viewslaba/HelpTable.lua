
local HelpCell  = import(".HelpCell")
local HelpTable = class("HelpTable",BaseTable)



function HelpTable:setViewData()
    if laba_config.lang == 1 then
        self._viewData = {
            { "财神",12,6,3 },
            { "鞭炮",10,5,3 },
            { "灯笼",10,4,3 },
            { "K",8,3,2 },
            { "Q",4,2,2 },
            { "J",4,2,1 },
            { 10,4,2,1 },
            { 9,3,2,1 },
            { 8,3,2,1 },
        }
    else
        self._viewData = {
            { "Yacht",12,6,3 },
            { "SportsCar",10,5,3 },
            { "Gold",10,4,3 },
            { "K",8,3,2 },
            { "Q",4,2,2 },
            { "J",4,2,1 },
            { "Champagne",4,2,1 },
            { "Watch",3,2,1 },
            { "A",3,2,1 },
        }
    end
end


function HelpTable:cellSizeForTable(table,idx)
    if laba_config.lang == 1 then
        return 954, 53
    else
        return 874, 55
    end
end


function HelpTable:tableCellAtIndex(table, idx)
    local cell =  table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    end
    if cell.view == nil then
        cell.view = HelpCell.new( self )
        cell:addChild(cell.view)
    end
    local data = self._viewData[ idx + 1]
    cell.view:loadDataUi( data,idx + 1 )
    self._cellList[idx+1] = cell.view
    return cell
end



return HelpTable