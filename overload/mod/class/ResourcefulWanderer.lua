local AddonAware = require('mod.class.resourcefulwanderer.AddonAware')
local Makeable = require('mod.class.resourcefulwanderer.Makeable')
local Area = require('mod.class.resourcefulwanderer.Area')
local Talent = require('mod.class.resourcefulwanderer.Talent')
local TalentGroup = require('mod.class.resourcefulwanderer.TalentGroup')
local TalentType = require('mod.class.resourcefulwanderer.TalentType')
local TalentTypeGroup = require('mod.class.resourcefulwanderer.TalentTypeGroup')
local WeaponMasteries = require('mod.class.resourcefulwanderer.WeaponMasteries')


module(..., package.seeall, class.inherit(Makeable))


_M.instance = nil


function _M:loadDefinitions(to_load)
    local definitions = {
        name_pools = { },
        description_pools = { },
        talent_types = { },
        areas = { },
        weapon_masteries = { }
    }

    local wanderer_load_path = 'mod/data/talents/wanderer/'
    local talent_types_load_path = wanderer_load_path .. 'talent-types/'

    if to_load.name_pools ~= nil then
        for _, name_pool_to_load in ipairs(to_load.name_pools) do
            local name_pool = dofile(talent_types_load_path .. 'name-pools/' .. name_pool_to_load .. '.lua')
            definitions.name_pools[name_pool_to_load] = name_pool
        end
    end

    if to_load.description_pools ~= nil then
        for _, description_pool_to_load in ipairs(to_load.description_pools) do
            local description_pool = dofile(talent_types_load_path .. 'description-pools/' .. description_pool_to_load .. '.lua')
            definitions.description_pools[description_pool_to_load] = description_pool
        end
    end

    if to_load.talent_types ~= nil then
        for _, talent_type_to_load in ipairs(to_load.talent_types) do
            local talent_type = dofile(talent_types_load_path .. talent_type_to_load .. '.lua')
            talent_type.id = talent_type_to_load
            definitions.talent_types[talent_type_to_load] = talent_type
        end
    end

    if to_load.areas ~= nil then
        for _, area_to_load in ipairs(to_load.areas) do
            local area = dofile(wanderer_load_path .. 'areas/' .. area_to_load .. '.lua')
            area.name = area_to_load
            definitions.areas[area_to_load] = area
        end
    end

    if to_load.weapon_masteries ~= nil then
        for _, competing_weapon_masteries_group_to_load in ipairs(to_load.weapon_masteries) do
            local competing_weapon_masteries_group = dofile(wanderer_load_path .. 'competing-weapon-masteries/' .. competing_weapon_masteries_group_to_load .. '.lua')
            table.insert(definitions.weapon_masteries, competing_weapon_masteries_group)
        end
    end

    return definitions
end


function _M:init(actor, configuration)
    assert(self.instance == nil, 'ResourcefulWanderer is a singleton class, you cannot instantiate it more than once.')
    self.instance = self

    assert(actor == game.player, 'ResourcefulWanderer can only use the player actor.')
    self.actor = game.player

    local definitions = self:loadDefinitions(configuration.to_load)
    TalentType:addNamePools(definitions.name_pools)
    TalentType:addDescriptionPools(definitions.description_pools)

    for _, definition in ipairs(definitions.talent_types) do
        TalentType:new(definition)
    end

    self.areas = { }
    for _, definition in ipairs(definitions.areas) do
        definition.actor = self.actor
        local area = Area.new(definition)
        if not area.isNil() then
            table.insert(self.areas, area)
        end
    end
    ---@diagnostic disable-next-line: undefined-field
    table.shuffle(self.areas)

    self.weapon_masteries = WeaponMasteries:make(definitions.weapon_masteries)

    -- Thanks to rexorcorum for reminding me about this :)
    if not self.actor:knowTalent('T_SHOOT') then
        self.actor:learnTalent('T_SHOOT', true)
    end
end

-- Returns all areas which cover the talent type
function _M:findCoveringAreas(talent_type_id)
    local areas = { }
    for _, area in ipairs(self.areas) do
        if area.is_covered then
            goto next_area
        end

        for _, ignored_talent_type in ipairs(area.ignore_talent_types) do
            if ignored_talent_type == talent_type_id then
                goto next_area
            end
        end

        for _, ignored_category in ipairs(area.ignore_categories) do
            if ignored_category == talent_type_id:gsub('/.*', '') then
                goto next_area
            end
        end

        for _, covered_category in ipairs(area.cover_categories) do
            if covered_category == talent_type_id:gsub('/.*', '') then
                table.insert(areas, area)
                goto next_area
            end
        end

        for _, cover_talent_type in ipairs(area.cover_talent_types) do
            if cover_talent_type == talent_type_id then
                table.insert(areas, area)
                goto next_area
            end
        end

        ::next_area::
    end

    return areas
