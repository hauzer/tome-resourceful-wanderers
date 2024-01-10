local Game = require('mod.class.Game')


_M = loadPrevious(...)


local base_makeWanderer = _M.makeWanderer
function _M:makeWanderer()
    self.actor.hauzer.resourceful_wanderers = { }
    local resourceful_wanderers = self.actor.hauzer.resourceful_wanderers

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

    -- "Areas" covered by wanderer categories
    resourceful_wanderers.areas_covered = {
        equilibrium = false,
        souls = false,
        insanity = false,
        steam = false
    }

    -- Wanderer categories definition
    resourceful_wanderers.talent_types = {
        {
            name = 'wanderer/asceticism',
            area = 'equilibrium',
            talent_ids = {
                'T_MEDITATION',
                'T_ANCESTRAL_LIFE',
                'T_HEALING_NEXUS'
            },
            does_support_talent_type_id = function(talent_type_id)
                local category_id = talent_type_id:gsub('/.*', '')
                return category_id == 'wild-gift'
            end
        },
        {
            name = 'wanderer/wilderman',
            area = 'equilibrium',
            talent_ids = {
                'T_SWALLOW',
                'T_MUCUS',
                'T_JELLY',
                'T_NATURE_S_DEFIANCE'
            },
            does_support_talent_type_id = function(talent_type_id)
                local category_id = talent_type_id:gsub('/.*', '')
                return category_id == 'wild-gift'
            end
        }
    }

    local soulpoacher_talent_type = {
        name = 'wanderer/soulpoacher',
        area = 'souls',
        talent_ids = {
            'T_SOUL_LEECH'
        },
        does_support_talent_type_id = function(talent_type_id)
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
        end
    }

    -- Handle Ashes of Urh'Rok
    if Game:isAddonActive('ashes-urhrok') then
        table.insert(soulpoacher_talent_type.talent_ids, 'T_RAZE')
    end
    table.insert(soulpoacher_talent_type.talent_ids, 'T_IMPENDING_DOOM')
    table.insert(resourceful_wanderers.talent_types, soulpoacher_talent_type)

    -- Handle Forbidden Cults
    if Game:isAddonActive('cults') then
        table.insert(resourceful_wanderers.talent_types,
            {
                name = 'wanderer/entropy',
                area = 'insanity',
                talent_ids = {
                    'T_ENTROPIC_GIFT',
                    'T_NETHERBLAST',
                    'T_RIFT_CUTTER'
                },
                does_support_talent_type_id = function(talent_type_id)
                    local category_id = talent_type_id:gsub('/.*', '')
                    return category_id == 'demented'
                end
            }
        )

        table.insert(resourceful_wanderers.talent_types,
            {
                name = 'wanderer/mutation',
                area = 'insanity',
                talent_ids = {
                    'T_MUTATED_HAND',
                    'T_DIGEST',
                    'T_CARRION_FEET'
                },
                does_support_talent_type_id = function(talent_type_id)
                    local category_id = talent_type_id:gsub('/.*', '')
                    return category_id == 'demented'
                end
            }
        )

        table.insert(resourceful_wanderers.talent_types,
            {
                name = 'wanderer/insanity',
                area = 'insanity',
                talent_ids = {
                    'T_DARK_WHISPERS',
                    'T_TENTACLED_WINGS',
                    'T_DECAYING_GROUNDS',
                },
                does_support_talent_type_id = function(talent_type_id)
                    local category_id = talent_type_id:gsub('/.*', '')
                    return category_id == 'demented'
                end
            }
        )
    end

    -- Handle Embers of Rage
    if Game:isAddonActive('orcs') then
        table.insert(resourceful_wanderers.talent_types,
            {
                name = 'wanderer/scrapper',
                area = 'steam',
                talent_ids = {
                    'T_THERAPEUTICS',
                    'T_CHEMISTRY',
                    'T_EXPLOSIVES'
                },
                does_support_talent_type_id = function(talent_type_id)
                    local category_id = talent_type_id:gsub('/.*', '')
                    return category_id == 'steamtech'
                end
            }
        )
    end

    -- Create wanderer categories definitions
    resourceful_wanderers.talent_ids = { }
    for _, category in ipairs(resourceful_wanderers.talent_types) do
        self.actor.__increased_talent_types = self.actor.__increased_talent_types or { }
        for _, talent_id in ipairs(category.talent_ids) do
            table.insert(self.actor.talents_types_def[category.name].talents, self.actor.talents_def[talent_id])
            table.insert(resourceful_wanderers.talent_ids, talent_id)
        end
    end

    -- Get the seed and shuffle the tables
    local _, _, iseed = self.actor.randventurer_seed:find('^([0-9]+)%-')
    local seed = tonumber(iseed)

    rng.seed(seed)
    table.shuffle(resourceful_wanderers.talent_types)
    rng.seed(os.time())

    -- Execute the delayed calls
    for _, call in ipairs(randventurerLearn_calls) do
        self.actor:randventurerLearn(call.what, call.silent)
    end

    self.finish()

    -- Thanks to rexorcorum for reminding me about this :)
    self.actor:learnTalent('T_SHOOT', true)

    return retval
end


return _M
