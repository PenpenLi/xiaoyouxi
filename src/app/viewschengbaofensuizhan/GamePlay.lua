
local personNode = import(".PersonNode")
local GamePlay = class( "GamePlay",BaseLayer )

function GamePlay:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GamePlay.super.ctor( self,param.name )

	self:addCsb("csbchengbaofensuizhan/GamePlay.csb")

	self:loadPerson()
end

function GamePlay:loadPerson()
	dump( chengbao_config.person[1].path,"---------------------------")
	local person = personNode.new( self,chengbao_config.person[1].path )
	self.PersonNode:addChild( person )
end












return GamePlay