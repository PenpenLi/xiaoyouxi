

local GameHelp = class( "GameHelp",BaseLayer )

function GameHelp:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameHelp.super.ctor( self,param.name )

    self:addCsb( "csbzuqiu/Help.csb" )
    self.ImagePoker:ignoreContentAdaptWithSize( true )--换图时忽略大小。

    self._curPageIndex = 1

    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end,
    })

    self:addNodeClick( self.ButtonNext,{ 
        endCallBack = function() self:next() end,
    })

    self:addNodeClick( self.ButtonPrevious,{ 
        endCallBack = function() self:previous() end,
    })

    self:loadUi()
end

function GameHelp:next(  )
	self._curPageIndex = self._curPageIndex + 1
	self:loadUi()
end

function GameHelp:previous(  )
	self._curPageIndex = self._curPageIndex - 1
	self:loadUi()
end

function GameHelp:loadUi(  )
	if self._curPageIndex == 1 then
		self.ImagePoker:loadTexture( "image/help/compare.png",1 )
		self.ImageText:loadTexture( "image/help/daxiaotext.png",1 )
		self.ImageOne:loadTexture( "image/help/lv1.png",1 )
		self.ImageTwo:loadTexture( "image/help/lan2.png",1 )
		self.ImageThree:loadTexture( "image/help/lan3.png",1 )
		self.ButtonPrevious:setVisible( false )
		self.ButtonNext:loadTexture( "image/lose/next.png",1 )
		self.ImageLong:setVisible( false )
		self.ImageHg1:setVisible( true )
		self.ImageHg:setVisible( false )
		self.ImagePax:setVisible( false )
	elseif self._curPageIndex == 2 then
		self.ImagePoker:loadTexture( "image/help/tonghua.png",1 )
		self.ImageText:loadTexture( "image/help/tonghuatext.png",1 )
		self.ImageOne:loadTexture( "image/help/lan1.png",1 )
		self.ImageTwo:loadTexture( "image/help/lv2.png",1 )
		self.ImageThree:loadTexture( "image/help/lan3.png",1 )
		self.ButtonPrevious:setVisible( true )
		self.ButtonNext:loadTexture( "image/lose/next.png",1 )
		self.ImageLong:setVisible( true )
		self.ImageHg1:setVisible( false )
		self.ImageHg:setVisible( true )
		self.ImagePax:setVisible( false )
	elseif self._curPageIndex == 3 then
		self.ImagePoker:loadTexture( "image/help/same.png",1 )
		self.ImageText:loadTexture( "image/help/sametext.png",1 )
		self.ImageOne:loadTexture( "image/help/lan1.png",1 )
		self.ImageTwo:loadTexture( "image/help/lan2.png",1 )
		self.ImageThree:loadTexture( "image/help/lv3.png",1 )
		self.ButtonPrevious:setVisible( true )
		self.ButtonNext:loadTexture( "image/help/gotit.png",1 )
		self.ImageLong:setVisible( false )
		self.ImageHg1:setVisible( false )
		self.ImageHg:setVisible( false )
		self.ImagePax:setVisible( true )
	elseif self._curPageIndex == 4 then
		self:close()
	end



end

function GameHelp:onEnter( ... )
	GameHelp.super.onEnter( self )
	casecadeFadeInNode( self.ImageBearLeft,0.5,200 )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self.ImageBearRight,0.5 )
end

function GameHelp:close(  )
	removeUIFromScene( UIDefine.ZUQIU_KEY.Help_UI )
end




return GameHelp