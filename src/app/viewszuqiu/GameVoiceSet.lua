

local GameVoiceSet = class( "GameVoiceSet",BaseLayer )


function GameVoiceSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameVoiceSet.super.ctor( self,param.name )


    self:addCsb( "csbzuqiu/Set.csb" )
	
	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end}
	)


	self:loadUi()
end

function GameVoiceSet:loadUi()
	-- local state = G_GetModel("Model_Sound"):get
end

function GameVoiceSet:close()
	removeUIFromScene( UIDefine.ZUQIU_KEY.Voice_UI )
end









return GameVoiceSet