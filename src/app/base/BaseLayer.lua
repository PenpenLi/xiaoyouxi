
--[[
    基础构造的layer
]]

local BaseLayer = class("BaseLayer",BaseNode )

function BaseLayer:ctor( name )
    self:setContentSize(cc.size( display.width,display.height ))
    self:registTouchEvent()
    BaseLayer.super.ctor(self,name)

    self._nodeClickRegist = {}
end

function BaseLayer:addCsb( fileName,zOrder )
    assert( fileName," !! fileName is nil !! ")
    if self._csbNode then
        return
    end
    self._csbNode,self._csbAct = CSBUtil.readLayerCSB( fileName,self )
    
    if zOrder then
        self:addChild( self._csbNode,zOrder )
    else
        self:addChild( self._csbNode )
    end
end

function BaseLayer:onEnter()
    BaseLayer.super.onEnter( self )
end

function BaseLayer:onExit()
    BaseLayer.super.onExit( self )
end


--[[
    以下四个方法是处理触摸的点击
]]
function BaseLayer:registTouchEvent()
    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(true)
    self.listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.listener:registerScriptHandler(handler(self, self.onTouchCancelled), cc.Handler.EVENT_TOUCH_CANCELLED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)
end
function BaseLayer:onTouchBegan( touch, event )
    return true
end
function BaseLayer:onTouchMoved( touch, event )
    
end
function BaseLayer:onTouchEnded( touch, event )
    
end
function BaseLayer:onTouchCancelled( touch, event )
    
end

function BaseLayer:removeNodeClick( node )
    assert( node," !! node is nil !! " )
end


rawset(_G, "BaseLayer", BaseLayer)
