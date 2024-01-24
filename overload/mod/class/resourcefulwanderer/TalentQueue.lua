local AddonAware = require('mod.class.resourcefulwanderer.AddonAware')
local Queue = require('mod.class.resourcefulwanderer.Queue')
local Talent = require('mod.class.resourcefulwanderer.Talent')


module(..., package.seeall, class.inherit(Queue, AddonAware))


function _M:init(definition)
    AddonAware.init(self, definition)
    if self:isNil() then
        return
    end

    definition.item_new = Talent.new
    Queue.init(self, definition)
    ---@diagnostic disable-next-line: undefined-field
    table.shuffle(self.items)
end


function _M:getItemPriority(talent)
    if talent.is_signature or talent.is_sticky then
        return 0
    else
        return nil
    end
end


function _M:areItemsEqual(a, b)
    return a.id == b or a == b.id or (a.id ~= nil and b.id ~= nil and a.id == b.id) or a == b
end


function _M:getDescription()
    local sticky_talent_names = { }
    local signature_talent_names = { }
    for _, talent in ipairs(self.tome.talents) do
        if talent.is_sticky then
            table.insert(sticky_talent_names, talent.name)
        elseif talent.is_signature then
            table.insert(signature_talent_names, talent.name)
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
