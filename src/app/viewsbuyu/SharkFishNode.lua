

local SharkFishNode = class("SharkFishNode",BaseNode)


function SharkFishNode:ctor()
	SharkFishNode.super.ctor( self,"SharkFishNode" )

	local fish = ccui.ImageView:create("fish1_3/0.png")
	self:addChild( fish )
	self._fish = fish
end



function SharkFishNode:onEnter()
	SharkFishNode.super.onEnter( self )

	local index = 1
	local last_point = cc.p( 0,0 )
	self:schedule( function()
		if index % 10 == 0 then
			-- print( "-----------index = "..index)
			local num = index / 10
			-- print( "-----------num = "..num)
			local path = "fish1_3/"..num..".png"
			self._fish:loadTexture( path )
		end
		-- dump(path,"--------------path = ")
		
		

		local cur_point = cc.p( self:getPosition() )
		local x = cur_point.x - last_point.x
		local y = cur_point.y - last_point.y
		local k = math.atan2( y,x )
		local r = 90 - k * 180 / math.pi
		-- local k = math.atan2( cur_point.y,cur_point.x )
		self:setRotation( r )
		last_point = clone( cur_point )

		index = index + 1
		if index > 119 then
			index = 0
		end
	end,0.02 )
end







return SharkFishNode