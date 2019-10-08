

local Person = class("Person",BaseNode)

Person.ACTION_TYPE = {
	IDLE = 0,
	RUN = 1,
	ATTACK = 2
}


function Person:ctor( id,gameLayer )
	assert( id," !! id is nil !! " )
	assert( gameLayer," !! gameLayer is nil !! " )
	Person.super.ctor( self,"Person" )
	self._id = id
	self._gameLayer = gameLayer
	self._config = nil
	self._attackImgIndex = { 1,2,3,4,5,10,11,12,13,14 }
	self:initConfig()
	self:createIcon()
	self._hp = self._config.hp
	self._status = self.ACTION_TYPE.IDLE
end


function Person:initConfig()

end


function Person:createIcon()
	self._icon = ccui.ImageView:create(self._config.path.."01.png",1)
	self:addChild( self._icon )
	self._scheduleTime = 0.18
end


function Person:onEnter()
	Person.super.onEnter( self )
	self:schedule( function()
		self:aiLogic()
	end,0.02 )
end

function Person:aiLogic()
end


function Person:playRunAction()
	if self._status == self.ACTION_TYPE.RUN then
		return
	end
	self._status = self.ACTION_TYPE.RUN
	local index = 6
	self._icon:stopAllActions()
	schedule( self._icon,function()
		local path = self._config.path..string.format("%02d.png",index)
		self._icon:loadTexture( path,1 )
		index = index + 1
		if index > 9 then
			index = 6
		end
	end,self._scheduleTime )
end

function Person:playAttackAction()
	if self._status == self.ACTION_TYPE.ATTACK then
		return
	end
	self._status = self.ACTION_TYPE.ATTACK
	local index = 1
	self._icon:stopAllActions()
	schedule( self._icon,function()
		local path = self._config.path..string.format("%02d.png",self._attackImgIndex[index])
		self._icon:loadTexture( path,1 )
		index = index + 1
		if index > #self._attackImgIndex then
			index = 1
		end
	end,self._scheduleTime )
end


function Person:getHp()
	return self._hp
end




return Person