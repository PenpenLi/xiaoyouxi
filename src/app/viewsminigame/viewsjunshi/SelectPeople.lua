


local SelectPeople = class("SelectPeople",BaseLayer)



function SelectPeople:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    SelectPeople.super.ctor( self,param.name )
    self:addCsb( "SelectPeople.csb" )

    for i = 1,6 do
    	self:addNodeClick( self["Button"..i],{ 
	        endCallBack = function() self:clickSelect( i ) end
	    })
    end
end



function SelectPeople:clickSelect( index )
	removeUIFromScene( UIDefine.MINIGAME_KEY.JunShi_Select_UI )
	addUIToScene( UIDefine.MINIGAME_KEY.JunShi_Play_UI,index )
end


















return SelectPeople