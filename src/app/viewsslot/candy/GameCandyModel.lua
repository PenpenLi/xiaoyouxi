
local BaseModel = import("app.viewsslot.base.BaseGameModel")

local GameCandyModel = class("GameCandyModel",BaseModel)


function GameCandyModel:ctor( reelConfig )
	GameCandyModel.super.ctor( self,reelConfig )
end









return GameCandyModel