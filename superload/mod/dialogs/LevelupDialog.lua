_M = loadPrevious(...)


local subtleMessageWarningColor = { r=255, g=255, b=80 }


local base_learnType = _M.learnType
function _M:learnType(tt, v)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if self.actor ~= game.player or not resourceful_wanderers.is_active then
        return base_learnType(self, tt, v)
    end

    if v then
        -- Wanderer categories can't be improved
        if resourceful_wanderers:is_talent_type_from_area(tt) and self.actor:knowTalentType(tt) then
            self:subtleMessage(_t'Impossible', _t'You cannot improve a Wanderer category mastery!', subtleMessageWarningColor)
            return
        end
    end

    return base_learnType(self, tt, v)
end


local base_generateList = _M.generateList
function _M:generateList()
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if self.actor ~= game.player or not resourceful_wanderers.is_active then
        return base_generateList(self)
    end

    self.actor.is_generating_list = true
    local retval = base_generateList(self)
    self.actor.is_generating_list = false
    return retval
end


return _M
