

local FishLine = class( "FishLine" )

function FishLine:ctor()
end

function FishLine:createLine( fish,dirType )
	if dirType == "all" then
		local index = random(1,7)
		if index == 1 then
			self:line1( fish )
		elseif index == 2 then
			self:line2( fish )
		elseif index == 3 then
			self:line3( fish )
		elseif index == 4 then
			self:line4( fish )
		elseif index == 5 then
			self:line5( fish )
		elseif index == 6 then
			self:line6( fish )
		elseif index == 7 then
			self:line7( fish )
		end
	elseif dirType == "left_right" then
		local random_dir = random(1,2)
		if random_dir == 1 then
			self:line2( fish )
		else
			fish._fish:setFlippedY( true )
			self:line3( fish )
		end
	end
end


-- 4向可出现的鱼
function FishLine:line1( fish )
	local move_began = random( 1,4 )-- 1,左  2,右  3,上  4,下
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
		elseif move_end == 3 then
			x3 = random( display.width * 3 / 4,display.width ) + 200
			y3 = display.height + 200
			end_point = cc.p( x3,y3 )
		elseif move_end == 4 then
			x3 = random( display.width * 3 / 4,display.width ) + 200
			y3 = 0 - 200
			end_point = cc.p( x3,y3 )
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
		elseif move_end == 3 then
			x3 = random( 0,display.width / 4 ) - 200
			y3 = display.height + 200
			end_point = cc.p( x3,y3 )
		elseif move_end == 4 then
			x3 = random( 0,display.width / 4 ) - 200
			y3 = 0 - 200
			end_point = cc.p( x3,y3 )
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
		elseif move_end == 3 then
			y3 = random( 0,display.height / 4 )
			x3 = -200
			end_point = cc.p( x3,y3 )
		elseif move_end == 4 then
			y3 = random( 0,display.height / 4 )
			x3 =  display.width + 200
			end_point = cc.p( x3,y3 )
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
		elseif move_end == 3 then
			y3 = random( display.height * 3 / 4,display.height )
			x3 = -200
			end_point = cc.p( x3,y3 )
		elseif move_end == 4 then
			y3 = random( display.height * 3 / 4,display.height )
			x3 =  display.width + 200
			end_point = cc.p( x3,y3 )
		end
	end

	-- end_point.x = end_point.x + display.width / 2
	-- end_point.y = end_point.y + display.height / 2

	local remove = cc.RemoveSelf:create()
	local bz = cc.BezierTo:create( random(15,25),{ c_point1,c_point2,end_point })
	local seq = cc.Sequence:create({ bz,remove })
	fish:runAction( seq )
end
-- 从左往右
function FishLine:line2( fish )
	-- 随机起点和终点，第二个值取区间的值
	local x_began = -200
	local y_began = random( -200,display.height + 200 )
	local began_pos = cc.p( x_began,y_began )
	local x_first = display.width / 4
	local y_first = random( 100,display.height - 100 )
	local first_pos = cc.p( x_first,y_first )
	local x_second = display.width * 3 / 4 
	local y_second = random( 100,display.height - 100 )
	local second_pos = cc.p( x_second,y_second )
	local x_end = display.width + 200
	local y_end = random( -200,display.height + 200 )
	local end_pos = cc.p( x_end,y_end )
	fish:setPosition( began_pos )
	local remove = cc.RemoveSelf:create()
	local bz = cc.BezierTo:create(random(15,25),{ first_pos,second_pos,end_pos })
	local seq = cc.Sequence:create({ bz,remove })
	fish:runAction( seq )
end
-- 从右往左
function FishLine:line3( fish )
	-- 随机起点和终点，第二个值取区间的值
	local x_began = display.width + 200
	local y_began = random( -200,display.height + 200 )
	local began_pos = cc.p( x_began,y_began )
	local x_first = display.width * 3 / 4
	local y_first = random( 100,display.height - 100 )
	local first_pos = cc.p( x_first,y_first )
	local x_second = display.width / 4 
	local y_second = random( 100,display.height - 100 )
	local second_pos = cc.p( x_second,y_second )
	local x_end = -200
	local y_end = random( -200,display.height + 200 )
	local end_pos = cc.p( x_end,y_end )

	fish:setPosition( began_pos )

	local remove = cc.RemoveSelf:create()
	local bz = cc.BezierTo:create(random(15,25),{ first_pos,second_pos,end_pos })
	local seq = cc.Sequence:create({ bz,remove })
	fish:runAction( seq )
