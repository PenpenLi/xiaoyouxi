
local MainGame = class("MainGame",BaseLayer)


function MainGame:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    MainGame.super.ctor( self,param.name )
end




function MainGame:onEnter()
	MainGame.super.onEnter( self )
	-- 设置物理边界
	self:setPhysicsBoundary()
	self:loadDataUI()
end


-- 设置物理边界
function MainGame:setPhysicsBoundary()
	-- 整个区域
	local size = display.size
    local body = cc.PhysicsBody:createEdgeBox(size,cc.PHYSICSBODY_MATERIAL_DEFAULT,2)
    local edgeNode = display.newNode()
    edgeNode:setPosition(size.width/2,size.height/2)
    edgeNode:setPhysicsBody(body)
    self:addChild(edgeNode)
end

function MainGame:loadDataUI()
	local img1 = ccui.ImageView:create("frame/role1/idle/1.png")
	self:addChild( img1 )
	img1:setPosition( display.cx - 300,display.cy - 300 )
	local material = {density = 1, restitution = 0, friction = 0}
	local oneBody = cc.PhysicsBody:createBox(img1:getContentSize(),material,cc.p(0,0))  --矩形刚体
	-- 设置为静态缸体
	oneBody:setDynamic(true);
	-- oneBody:setContactTestBitmask(0xFFFFFFFF)
    -- oneBody:applyImpulse(cc.p(0,10000))

    img1:setPhysicsBody(oneBody)
    local move_by = cc.MoveBy:create(5,cc.p( 500,0))
    img1:runAction( move_by )


    local img2 = ccui.ImageView:create("frame/role1/idle/1.png")
	self:addChild( img2 )
	img2:setPosition( display.cx + 300,display.cy - 300 )
	local material2 = {density = 1, restitution = 0, friction = 0}
	local oneBody2 = cc.PhysicsBody:createBox(img2:getContentSize(),material2,cc.p(0,0))  --矩形刚体
	oneBody2:setDynamic(false);
	oneBody2:getShape(0):setMass(5000);
	-- oneBody2:setGravityEnable( false )

	-- oneBody2:setContactTestBitmask(0xFFFFFFFF)
    -- oneBody2:applyImpulse(cc.p(0,10000))
    img2:setPhysicsBody(oneBody2)
end













return MainGame