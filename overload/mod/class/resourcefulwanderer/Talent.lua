local ActorTalents = require('engine.interface.ActorTalents')

local AddonAware = require('mod.class.resourcefulwanderer.AddonAware')
local Nilable = require('mod.class.resourcefulwanderer.Nilable')


module(..., package.seeall, class.inherit(AddonAware, Nilable))


function _M:init(definition)
    self.id = definition.id == nil and definition or definition.id
    self.tome = ActorTalents:getTalentFromId(self.id)
    assert(self.tome ~= nil, 'Talent ' .. self.id .. ' doesn\'t exist!')

    self.is_signature = definition.is_signature == nil and false or true
    self.is_sticky = definition.is_sticky == nil and false or true
end


function _M:attachToTalentType(talent_type)
    self:detachFromTalentType()

    self.tome.wanderer = self
    self.talent_type = talent_type
    table.insert(self.talent_type.tome.talents, self.tome)
end


function _M:detachFromTalentType()
    if self.talent_type == nil then
        return
    end

    for i, talent in ipairs(self.talent_type.tome.talents) do
        if talent.id == self.id then
            table.remove(self.talent_type.tome.talents, i)
            break
        end
    end

    self.talent_type = nil
    self.tome.wanderer = nil
end