end
-- 从上往下
function FishLine:line4( fish )
	-- 随机起点和终点，第二个值取区间的值
	local x_began = random( -200,display.width + 200 )
	local y_began = display.height + 200
	local began_pos = cc.p( x_began,y_began )
	local x_first = random( 100,display.width - 100 )
	local y_first = display.height * 3 / 4
	local first_pos = cc.p( x_first,y_first )
	local x_second = random( 100,display.width - 100 )
	local y_second = display.height / 4
	local second_pos = cc.p( x_second,y_second )
	local x_end = random( -200,display.width + 200 )
	local y_end = -200
	local end_pos = cc.p( x_end,y_end )

	fish:setPosition( began_pos )

	local remove = cc.RemoveSelf:create()
	local bz = cc.BezierTo:create(random(15,25),{ first_pos,second_pos,end_pos })
	local seq = cc.Sequence:create({ bz,remove })
	fish:runAction( seq )
end
-- 从下往上
function FishLine:line5( fish )
	-- 随机起点和终点，第二个值取区间的值
	local x_began = random( -200,display.width + 200 )
	local y_began = -200
	local began_pos = cc.p( x_began,y_began )
	local x_first = random( 100,display.width - 100 )
	local y_first = display.height / 4
	local first_pos = cc.p( x_first,y_first )
	local x_second = random( 100,display.width - 100 )
	local y_second = display.height * 3 / 4
	local second_pos = cc.p( x_second,y_second )
	local x_end = random( -200,display.width + 200 )
	local y_end = display.height + 200
	local end_pos = cc.p( x_end,y_end )

	fish:setPosition( began_pos )

	local remove = cc.RemoveSelf:create()
	local bz = cc.BezierTo:create(random(15,25),{ first_pos,second_pos,end_pos })
	local seq = cc.Sequence:create({ bz,remove })
	fish:runAction( seq )
end

-- 从左上下角，到右上下角
function FishLine:line6( fish )
	local x_began = -200
	local num = random( 1,2 ) -- 1，左上，2，左下 --- 出现
	local y_began
	if num == 1 then
		y_began = display.height + 200
	else
		y_began = -200
	end
	
	local began_pos = cc.p( x_began,y_began )
	local x_first = display.width * 2 / 5
	local y_first = random( display.height / 2 - 100,display.height / 2 + 100 )
	local first_pos = cc.p( x_first,y_first )
	local x_second = display.width * 3 / 5
	local y_second = random( display.height / 2 - 100,display.height / 2 + 100 )
	local second_pos = cc.p( x_second,y_second )
	local x_end = display.width + 200
	num = random( 1,2 ) -- 1，左上，2，左下 --- 消失
	local y_end
	if num == 1 then
		y_end = display.height + 200
	else
		y_end = -200
	end
	local end_pos = cc.p( x_end,y_end )

	fish:setPosition( began_pos )

	local remove = cc.RemoveSelf:create()
	local bz = cc.BezierTo:create(random(15,25),{ first_pos,second_pos,end_pos })
	local seq = cc.Sequence:create({ bz,remove })
	fish:runAction( seq )
end
-- 从右上下角，到左上下角
function FishLine:line7( fish )
	local x_began = display.width + 200
	local num = random( 1,2 ) -- 1，右上，2，右下 --- 消失
	local y_began
	if num == 1 then
		y_began = display.height + 200
	else
		y_began = -200
	end
	
	local began_pos = cc.p( x_began,y_began )
	local x_first = display.width * 3 / 5
	local y_first = random( display.height / 2 - 100,display.height / 2 + 100 )
	local first_pos = cc.p( x_first,y_first )
	local x_second = display.width * 2 / 5
	local y_second = random( display.height / 2 - 100,display.height / 2 + 100 )
	local second_pos = cc.p( x_second,y_second )
	local x_end = -200
	num = random( 1,2 ) -- 1，左上，2，左下 --- 出现
	local y_end
	if num == 1 then
		y_end = display.height + 200
	else
		y_end = -200
	end
	local end_pos = cc.p( x_end,y_end )

	fish:setPosition( began_pos )

	local remove = cc.RemoveSelf:create()
	local bz = cc.BezierTo:create(random(15,25),{ first_pos,second_pos,end_pos })
	local seq = cc.Sequence:create({ bz,remove })
	fish:runAction( seq )
end



-- 小鱼串，从左上下角出现，对角线消失
function FishLine:line8( fish )
	local x_began = -200
	local num = random( 1,2 ) -- 1，左上出现右下消失，2，左下出现右上消失
	local y_began
	local y_first
	local y_second
	if num == 1 then
		y_began = display.height + 200
		y_first = display.height / 2 - 200
		y_second = display.height / 2 + 200
	else
		y_began = -200
		y_first = display.height / 2 + 200
		y_second = display.height / 2 - 200
	end
	
	local began_pos = cc.p( x_began,y_began )
	local x_first = display.width * 2 / 5
	
	local first_pos = cc.p( x_first,y_first )
	local x_second = display.width * 3 / 5
	
	local second_pos = cc.p( x_second,y_second )
	local x_end = display.width + 200
	local y_end
	if num == 2 then
		y_end = display.height + 200
	else
		y_end = -200
	end
	local end_pos = cc.p( x_end,y_end )

	fish:setPosition( began_pos )
	local bz = cc.BezierTo:create(15,{ first_pos,second_pos,end_pos })
	fish:runAction( bz )
