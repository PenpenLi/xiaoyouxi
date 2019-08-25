
local BaseModel = import("app.viewsslot.base.BaseGameModel")

local GameWolfModel = class("GameWolfModel",BaseModel)


function GameWolfModel:ctor( reelConfig )
	GameWolfModel.super.ctor( self,reelConfig )
end









return GameWolfModel