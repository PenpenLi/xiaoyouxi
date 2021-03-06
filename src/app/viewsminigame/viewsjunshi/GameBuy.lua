
local GameBuy = class("GameBuy",BaseLayer)


GameBuy.COIN = {
    30,
    60,
    100
}

GameBuy.QIAN = {
    6,
    12,
    18
}

function GameBuy:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameBuy.super.ctor( self,param.name )
    self._layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ))
    self:addChild( self._layer )

    self._param = param

    self._index = param.data

    self:addCsb( "Buy.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
    
    -- 购买
    self:addNodeClick( self.ButtonBuy,{ 
        endCallBack = function() self:buy() end
    })
end


function GameBuy:onEnter()
    GameBuy.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    casecadeFadeInNode( self._layer,0.5,150 )

    -- 设置文本
    if js_card_lang == 1 then
        self.Text_1:setString( string.format("Does it cost $%s",self.QIAN[ self._index ]) )
        self.Text_2:setString( string.format("to buy %s copper coins?",self.COIN[ self._index ]) )
    else
        self.Text_1:setString( string.format("是否花费 ￥%s",self.QIAN[ self._index ]) )
        self.Text_2:setString( string.format("购买 %s 铜币?",self.COIN[ self._index ]) )
    end
end

function GameBuy:buy()
    -- 调用sdk

    -- 这里是用于测试 请在调用完sdk后 回调 buyCoinCallBack 
    self:buyCoinCallBack()
end

-- 购买完金币后的回调
function GameBuy:buyCoinCallBack()
    local add_coin = self.COIN[ self._index ]
    G_GetModel("Model_JunShi"):setCoin( add_coin )
end

-- 关闭
function GameBuy:close()
    removeUIFromScene( UIDefine.MINIGAME_KEY.JunShi_Buy_UI )
end




return GameBuy