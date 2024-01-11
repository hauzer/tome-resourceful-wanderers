_M = loadPrevious(...)


local subtleMessageWarningColor = { r=255, g=255, b=80 }


local base_learnType = _M.learnType
function _M:learnType(tt, v)
    local resourceful_wanderers = self.actor.hauzer.resourceful_wanderers
    if not resourceful_wanderers then
        return base_learnType(self, tt, v)
    end

    if v then
        -- Wanderer categories can't be improved
        if resourceful_wanderers:knows_talent_type_id(tt) then
            self:subtleMessage(_t"Impossible", _t"You cannot improve a Wanderer category mastery!", subtleMessageWarningColor)
            return
        end
    end

    return base_learnType(self, tt, v)
end


return _M
