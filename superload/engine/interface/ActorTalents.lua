_M = loadPrevious(...)


local EscortRewards = require('mod.class.EscortRewards')
local Dialog = require('engine.ui.Dialog')


local base_learnTalent = _M.learnTalent
function _M:learnTalent(learned_talent_id, force, nb)
    local retval = base_learnTalent(self, learned_talent_id, force, nb)

    if retval and self.resourceful_randventurer then
        local learned_talent = self:getTalentFromId(learned_talent_id)
        local learned_talent_type_id = learned_talent.type[1]

        local talents_types_ids_group = nil
        for _, group in ipairs(self.resourceful_randventurer.talents_types_ids_groups) do
            if group.applies_to_talent_type_id(learned_talent_type_id) then
                talents_types_ids_group = group
                break
            end
        end

        if talents_types_ids_group then
            if talents_types_ids_group.resolved == 0 then
                if not talents_types_ids_group.chosen then
                    for _, group in ipairs(talents_types_ids_group.talents_ids_groups) do
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
                            talents_types_ids_group.chosen = group
                            break
                        end
                    end
                end

                -- We have a chosen group
                if talents_types_ids_group.chosen then
                    -- Learn all of the talents from the group
                    for _, talent_id in ipairs(talents_types_ids_group.chosen) do
                        base_learnTalent(self, talent_id, true, nil, {no_unlearn = true})
                    end

                    -- Mark the learned talent as non-unlearnable
                    if learned_talent.base_no_unlearn_last ~= nil then
                        learned_talent.no_unlearn_last = learned_talent.base_no_unlearn_last
                    end
                    learned_talent.no_unlearn_last = true

                    -- Revert the unlearnability state of all other talents
                    for talent_type_id, known in pairs(self.talents_types) do
                        if known and talents_types_ids_group.applies_to_talent_type_id(talent_type_id) then
                            local talent_type = self:getTalentTypeFrom(talent_type_id)
                            local first_talent = talent_type.talents[1]

                            if first_talent.id ~= learned_talent_id and first_talent.base_no_unlearn_last ~= nil then
                                first_talent.no_unlearn_last = first_talent.base_no_unlearn_last
                            end
                        end
                    end
                end
            -- If we have two or more points in relevant talents, mark all of them as unlearnable
            elseif talents_types_ids_group.resolved == 1 then
                for talent_type_id, known in pairs(self.talents_types) do
                    if known and talents_types_ids_group.applies_to_talent_type_id(talent_type_id) then
                        local talent_type = self:getTalentTypeFrom(talent_type_id)
                        local first_talent = talent_type.talents[1]

                        if first_talent.base_no_unlearn_last ~= nil then
                            first_talent.no_unlearn_last = first_talent.base_no_unlearn_last
                        end
                    end
                end
            end

            talents_types_ids_group.resolved = talents_types_ids_group.resolved + 1
        end
    end

    return retval
end


local base_unlearnTalent = _M.unlearnTalent
function _M:unlearnTalent(unlearned_talent_id, nb)
    local retval = base_unlearnTalent(self, unlearned_talent_id, nb)

    if retval and self.resourceful_randventurer then
        local unlearned_talent = self:getTalentFromId(unlearned_talent_id)
        local unlearned_talent_type_id = unlearned_talent.type[1]

        local talents_types_ids_group = nil
        for _, group in ipairs(self.resourceful_randventurer.talents_types_ids_groups) do
            if group.applies_to_talent_type_id(unlearned_talent_type_id) then
                talents_types_ids_group = group
                break
            end
        end

        if talents_types_ids_group then
            if talents_types_ids_group.resolved == 1 then
                -- Unlearn the chosen group of talents
                for _, talent_id in ipairs(talents_types_ids_group.chosen) do
                    base_unlearnTalent(self, talent_id)
                end

                -- Mark all relevant talents as non-unlearnable
                for talent_type_id, known in pairs(self.talents_types) do
                    if known and talents_types_ids_group.applies_to_talent_type_id(talent_type_id) then
                        local talent_type = self:getTalentTypeFrom(talent_type_id)
                        local first_talent = talent_type.talents[1]

                        if first_talent.base_no_unlearn_last == nil then
                            first_talent.base_no_unlearn_last = first_talent.no_unlearn_last
                        end
                        first_talent.no_unlearn_last = true
                    end
                end
            -- If we're left at one point of relevant talents, revert the unlearnability state of all non-known, but mark the remaining one as unlearnable
            elseif talents_types_ids_group.resolved == 2 then
                for talent_type_id, known in pairs(self.talents_types) do
                    if known and talents_types_ids_group.applies_to_talent_type_id(talent_type_id) then
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

            talents_types_ids_group.resolved = talents_types_ids_group.resolved - 1
        end
    end

    return retval
