local Nilable = require('mod.class.resourcefulwanderer.Nilable')

-- Gives child classes the ability to check if their required addons are present.
module(..., package.seeall, class.inherit(Nilable))


function _M:init(definition)
    self.addons = definition.addons == nil and { } or definition.addons
    for _, addon in ipairs(self.addons) do
        if not game:isAddonActive(addon) then
            self:setToNil()
            break
        end
    end
end
