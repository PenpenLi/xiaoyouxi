

local GameZhiPaiHelp = class( "GameZhiPaiHelp",BaseLayer )


function GameZhiPaiHelp:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameZhiPaiHelp.super.ctor( self,param.name )--执行父类的构造函数

    self._param = param

	local layer =cc.LayerColor:create(cc.c4b(0,0,0,150))
	self:addChild( layer )
	self._layer = layer

	self:addCsb( "csbheji/csbzhipai/Help.csb" )

	self:addNodeClick( self.ButtonHelpClose,{
		endCallBack = function ()
			self:close()
		end
	})
end


function GameZhiPaiHelp:onEnter()
    GameZhiPaiHelp.super.onEnter( self )
    casecadeFadeInNode( self.ImageHelpBg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end


function GameZhiPaiHelp:close()
	removeUIFromScene( UIDefine.HEJI_KEY.ZhiPai_Help_UI )
	-- body
end





return GameZhiPaiHelp