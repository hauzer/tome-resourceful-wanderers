_M = loadPrevious(...)


local base_learnTalent = _M.learnTalent
function _M:learnTalent(learned_talent_id, force, nb, extra)
    local retval = base_learnTalent(self, learned_talent_id, force, nb, extra)

    if retval and self.resourceful_randventurer then
        local learned_talent = self:getTalentFromId(learned_talent_id)
        local learned_talent_type_id = learned_talent.type[1]

        local talents_types_resolver = nil
        for _, group in ipairs(self.resourceful_randventurer.talents_types_resolvers) do
            if group.applies_to_talent_type_id(learned_talent_type_id) then
                talents_types_resolver = group
                break
            end
        end

        if talents_types_resolver then
            if talents_types_resolver.resolved == 0 then
                if not talents_types_resolver.chosen then
                    for _, group in ipairs(talents_types_resolver.talents_ids_groups) do
                        -- Check if all of the talents from a talent group can be learned
                        local can_all_talents_be_learned = function()
                            for _, talent_id in ipairs(group) do
                                local talent = self:getTalentFromId(talent_id)
                                if rawget(talent, 'require') then
                                    local require = talent.require
                                    if type(require) == 'function' then require = require(self, talent) end
                                    local offset = 1

                                    if require.special and not require.special.fct(self, t, offset) then
                                        return false
                                    end

                                    if require.special2 and not require.special2.fct(self, talent, offset) then
                                        return false
                                    end

                                    if require.special3 and not require.special3.fct(self, talent, offset) then
                                        return false
                                    end

                                    if require.birth_descriptors then
                                        for _, d in ipairs(require.birth_descriptors) do
                                            if not self.descriptor or self.descriptor[d[1]] ~= d[2] then
                                                return false
                                            end
                                        end
                                    end
                                end

                                return true
                            end
                        end

                        -- Set this talent groups as the chosen one if all of the talents pass the checks
                        if can_all_talents_be_learned() then
                            talents_types_resolver.chosen = group
                            break
                        end
                    end
                end

                -- We have a chosen group
                if talents_types_resolver.chosen then
                    -- Learn all of the talents from the group
                    for _, talent_id in ipairs(talents_types_resolver.chosen) do
                        base_learnTalent(self, talent_id, true, nil, {no_unlearn = true})
                    end

                    -- Mark the learned talent as non-unlearnable
                    if learned_talent.base_no_unlearn_last ~= nil then
                        learned_talent.no_unlearn_last = learned_talent.base_no_unlearn_last
                    end
                    learned_talent.no_unlearn_last = true

                    -- Revert the unlearnability state of all other talents
                    for talent_type_id, known in pairs(self.talents_types) do
                        if known and talents_types_resolver.applies_to_talent_type_id(talent_type_id) then
                            local talent_type = self:getTalentTypeFrom(talent_type_id)
                            local first_talent = talent_type.talents[1]

                            if first_talent.id ~= learned_talent_id and first_talent.base_no_unlearn_last ~= nil then
                                first_talent.no_unlearn_last = first_talent.base_no_unlearn_last
                            end
                        end
                    end
                end
            -- If we have two or more points in relevant talents, mark all of them as unlearnable
            elseif talents_types_resolver.resolved == 1 then
                for talent_type_id, known in pairs(self.talents_types) do
                    if known and talents_types_resolver.applies_to_talent_type_id(talent_type_id) then
                        local talent_type = self:getTalentTypeFrom(talent_type_id)
                        local first_talent = talent_type.talents[1]

                        if first_talent.base_no_unlearn_last ~= nil then
                            first_talent.no_unlearn_last = first_talent.base_no_unlearn_last
                        end
                    end
                end
            end

            talents_types_resolver.resolved = talents_types_resolver.resolved + 1
        end
    end

    return retval
end


local base_unlearnTalent = _M.unlearnTalent
function _M:unlearnTalent(unlearned_talent_id, nb, no_unsustain, extra)
    local retval = base_unlearnTalent(self, unlearned_talent_id, nb, no_unsustain, extra)

    if retval and self.resourceful_randventurer then
        local unlearned_talent = self:getTalentFromId(unlearned_talent_id)
        local unlearned_talent_type_id = unlearned_talent.type[1]

        local talents_types_resolver = nil
        for _, resolver in ipairs(self.resourceful_randventurer.talents_types_resolvers) do
            if resolver.applies_to_talent_type_id(unlearned_talent_type_id) then
                talents_types_resolver = resolver
                break
            end
        end

        if talents_types_resolver then
            if talents_types_resolver.resolved == 1 then
                -- Unlearn the chosen group of talents
                for _, talent_id in ipairs(talents_types_resolver.chosen) do
                    base_unlearnTalent(self, talent_id)
                end

                -- Mark all relevant talents as non-unlearnable
                for talent_type_id, known in pairs(self.talents_types) do
                    if known and talents_types_resolver.applies_to_talent_type_id(talent_type_id) then
                        local talent_type = self:getTalentTypeFrom(talent_type_id)
                        local first_talent = talent_type.talents[1]

                        if first_talent.base_no_unlearn_last == nil then
                            first_talent.base_no_unlearn_last = first_talent.no_unlearn_last
                        end
                        first_talent.no_unlearn_last = true
                    end
                end
            -- If we're left at one point of relevant talents, revert the unlearnability state of all non-known, but mark the remaining one as unlearnable
            elseif talents_types_resolver.resolved == 2 then
                for talent_type_id, known in pairs(self.talents_types) do
                    if known and talents_types_resolver.applies_to_talent_type_id(talent_type_id) then
                        local talent_type = self:getTalentTypeFrom(talent_type_id)
                        local first_talent = talent_type.talents[1]
                        
                        if self:knowTalent(first_talent.id) then
                            if first_talent.base_no_unlearn_last == nil then
                                first_talent.base_no_unlearn_last = first_talent.no_unlearn_last
                            end
                            first_talent.no_unlearn_last = true
                        else
                            if first_talent.base_no_unlearn_last ~= nil then
                                first_talent.no_unlearn_last = first_talent.base_no_unlearn_last
                            end
                        end
                    end
                end
            end

            talents_types_resolver.resolved = talents_types_resolver.resolved - 1
        end
    end

    return retval
end


return _M
