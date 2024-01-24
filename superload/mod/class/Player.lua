_M = loadPrevious(...)


local base_knowTalentType = _M.knowTalentType
function _M:knowTalentType(talent_type_id)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if self.is_generating_list == nil or not self.is_generating_list or not resourceful_wanderers.is_active then
        return base_knowTalentType(self, talent_type_id)
    end

    local retval = base_knowTalentType(self, talent_type_id)
    if retval ~= nil then
        local tome_talent_type = self.talents_types_def[talent_type_id]

        for i, talent in ipairs(tome_talent_type.talents) do
            if resourceful_wanderers:is_talent_type_from_area(talent_type_id) then
                if talent.orig_levelup_screen_break_line == nil then
                    if talent.levelup_screen_break_line == nil then
                        talent.orig_levelup_screen_break_line = false
                    else
                        talent.orig_levelup_screen_break_line = talent.levelup_screen_break_line
                    end
                end

                talent.levelup_screen_break_line = i % 4 == 0 and i < #tome_talent_type.talents
            elseif talent.orig_levelup_screen_break_line ~= nil then
                talent.levelup_screen_break_line = talent.orig_levelup_screen_break_line
                talent.orig_levelup_screen_break_line = nil
            end
        end
    end

    return retval
end


local base_learnTalentType = _M.learnTalentType
function _M:learnTalentType(tt, v)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if not resourceful_wanderers.is_active then
        return base_learnTalentType(self, tt, v)
    end

    local retval = base_learnTalentType(self, tt, v)
    if not retval then
        return retval
    end

    resourceful_wanderers:unmanage_talent_type(tt)
    for _, covering_area in ipairs(resourceful_wanderers:find_covering_areas_for_talent_type(tt)) do
        resourceful_wanderers:cover_area(covering_area)
    end

    return retval
end

local base_numberKnownTalent = _M.numberKnownTalent
function _M:numberKnownTalent(type, ...)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if not resourceful_wanderers.is_active then
        return base_numberKnownTalent(self, type, ...)
    end

	local retval = base_numberKnownTalent(self, type, ...)

    for _, talent in ipairs(self.talents_types_def[type].talents) do
        if not self:knowTalent(talent.id) then
            if resourceful_wanderers:knows_competing_mastery_talent(talent.id) then
                retval = retval + 1
            end
        end
    end

    return retval
end

local base_canLearnTalent = _M.canLearnTalent
function _M:canLearnTalent(t, offset, ignore_special)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if not resourceful_wanderers.is_active then
        return base_canLearnTalent(self, t, offset, ignore_special)
    end

    return resourceful_wanderers:with_managed_talent(t, function(talent_type, ...)
        local can_learn = base_canLearnTalent(self, t, offset, ignore_special)

        if can_learn and not self:knowTalent(t.id) then
            return not resourceful_wanderers:knows_competing_mastery_talent(t.id) and not resourceful_wanderers:is_talent_type_at_limit(talent_type)
        end

        return can_learn
    end)
end

local base_getTalentReqDesc = _M.getTalentReqDesc
function _M:getTalentReqDesc(t_id, levmod)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if not resourceful_wanderers.is_active then
        return base_getTalentReqDesc(self, t_id, levmod)
    end

    return resourceful_wanderers:with_managed_talent(self.talents_def[t_id], function(talent_type, _, tome_talent)
        local tome_talent_original_required_lower = tome_talent.type[2]
        for _, sibling_talent in ipairs(self.talents_types_def[tome_talent.type[1]].talents) do
            if sibling_talent.id == t_id then
                break
            end

            if resourceful_wanderers:knows_competing_mastery_talent(sibling_talent.id) then
                tome_talent.type[2] = tome_talent.type[2] - 1
            end
        end

        local str = base_getTalentReqDesc(self, t_id, levmod)

        tome_talent.type[2] = tome_talent_original_required_lower

        if not self:knowTalent(t_id) then
            if resourceful_wanderers:does_talent_type_have_limit(talent_type) then
                str:add(
                    (not resourceful_wanderers:is_talent_type_at_limit(talent_type) and {'color', 0x00,0xff,0x00} or {'color', 0xff,0x00,0x00}),
                    _t'- Less than ' .. talent_type.talent_learn_limit .. _t' talents known in this category',
                    true
                )
            end

            if #resourceful_wanderers:get_competing_mastery_talents(t_id) > 0 then
                str:add(
                    (not resourceful_wanderers:knows_competing_mastery_talent(t_id) and {'color', 0x00,0xff,0x00} or {'color', 0xff,0x00,0x00}),
                    _t'- No other talents covering this weapon mastery known',
                    true
                )
            end
        end

        return str
    end)
end

local base_getTalentMastery = _M.getTalentMastery
function _M:getTalentMastery(t)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if not resourceful_wanderers.is_active then
        return base_getTalentMastery(self, t)
    end

    return resourceful_wanderers:with_managed_talent(t, function(...)
        return base_getTalentMastery(self, t)
    end)
end


return _M
