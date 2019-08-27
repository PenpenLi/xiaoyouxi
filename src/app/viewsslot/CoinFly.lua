
-- Author: 	刘阳
-- Date: 	2019-03-28
-- Desc:	金币飞的动画

local CoinNode = require("app.viewsslot.CoinNode")
local CoinFly = class("CoinFly",function()
	return cc.Node:create()
end)



function CoinFly:ctor( startPoint,endPoint,callBack,rate )
	-- 添加
	cc.SpriteFrameCache:getInstance():addSpriteFrames("csbslot/hall/coin_fly.plist")
	self:setContentSize( display.width,display.height )

	self._startPoint = startPoint
	self._endPoint = endPoint
	self._callBack = function()
		if callBack then
			callBack()
		end
		self:removeFromParent()
	end
	self._rate = rate

	-- 金币飞的动画
	self:flyAction()
	-- 添加闪烁的星星
	self:starAction()

	local is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		audio.playSound("csbslot/hall/hmp3/sound_daily_wheel_coin_fly.mp3",false)
	end
end

function CoinFly:flyAction()
	local coin_num = 15
	for i = 1,coin_num do
		local coin_node = CoinNode.new()
		self:addChild( coin_node )
		coin_node:flyAction( self._startPoint,self._endPoint,i,coin_num,self._callBack,self._rate )
	end
end

function CoinFly:starAction()
	local x_min,x_max = 0,0
	if self._startPoint.x >= self._endPoint.x then
		x_min = self._endPoint.x
		x_max = self._startPoint.x
	else
		x_min = self._startPoint.x
		x_max = self._endPoint.x
	end
	local y_min,y_max = 0,0
	if self._startPoint.y >= self._endPoint.y then
		y_min = self._endPoint.y
		y_max = self._startPoint.y
	else
		y_min = self._startPoint.y
		y_max = self._endPoint.y
	end

	for i = 1,40 do
		local random_num = random(1,10)
		local star = nil
		if random_num % 2 == 0 then
			star = ccui.ImageView:create("star.png",1)
		else
			star = ccui.ImageView:create("star2.png",1)
		end
		star:setPosition(cc.p(random(x_min,x_max),random(y_min,y_max)))
		self:addChild( star )
		star:setVisible( false )
		star:setOpacity( 0 )
		local tinto = cc.TintTo:create( 0.1,255,255,0 )
		local call_show = cc.CallFunc:create( function()
			star:setVisible( true )
		end )
		local delay = cc.DelayTime:create( random(1,20) / 10 )
		local fade_in = cc.FadeIn:create( 0.5 )
		local fade_out = cc.FadeOut:create(  0.5 )
		local remove = cc.RemoveSelf:create()
		local seq1 = cc.Sequence:create({ tinto,call_show,delay,fade_in,fade_out,remove })
		star:runAction( seq1 )
	end
end


return CoinFly