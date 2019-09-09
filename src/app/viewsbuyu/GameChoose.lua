


local GameChoose = class( "GameChoose",BaseLayer )

function GameChoose:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameChoose.super.ctor( self,param.name )

    self:addCsb( "csbbuyu/GameChoose.csb" )

    self:addNodeClick( self.ButtonLevel1,{
    	endCallBack = function ()
    		self:goGame1()
    	end
    })
    self:addNodeClick( self.ButtonLevel2,{
    	endCallBack = function ()
    		self:goGame2()
    	end
    })
    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
end

function GameChoose:onEnter( ... )
	GameChoose.super.onEnter( self )
end

function GameChoose:goGame1( ... )
	addUIToScene( UIDefine.BUYU_KEY.Play_UI,1 )
    removeUIFromScene( UIDefine.BUYU_KEY.Start_UI )
    removeUIFromScene( UIDefine.BUYU_KEY.Choose_UI )
end
function GameChoose:goGame2( ... )
	addUIToScene( UIDefine.BUYU_KEY.Play_UI,2 )
    removeUIFromScene( UIDefine.BUYU_KEY.Start_UI )
    removeUIFromScene( UIDefine.BUYU_KEY.Choose_UI )
end

function GameChoose:close( ... )
	removeUIFromScene( UIDefine.BUYU_KEY.Choose_UI )
end







return GameChoose