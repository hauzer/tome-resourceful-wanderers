_M = loadPrevious(...)


local base_makeWanderer = _M.makeWanderer
function _M:makeWanderer()
    self.actor.resourceful_randventurer = {}

    -- We need to delay calls to randventurerLearn() and indirectly to learnTalentType() so we can sort our tables according to the seed
    local randventurerLearn_calls = {}
    local base_randventurerLearn = self.actor.randventurerLearn
    self.actor.randventurerLearn = function(self, what, silent)
        table.insert(randventurerLearn_calls, {
            what = what,
            silent = silent
        })
    end

    -- Also delay the call to finish() so the talent types appear on character creation
    local base_finish = self.finish
    self.finish = function() end

    local retval = base_makeWanderer(self)
    self.actor.randventurerLearn = base_randventurerLearn
    self.finish = base_finish

    self.actor.resourceful_randventurer.talents_types_resolvers = {
        {
            resolved = 0,
            applies_to_talent_type_id = function(talent_type_id)
                local category_id = talent_type_id:gsub('/.*', '')
                return category_id == 'wild-gift'
            end,
            talents_ids_groups = {
                {
                    'T_MEDITATION'
                },
                {
                    'T_STONESHIELD'
                },
                {
                    'T_STONE_VINES',
                    'T_ELDRITCH_VINES'
                },
                {
                    'T_NATURE_S_DEFIANCE'
                },
                {
                    'T_ANCESTRAL_LIFE'
                },
                {
                    'T_HEALING_NEXUS'
                },
                {
                    'T_PSIBLADES',
                    'T_NATURE_S_EQUILIBRIUM'
                },
                {
                    'T_MUCUS'
                },
                {
                    'T_MITOSIS',
                    'T_REABSORB'
                },
                {
                    'T_SWALLOW'
                },
                {
                    'T_JELLY'
                }
            }
        },
        {
            resolved = 0,
            applies_to_talent_type_id = function(talent_type_id)
                local affected_talents_types_ids = {
                    'spell/age-of-dusk',
                    'spell/animus',
                    'spell/death',
                    'spell/dreadmaster',
                    'spell/eradication',
                    'spell/glacial-waste',
                    'spell/grave',
                    'spell/master-necromancer',
                    'spell/master-of-bones',
                    'spell/master-of-flesh',
                    'spell/rime-wraith',
                    'spell/undead-drake'
                }

                for _, affected_talent_type_id in ipairs(affected_talents_types_ids) do
                    if affected_talent_type_id == talent_type_id then
                        return true
                    end
                end

                return false
            end,
            talents_ids_groups = {
                {
                    'T_SOUL_LEECH'
                },
                {
                    'T_RAZE'
                }
            }
        },
        {
            resolved = 0,
            applies_to_talent_type_id = function(talent_type_id)
                local category_id = talent_type_id:gsub('/.*', '')
                return category_id == 'demented'
            end,
            talents_ids_groups = {
                {
                    'T_DISEASED_TONGUE'
                },
                {
                    'T_WORM_THAT_WALKS',
                    'T_WORM_THAT_STABS'
                },
                {
                    'T_CARRION_FEET'
                },
                {
                    'T_DIGEST'
                },
                {
                    'T_MUTATED_HAND'
                },
                {
                    'T_ENTROPIC_GIFT'
                },
                {
                    'T_DARK_WHISPERS'
                },
                {
                    'T_NETHERBLAST'
                },
                {
                    'T_RIFT_CUTTER'
                },
                {
                    'T_BLACK_MONOLITH'
                },
                {
                    'T_TENTACLED_WINGS'
                },
                {
                    'T_DECAYING_GROUNDS'
                }
            }
        }
    }

    -- Get the seed and shuffle the tables
    local _, _, iseed = self.actor.randventurer_seed:find('^([0-9]+)%-')
    local seed = tonumber(iseed)

    rng.seed(seed)
    for _, talents_types_resolver in ipairs(self.actor.resourceful_randventurer.talents_types_resolvers) do
        table.shuffle(talents_types_resolver.talents_ids_groups)
    end
    rng.seed(os.time())

    -- Execute the delayed calls
    for _, call in ipairs(randventurerLearn_calls) do
        self.actor:randventurerLearn(call.what, call.silent)
    end

    -- Thanks to rexorcorum for reminding me about this :)
    self.actor:learnTalent('T_SHOOT', true)

    self.finish()

    return retval
end


return _M
