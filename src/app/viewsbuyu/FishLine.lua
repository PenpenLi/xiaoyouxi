

local FishLine = class( "FishLine",BaseLayer)






-- 4向可出现的鱼
function FishLine:shark( fish )
	local move_began = random( 1,4 )-- 1,左  2,右  3,上  4,下
	-- local move_began = 1
	-- local move_began = 4
	local c_point1 = nil
	local c_point2 = nil
	local end_point = nil

	-- 1，鱼从左出现
	if move_began == 1 then
		-- 从左边出现
		local x = -200
		-- 随机出现高度y
		local y = random( -200,display.height )
		-- c_point1 = cc.p( x,y )
		fish:setPosition( x,y )
		dump( c_point1,"---------------c_point1 = ")

		-- 第一次移动到中间区域的x位置
		local x1 = random( display.width / 4,display.width / 2 )
		-- 随机中间区域的高度y，与出现相对随机
		local y1 = nil
		if y < display.height / 2 then
			y1 = random( y,display.height - 100 )
		else
			y1 = random( 100,y )
		end
		c_point1 = cc.p( x1,y1 )
		dump( c_point1,"---------------c_point1 = ")

		-- 第二次移动到位置
		local x2 = random( display.width / 2,display.width * 3 / 4 )
		local y2 = nil
		if y1 < display.height / 2 then
			y2 = random( y1,display.height - 100 )
		else
			y2 = random( 100,y1 )
		end
		c_point2 = cc.p( x2,y2 )

		-- 消失位置
		local x3 = nil
		local y3 = nil
		local move_end = random( 1,4 ) -- 1,2,消失在右  3，消失在上，4，消失在下
		if move_end <= 2 then
			x3 = display.width + 200
			-- 继续根据出现的高度y，给一个结束的y
			if y2 < display.height / 2 then
				y3 = random( 0,y2 ) + 200
			else
				y3 = random( y2,display.height ) + 200
			end
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		elseif move_end == 3 then
			x3 = random( display.width * 3 / 4,display.width ) + 200
			y3 = display.height + 200
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		elseif move_end == 4 then
			x3 = random( display.width * 3 / 4,display.width ) + 200
			y3 = 0 - 200
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		end
	end
	-- 2，鱼从右出现
	if move_began == 2 then
		-- 从左边出现
		local x = display.width + 200
		-- 随机出现高度y
		local y = random( -200,display.height + 200 )
		-- c_point1 = cc.p( x,y )
		fish:setPosition( x,y )
		dump( c_point1,"---------------c_point1 = ")

		-- 第一次移动到中间区域的x位置
		local x1 = random( display.width * 3 / 4,display.width )
		-- 随机中间区域的高度y，与出现相对随机
		local y1 = nil
		if y < display.height / 2 then
			y1 = random( y,display.height - 100 )
		else
			y1 = random( 100,y )
		end
		c_point1 = cc.p( x1,y1 )
		dump( c_point1,"---------------c_point1 = ")

		-- 第二次移动到位置
		local x2 = random( display.width / 4,display.width / 2 )
		local y2 = nil
		if y1 < display.height / 2 then
			y2 = random( y1,display.height - 100 )
		else
			y2 = random( 100,y1 )
		end
		c_point2 = cc.p( x2,y2 )

		-- 消失位置
		local x3 = nil
		local y3 = nil
		local move_end = random( 1,4 ) -- 1,2,消失在右  3，消失在上，4，消失在下
		if move_end <= 2 then
			x3 = -200
			-- 继续根据出现的高度y，给一个结束的y
			if y2 < display.height / 2 then
				y3 = random( 0,y2 )
			else
				y3 = random( y2,display.height )
			end
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		elseif move_end == 3 then
			x3 = random( 0,display.width / 4 ) - 200
			y3 = display.height + 200
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		elseif move_end == 4 then
			x3 = random( 0,display.width / 4 ) - 200
			y3 = 0 - 200
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		end
	end
	-- 3，鱼从上出现
	if move_began == 3 then
		-- 从上边出现随机x
		local x = random( -200,display.width + 200 )
		-- 出现高度y
		local y = display.height + 200
		-- c_point1 = cc.p( x,y )
		fish:setPosition( x,y )
		dump( c_point1,"---------------c_point1 = ")

		-- 第一次移动到中间区域的y位置
		local y1 = random( display.height / 2,display.height * 3 / 4 )
		-- 随机中间区域的x，与出现相对随机
		local x1 = nil
		if x < display.width / 2 then
			x1 = random( x,display.width - 100 )
		else
			x1 = random( 100,x )
		end
		c_point1 = cc.p( x1,y1 )
		dump( c_point1,"---------------c_point1 = ")

		-- 第二次移动到位置
		local y2 = random( display.height / 4,display.height / 2 )
		local x2 = nil
		if x1 < display.width / 2 then
			x2 = random( x1,display.width - 100 )
		else
			x2 = random( 100,x1 )
		end
		c_point2 = cc.p( x2,y2 )

		-- 消失位置
		local x3 = nil
		local y3 = nil
		local move_end = random( 1,4 ) -- 1,2,消失在下  3，消失在左，4，消失在右
		if move_end <= 2 then
			y3 = -200
			-- 继续根据出现的高度y，给一个结束的y
			if x2 < display.width / 2 then
				x3 = random( 0,x2 )
			else
				x3 = random( x2,display.width )
			end
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		elseif move_end == 3 then
			y3 = random( 0,display.height / 4 )
			x3 = -200
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		elseif move_end == 4 then
			y3 = random( 0,display.height / 4 )
			x3 =  display.width + 200
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		end
	end
	-- 4，鱼从下出现
	if move_began == 4 then
		-- 从下边出现随机x
		local x = random( -200,display.width + 200 )
		-- 出现高度y
		local y = -200
		-- c_point1 = cc.p( x,y )
		fish:setPosition( x,y )
		dump( c_point1,"---------------c_point1 = ")

		-- 第一次移动到中间区域的y位置
		local y1 = random( 0,display.height / 4 )
		-- 随机中间区域的x，与出现相对随机
		local x1 = nil
		if x < display.width / 2 then
			x1 = random( x,display.width - 100 )
		else
			x1 = random( 100,x )
		end
		c_point1 = cc.p( x1,y1 )
		dump( c_point1,"---------------c_point1 = ")

		-- 第二次移动到位置
		local y2 = random( display.height / 4,display.height / 2 )
		local x2 = nil
		if x1 < display.width / 2 then
			x2 = random( x1,display.width - 100 )
		else
			x2 = random( 100,x1 )
		end
		c_point2 = cc.p( x2,y2 )

		-- 消失位置
		local x3 = nil
		local y3 = nil
		local move_end = random( 1,4 ) -- 1,2,消失在上  3，消失在左，4，消失在右
		if move_end <= 2 then
			y3 = display.height + 200
			-- 继续根据出现的高度y，给一个结束的y
			if x2 < display.width / 2 then
				x3 = random( x2,display.width )
			else
				x3 = random( 0,x2 )
			end
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		elseif move_end == 3 then
			y3 = random( display.height * 3 / 4,display.height )
			x3 = -200
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		elseif move_end == 4 then
			y3 = random( display.height * 3 / 4,display.height )
			x3 =  display.width + 200
			end_point = cc.p( x3,y3 )
			dump( end_point,"---------------end_point = ")
		end
	end
	-- 鱼游出屏幕还需不需要remove？
	local bz = cc.BezierTo:create(15,{ c_point1,c_point2,end_point })
	fish:runAction( bz )
end
function FishLine:move2()
	-- 随机起点和终点，第二个值取区间的值
end








return FishLine