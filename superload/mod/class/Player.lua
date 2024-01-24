_M = loadPrevious(...)


local base_init = _M.init
function _M:init(...)
    base_init(self, ...)

    self.resourceful_wanderer_configuration = {
        to_load = {
            talent_types = {
                name_pools = {
                    'fire',
                    'electricity'
                },
                description_pools = {
                    'fire',
                    'electricity'
                },
                'explosives',
                'golemancy',
                'souls',
                'stone-alchemy'
            },
            areas = {
                'chronomancy/spellbinding',
                'corruption/heart-of-fire',
                'corruption/wrath',
                'psionic/charged-mastery',
                'psionic/discharge',
                'psionic/kinetic-mastery',
                'psionic/thermal-mastery',
                'spell/advanced-golemancy',
                'spell/explosives',
                'spell/storm',
                'spell/wildfire',
                'steamtech/magnetism',
                'technique/magical-combat',
                'wild-gift/higher-draconic',
                'alchemy',
                'bows',
                'combos',
                'entropy',
                'equilibrium',
                'guns',
                'insanity',
                'magic',
                'minions',
                'modded-guns',
                'psychic-guns',
                'shadows',
                'slings',
                'souls',
                'stealth',
                'steamsaws',
                'steamtech',
                'summons',
                'unarmed-mastery'
            },
            weapons_masteries = {
                'bow-and-sling',
                'shield',
                'steamgun',
                'strength-of-purpose'
            }
        }
    }
end


local base_learnTalentType = _M.learnTalentType
function _M:learnTalentType(tt, v)
    if self.resourceful_wanderer == nil then
        return base_learnTalentType(self, tt, v)
    end

    local retval = base_learnTalentType(self, tt, v)
    if not retval then
        return retval
    end

    self.resourceful_wanderer:unmanage_talent_type(tt)
    for _, covering_area in ipairs(self.resourceful_wanderer:find_covering_areas_for_talent_type(tt)) do
        self.resourceful_wanderer:cover_area(covering_area)
    end

    return retval
end


local base_numberKnownTalent = _M.numberKnownTalent
function _M:numberKnownTalent(type, ...)
    if self.resourceful_wanderer == nil then
        return base_numberKnownTalent(self, type, ...)
    end

	local retval = base_numberKnownTalent(self, type, ...)

    for _, talent in ipairs(self.talents_types_def[type].talents) do
        if not self:knowTalent(talent.id) and self.resourceful_wanderer:knowsCompetingMasteryTalent(talent.id) then
            retval = retval + 1
        end
    end

    return retval
end


local base_canLearnTalent = _M.canLearnTalent
function _M:canLearnTalent(t, offset, ignore_special)
    if self.resourceful_wanderer == nil then
        return base_canLearnTalent(self, t, offset, ignore_special)
    end

    return self.resourceful_wanderer:withManagedTalent(t, function(talent_type, ...)
        local can_learn = base_canLearnTalent(self, t, offset, ignore_special)

        if can_learn and not self:knowTalent(t.id) then
            return not self.resourceful_wanderer:knowsCompetingMasteryTalent(t.id) and not self.resourceful_wanderer:is_talent_type_at_limit(talent_type)
        end

        return can_learn
    end)
end


local base_getTalentReqDesc = _M.getTalentReqDesc
function _M:getTalentReqDesc(t_id, levmod)
    if self.resourceful_wanderer == nil then
        return base_getTalentReqDesc(self, t_id, levmod)
    end

    return self.resourceful_wanderer:withManagedTalent(self.talents_def[t_id], function(talent_type, _, tome_talent)
        local tome_talent_original_required_lower = tome_talent.type[2]
        for _, sibling_talent in ipairs(self.talents_types_def[tome_talent.type[1]].talents) do
            if sibling_talent.id == t_id then
                break
            end

            if self.resourceful_wanderer:knowsCompetingMasteryTalent(sibling_talent.id) then
                tome_talent.type[2] = tome_talent.type[2] - 1
            end
        end

        local str = base_getTalentReqDesc(self, t_id, levmod)

        tome_talent.type[2] = tome_talent_original_required_lower

        if not self:knowTalent(t_id) then
            if self.resourceful_wanderer:does_talent_type_have_limit(talent_type) then
                str:add(
                    (not self.resourceful_wanderer:is_talent_type_at_limit(talent_type) and {'color', 0x00,0xff,0x00} or {'color', 0xff,0x00,0x00}),
                    _t'- Less than ' .. talent_type.maximum_known_talents .. _t' talents known in this category',
                    true
                )
            end

            str:add(
                (not self.resourceful_wanderer:knowsCompetingMasteryTalent(t_id) and {'color', 0x00,0xff,0x00} or {'color', 0xff,0x00,0x00}),
                _t'- No other talents covering this weapon mastery known',
                true
            )
        end

        return str
    end)
end


local base_getTalentMastery = _M.getTalentMastery
function _M:getTalentMastery(t)
    if self.resourceful_wanderer == nil then
        return base_getTalentMastery(self, t)
    end

    return self.resourceful_wanderer:withManagedTalent(t, function(...)
        return base_getTalentMastery(self, t)
    end)
end


return _M