end
-- 小鱼串，从右上下角出现，对角线消失
function FishLine:line9( fish )
	local x_began = display.width + 200
	local num = random( 1,2 ) -- 1，右上出现左下消失，2，右下出现左上消失
	local y_began
	local y_first
	local y_second
	if num == 1 then
		y_began = display.height + 200
		y_first = display.height / 2 - 200
		y_second = display.height / 2 + 200
	else
		y_began = -200
		y_first = display.height / 2 + 200
		y_second = display.height / 2 - 200
	end
	
	local began_pos = cc.p( x_began,y_began )
	local x_first = display.width * 3 / 5
	
	local first_pos = cc.p( x_first,y_first )
	local x_second = display.width * 2 / 5
	
	local second_pos = cc.p( x_second,y_second )
	local x_end = -200
	local y_end
	if num == 2 then
		y_end = display.height + 200
	else
		y_end = -200
	end
	local end_pos = cc.p( x_end,y_end )

	fish:setPosition( began_pos )
	local bz = cc.BezierTo:create(15,{ first_pos,second_pos,end_pos })
	fish:runAction( bz )
end
-- 小鱼串，从左出现，右消失----两条贝塞尔曲线
function FishLine:line10( fish )
	local x_began = -(display.width / 5)
	local y_began = random( 100,display.height - 100 )
	local began_pos = cc.p( x_began,y_began )
	
	local x_first = display.width / 5
	local y_first = y_began + 300
	local first_pos = cc.p( x_first,y_first )
	local x_second = display.width * 2 / 5
	local y_second = y_began - 300
	local second_pos = cc.p( x_second,y_second )
	local x_end = display.width * 3 / 5
	local y_end = y_began
	local end_pos = cc.p( x_end,y_end )
	local bz = cc.BezierTo:create(15,{ first_pos,second_pos,end_pos })

	x_first = display.width * 4 / 5
	y_first = y_began + 300
	first_pos = cc.p( x_first,y_first )
	x_second = display.width
	y_second = y_began - 300
	second_pos = cc.p( x_second,y_second )
	x_end = display.width + display.width / 5
	y_end = y_began
	end_pos = cc.p( x_end,y_end )
	local bz1 = cc.BezierTo:create(15,{ first_pos,second_pos,end_pos })
	
	local seq = cc.Sequence:create({ bz,bz1 })
	
	fish:setPosition( began_pos )
	
	fish:runAction( seq )
end
-- 小鱼串，从左出现，右消失----三条贝塞尔曲线
function FishLine:line11( fish )
	local x_began = -(display.width / 8)
	local y_began = random( 100,display.height - 100 )
	local began_pos = cc.p( x_began,y_began )
	
	local x_first = display.width / 8
	local y_first = y_began + 250
	local first_pos = cc.p( x_first,y_first )
	local x_second = display.width * 2 / 8
	local y_second = y_began - 250
	local second_pos = cc.p( x_second,y_second )
	local x_end = display.width * 3 / 8
	local y_end = y_began
	local end_pos = cc.p( x_end,y_end )
	local bz = cc.BezierTo:create(15,{ first_pos,second_pos,end_pos })

	x_first = display.width * 4 / 8
	y_first = y_began + 250
	first_pos = cc.p( x_first,y_first )
	x_second = display.width * 5 / 8
	y_second = y_began - 250
	second_pos = cc.p( x_second,y_second )
	x_end = display.width * 6 / 8
	y_end = y_began
	end_pos = cc.p( x_end,y_end )
	local bz1 = cc.BezierTo:create(15,{ first_pos,second_pos,end_pos })

	x_first = display.width * 7 / 8
	y_first = y_began + 250
	first_pos = cc.p( x_first,y_first )
	x_second = display.width * 8 / 8
	y_second = y_began - 250
	second_pos = cc.p( x_second,y_second )
	x_end = display.width + display.width / 8
	y_end = y_began
	end_pos = cc.p( x_end,y_end )
	local bz2 = cc.BezierTo:create(15,{ first_pos,second_pos,end_pos })
	
	local seq = cc.Sequence:create({ bz,bz1,bz2 })
	
	fish:setPosition( began_pos )
	
	fish:runAction( seq )
end

return FishLine