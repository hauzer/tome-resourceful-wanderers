_M = loadPrevious(...)


local subtleMessageWarningColor = { r=255, g=255, b=80 }


local base_learnType = _M.learnType
function _M:learnType(tt, v)
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if self.actor ~= game.player or not resourceful_wanderers.is_active then
        return base_learnType(self, tt, v)
    end

    if v then
        -- Wanderer categories can't be improved
        if resourceful_wanderers:is_talent_type_from_area(tt) and self.actor:knowTalentType(tt) then
            self:subtleMessage(_t'Impossible', _t'You cannot improve a Wanderer category mastery!', subtleMessageWarningColor)
            return
        end
    end

    return base_learnType(self, tt, v)
end


local base_generateList = _M.generateList
function _M:generateList()
    local resourceful_wanderers = game:get_resourceful_wanderers()
    if self.actor ~= game.player or not resourceful_wanderers.is_active then
        return base_generateList(self)
    end

    local base_actor_knowTalentType = self.actor.knowTalentType
    self.actor.knowTalentType = function(self, talent_type_id)
        local retval = base_actor_knowTalentType(self, talent_type_id)
        if retval ~= nil then
            local tome_talent_type = self.talents_types_def[talent_type_id]

            for i, talent in ipairs(tome_talent_type.talents) do
                if resourceful_wanderers:is_talent_type_from_area(talent_type_id) then
                    if talent.orig_levelup_screen_break_line == nil then
                        talent.orig_levelup_screen_break_line = talent.levelup_screen_break_line
                    end

                    talent.levelup_screen_break_line = i % 4 == 0 and i ~= #tome_talent_type.talents
                elseif talent.orig_levelup_screen_break_line ~= nil then
                    talent.levelup_screen_break_line = talent.orig_levelup_screen_break_line
                    talent.orig_levelup_screen_break_line = nil
                end
            end
        end

        return retval
    end

    local retval = base_generateList(self)
    self.actor.knowTalentType = base_actor_knowTalentType
    return retval
end


return _M
