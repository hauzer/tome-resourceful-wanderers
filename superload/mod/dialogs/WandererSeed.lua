local Game = require('mod.class.Game')
local ActorTalents = require('engine.interface.ActorTalents')


_M = loadPrevious(...)


function _M:setup_resourceful_wanderers()
    self.actor.hauzer.resourceful_wanderers = { }
    local resourceful_wanderers = self.actor.hauzer.resourceful_wanderers

    function resourceful_wanderers:construct(actor)
        self.actor = actor

        -- Areas covered by wanderer categories
        self.areas_covered = {
            equilibrium = false,
            souls = false,
            insanity = false,
            steam = false,
            chrono = false
        }

        -- Wanderer category specifications
        local talent_types = {
            {
                names = {
                    'wanderer/ascetic',
                    'wanderer/hermit',
                    'wanderer/eremite'
                },
                area = 'equilibrium',
                generic = true,
                talents = {
                    'T_MEDITATION',
                    'T_ANCESTRAL_LIFE',
                    'T_HEALING_NEXUS'
                },
                remove_treshold = 1,
                descriptions = {
                    _t'Take the path of becoming one with all.',
                    _t'Take the path of becoming all with one.',
                    _t'Take the path of becoming.',
                },
                does_support_talent_type_id = function(talent_type_id)
                    local category_id = talent_type_id:gsub('/.*', '')
                    return category_id == 'wild-gift'
                end
            },
            {
                names = {
                    'wanderer/wilderman',
                    'wanderer/forager',
                    'wanderer/beast'
                },
                area = 'equilibrium',
                talents = {
                    'T_SWALLOW',
                    'T_MUCUS',
                    'T_JELLY',
                    'T_NATURE_S_DEFIANCE'
                },
                remove_treshold = 2,
                descriptions = {
                    _t'The forest calls out to you.',
                    _t'Mother Nature shall fight back!',
                    _t'[.....]'
                },
                does_support_talent_type_id = function(talent_type_id)
                    local category_id = talent_type_id:gsub('/.*', '')
                    return category_id == 'wild-gift'
                end
            },
            {
                names = {
                    'wanderer/soulpoacher',
                    'wanderer/soulsnatcher',
                    'wanderer/soulsnuffer'
                },
                area = 'souls',
                talents = {
                    'T_SOUL_LEECH',
                    'T_IMPENDING_DOOM',
                    {
                        id = 'T_RAZE',
                        addons = {
                            'ashes-urhrok'
                        }
                    }
                },
                remove_treshold = 1,
                descriptions = {
                    _t'The urge to feast is becoming maddening!',
                    _t'Souls? Collect them? Why not!',
                    _t'Ah, how they all keep me company.'
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
            },
            {
                names = {
                    'wanderer/madman',
                    'wanderer/mutant',
                    'wanderer/entropist'
                },
                area = 'insanity',
                addons = {
                    'cults'
                },
                talents = {
                    'T_ENTROPIC_GIFT',
                    'T_NETHERBLAST',
                    'T_RIFT_CUTTER',
                    'T_MUTATED_HAND',
                    'T_DIGEST',
                    'T_CARRION_FEET',
                    'T_DARK_WHISPERS',
                    'T_TENTACLED_WINGS',
                    'T_DECAYING_GROUNDS',
                    'T_BLACK_MONOLITH'
                },
                max_talents = 4,
                remove_treshold = 2,
                descriptions = {
                    _t'Let it go... let it all wash away.',
                    _t'You feel -- *something* -- stirring inside of you.',
                    _t'The shadows in the corner of your eye are starting to show themselves rather frequently as of late.'
                },
                does_support_talent_type_id = function(talent_type_id)
                    local category_id = talent_type_id:gsub('/.*', '')
                    return category_id == 'demented'
                end
            },
            {
                names = {
                    'wanderer/scrapper',
                    'wanderer/technician',
                    'wanderer/journeyman'
                },
                area = 'steam',
                addons = {
                    'orcs'
                },
                generic = true,
                talents = {
                    'T_THERAPEUTICS',
                    'T_CHEMISTRY',
                    'T_EXPLOSIVES'
                },
                remove_treshold = 0,
                descriptions = {
                    _t'Now, if I could just polarize this power converter...',
                    _t'*BANG!* *BANG!* *BANG!* Ooh, science is tough work!',
                    _t'Maybe the old professor was onto something.'
                },
                does_support_talent_type_id = function(talent_type_id)
                    local category_id = talent_type_id:gsub('/.*', '')
                    return category_id == 'steamtech'
                end
            }
            -- {
            --     name = 'wanderer/chrono',
            --     area = 'chrono',
            --     talents = {
            --         'T_THERAPEUTICS',
            --         'T_CHEMISTRY',
            --         'T_EXPLOSIVES'
            --     },
            --     description = _t'Now, if I could just polarize this power converter...',
            --     does_support_talent_type_id = function(talent_type_id)
            --         local category_id = talent_type_id:gsub('/.*', '')
            --         return category_id == 'steamtech'
            --     end
            -- }
        }

        -- Shuffle data accoring to the seed. The seed is set to the one generated by the base makeWanderer()
        for _, talent_type in ipairs(talent_types) do
            if talent_type.names then
                table.shuffle(talent_type.names)
                talent_type.name = talent_type.names[1]
            end

            table.shuffle(talent_type.talents)

            if talent_type.descriptions then
                table.shuffle(talent_type.descriptions)
                talent_type.description = talent_type.descriptions[1]
            end
        end
        table.shuffle(talent_types)

        -- Create wanderer categories definitions
        self.talent_types = { }
        for talent_type_i, talent_type in ipairs(talent_types) do
            -- Don't use categories whose addon requirements aren't met
            local talent_type_has_required_addons = true
            if talent_type.addons then
                for _, addon in ipairs(talent_type.addons) do
                    if not Game:isAddonActive(addon) then
                        talent_type_has_required_addons = false
                        break
                    end
                end
            end

            if talent_type_has_required_addons then
                ActorTalents:newTalentType {
                    allow_random = false,
                    no_silence = false,
                    is_spell = false,
                    type = talent_type.name,
                    name = _t(talent_type.name:gsub('.*/', ''), 'talent type'),
                    generic = talent_type.generic,
                    description = talent_type.description
                }

                local talents_to_keep = { }
                for _, talent in ipairs(talent_type.talents) do
                    -- Don't use talents whose addon requirements aren't met
                    local talent_has_required_addons = true
                    if talent.addons then
                        for _, addon in ipairs(talent.addons) do
                            if not Game:isAddonActive(addon) then
                                talent_has_required_addons = false
                                break
                            end
                        end
                    end

                    if talent_has_required_addons then
                        table.insert(talents_to_keep, talent)

                        if #talents_to_keep == talent_type.max_talents then
                            break
                        end
                    end
                end

                -- Sort talents in category tree according to required level
                table.sort(talents_to_keep, function(talent_a, talent_b)
                    local talent_a_id = self:get_talent_id(talent_a)
                    local talent_b_id = self:get_talent_id(talent_b)

                    local talent_a_def = self.actor.talents_def[talent_a_id]
                    local talent_b_def = self.actor.talents_def[talent_b_id]

                    local talent_a_level = 0
                    local talent_b_level = 0

                    if talent_a_def.require.level then
                        talent_a_level = util.getval(talent_a_def.require.level, 1)
                    end

                    if talent_b_def.require.level then
                        talent_b_level = util.getval(talent_b_def.require.level, 1)
                    end

                    return talent_a_level < talent_b_level
                end)

                for _, talent in ipairs(talents_to_keep) do
                    local talent_id = self:get_talent_id(talent)
                    local talent_def = self.actor.talents_def[talent_id]

                    table.insert(self.actor.talents_types_def[talent_type.name].talents, talent_def)
                end

                talent_type.talents = talents_to_keep
                table.insert(self.talent_types, talent_type)
            end
        end
    end

    -- Get the talent ID from the specification talent object, whether it's a string or a table
    function resourceful_wanderers:get_talent_id(talent)
        if type(talent) == 'string' then
            return talent
        else
            return talent.id
        end
    end

    -- Does the addon currently manage the given talent?
    function resourceful_wanderers:owns_talent_id(talent_id)
        for _, talent_type in ipairs(self.talent_types) do
            for _, talent in ipairs(talent_type.talents) do
                if self:get_talent_id(talent) == talent_id then
                    return true
                end
            end
        end

        return false
    end

    -- Does the addon currently manage the given talent?
    function resourceful_wanderers:disown_talent_id(talent_id)
        local talent_types_to_keep = { }
        for _, talent_type in ipairs(self.talent_types) do
            local index_to_remove = -1
            local count = 0

            -- If the player learned a category which contains a wanderer talent, remove it from the wanderer category
            for i, talent in ipairs(talent_type.talents) do
                if index_to_remove == -1 and self:get_talent_id(talent) == talent_id then
                    index_to_remove = i
                end

                count = count + 1
            end

            if index_to_remove ~= -1 then
                table.remove(talent_type.talents, index_to_remove)
                table.remove(self.actor.talents_types_def[talent_type.name].talents, index_to_remove)
            end

            if count > talent_type.remove_treshold then
                table.insert(talent_types_to_keep, talent_type)
            -- If the wanderer category doesn't have any more talents, remove it and refund the talent and category point if they were spent
            else
                for _, talent in ipairs(talent_type.talents) do
                    self.actor:unlearnTalentFull(self:get_talent_id(talent))
                end

                if self.actor.talents_types[talent_type.name] == true then
                    self.actor.unused_talents_types = self.actor.unused_talents_types + 1
                end

                self.actor.talents_types[talent_type.name] = nil
                self.actor.changed = true
            end
        end

        self.talent_types = talent_types_to_keep
    end

    -- Does the addon currently manage the given category?
    function resourceful_wanderers:get_talent_type(talent_type_id)
        for _, talent_type in ipairs(self.talent_types) do
            if talent_type.name == talent_type_id then
                return talent_type
            end
        end
    end

    -- Does the addon currently manage the given category?
    function resourceful_wanderers:owns_talent_type_id(talent_type_id)
        if resourceful_wanderers:get_talent_type(talent_type_id) then
            return true
        end

        return false
    end

    -- Actor knows a currently managed category?
    function resourceful_wanderers:knows_talent_type_id(talent_type_id)
        return self:owns_talent_type_id(talent_type_id) and self.actor:knowTalentType(talent_type_id)
    end

    -- Get the supporting wanderer category for the given category
    function resourceful_wanderers:get_supporting_talent_type(talent_type_id)
        for _, talent_type in ipairs(self.talent_types) do
            if talent_type.does_support_talent_type_id and talent_type.does_support_talent_type_id(talent_type_id) then
                return talent_type
            end
        end
    end

    -- Get the first known wanderer category which contains the given talent
    function resourceful_wanderers:get_known_talent_type_for_talent_id(talent_id)
        for _, talent_type in ipairs(self.talent_types) do
            if self.actor:knowTalentType(talent_type.name) then
                for _, talent in ipairs(talent_type.talents) do
                    if self:get_talent_id(talent) == talent_id then
                        return talent_type
                    end
                end
            end
        end
    end

    -- Cover an area
    function resourceful_wanderers:cover_area(supporting_talent_type, learnTalentType)
        if not self.areas_covered[supporting_talent_type.area] then
            learnTalentType(self.actor, supporting_talent_type.name, false)
            self.areas_covered[supporting_talent_type.area] = true
            
            -- Handle steam-specific stuff
            if supporting_talent_type.area == 'steam' then
                self.actor:learnTalent('T_CREATE_TINKER', true)

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
                            ego_chance=-1000
                        }
                    }
                }

                for _, item in ipairs(items) do
                    for i = 1, item.amount do
                        local object = resolvers.resolveObject(self.actor, item.data)
                        object.__transmo = true
                        object:identify(true)
                    end
                end
            end
        end
    end

    -- Make talents in wanderer categories able to be learned in any order and without other original category-specific requirements
    function resourceful_wanderers:with_freestanding_wanderer_talent(talent, callback)
        local talent_type = self:get_known_talent_type_for_talent_id(talent.id)
        if talent_type then
            local orig_type = talent.type
            talent.type = {
                talent_type.name,
                0
            }

            local retval = callback()

            talent.type = orig_type
            return retval
        end

        return callback()
    end

    resourceful_wanderers:construct(self.actor)

    -- Thanks to rexorcorum for reminding me about this :)
    self.actor:learnTalent('T_SHOOT', true)
end

local base_makeWanderer = _M.makeWanderer
function _M:makeWanderer()
    -- We need to delay calls to randventurerLearn() and indirectly to learnTalentType() so we can use the seed
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

    -- Get the seed and setup the addon
    local _, _, iseed = self.actor.randventurer_seed:find('^([0-9]+)%-')
    local seed = tonumber(iseed)

    rng.seed(seed)
    self:setup_resourceful_wanderers()
    rng.seed(os.time())

    -- Execute the delayed calls
    for _, call in ipairs(randventurerLearn_calls) do
        self.actor:randventurerLearn(call.what, call.silent)
    end

    self.finish()

    return retval
end


return _M
