_M = loadPrevious(...)


local base_learnTalentType = _M.learnTalentType
function _M:learnTalentType(tt, v)
    local resourceful_wanderers = game:get_resourceful_wanderers()

    local retval = base_learnTalentType(self, tt, v)
    if resourceful_wanderers.is_active then
        resourceful_wanderers:after_learnTalentType(tt)
    end
    return retval
end

local base_canLearnTalent = _M.canLearnTalent
function _M:canLearnTalent(t, offset, ignore_special)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if not resourceful_wanderers.is_active then
        return base_canLearnTalent(self, t, offset, ignore_special)
    end

    return resourceful_wanderers:with_managed_talent(t, function()
        return base_canLearnTalent(self, t, offset, ignore_special)
    end)
end

local base_getTalentReqDesc = _M.getTalentReqDesc
function _M:getTalentReqDesc(t_id, levmod)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if not resourceful_wanderers.is_active then
        return base_getTalentReqDesc(self, t_id, levmod)
    end

    return resourceful_wanderers:with_managed_talent(self.talents_def[t_id], function()
        return base_getTalentReqDesc(self, t_id, levmod)
    end)
end

local base_getTalentMastery = _M.getTalentMastery
function _M:getTalentMastery(t)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if not resourceful_wanderers.is_active then
        return base_getTalentMastery(self, t)
    end

    return resourceful_wanderers:with_managed_talent(t, function()
        return base_getTalentMastery(self, t)
    end)
end


return _M