end


local base_learnTalentType = _M.learnTalentType
function _M:learnTalentType(learned_talent_type_id, v)
    local retval = base_learnTalentType(self, learned_talent_type_id, v)

    if retval and self.resourceful_randventurer then
        local learned_category_id = learned_talent_type_id:gsub('/.*', '')

        -- Handle steam
        if learned_category_id == 'steamtech' and not self.resourceful_randventurer.steamtech_resolved then
            -- Check if the player has seen the Tinker escort
            game.state.escorts_seen = game.state.escorts_seen or {}
            local seen_steamtech_escort = false
            for _, escort in ipairs(game.state.escorts_seen) do
                if escort == 'steamtech' then
                    seen_steamtech_escort = true
                    break
                end
            end
    
            -- The player hasn't encountered the Tinker escort
            if not seen_steamtech_escort then
                -- Give the player a basic steam implant
                local implant = resolvers.resolveObject(self, {
                    type='scroll',
                    subtype='implant',
                    name='steam generator implant',
                    base_list='mod.class.Object:/data-orcs/general/objects/inscriptions.lua',
                    autoreq=true,
                    ego_chance=-1000
                })
                implant:identify(true)

                -- Mark the Tinker escort as seen
                table.insert(game.state.escorts_seen, 'steamtech')

                -- Trigger the Tinker escort award
                local base_simplePopup = Dialog.simplePopup
                Dialog.simplePopup = function(self, title, text, fct, no_leave)
                    -- Modify the dialogue a bit
                    text = _t'Suddenly, a vapour cloud appears, and a person steps out. "You\'re exactly who I\'m looking for!" ' .. text .. _t' The cloud dissipates along with her as she steps back. She also left you with a device apparently able to produce vapours in a similar fashion.'
                    return base_simplePopup(self, title, text, fct, no_leave)
                end
                EscortRewards:listRewards().steamtech.special[1].action(nil, self, function(_, _, _, _, _, _) end)
                Dialog.simplePopup = base_simplePopup
            end

            self.resourceful_randventurer.steamtech_resolved = true
        -- Handle other resources
        else
            local talents_types_ids_group = nil
            for _, group in ipairs(self.resourceful_randventurer.talents_types_ids_groups) do
                if group.applies_to_talent_type_id(learned_talent_type_id) then
                    talents_types_ids_group = group
                    break
                end
            end

            if talents_types_ids_group and talents_types_ids_group.resolved == 0 then
                local talents_ids_groups = talents_types_ids_group.talents_ids_groups

                for _, talents_ids_group in ipairs(talents_ids_groups) do
                    -- Check if the player knows all talent types of a group
                    local knows_all_talent_types = function()
                        for _, talent_id in ipairs(talents_ids_group) do
                            local talent = self:getTalentFromId(talent_id)
                            local talent_type_id = talent.type[1]
                            
                            if not self:knowTalentType(talent_type_id) then
                                -- One of the talent types of a group is not known to the player
                                return false
                            end
                        end

                        return true
                    end

                    -- The player has learned all of the talent types of a group; this category is resolved
                    if knows_all_talent_types() then
                        -- Mark all other modified not-unlearnable talents as unlearnable
                        for talent_type_id, known in pairs(self.talents_types) do
                            if known and talents_types_ids_group.applies_to_talent_type_id(talent_type_id) then
                                local talent_type = self:getTalentTypeFrom(talent_type_id)
                                local first_talent = talent_type.talents[1]

                                if first_talent.base_no_unlearn_last then
                                    first_talent.no_unlearn_last = first_talent.base_no_unlearn_last
                                end
                            end
                        end

                        talents_types_ids_group.resolved = talents_types_ids_group.resolved + 1
                        break
                    end
                end

                -- Otherwise, if the category isn't resolved, mark the first talent of the learned type as unlearnable
                if talents_types_ids_group.resolved == 0 then
                    local learned_talent_type = self:getTalentTypeFrom(learned_talent_type_id)
                    local first_talent = learned_talent_type.talents[1]
                    first_talent.base_no_unlearn_last = first_talent.no_unlearn_last or false
                    first_talent.no_unlearn_last = true
                end
            end
        end
    end

    return retval
end


return _M
