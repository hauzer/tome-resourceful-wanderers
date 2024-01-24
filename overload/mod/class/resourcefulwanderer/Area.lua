local AddonAware = require('mod.class.resourcefulwanderer.AddonAware')
local Makeable = require('mod.class.resourcefulwanderer.Makeable')
local Area = require('mod.class.resourcefulwanderer.Area')
local Talent = require('mod.class.resourcefulwanderer.Talent')
local TalentGroup = require('mod.class.resourcefulwanderer.TalentGroup')
local TalentType = require('mod.class.resourcefulwanderer.TalentType')
local TalentTypeQueue = require('mod.class.resourcefulwanderer.TalentTypeQueue')
local WeaponMasteries = require('mod.class.resourcefulwanderer.WeaponMasteries')


module(..., package.seeall, class.inherit(AddonAware))


function _M:init(definition)
    AddonAware.init(definition)
    if self:isNil() then
        return
    end

    self.is_covered = false
    self.actor = definition.actor

    self.cover_categories = definition.cover_categories == nil and { } or definition.cover_categories
    self.ignore_categories = definition.ignore_categories == nil and { } or definition.ignore_categories
    self.cover_talent_types = definition.cover_talent_types == nil and { } or definition.cover_talent_types
    self.ignore_talent_types = definition.ignore_talent_types == nil and { } or definition.ignore_talent_types

    self.talent_type_queue = TalentTypeQueue.new(definition.talent_type_queue)
end


-- Covers an area
function _M:cover()
    if self.is_covered then
        return
    end

    self.talent_types = self.talent_type_queue:take()
    for _, talent_type in ipairs(self.talent_types) do
        talent_type:addToGame()
        talent_type:learn(self.actor)
    end

    self.is_covered = true
end
