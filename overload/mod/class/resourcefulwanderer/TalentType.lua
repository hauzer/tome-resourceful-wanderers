local ActorTalents = require('engine.interface.ActorTalents')

local AddonAware = require('mod.class.resourcefulwanderer.AddonAware')
local Makeable = require('mod.class.resourcefulwanderer.Makeable')
local Area = require('mod.class.resourcefulwanderer.Area')
local Talent = require('mod.class.resourcefulwanderer.Talent')
local TalentQueue = require('mod.class.resourcefulwanderer.TalentQueue')


module(..., package.seeall, class.inherit(AddonAware))


_M.with_id = { }
_M.name_pools = { }
_M.description_pools = { }



function _M:addNamePool(id, definition)
    self.name_pools[id] = definition

    ---@diagnostic disable-next-line: undefined-field
    table.shuffle(self.name_pools[id])
end


function _M:addNamePools(definitions)
    for id, definition in pairs(definitions) do
        self:addNamePool(id, definition)
    end
end


function _M:addDescriptionPool(id, definition)
    self.description_pools[id] = definition

    ---@diagnostic disable-next-line: undefined-field
    table.shuffle(self.description_pools[id])
end


function _M:addDescriptionPools(definitions)
    for id, definition in pairs(definitions) do
        self:addDescriptionPool(id, definition)
    end
end


-- Define talent types of an area from a definition of groups of talent types
function _M:make(definition)
    if type(definition) == 'string' then
        local id = definition
        return self.with_id[id]
    end

    return self.new(definition)
end


-- Define an area talent type from a talent type definition
function _M:init(definition)
    AddonAware.init(definition)
    if self:isNil() then
        return
    end

    if definition.id then
        self.named[definition.id] = self
    end

    -- Normalize definition properties and create the talent type
    if definition.names then
        ---@diagnostic disable-next-line: undefined-field
        table.shuffle(definition.names)
        self.name = definition.names[1]
    elseif definition.name then
        self.name = definition.name
    end

    if definition.descriptions then
        ---@diagnostic disable-next-line: undefined-field
        table.shuffle(definition.descriptions)
        self.description = definition.descriptions[1]
    elseif definition.description then
        self.description = definition.description
    end

    self.is_generic = definition.is_generic == nil and false or definition.is_generic
    self.is_unlocked = definition.is_unlocked == nil and false or definition.is_unlocked
    self.mastery = definition.mastery == nil and 0.8 or definition.mastery
    self.can_learn_at_most = definition.can_learn_at_most
    self.talent_queue = TalentQueue.new(definition.talent_queue)

    self.on_cover = definition.on_cover or function(...) end
end


function _M:addToGame()
    if self.name == nil and self.definition.name_pool then
        local name_pool = self.description_pools[self.definition.name_pool]
        self.name = name_pool[1]
        table.remove(name_pool, 1)
    end

    self.type = 'wanderer/' .. self.name

    if self.description == nil and self.definition.description_pool then
        local description_pool = self.description_pools[self.definition.description_pool]
        self.description = description_pool[1]
        table.remove(description_pool, 1)
    end

    -- Create ToME talent type definition
    ActorTalents:newTalentType {
        allow_random = false,
        type = self.type,
        name = _t(self.name, 'talent type'),
        generic = self.is_generic,
        description = self.description
    }

    self.tome = ActorTalents:getTalentTypeFrom(self.type)
    self.tome.wanderer = self

    ActorTalents:setTalentTypeMastery(self.id, self.mastery)

    self.talents = { }
    self:addTalents()
end


function _M:addTalents(how_many)
    for _, talent in ipairs(self.talent_queue:take({ exactly = how_many })) do
        talent:addToTalentType(self)
        table.insert(self.talents, talent)
    end

    -- Sort talents in the talent type according to required level
    table.sort(self.tome.talents, function(a, b)
        local a_level = 0
        local b_level = 0

        if a.require.level then
            a_level = util.getval(a.require.level, 1)
        end

        if b.require.level then
            b_level = util.getval(b.require.level, 1)
        end

        return a_level < b_level
    end)

    self:updateTomeDescription()
