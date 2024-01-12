_M = loadPrevious(...)


local subtleMessageWarningColor = { r=255, g=255, b=80 }


local base_learnType = _M.learnType
function _M:learnType(tt, v)
    local resourceful_wanderers = game.player.hauzer.resourceful_wanderers
    if self.actor ~= game.player or not resourceful_wanderers then
        return base_learnType(self, tt, v)
    end

    if v then
        -- Wanderer categories can't be improved
        if resourceful_wanderers:knows_talent_type_id(tt) then
            self:subtleMessage(_t"Impossible", _t"You cannot improve a Wanderer category mastery!", subtleMessageWarningColor)
            return
        end
    end

    return base_learnType(self, tt, v)
end


local base_generateList = _M.generateList
function _M:generateList()
    local resourceful_wanderers = game.player.hauzer.resourceful_wanderers
    if self.actor ~= game.player or not resourceful_wanderers then
        return self:base_generateList(self)
    end

    local base_actor_knowTalentType = self.actor.knowTalentType
    self.actor.knowTalentType = function(self, talent_type_id)
        local retval = base_actor_knowTalentType(self, talent_type_id)
        if retval ~= nil then
            local talent_type = self.talents_types_def[talent_type_id]

            for i, talent in ipairs(talent_type.talents) do
                if resourceful_wanderers:owns_talent_type_id(talent_type.type) then
                    if not talent.orig_levelup_screen_break_line then
                        talent.orig_levelup_screen_break_line = talent.levelup_screen_break_line
                    end

                    talent.levelup_screen_break_line = i % 4 == 0 and i ~= #talent_type.talents
                else if talent.orig_levelup_screen_break_line then
                    talent.levelup_screen_break_line = talent.orig_levelup_screen_break_line
                    talent.orig_levelup_screen_break_line = nil
                end end
            end
        end

        return retval
    end

    local retval = base_generateList(self)
    self.actor.knowTalentType = base_actor_knowTalentType
    return retval
end


return _M
