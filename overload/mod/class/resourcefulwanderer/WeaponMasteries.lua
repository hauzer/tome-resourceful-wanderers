local AddonAware = require('mod.class.resourcefulwanderer.AddonAware')
local Makeable = require('mod.class.resourcefulwanderer.Makeable')
local Area = require('mod.class.resourcefulwanderer.Area')
local Talent = require('mod.class.resourcefulwanderer.Talent')
local TalentGroup = require('mod.class.resourcefulwanderer.TalentGroup')
local TalentType = require('mod.class.resourcefulwanderer.TalentType')
local TalentTypeGroup = require('mod.class.resourcefulwanderer.TalentTypeGroup')
local WeaponMasteries = require('mod.class.resourcefulwanderer.WeaponMasteries')


module(..., package.seeall, class.inherit(Makeable))


function _M:init(definitions)
    self.groups = { }
    for key, definition in pairs(definitions) do
        if type(key) == 'string' then
            local main_talent = key
            for _, other_talent in ipairs(definition) do
                table.insert(self.groups, { main_talent, other_talent })
            end
        else
            table.insert(self.groups, definition)
        end
    end
end


-- Gets all competing mastery talents for the given talent
function _M:getCompetingMasteryTalents(talent_id)
    local competing_talents = { }
    for _, group in pairs(self.groups) do
        local is_competing_group = false
        local other_talents = { }
        for _, group_talent_id in ipairs(group) do
            if group_talent_id == talent_id then
                is_competing_group = true
            else
                table.insert(other_talents, group_talent_id)
            end
        end

        if is_competing_group then
            for _, other_talent in ipairs(other_talents) do
                table.insert(competing_talents, other_talent)
            end
        end
    end

    return competing_talents
end
