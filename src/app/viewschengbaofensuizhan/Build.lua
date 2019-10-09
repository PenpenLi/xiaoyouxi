

local Build = class("Build",BaseNode)


function Build:ctor( id,gameLayer )
	assert( id," !! id is nil !! " )
	assert( gameLayer," !! gameLayer is nil !! " )
	Build.super.ctor( self,"Build" )

	self._id = id
	self._gameLayer = gameLayer

	self:initConfig()
	self:createIcon()

	self._hp = self._config.hp
end

function Build:initConfig()
	self._config = chengbao_config.build[self._id]
end

function Build:createIcon()
	self._icon = ccui.ImageView:create( self._config.path )
	self:addChild( self._icon )
	-- self._icon:setAnchorPoint( cc.p( 1,0 ) )
end


-- 受到攻击
function Build:beAttacked( harmValue )
	assert( harmValue," !! harmValue is nil  !! ")
	self._hp = self._hp - harmValue

	-- 播放受到攻击的动画
	self:beAttackedAction()
	if self._hp <= 0 then
		self:dead()
	end
end

function Build:beAttackedAction()
	if self._playBeAttackedActionMark then
		return
	end
	self._playBeAttackedActionMark = true
	local tinto1 = cc.TintTo:create(0.2, 255, 0, 0)
	local tinto2 = cc.TintTo:create(0.1, 255, 255, 255)
	local call_end = cc.CallFunc:create( function()
		self._playBeAttackedActionMark = nil
	end )
	self:runAction( cc.Sequence:create({ tinto1,tinto2,call_end }) )
end

-- 销毁
function Build:dead()
	-- 播放销毁动画
	print("-------------->建筑销毁")
end


function Build:getHp()
	return self._hp
end



return Build