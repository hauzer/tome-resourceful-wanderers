local AddonAware = require('mod.class.resourcefulwanderer.AddonAware')
local TalentType = require('mod.class.resourcefulwanderer.TalentType')


module(..., package.seeall, class.inherit(AddonAware))


function _M:init(definition)
    if definition.types then
        self.items = self:make(definition.types)
        self.maximum_types = definition.maximum_types
    else
        self.items = { }
        for _, talent_type_definition in definition do
            table.insert(self.items, TalentType:make(talent_type_definition))
        end
    end

    ---@diagnostic disable-next-line: undefined-field
    table.shuffle(self.items)
end
