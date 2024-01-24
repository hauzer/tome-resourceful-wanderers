local AddonAware = require('mod.class.resourcefulwanderer.AddonAware')
local Nilable = require('mod.class.resourcefulwanderer.Nilable')
local Queue = require('mod.class.resourcefulwanderer.Queue')
local TalentType = require('mod.class.resourcefulwanderer.TalentType')


module(..., package.seeall, class.inherit(Queue, AddonAware))


function _M:init(definition)
    AddonAware.init(self, definition)
    if self:isNil() then
        return
    end

    definition.item_new = function(...) return TalentType:make(...) end
    Queue.init(self, definition)
    ---@diagnostic disable-next-line: undefined-field
    table.shuffle(self.items)
end
