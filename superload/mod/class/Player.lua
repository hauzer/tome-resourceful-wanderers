_M = loadPrevious(...)


local base_init = _M.init
function _M:init(t, no_default)
    local retval = base_init(self, t, no_default)

    if not self.hauzer then
        self.hauzer = { }
    end

    return retval
end

local base_learnTalentType = _M.learnTalentType
function _M:learnTalentType(tt, v)
    local resourceful_wanderers = self.hauzer.resourceful_wanderers
    if not resourceful_wanderers then
        return base_learnTalentType(self, tt, v)
    end

    local supporting_talent_type = resourceful_wanderers:get_supporting_talent_type(tt)
    if supporting_talent_type then
        resourceful_wanderers:cover_area(supporting_talent_type)
    end

    -- If the player learned a category which contains a wanderer talent, remove it from wanderer categories
    -- (excluding the learned one), possibly removing the whole category
    for _, talent in ipairs(self.talents_types_def[tt].talents) do
        resourceful_wanderers:disown_talent_id(talent.id,  { tt })
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

local base_getTalentMastery = _M.getTalentMastery
function _M:getTalentMastery(talent)
    local resourceful_wanderers = self.hauzer.resourceful_wanderers
    if not resourceful_wanderers then
        return base_getTalentMastery(self, talent)
    end

    local talent_type = resourceful_wanderers:get_known_talent_type_for_talent_id(talent.id)
    if talent_type then
        local orig_talent_type = talent.type[1]
        talent.type[1] = talent_type.name

        local retval = base_getTalentMastery(self, talent)

        talent.type[1] = orig_talent_type
        return retval
    end

    return base_getTalentMastery(self, talent)
end


return _M
