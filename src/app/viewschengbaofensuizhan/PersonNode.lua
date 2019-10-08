

local PersonNode = class( "PersonNode",BaseNode )

function PersonNode:ctor( parent,personPath )
	assert( personPath," !! personPath is nil !! " )
	self._personPath = personPath

	self:addCsb( personPath )
	TouchNode.extends( self.Person,function ( event )
		return self:touchCard( event )
	end)
end

function PersonNode:touchCard( event )
	if event.name == "began" then
		self._touchPos = touch:getLocation()
        return true
    elseif event.name == "moved" then
		self._touchPos = touch:getLocation()
		self:setPosition( self._touchPos )
    elseif event.name == "ended" then
    	
    elseif event.name == "outsideend" then
    	
    end
end


















return PersonNode