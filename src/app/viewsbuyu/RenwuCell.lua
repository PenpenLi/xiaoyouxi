

local RenwuCell = class( "RenwuCell",BaseNode )

function RenwuCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RenwuCell.super.ctor( self,"RenwuCell")
	self:addCsb( "csbbuyu/NodeAssignment.csb" )


	TouchNode.extends( self.ButtonGet,function ( event )
		return self:getCoin( event )
	end)
end

function RenwuCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	self._data = data
	self._index = index
	
	local task_data = G_GetModel("Model_BuYu"):getTaskById( data.fish_id )

	self.ImageFish:loadTexture( data.path,1 )
	self.TextTarget:setString( data.task_num )

	self.TextJindu:setString( task_data.num )

	local rate = math.floor( task_data.num / data.task_num * 100)
	self.ExpBar:setPercent( rate )
	self.TextCoin:setString( data.coin )
	
	-- 目标未达到
	if task_data.num < data.task_num then
		graySprite( self.ButtonGet:getVirtualRenderer():getSprite() )
		self.Text_1:setString( "未完成" )
	else
		if task_data.state == 1 then
			task_data.state = 2
		end
		if task_data.state == 2 then
			-- 未领取
			ungraySprite( self.ButtonGet:getVirtualRenderer():getSprite() )
			self.Text_1:setString( "完成" )
		else
			-- 已领取
			graySprite( self.ButtonGet:getVirtualRenderer():getSprite() )
			self.Text_1:setString( "已领取" )
		end
		
	end
	
end

function RenwuCell:clearUiState()
	
end
function RenwuCell:getCoin( event )
	local task_data = G_GetModel("Model_BuYu"):getTaskById( self._data.fish_id )
	if task_data.state ~= 2 then
		return
	end
	
	task_data.state = 3
	self:loadDataUi( self._data,self._index )
	local coin = self.TextCoin:getString()
	G_GetModel("Model_BuYu"):saveTaskListState( self._index )
	G_GetModel("Model_BuYu"):setCoin( coin )
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_BUYU_BUY_COIN )
end










return RenwuCell