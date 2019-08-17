


local GameZhuanPan = class( "GameZhuanPan",BaseLayer )


function GameZhuanPan:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameZhuanPan.super.ctor( self,param.name ) -----------------------一句话五小时。。。。。

	self:addCsb( "csbslot/TurnTable.csb" )

	self:addNodeClick( self.ButtonSpin11,{
		endCallBack = function ()
			self:turnBegan()
		end
	})
end

function GameZhuanPan:onEnter()
	GameZhuanPan.super.onEnter( self )


end


function GameZhuanPan:turnBegan()
	
	local turn_num = 5
	local rot = random( 1,15 )
	local delay = cc.DelayTime:create( 0.1)
	local rotate_began = cc.RotateBy:create( 0.5,-15 )
	local rotate = cc.RotateBy:create( 4,360 * turn_num + rot * 24 + 30)
	local rotate_end = cc.RotateBy:create( 0.5,-15 )
	local easeSineInOut = cc.EaseSineInOut:create( rotate )
	local call = cc.CallFunc:create(function ()
		print("-------------------123")
		self:playCsbAction( "zhongjiang",true )
	end)
	local seq = cc.Sequence:create({ delay,rotate_began,easeSineInOut,rotate_end,call })
	
	self.Bg3:runAction( seq )
	-- local rot_began = 90
	local index = 0
	local rot_began = self.Bg3:getRotation()

	self:schedule(function ()
		
		local rot_last = self.Bg3:getRotation()
		local rot = rot_last - rot_began
		local num = rot / 24

		if num > 1 then
			local bool_go = true
			while bool_go do
				index = index + 1
				num = num - 1
				rot_began = rot_began + 24
				if num < 1 then
					bool_go = false
				end
			end
		end

		-- if num > 1 then
		-- 	print("---------------------00000000")
		-- 	while num < 1 do----------------------------------------------------------这个循环为什么进不去？？？
		-- 		print("---------------------11111")
		-- 		index = index + 1
		-- 		print("---------------------index = "..index)
		-- 		num = num - 1
		-- 		print("---------------------numnum = "..num)
		-- 		rot_began = rot_began + 24
		-- 	end
		-- end
		-- while num < 1 do
		-- 	print("---------------------11111")
		-- 	index = index + 1
		-- 	print("---------------------index = "..index)
		-- 	num = num - 1
		-- 	print("---------------------numnum = "..num)
		-- 	rot_began = rot_began + 24
		-- end
		if index > 3 then
			index = 3
		end
		-- local hand_rot = index * 20
		-- if hand_rot < 30 then
		-- 	hand_rot = 30
		-- end
		-- if hand_rot > 90 then
		-- 	hand_rot = 90
		-- end		
		self.ImageZhiZhen:setRotation( 90 - index * 20 )
		if index == 3 then
			print("---------------------111111111111111")
			self:zhizhen()
		end

		
		if index >= 1 then
			index = index - 1
		end
		
		
		-- local rot_last = self.Bg3:getRotation()
		-- local rot = rot_began - rot_last
		-- if rot >= 90 then
		-- 	self.ImageZhiZhen:setRotation( 90 )
		-- elseif rot <= 30 then
		-- 	self.ImageZhiZhen:setRotation( 30 )
		-- else
		-- 	self.ImageZhiZhen:setRotation( rot )
		-- end
		-- -- rot_began = rot_began + 8
		-- print("---------------------rot = "..rot)
	end,0.1)
end
function GameZhuanPan:zhizhen()
	self.ImageZhiZhen:setRotation( 30 )
	local rotate1 = cc.RotateTo:create( 0.05,35 )
	local rotate2 = cc.RotateTo:create( 0.05,30 )
	local seq = cc.Sequence:create({ rotate1,rotate1 })
	self.ImageZhiZhen:runAction( seq )
end































return GameZhuanPan