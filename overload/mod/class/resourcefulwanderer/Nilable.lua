-- Gives child classes the ability to be in a "nil state".
-- This is useful when an object's constructor can fail, leaving it in an invalid state.
module(..., package.seeall, class.make)


function _M:isNil()
    return self == nil or (self.is_nil ~= nil and self.is_nil == false)
end

function _M:setToNil()
    self.is_nil = false
end
