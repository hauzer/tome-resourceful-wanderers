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

local base_numberKnownTalent = _M.numberKnownTalent
function _M:numberKnownTalent(type, ...)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if not resourceful_wanderers.is_active then
        return base_numberKnownTalent(self, type, ...)
    end

	local retval = base_numberKnownTalent(self, type, ...)

    for _, talent in ipairs(self.talents_types_def[type].talents) do
        if not self:knowTalent(talent.id) then
            local knows_competing_talent = false
            for _, competing_talent in ipairs(resourceful_wanderers:get_competing_mastery_talents(talent.id)) do
                if self:knowTalent(competing_talent) then
                    knows_competing_talent = true
                    break
                end
            end

            if knows_competing_talent then
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
            local did_hit_talent_limit =
                talent_type ~= nil and
                talent_type.talent_learn_limit ~= nil and
                (resourceful_wanderers:get_talent_type_number_of_known_talents(talent_type.name) >= talent_type.talent_learn_limit)

            local knows_competing_mastery_talents = false
            local competing_mastery_talents = resourceful_wanderers:get_competing_mastery_talents(t.id)
            if #competing_mastery_talents > 0 then
                for _, competing_talent_id in ipairs(competing_mastery_talents) do
                    if self:knowTalent(competing_talent_id) then
                        knows_competing_mastery_talents = true
                        break
                    end
                end
            end

            return can_learn and not knows_competing_mastery_talents and not did_hit_talent_limit
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
        local tome_talent_type_2 = tome_talent.type[2]
        for _, sibling_talent in ipairs(self.talents_types_def[tome_talent.type[1]].talents) do
            if sibling_talent.id == t_id then
                break
            end

            local knows_competing_talent = false
            for _, competing_talent_id in ipairs(resourceful_wanderers:get_competing_mastery_talents(sibling_talent.id)) do
                if self:knowTalent(competing_talent_id) then
                    knows_competing_talent = true
                    break
                end
            end

            if knows_competing_talent then
                tome_talent.type[2] = tome_talent.type[2] - 1
            end
        end

        local str = base_getTalentReqDesc(self, t_id, levmod)

        tome_talent.type[2] = tome_talent_type_2

        if not self:knowTalent(t_id) then
            if talent_type ~= nil and talent_type.talent_learn_limit ~= nil then
                local did_hit_talent_limit = resourceful_wanderers:get_talent_type_number_of_known_talents(talent_type.name) >= talent_type.talent_learn_limit
                str:add((not did_hit_talent_limit and {'color', 0x00,0xff,0x00} or {'color', 0xff,0x00,0x00}), _t'- Less than ' .. talent_type.talent_learn_limit .. _t' talents known in this category', true)
            end

            local competing_mastery_talents = resourceful_wanderers:get_competing_mastery_talents(t_id)
            if #competing_mastery_talents > 0 then
                local knows_competing_mastery_talents = false
                for _, competing_talent_id in ipairs(competing_mastery_talents) do
                    if self:knowTalent(competing_talent_id) then
                        knows_competing_mastery_talents = true
                        break
                    end
                end

                str:add((not knows_competing_mastery_talents and {'color', 0x00,0xff,0x00} or {'color', 0xff,0x00,0x00}), _t'- No other talents covering this weapon mastery known', true)
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