end


function _M:learn(actor)
    actor:learnTalentType(self.type, self.is_unlocked)

    local log_message = {
        data = '#GOLD#You begin to intuit a few things about the world as you learn #LIGHT_BLUE#' .. self:getPrettyName() .. '#GOLD#.'
    }
    self.on_cover(self.actor, log_message)

    if actor == game.player then
        game.log(log_message.data)
    end
end


function _M:removeTalents(talents_to_remove_original)
    local talents_to_remove = { }
    for _, talent in ipairs(talents_to_remove_original) do
        table.insert(talents_to_remove, talent)
    end

    local talents_to_remove_at_start = #talents_to_remove

    if self.tome ~= nil then
        local talents_to_keep = { }
        for _, talent in ipairs(self.talents) do
            if #talents_to_remove == 0 then
                break
            end

            local remove_talent
            for _, talent_to_remove in ipairs(talents_to_remove) do
                if talent_to_remove.id == talent.id then
                    talent:detachFromTalentType()
                    table.remove(talents_to_remove, remove_talent)
                    break
                end
            end
        end

        self.talents = talents_to_keep
    end

    self.talent_queue:remove(talents_to_remove, false)

    local talents_removed = talents_to_remove_at_start - #talents_to_remove
    if self.tome ~= nil and talents_removed > 0 then
        self:addTalents(talents_removed)
    end
end


-- Get talent type number of known talents
function _M:getNumberOfKnownTalents(actor)
    local number_of_known_talents = 0
    for _, talent in ipairs(self.tome.talents) do
        if actor:knowTalent(talent.id) then
            number_of_known_talents = number_of_known_talents + 1
        end
    end

    return number_of_known_talents
end


-- Does a talent type have a limit of learned talents?
function _M:doesHaveTalentLimit()
    return self.can_learn_at_most ~= nil
end


-- Check if any more talents can be learned in the talent type
function _M:isOverTalentLimit()
    return self:doesHaveTalentLimit() and self:getNumberOfKnownTalents() > self.can_learn_at_most
end


function _M:getPrettyName()
    return tostring(tstring {
        {'font', 'bold'},
            _t(self.type:gsub('/.*', ''), 'talent category'):capitalize() ..
            ' / ' ..
            self.type:gsub('.*/', ''):capitalize(),
        {'font', 'normal'}
    })
end


function _M:getDescription()
    local sticky_talent_names = { }
    local signature_talent_names = { }
    for _, talent in ipairs(self.talents) do
        if talent.is_sticky then
            table.insert(sticky_talent_names, talent.tome.name)
        elseif talent.is_signature then
            table.insert(signature_talent_names, talent.tome.name)
        end
    end

    local description
    if #sticky_talent_names > 0 then
        description =
            '#{italic}#This category will never be removed unless the original categories of the following talents are learned: ' ..
            '\n - ' .. table.concat(sticky_talent_names, '\n - ') .. '\n'
    elseif #signature_talent_names > 0 then
        description =
            '#{italic}#This category will be removed if the original categories of any of the following talents are learned: ' ..
            '\n - ' .. table.concat(signature_talent_names, '\n - ') .. '\n'
    else
        local talents_until_remove
        if self.minimum ~= nil then
            talents_until_remove = #self.talents - self.minimum
        elseif self.maximum_known ~= nil then
            talents_until_remove = self.maximum_known - self.removed
        end

        if talents_until_remove ~= nil then
            description = '#{italic}#This category will be removed if you learn the original categories of ' .. talents_until_remove .. ' more talents.'
        else
            description = '#{italic}#This category will be removed once you learn the original categories of all of its talents.'
        end
    end

    return description
end


function _M:updateTomeDescription()
    self.tome.description =
        self.description .. '\n\n\n\n' .. self:getDescription() ..
        '\nIf this category is removed, any invested category and talent points will be refunded.'
end
