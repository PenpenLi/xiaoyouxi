
local CoinNode = class("CoinNode",function()
	return cc.Node:create()
end)


function CoinNode:ctor()
	-- 创建 coin
	local coin = ccui.ImageView:create("jinbi1.png",1)
	self:addChild( coin )
	coin:setTag( 101 )
	coin:setScale( 0.5 )
	coin.__imageIndex = 1
	-- 创建 gold_star
	local gold_star = ccui.ImageView:create("gold_star_1.png",1)
	self:addChild( gold_star )
	gold_star:setTag( 102 )
	gold_star:setOpacity( 0 )
	gold_star:setScale( 1.45 )
	gold_star.__imageIndex = 0
end


function CoinNode:coinAction()
	-- coin
	local coin = self:getChildByTag( 101 )
	if coin then
		local scale_to1 = cc.ScaleTo:create( self._flytime / 4,1.2 )
		local delay_time = cc.DelayTime:create( self._flytime / 2 )
		local scale_to2 = cc.ScaleTo:create( self._flytime / 4 ,0.6 )
		local seq = cc.Sequence:create( { scale_to1,delay_time,scale_to2 } )
		coin:runAction( seq )
	end

	-- gold_star
	local gold_star = self:getChildByTag( 102 )
	if gold_star then
		local fade_in = cc.FadeIn:create( self._flytime / 4 )
		local delay_time = cc.DelayTime:create( self._flytime / 2 )
		local fade_out = cc.FadeOut:create(  self._flytime / 4 )
		local remove = cc.RemoveSelf:create()
		local seq1 = cc.Sequence:create({ fade_in,delay_time,fade_out,remove })
		gold_star:runAction( seq1 )
	end

	self.__timedt = 0
	self:onUpdate( function()
		self.__timedt = self.__timedt + 0.01
		if self.__timedt > 0.04 then
			self.__timedt = 0
			-- coin
			local coin = self:getChildByTag( 101 )
			if coin then
				local img_path1 = "jinbi"..coin.__imageIndex..".png"
				coin:loadTexture( img_path1,1 )
				coin.__imageIndex = coin.__imageIndex + 1
				if coin.__imageIndex > 16 then
					coin.__imageIndex = 1
				end
			end
			-- gold_star
			local gold_star = self:getChildByTag( 102 )
			if gold_star then
				local img_path2 = "gold_star_"..gold_star.__imageIndex..".png"
				gold_star:loadTexture( img_path2,1 )
				gold_star.__imageIndex = gold_star.__imageIndex + 1
				if gold_star.__imageIndex > 9 then
					gold_star.__imageIndex = 1
				end
			end
		end
	end)
end

function CoinNode:flyAction( startPoint,endPoint,index,maxIndex,callBack,rate )
	local start_point = clone( startPoint )
	local end_point = clone( endPoint )
	local bz_total_fly_time1 = 1
	local bz_total_fly_time2 = 0.5

	self._flytime = bz_total_fly_time1
	self._maxIndex = maxIndex
	self._callBack = callBack

	self:setPosition( start_point )
	self:setVisible( false )
	local delay = cc.DelayTime:create( 0.15 * index )
	local call_show = cc.CallFunc:create( function()
		self:setVisible( true )
		self:coinAction()
	end)

	local m_rate = 1
	if rate then
		m_rate = rate
	end


	local actions = {}
	table.insert( actions,delay )
	table.insert( actions,call_show )


	local bez = cc.BezierTo:create(1,{cc.p(endPoint.x,startPoint.y+(endPoint.y-startPoint.y)*0.3),
        cc.p(startPoint.x,startPoint.y+(endPoint.y-startPoint.y)*0.5),endPoint})

	table.insert( actions,bez )

	local call_fly_end = cc.CallFunc:create( function()
		self:flyEndAction( index )
	end )
	table.insert( actions,call_fly_end )
	local seq = cc.Sequence:create( actions )
	self:runAction( seq )
end

function CoinNode:flyEndAction( index )
	self:unscheduleUpdate()
	local coin = self:getChildByTag( 101 )
	if coin then
		local fade_out = cc.FadeOut:create(0.2)
		local call_create = cc.CallFunc:create( function()
			local jinbi = ccui.ImageView:create("jinbi1.png",1)
			self:addChild( jinbi,100 )
			local scale_to1 = cc.ScaleTo:create( 0.4,2 )
			local fade_out1 = cc.FadeOut:create(0.4)
			local spawn = cc.Spawn:create({ scale_to1,fade_out1 })
			local call_remove = cc.CallFunc:create( function()
				self:setVisible( false )
				-- 金币飞行完毕 执行回调
				if index == self._maxIndex then
					if self._callBack then
						self._callBack()
					end
				end
			end )
			local seq1 = cc.Sequence:create({ spawn,call_remove })
			jinbi:runAction( seq1 )
		end )
		local seq = cc.Sequence:create({ fade_out,call_create })
		coin:runAction( seq )
	end
end

return CoinNode