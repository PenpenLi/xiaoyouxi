
local ChooseNode = import(".ChooseNode")
local GameChoose = class("GameChoose",BaseLayer)

function GameChoose:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameChoose.super.ctor( self,param.name )

    self:addCsb("csbfensuizhan/ChooseLayer.csb")

    self._level = 2 -- 当前关
    self._totalLevel = 5
    self:loadUi()
end

function GameChoose:loadUi(  )

	for i=1,self._totalLevel do
		local node = ChooseNode.new( i,self._level,self )
		self:addChild( node )
		node:setPosition(cc.p(display.width * i / (self._totalLevel + 1),display.height / 2))
	end
end

function GameChoose:onEnter()
	GameChoose.super.onEnter( self )
end












return GameChoose