end


-- Make the talent, if it's managed, act as if it belongs to a wanderer category for the duration of the callback
function _M:withManagedTalent(tome_talent, callback)
    local talent_type = self.getKnownWandererTalentTypeForTalent(tome_talent)
    if talent_type == nil then
        return callback(nil, nil, tome_talent)
    end

    local original_type = talent.type
    tome_talent.type = {
        talent_type.id,
        0
    }

    local retval = callback(talent_type, managed_talent, tome_talent)

    tome_talent.type = original_type
    return retval
end

-- Remove all talent type's talents from all areas
function _M:onLearnTalentType(learned_talent_type)
    local learned_tome_talent_type = self.actor.getTalentTypeFrom(learned_talent_type_id)

    local areas_to_keep = { }
    for _, area in ipairs(self.areas) do
        local talent_types_to_keep = { }
        for _, talent_type in ipairs(area.talent_types) do
            local talents_to_keep = { }
            local tome_talents_to_keep = { }
            local individual_talent_log_messages = { }
            local was_signature_talent_removed = false
            local has_sticky_talents = false

            -- If the talent type to unmanage is an area talent type, don't touch anything
            if talent_type.id == learned_tome_talent_type.id then
                goto next_talent_type
            end

            -- Remove all talents of talent type to unmanage
            for _, talent in ipairs(talent_type.talents) do
                for _, talent_to_unmanage in ipairs(learned_tome_talent_type.talents) do
                    if talent.id ~= talent_to_unmanage.id then
                        goto next_talent_to_unmanage
                    end

                    local talent_def_to_remove_name = tstring {
                        {'font', 'bold'},
                        self.actor.talents_def[talent.id].name,
                        {'font', 'normal'}
                    }

                    local log_message
                    if self.actor:knowTalent(talent.id) then
                        log_message =
                            '#GOLD#Your understanding of #LIGHT_BLUE#' ..
                            tostring(talent_def_to_remove_name) ..
                            '#GOLD# becomes deeper.'
                    else
                        log_message =
                            '#GOLD#You readjust the angle from which you should learn #LIGHT_BLUE#' ..
                            tostring(talent_def_to_remove_name) .. '#GOLD#.'
                    end

                    local talent_type_name = tstring {
                        {'font', 'bold'},
                            _t(talent_type.id:gsub('/.*', ''), 'talent category'):capitalize() ..
                            ' / ' ..
                            talent_type.id:gsub('.*/', ''):capitalize(),
                        {'font', 'normal'}
                    }

                    local talent_type_to_unmanage_name = tstring {
                        {'font', 'bold'},
                            _t(talent_type_to_unmanage_id:gsub('/.*', ''), 'talent category'):capitalize() ..
                            ' / ' ..
                            talent_type_to_unmanage_id:gsub('.*/', ''):capitalize(),
                        {'font', 'normal'}
                    }

                    table.insert(individual_talent_log_messages,
                        log_message ..
                        ' The talent has been removed from #LIGHT_BLUE#' .. tostring(talent_type_name) ..
                        '#GOLD# since you learned its original category, #LIGHT_BLUE#' .. tostring(talent_type_to_unmanage_name) .. '#GOLD#.'
                    )

                    -- If the talent type we're unmanaging is from an area, and the talent we're unmanaging is
                    -- signature in the iterating talent type, then make it sticky in the talent type
                    -- we're unmanaging (if it's not alreaday a signature talent)
                    if talent.is_signature then
                        if talent_type_to_unmanage_area then
                            for _, talent_type in ipairs(talent_type_to_unmanage_area.talent_types) do
                                for _, talent_to_sticky in ipairs(talent_type.talents) do
                                    if talent.id == talent_to_sticky.id and not talent_to_sticky.is_signature then
                                        talent_to_sticky.is_sticky = true
                                        goto break_from_sticky
                                    end
                                end
                            end
                        end

                        ::break_from_sticky::

                        was_signature_talent_removed = true
                    end

                    if talent_type.maximum_removed_talents ~= nil then
                        talent_type.maximum_removed_talents = talent_type.maximum_removed_talents - 1
                    end

                    if talent_type.maximum_known_talents ~= nil then
                        talent_type.maximum_known_talents = talent_type.maximum_known_talents - 1
                    end

                    goto next_talent

                    ::next_talent_to_unmanage::
                end

                table.insert(tome_talents_to_keep, self.actor.talents_def[talent.id])
                table.insert(talents_to_keep, talent)

                if talent.is_sticky and not talent.is_signature then
                    has_sticky_talents = true
                end

                ::next_talent::
            end

            if self.actor:knowTalentType(talent_type.id) ~= nil then
                self.actor.talents_types_def[talent_type.id].talents = tome_talents_to_keep
            end



            talent_type.talents = talents_to_keep

            -- Remove the talent type completely if:
            -- - It has no sticky talents and:
            --     - A signature talent has been removed.
            --     - Category has number of talents less then or equal to `minimum_talents`.
            --     - Category has lost a number of talents more than or equal to `maximum_removed_talents`.
            -- Refund the category and talent points if any were spent.
            if
                (
                    #talent_type.talents <= talent_type.minimum_talents or
                    (talent_type.maximum_removed_talents ~= nil and talent_type.maximum_removed_talents <= 0) or
                    (talent_type.maximum_known_talents ~= nil and talent_type.maximum_known_talents <= 0) or
                    was_signature_talent_removed
                ) and
                not has_sticky_talents
            then
                local talents_removed_string = ''
                for _, talent in ipairs(talent_type.talents) do
                    local talent_def = self.actor.talents_def[talent.id]

                    if self.actor:knowTalentType(talent_type.name) then
                        local talent_removed_string = ''
                        if talents_removed_string ~= '' then
                            talent_removed_string = talent_removed_string .. '#GOLD#, '
                        end

                        local talent_name = tstring {
                            {'font', 'bold'},
                            talent_def.name,
                            {'font', 'normal'}
                        }

                        talent_removed_string = talent_removed_string .. '#LIGHT_BLUE#' .. tostring(talent_name)
                        talents_removed_string = talents_removed_string .. talent_removed_string
                    end

                    if talent_def.generic == true then
                        self.actor.unused_generics = self.actor.unused_generics + (self.actor.talents[talent.id] or 0)
                    else
                        self.actor.unused_talents = self.actor.unused_talents + (self.actor.talents[talent.id] or 0)
                    end

                    self.actor:unlearnTalentFull(talent_def.id)
                end

                local talent_type_name = tstring {
                    {'font', 'bold'},
                        _t(talent_type.id:gsub('/.*', ''), 'talent category'):capitalize() ..
                        ' / ' ..
                        talent_type.id:gsub('.*/', ''):capitalize(),
                    {'font', 'normal'}
                }

                local do_log = true
                local log_message
                if self.actor:knowTalentType(talent_type.id) then
                    log_message = '#GOLD#You solidify your knowledge of #LIGHT_BLUE#%s#GOLD# at the expense of flexibility. '
                    if talents_removed_string ~= '' then
                        log_message = log_message .. 'You forget the category along with all of the remaining talents: ' .. talents_removed_string .. '#GOLD#.'
                    else
                        log_message = log_message .. 'You forget the category.'
                    end

                    log_message = log_message .. ' Any spent talent or category points have been refunded.'
                elseif self.actor:knowTalentType(talent_type.id) == false then
                    log_message = '#GOLD#Never taking an interest in #LIGHT_BLUE#%s#GOLD#, you forget all about it as if you never knew it.'
                else
                    do_log = false
                end

                if self.actor.talents_types[talent_type.id] == true then
                    self.actor.unused_talents_types = self.actor.unused_talents_types + 1
                end

                self.actor.talents_types[talent_type.id] = nil
                self.actor.talents_types_mastery[talent_type.id] = nil
                self.actor.changed = true

                if do_log then
                    game.log(log_message, tostring(talent_type_name))
                end

                goto next_talent_type_dont_keep
            end

            if self.actor:knowTalentType(talent_type.id) ~= nil then
                self:update_talent_type_description(talent_type)

                for _, message in ipairs(individual_talent_log_messages) do
                    game.log(message)
                end
            end

            ::next_talent_type::
            table.insert(talent_types_to_keep, talent_type)

            ::next_talent_type_dont_keep::
        end

        -- Don't keep empty areas
        area.talent_types = talent_types_to_keep
        if #area.talent_types > 0 then
            table.insert(areas_to_keep, area)
        end
    end

    self.areas = areas_to_keep
end


-- Check if actor knows any competing mastery talent for the given talent
function _M:knowsCompetingMasteryTalent(talent_id)
    for _, competing_talent_id in ipairs(self:getCompetingMasteryTalents(talent_id)) do
        if self:knowTalent(competing_talent_id) then
            return true
        end
    end

    return false
end
