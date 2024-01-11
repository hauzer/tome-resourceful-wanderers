_M = loadPrevious(...)


local base_learnTalentType = _M.learnTalentType
function _M:learnTalentType(tt, v)
    local resourceful_wanderers = self.hauzer.resourceful_wanderers
    if not resourceful_wanderers then
        return base_learnTalentType(self, tt, v)
    end

    if not resourceful_wanderers:owns_talent_type_id(tt) then
        local supporting_talent_type = resourceful_wanderers:get_supporting_talent_type(tt)
        if supporting_talent_type then
            resourceful_wanderers:cover_area(supporting_talent_type, base_learnTalentType)
        end

        -- If the player learned a category which contains a wanderer talent, remove it from the wanderer category, possibly removing the whole category
        for _, talent in ipairs(self.talents_types_def[tt].talents) do
            resourceful_wanderers:disown_talent_id(talent.id)
        end
    end

    return base_learnTalentType(self, tt, v)
end

local base_canLearnTalent = _M.canLearnTalent
function _M:canLearnTalent(t, offset, ignore_special)
    local resourceful_wanderers = self.hauzer.resourceful_wanderers
    if not self.hauzer.resourceful_wanderers then
        return base_canLearnTalent(self, t, offset, ignore_special)
    end

    return resourceful_wanderers:with_freestanding_wanderer_talent(t, function()
        return base_canLearnTalent(self, t, offset, ignore_special)
    end)
end

local base_getTalentReqDesc = _M.getTalentReqDesc
function _M:getTalentReqDesc(t_id, levmod)
    local resourceful_wanderers = self.hauzer.resourceful_wanderers
    if not resourceful_wanderers then
        return base_getTalentReqDesc(self, t_id, levmod)
    end

    return resourceful_wanderers:with_freestanding_wanderer_talent(self.talents_def[t_id], function()
        return base_getTalentReqDesc(self, t_id, levmod)
    end)
end


return _M
