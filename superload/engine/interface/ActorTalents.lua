_M = loadPrevious(...)


-- Make talents in wanderer categories able to be learned in any order and without other original category-specific requirements
function _M:with_freestanding_resourceful_talent(talent, callback)
    local resourceful_wanderers = self.hauzer.resourceful_wanderers

    for _, resourceful_talent_type in ipairs(resourceful_wanderers.talent_types) do
        if self:knowTalentType(resourceful_talent_type.name) then
            for _, resourceful_talent_id in ipairs(resourceful_talent_type.talent_ids) do
                if resourceful_talent_id == talent.id then
                    local orig_type = talent.type

                    talent.type = {
                        resourceful_talent_type.name,
                        0
                    }

                    local retval = callback()

                    talent.type = orig_type

                    return retval
                end
            end
        end
    end

    return callback()
end

local base_learnTalentType = _M.learnTalentType
function _M:learnTalentType(tt, v)
    local resourceful_wanderers = self.hauzer.resourceful_wanderers
    if not resourceful_wanderers then
        return base_learnTalentType(self, tt, v)
    end

    if tt:gsub('/.*', '') ~= 'wanderer' then
        for _, resourceful_talent_type in ipairs(resourceful_wanderers.talent_types) do
            if resourceful_talent_type.does_support_talent_type_id(tt) then
                -- If the area hasn't been covered, cover it (usually means learning a wanderer category)
                if not resourceful_wanderers.areas_covered[resourceful_talent_type.area] then
                    base_learnTalentType(self, resourceful_talent_type.name, false)
                    resourceful_wanderers.areas_covered[resourceful_talent_type.area] = true
                    
                    -- Handle steam-specific stuff
                    if resourceful_talent_type.area == 'steam' then
                        self:learnTalent('T_CREATE_TINKER', true)

                        -- Give the player some basic steamtech items
                        local items = {
                            {
                                amount = 1,
                                data = {
                                    defined='APE',
                                    base_list='mod.class.Object:/data-orcs/general/objects/quest-artifacts.lua'
                                }
                            },
                            {
                                amount = 2,
                                data = {
                                    type='scroll',
                                    subtype='implant',
                                    name='steam generator implant',
                                    base_list='mod.class.Object:/data-orcs/general/objects/inscriptions.lua',
                                    autoreq=true,
                                    ego_chance=-1000
                                }
                            },
                            {
                                amount = 2,
                                data = {
                                    type='weapon',
                                    subtype='steamsaw',
                                    name='iron steamsaw',
                                    base_list='mod.class.Object:/data-orcs/general/objects/steamsaw.lua',
                                    autoreq=true,
                                    ego_chance=-1000
                                }
                            },
                            {
                                amount = 2,
                                data = {
                                    type='weapon',
                                    subtype='steamgun',
                                    name='iron steamgun',
                                    base_list='mod.class.Object:/data-orcs/general/objects/steamgun.lua',
                                    autoreq=true,
                                    ego_chance=-1000
                                }
                            }
                        }

                        for _, item in ipairs(items) do
                            for i = 1, item.amount do
                                local object = resolvers.resolveObject(self, item.data)
                                object.__transmo = true
                                object:identify(true)
                            end
                        end
                    end
                end

                -- If the player learned a category which contains a wanderer talent, remove it from the wanderer category
                for _, talent in ipairs(self.talents_types_def[tt].talents) do
                    local resourceful_talent_type_talents = self.talents_types_def[resourceful_talent_type.name].talents
                    local index_to_remove = -1
                    local count = 0
                    for i, resourceful_talent in ipairs(resourceful_talent_type_talents) do
                        if index_to_remove == -1 and talent.id == resourceful_talent.id then
                            index_to_remove = i

                            -- Remove the talent from the wanderer category definition table
                            local index_to_remove_j = -1
                            for j, talent in ipairs(resourceful_talent_type.talent_ids) do
                                if resourceful_talent.id == talent.id then
                                    index_to_remove_j = j
                                    break
                                end
                            end

                            if index_to_remove_j ~= -1 then
                                table.remove(resourceful_talent_type.talents, index_to_remove_j)
                            end

                            -- Remove the talent from the wanderer talents table
                            index_to_remove_j = -1
                            for j, talent_id in ipairs(resourceful_wanderers.talent_ids) do
                                if resourceful_talent.id == talent_id then
                                    index_to_remove_j = j
                                    break
                                end
                            end

                            if index_to_remove_j ~= -1 then
                                table.remove(resourceful_wanderers.talent_ids, index_to_remove_j)
                            end
                        else
                            count = count + 1
                        end
                    end

                    if index_to_remove ~= -1 then
                        table.remove(resourceful_talent_type_talents, index_to_remove)

                        -- If the wanderer category doesn't have any more talents, remove it and refund the category point if it was spent
                        if count == 0 then
                            if self.talents_types[resourceful_talent_type.name] == true then
                                self.unused_talent_types = self.unused_talent_types + 1
                            end

                            self.talents_types[resourceful_talent_type.name] = nil
                            self.changed = true
                        end
                    end
                end
            end
        end
    end

    return base_learnTalentType(self, tt, v)
end

local base_canLearnTalent = _M.canLearnTalent
function _M:canLearnTalent(t, offset, ignore_special)
    if not self.hauzer.resourceful_wanderers then
        return base_canLearnTalent(self, t, offset, ignore_special)
    end

    return self:with_freestanding_resourceful_talent(t, function()
        return base_canLearnTalent(self, t, offset, ignore_special)
    end)
end

local base_getTalentReqDesc = _M.getTalentReqDesc
function _M:getTalentReqDesc(t_id, levmod)
    if not self.hauzer.resourceful_wanderers then
        return base_getTalentReqDesc(self, t_id, levmod)
    end

    return self:with_freestanding_resourceful_talent(self.talents_def[t_id], function()
        return base_getTalentReqDesc(self, t_id, levmod)
    end)
end


return _M
