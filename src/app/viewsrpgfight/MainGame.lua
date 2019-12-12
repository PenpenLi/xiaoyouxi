
local PeopleSolider = import(".PeopleSolider")
local EnemySolider = import(".EnemySolider")
local MainGame = class("MainGame",BaseLayer)




function MainGame:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    MainGame.super.ctor( self,param.name )

    self:addCsb( "csbrpgfight/FightLayer.csb" )
    self._enemyList = {}
    self._peopleList = {}
    self.m_brackPos = {}
end


function MainGame:onEnter()
	MainGame.super.onEnter( self )
	self:loadBrick()

	-- 创建士兵
	local m_brickId = {col = 1,row = 1}
	local people = PeopleSolider.new(1,m_brickId,self)
	self:addChild(people)
	local m_pos = self:getBrackPos(1,1)
	people:setPosition(m_pos)
	table.insert(self._peopleList,people)

	-- 创建一个敌人
	local e_brickId = {col = 10,row = 5}
	local enemy = EnemySolider.new(1,e_brickId,self)
	self:addChild(enemy)
	local e_pos = self:getBrackPos(10,5)
	enemy:setPosition(e_pos)
	table.insert(self._enemyList,enemy)
end


-- 添加砖块
function MainGame:loadBrick()
	local brick_size = cc.size(160,160)
	local start_x,start_y = 100 + brick_size.width / 2,100 + brick_size.height / 2
	local col = 11
	local row = 6
	for i = 1,col do
		self.m_brackPos[i] = {}
		for j = 1,row do
			local img = ccui.ImageView:create("image/box_Pass.png",1)
			self:addChild( img )
			local x_pos = start_x + (i - 1) * brick_size.width
			local y_pos = start_y + (j - 1) * brick_size.height
			img:setPosition( x_pos,y_pos )
			img:setOpacity( 150 )
			self.m_brackPos[i][j] = cc.p( x_pos,y_pos )
		end
	end
end

-- 获取砖块的坐标
function MainGame:getBrackPos( col,row )
	assert( col," !! col is nil !! " )
	assert( row," !! row is nil !! " )
	return self.m_brackPos[col][row]
end

-- 创建士兵
function MainGame:createPeopleSolider(  )
	-- body
end





return MainGame