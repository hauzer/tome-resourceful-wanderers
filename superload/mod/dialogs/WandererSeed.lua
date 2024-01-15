local Game = require('mod.class.Game')
local ActorTalents = require('engine.interface.ActorTalents')


_M = loadPrevious(...)


function _M:setup_resourceful_wanderers()
    local resourceful_wanderers = game.resourceful_wanderers

    function resourceful_wanderers:construct(actor)
        self.is_active = true
        self.actor = actor

        self.weapon_mastery_talent_groups = {
            {
                'T_AUTOLOADER',
                'T_STEAMGUN_MASTERY',
                'T_PSYSHOT'
            }
        }

        self.talent_type_name_pools = {
            fire = {
                'pyromaniac',
                'arsonist',
                'torch'
            },
            electricity = {
                'conduit',
                'electro',
                'spark'
            }
        }

        self.talent_type_description_pools = {
            fire = {
                _t'Everything you touch seems to go up in blazes!',
                _t'Your hands are warm, hot, they burn!',
                _t'You... must... release... the... flame...'
            },
            electricity = {
                _t'Woah, cool! You hair stands up all wavy on its own!',
                _t'Ouch, ouch! Dammit, everything you touch sparks!',
                _t'*bzzzzzzzztt* The humming just won\'t stop.'
            }
        }

        -- Talent type declarations
        -- These are used in multiple areas
        self.talent_type_declarations = {
            ['stone-alchemy'] = {
                names = {
                    'jeweler',
                    'gemologist',
                    'crafstman'
                },
                is_generic = true,
                talents = {
                    'T_EXTRACT_GEMS',
                    'T_IMBUE_ITEM',
                    {
                        'T_GEM_PORTAL',
                        'T_STONE_TOUCH'
                    }
                },
                descriptions = {
                    _t'Shiny!',
                    _t'Let\'s see what we got in this haul.',
                    _t'My precious...'
                }
            },
            golemancy = {
                names = {
                    'sculptor',
                    'carver',
                    'idolatrol'
                },
                talents = {
                    'T_GOLEM_POWER',
                    'T_GOLEM_RESILIENCE',
                    {
                        'T_INVOKE_GOLEM',
                        'T_GOLEM_PORTAL'
                    }
                },
                descriptions = {
                    _t'It\'s alive!',
                    _t'I brought you to life, and I shall command you!',
                    _t'Oh, powerful spirit inhabiting this construct, aid me and protect me from my foes.'
                }
            },
            explosives = {
                names = {
                    'bomber',
                    'blaster',
                    'detonator'
                },
                talents = {
                    'T_THROW_BOMB',
                    'T_ALCHEMIST_PROTECTION',
                    'T_EXPLOSION_EXPERT'
                },
                descriptions = {
                    _t'BOOOM!!',
                    _t'Uh, which gems are explosive again?',
                    _t'I\'m pretty sure I had eyebrows yesterday.'
                }
            },
            souls = {
                names = {
                    'soulpoacher',
                    'soulsnatcher',
                    'soulsnuffer'
                },
                talents = {
                    {
                        id = 'T_SOUL_LEECH',
                        is_signature = true
                    },
                    'T_IMPENDING_DOOM',
                    {
                        id = 'T_RAZE',
                        addon = 'ashes-urhrok',
                        is_signature = true
                    }
                },
                own_remove_treshold = 1,
                descriptions = {
                    _t'The urge to feast is becoming maddening!',
                    _t'Souls? Collect them? Why not!',
                    _t'Ah, how they all keep me company.'
                }
            }
        }

        -- Area declarations
        self.area_declarations = {
            equilibrium = {
                cover_category = 'wild-gift',
                ignore_talent_types = {
                    'wild-gift/fungus',
                    'wild-gift/harmony'
                },
                talent_types_group = {
                    {
                        names = {
                            'recluse',
                            'hermit',
                            'eremite'
                        },
                        is_generic = true,
                        talents = {
                            'T_MEDITATION',
                            'T_ANCESTRAL_LIFE',
                            'T_HEALING_NEXUS'
                        },
                        own_remove_treshold = 1,
                        descriptions = {
                            _t'Patient solitude leads to greater understanding.',
                            _t'You never enjoyed living in the world.',
                            _t'Give what you have, take what is offered.',
                        }
                    },
                    {
                        names = {
                            'wilderman',
                            'forager',
                            'beast'
                        },
                        talents = {
                            'T_SWALLOW',
                            'T_MUCUS',
                            'T_JELLY',
                            'T_NATURE_S_DEFIANCE'
                        },
                        own_remove_treshold = 2,
                        descriptions = {
                            _t'The forest calls out to you.',
                            _t'Mother Nature shall fight back!',
                            _t'Ah! It\'s a good day to take a stroll and never come back.'
                        }
                    }
                }
            },
            souls = {
                cover_talent_types = {
                    'spell/age-of-dusk',
                    'spell/death',
                    'spell/glacial-waste',
                    'spell/master-of-bones',
                    'spell/master-of-flesh',
                    'spell/rime-wraith'
                },
                talent_type = 'souls'
            },
            minions = {
                cover_talent_types = {
                    'spell/eradication',
                    'spell/dreadmaster',
                    'spell/grave',
                    'spell/master-necromancer'
                },
                talent_type_group = {
                    'souls',
                    {
                        names = {
                            'gravekeeper',
                            'mortician',
                            'undertaker'
                        },
                        talents = {
                            {
                                id = 'T_CALL_OF_THE_CRYPT',
                                is_sticky = true
                            },
                            {
                                'T_SHATTERED_REMAINS',
                                'T_ASSEMBLE',
                                'T_LORD_OF_SKULLS'
                            },
                            {
                                id = 'T_CALL_OF_THE_MAUSOLEUM',
                                is_sticky = true
                            },
                            {
                                'T_CORPSE_EXPLOSION',
                                'T_PUTRESCENT_LIQUEFACTION',
                                'T_DISCARDED_REFUSE'
                            }
                        },
                        max_talents = 4,
                        descriptions = {
                            _t'Twitch, twitch! They still twitch.',
                            _t'From dust you came, to dust you shall return. And from dust you shall rise again once more.',
                            _t'I take such good care of you, no wonder death can\'t separate us.'
                        }
                    }
                }
            },
            insanity = {
                addon = 'cults',
                cover_category = 'demented',
                ignore_talent_types = {
                    'demented/entropy',
                    'demented/nether',
                    'demented/tentacles',
                    'demented/slow-death',
                    'demented/madness',
                    'demented/scourge-drake',
                    'demented/oblivion'
                },
                talent_type = {
                    names = {
                        'madman',
                        'mutant',
                        'specimen'
                    },
                    talents = {
                        'T_MUTATED_HAND',
                        'T_DIGEST',
                        'T_CARRION_FEET',
                        'T_DARK_WHISPERS',
                        'T_TENTACLED_WINGS',
                        'T_DECAYING_GROUNDS',
                        'T_BLACK_MONOLITH'
                    },
                    max_talents = 4,
                    own_remove_treshold = 2,
                    descriptions = {
                        _t'You feel -- *something* -- stirring inside of you.',
                        _t'Hahh-ahhah!',
                        _t'That alchemist is going to have a taste of his own medicine.'
                    }
                }
            },
            entropy = {
                addon = 'cults',
                cover_talent_type = 'demented/oblivion',
                talent_type = {
                    names = {
                        'entropist',
                        'nihilist',
                        'antirealist'
                    },
                    talents = {
                        'T_NETHERBLAST',
                        'T_RIFT_CUTTER',
                        'T_SPATIAL_DISTORTION',
                        'T_POWER_OVERWHELMING'
                    },
                    max_talents = 3,
                    own_remove_treshold = 1,
                    descriptions = {
                        _t'Reality is an illusion. Shatter it!',
                        _t'Let the unbecoming essence of the universe wash over you...',
                        _t'It\'s as though there\'s less of you each passing moment.'
                    }
                }
            },
            steamtech = {
                addon = 'orcs',
                cover_category = 'steamtech',
                cover_talent_types = {
                    'psionic/action-at-a-distance',
                    'psionic/gestalt',
                    'psionic/psionic-fog'
                },
                ignore_talent_types = {
                    'steamtech/blacksmith',
                    'steamtech/chemistry',
                    'steamtech/physics'
                },
                talent_type = {
                    names = {
                        'scrapper',
                        'technician',
                        'journeyman'
                    },
                    is_generic = true,
                    talents = {
                        {
                            take = 2,
                            'T_THERAPEUTICS',
                            'T_CHEMISTRY',
                            'T_EXPLOSIVES'
                        },
                        {
                            take = 2,
                            'T_SMITH',
                            'T_MECHANICAL',
                            'T_ELECTRICITY'
                        }
                    },
                    max_talents = 4,
                    descriptions = {
                        _t'Now, if I could just polarize this power converter...',
                        _t'*BANG!* *BANG!* *BANG!* Ooh, science is tough work!',
                        _t'Maybe the old professor was onto something.'
                    },
                    on_cover = function(self, log_message)
                        -- Give the player some basic steamtech items
                        local items = {
                            {
                                amount = 1,
                                data = {
                                    defined='APE',
                                    base_list='mod.class.Object:/data-orcs/general/objects/quest-artifacts.lua'
                                },
                                transmogrify = false
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
                            for _ = 1, item.amount do
                                local object = resolvers.resolveObject(resourceful_wanderers.actor, item.data)
                                if item.transmogrify ~= nil then
                                    object.__transmo = item.transmogrify
                                else
                                    object.__transmo = true
                                end

                                object:identify(true)
                            end
                        end

                        log_message.data = log_message.data .. ' You also find some gadgets.'
                    end
                }
            },
            ['chronomancy/spellbinding'] = {
                talent_type = {
                    names = {
                        'clockmaker',
                        'historian',
                        'chronologist'
                    },
                    talent_groups = {
                        {
                            'T_WARP_BLADE',
                            'T_BLINK_BLADE',
                            'T_BLADE_SHEAR',
                            'T_ARROW_STITCHING',
                            'T_SINGULARITY_ARROW',
                            'T_ATTENUATE',
                            'T_REPULSION_BLAST',
                            'T_GRAVITY_SPIKE',
                            'T_GRAVITY_LOCUS',
                            'T_GRAVITY_WELL',
                            'T_DUST_TO_DUST',
                            'T_MATERIALIZE_BARRIER',
                            'T_SPATIAL_TETHER',
                            'T_BANISH',
                            'T_DIMENSIONAL_ANCHOR',
                            'T_HASTE',
                            'T_TIME_STOP',
                            'T_CHRONO_TIME_SHIELD',
                            'T_STOP',
                            'T_STATIC_HISTORY',
                            'T_WEAPON_FOLDING',
                            'T_INVIGORATE',
                            'T_BREACH',
                            'T_WARDEN_S_FOCUS',
                            'T_THREAD_WALK',
                            'T_THREAD_THE_NEEDLE',
                            'T_RETHREAD',
                            'T_TEMPORAL_FUGUE',
                            'T_CEASE_TO_EXIST',
                            'T_TEMPORAL_BOLT',
                            'T_TIME_SKIP',
                            'T_TEMPORAL_REPRIEVE',
                            'T_ECHOES_FROM_THE_PAST'
                        },
                        {
                            is_generic = true,
                            'T_PRECOGNITION',
                            'T_CONTINGENCY',
                            'T_SEE_THE_THREADS',
                            'T_ENERGY_DECOMPOSITION',
                            'T_ENERGY_ABSORPTION',
                            'T_REDUX',
                            'T_ENTROPY',
                            'T_WORMHOLE'
                        }
                    },
                    max_talents = 8,
                    disown_remove_treshold = 4,
                    talent_learn_limit = 4,
                    descriptions = {
                        _t'Didn\'t I have this deja vu already? Deja-deja vu?',
                        _t'Very strange that these clocks are all showing different incorrect times. Again.',
                        _t'Is that... me?!'
                    }
                },
            },
            ['corruption/heart-of-fire'] = {
                addon = 'ashes-urhrok',
                talent_type = {
                    name = 'incinerator',
                    talents = {
                        {
                            id = 'T_INCINERATING_BLOWS',
                            is_signature = true
                        },
                        'T_FIERY_GRASP',
                        'T_FEARSCAPE_SHIFT',
                        'T_CAUTERIZE_SPIRIT',
                        'T_INFERNAL_BREATH_DOOM',
                        'T_FEARSCAPE_AURA'
                    },
                    max_talents = 3,
                    descriptions = {
                        _t'The smell of sulfur follows you everywhere you go.',
                        _t'You\'re drawn to fire like a moth. Bathe in it.',
                        _t'Set the world ablaze!'
                    }
                }
            },
            ['corruption/wrath'] = {
                addon = 'ashes-urhrok',
                talent_type = {
                    name = 'destroyer',
                    talents = {
                        'T_DRAINING_ASSAULT',
                        'T_RECKLESS_STRIKE',
                        'T_ABDUCTION',
                        'T_INCINERATING_BLOWS',
                        'T_FEARSCAPE_AURA'
                    },
                    max_talents = 4,
                    own_remove_treshold = 2,
                    descriptions = {
                        _t'You\'ve never been more vital. You just feel the need to take it out on something, or someone.',
                        _t'Muscles ache from bulging, release the pain!',
                        _t'Something drives you to DESTROY!'
                    }
                }
            },
            shadows = {
                cover_talent_types = {
                    'cursed/advanced-shadowmancy',
                    'cursed/one-with-shadows'
                },
                talent_type = {
                    names = {
                        'umbra',
                        'silhoutte',
                        'contour'
                    },
                    talents = {
                        {
                            id = 'T_CALL_SHADOWS',
                            is_signature = true
                        },
                        'T_FOCUS_SHADOWS',
                        'T_SHADOW_SENSES',
                        'T_SHADOWS_EMPATHY',
                        'T_SHADOW_TRANSPOSITION',
                        'T_SHADOW_DECOY',
                        'T_MERGE',
                        'T_STONE',
                        'T_SHADOW_S_PATH',
                        'T_CURSED_BOLT'
                    },
                    max_talents = 4,
                    descriptions = {
                        _t'Darkness... soothing...',
                        _t'Light scares away the friends.',
                        _t'The shadows in the corner of your eye are starting to show themselves rather frequently as of late.'
                    }
                }
            },
            ['psionic/charged-mastery'] = {
                talent_type = {
                    name_pool = 'electricity',
                    talents = {
                        'T_CHARGED_SHIELD',
                        'T_CHARGE_LEECH',
                        'T_CHARGED_AURA',
                        'T_CHARGED_STRIKE',
                        'T_BRAIN_STORM'
                    },
                    max_talents = 4,
                    own_remove_treshold = 2,
                    description_pool = 'electricity'
                }
            },
            ['psionic/kinetic-mastery'] = {
                talent_type = {
                    name = 'kineticist',
                    talents = {
                        'T_KINETIC_SHIELD',
                        'T_KINETIC_LEECH',
                        'T_KINETIC_AURA',
                        'T_KINETIC_STRIKE',
                        'T_MINDLASH'
                    },
                    max_talents = 4,
                    own_remove_treshold = 2,
                    descriptions = {
                        _t'Heey what, did I move that cup?!',
                        _t'Heh, funny. The rock just bounced off of me.',
                        _t'I think my body is going to atrophy if I continue doing this.'
                    }
                }
            },
            ['psionic/thermal-mastery'] = {
                talent_type = {
                    name_pool = 'fire',
                    talents = {
                        'T_THERMAL_SHIELD',
                        'T_THERMAL_LEECH',
                        'T_THERMAL_AURA',
                        'T_THERMAL_STRIKE',
                        'T_PYROKINESIS'
                    },
                    max_talents = 4,
                    own_remove_treshold = 2,
                    description_pool = 'fire'
                }
            },
            ['psionic/discharge'] = {
                talent_type_group = {
                    {
                        names = {
                            'lunatic',
                            'psycho',
                            'maniac'
                        },
                        talents = {
                            'T_MIND_SEAR',
                            'T_PSYCHIC_LOBOTOMY',
                            'T_SUNDER_MIND'
                        },
                        descriptions = {
                            _t'Get them out of my head, GET THEM OUT!!',
                            _t'Pity the confessor unfortunate enough to have to hear you.',
                            _t'In an insane world, it\'s only natural to go crazy.'
                        }
                    },
                    {
                        names = {
                            'mystic',
                            'guru',
                            'yogi'
                        },
                        talents = {
                            {
                                id = 'T_BIOFEEDBACK',
                                is_signature = true
                            },
                            'T_RESONANCE_FIELD',
                            'T_AMPLIFICATION',
                            'T_CONVERSION'
                        },
                        max_talents = 3,
                        descriptions = {
                            _t'Take the path of becoming one with all.',
                            _t'Take the path of becoming all with one.',
                            _t'Take the path of becoming.'
                        }
                    }
                }
            },
            alchemy = {
                cover_talent_types = {
                    'spell/acid-alchemy',
                    'spell/energy-alchemy',
                    'spell/fire-alchemy',
                    'spell/frost-alchemy'
                },
                talent_type_group = {
                    'golemancy',
                    'stone-alchemy',
                    'explosives'
                }
            },
            ['spell/advanced-golemancy'] = {
                talent_type_group = {
                    'golemancy',
                    'stone-alchemy'
                }
            },
            ['spell/explosives'] = {
                talent_type = 'stone-alchemy'
            },
            ['spell/aether'] = {
                talent_type = {
                    names = {
                        'apprentice',
                        'novice',
                        'neophyte'
                    },
                    talents = {
                        'T_MANATHRUST',
                        'T_DISRUPTION_SHIELD',
                        {
                            'T_ARCANE_POWER',
                            'T_ARCANE_VORTEX'
                        }
                    },
                    descriptions = {
                        _t'When is this book going to get GOOD?!',
                        _t'That\'s not the right incantation!',
                        _t'Focus... Must focus...'
                    }
                }
            },
            ['spell/storm'] = {
                talent_type = {
                    name_pool = 'electricity',
                    talents = {
                        'T_LIGHTNING',
                        {
                            take = 2,
                            'T_CHAIN_LIGHTNING',
                            'T_FEATHER_WIND',
                            'T_THUNDERSTORM'
                        }
                    },
                    description_pool = 'electricity'
                }
            },
            ['spell/wildfire'] = {
                talent_type = {
                    name_pool = 'fire',
                    talents = {
                        'T_FLAME',
                        {
                            take = 2,
                            'T_FLAMESHOCK',
                            'T_FIREFLASH',
                            'T_INFERNO'
                        }
                    },
                    description_pool = 'fire'
                }
            },
            ['steamtech/magnetism'] = {
                addon = 'orcs',
                talent_type = {
                    names = {
                        'contraptor',
                        'mechanic',
                        'gadgeteer'
                    },
                    talents = {
                        'T_DEPLOY_TURRET',
                        {
                            'T_OVERCLOCK',
                            'T_UPGRADE',
                            'T_HUNKER_DOWN'
                        },
                        'T_MECHARACHNID',
                        {
                            'T_STORMCOIL_GENERATOR',
                            'T_MECHARACHNID_CHASSIS',
                            'T_MECHARACHNID_PILOTING'
                        }
                    },
                    descriptions = {
                        _t'What does this button do?',
                        _t'... it isn\'t supposed to do that!',
                        _t'Heh, I can take back control of it, just give me a minute...'
                    }
                }
            },
            ['modded-guns'] = {
                cover_talent_types = {
                    'steamtech/artillery',
                    'steamtech/heavy-weapons',
                    'steamtech/chemical-warfare'
                },
                addon = 'orcs',
                talent_type = {
                    names = {
                        'modder',
                        'gunsmith',
                        'overclocker'
                    },
                    talents = {
                        {
                            id = 'T_AUTOLOADER',
                            is_signature = true
                        },
                        'T_OVERHEAT_BULLETS',
                        'T_SUPERCHARGE_BULLETS',
                        'T_PERCUSSIVE_BULLETS',
                        'T_COMBUSTIVE_BULLETS',
                        'T_DOUBLE_SHOTS',
                        'T_UNCANNY_RELOAD',
                        'T_STATIC_SHOT'
                    },
                    max_talents = 4,
                    descriptions = {
                        _t'There\'s always a way to juice out some more power.',
                        _t'Gotta pick the right tool for the job. And the job is killing stuff.',
                        _t'I wonder if I can make these two parts compatible...'
                    }
                }
            },
            guns = {
                cover_talent_types = {
                    'steamtech/bullets-mastery',
                    'steamtech/elusiveness',
                    'steamtech/gunslinging'
                },
                addon = 'orcs',
                talent_type = {
                    names = {
                        'pistolero',
                        'gunfighter',
                        'gunner'
                    },
                    talents = {
                        {
                            id = 'T_STEAMGUN_MASTERY',
                            is_signature = true
                        },
                        'T_STRAFE',
                        'T_STARTLING_SHOT',
                        'T_EVASIVE_SHOTS',
                        'T_TRICK_SHOT',
                        'T_DOUBLE_SHOTS',
                        'T_UNCANNY_RELOAD',
                        'T_STATIC_SHOT'
                    },
                    max_talents = 4,
                    descriptions = {
                        _t'Nothing better in life than the smell of gunpowder.',
                        _t'Fastest hand in the West... and East.',
                        _t'It\'s high noon.'
                    }
                }
            },
            ['psychic-guns'] = {
                cover_talent_types = {
                    'steamtech/dread',
                    'steamtech/mechstar'
                },
                addon = 'orcs',
                talent_type = {
                    names = {
                        'terrorist',
                        'hitman',
                        'gunman'
                    },
                    talents = {
                        {
                            id = 'T_PSYSHOT',
                            is_signature = true
                        },
                        'T_BOILING_SHOT',
                        'T_BLUNT_SHOT',
                        'T_VACUUM_SHOT',
                        'T_DOUBLE_SHOTS',
                        'T_UNCANNY_RELOAD',
                        'T_STATIC_SHOT',
                        'T_LUCID_SHOT',
                        'T_PSY_WORM'
                    },
                    max_talents = 4,
                    descriptions = {
                        _t'Meditate on the shot before pulling the trigger.',
                        _t'It\'s not about accuracy, it\'s about terror.',
                        _t'Break their mind before firing a single shot. Then they\'re easy marks.'
                    }
                }
            },
            steamsaws = {
                cover_talent_types = {
                    'steamtech/sawmaiming',
                    'steamtech/battlefield-management',
                    'steamtech/automated-butchery'
                },
                addon = 'orcs',
                talent_type = {
                    names = {
                        'butcher',
                        'gorefiend',
                        'decapitator'
                    },
                    talents = {
                        {
                            id = 'T_STEAMSAW_MASTERY',
                            is_signature = true
                        },
                        'T_OVERHEAT_SAWS',
                        'T_TEMPEST_OF_METAL',
                        'T_OVERCHARGE_SAWS',
                        'T_TO_THE_ARMS',
                        'T_BLOODSTREAM',
                        'T_SPINAL_BREAK',
                        'T_SAW_WHEELS',
                        'T_GRINDING_SHIELD',
                        'T_PUNISHMENT',
                        'T_CONTINUOUS_BUTCHERY'
                    },
                    max_talents = 4,
                    descriptions = {
                        _t'Cut, cut, cut, cut!',
                        _t'They spin so hypnotically...',
                        _t'Dismember, maim, cut, disembowel!'
                    }
                }
            },
            stealth = {
                cover_talent_types = {
                    'technique/assassination',
                    'cunning/ambush'
                },
                talent_type = {
                    names = {
                        'sneak',
                        'thief',
                        'burglar'
                    },
                    talents = {
                        {
                            id = 'T_STEALTH',
                            is_signature = true
                        },
                        'T_SHADOWSTRIKE',
                        'T_SOOTHING_DARKNESS',
                        'T_SHADOW_DANCE',
                        'T_COUP_DE_GRACE',
                        'T_TERRORIZE',
                        'T_GARROTE',
                        'T_MARKED_FOR_DEATH'
                    },
                    max_talents = 4,
                    descriptions = {
                        _t'I can definitely slip by.',
                        _t'Exploit their weakpoint.',
                        _t'They\'ll never see me coming...'
                    }
                }
            },
            ['technique/magical-combat'] = {
                talent_type = {
                    names = {
                        'spellsword',
                        'battlemage',
                        'hexsword'
                    },
                    mastery = 0,
                    talents = {
                        'T_FLAME',
                        'T_LIGHTNING',
                        'T_EARTHEN_MISSILES'
                    },
                    disown_remove_treshold = 1,
                    descriptions = {
                        _t'Sword and sorcery!',
                        _t'Why not both?',
                        _t'Where are the naysayers who told me I should specialize?'
                    }
                }
            },
            ['unarmed-mastery'] = {
                cover_talent_types = {
                    'technique/pugilism',
                    'technique/finishing-moves',
                    'technique/grappling',
                    'technique/unarmed-discipline'
                },
                talent_type = {
                    names = {
                        'monk',
                        'karatist',
                        'disciple'
                    },
                    is_generic = true,
                    talents = {
                        {
                            id = 'T_UNARMED_MASTERY',
                            is_signature = true
                        },
                        'T_UNIFIED_BODY',
                        'T_HEIGHTENED_REFLEXES',
                        'T_REFLEX_DEFENSE'
                    },
                    max_talents = 3,
                    descriptions = {
                        _t'In a healthy body, a healthy mind.',
                        _t'Relax your muscles, feel the flow around you.',
                        _t'Misplaced strength is as dangerous as any opponent.'
                    }
                }
            },
            combos = {
                cover_talent_types = {
                    'technique/finishing-moves',
                    'technique/grappling',
                    'technique/unarmed-discipline'
                },
                talent_type = {
                    names = {
                        'bruiser',
                        'ringster',
                        'boxer'
                    },
                    talents = {
                        {
                            id = 'T_DOUBLE_STRIKE',
                            is_signature = true
                        },
                        'T_SPINNING_BACKHAND',
                        'T_AXE_KICK',
                        'T_FLURRY_OF_FISTS',
                        'T_UPPERCUT',
                        'T_CONCUSSIVE_PUNCH',
                        'T_BUTTERFLY_KICK',
                        'T_HAYMAKER',
                        'T_PUSH_KICK',
                        'T_RELENTLESS_STRIKES'
                    },
                    max_talents = 4,
                    descriptions = {
                        _t'One, two, three! That\'s how you do it.',
                        _t'I didn\'t see his left hook coming...',
                        _t'I need to train!'
                    }
                }
            }

            -- TODO
            -- cunning/called-shots (slings)
        }

        for _, name_pool in pairs(self.talent_type_name_pools) do
            ---@diagnostic disable-next-line: undefined-field
            table.shuffle(name_pool)
        end

        for _, description_pool in pairs(self.talent_type_description_pools) do
            ---@diagnostic disable-next-line: undefined-field
            table.shuffle(description_pool)
        end

        -- Define talent types which are used in multiple areas
        local talent_types_to_keep = { }
        for talent_type_id, talent_type_declaration in pairs(self.talent_type_declarations) do
            local talent_type = self:define_talent_type_full(talent_type_declaration)
            if talent_type then
                talent_types_to_keep[talent_type_id] = talent_type
            end
        end
        self.talent_types = talent_types_to_keep

        self.areas = self:define_areas(self.area_declarations)

        -- Thanks to rexorcorum for reminding me about this :)
        if not self.actor:knowTalent('T_SHOOT') then
            self.actor:learnTalent('T_SHOOT', true)
        end
    end

    -- Define areas from area declarations
    function resourceful_wanderers:define_areas(area_declarations)
        local areas = { }
        for area_name, area_declaration in pairs(area_declarations) do
            -- Skip area if it doesn't meet addon requirements
            local addons
            if area_declaration.addon then
                addons = { area_declaration.addon }
            else
                addons = area_declaration.addons or { }
            end

            for _, addon in ipairs(addons) do
                if not Game:isAddonActive(addon) then
                    goto next_area_declaration
                end
            end

            local area = {
                name = area_name,
                is_covered = false,
                addons = addons,
                on_cover = area_declarations.on_cover or function(_) end
            }

            -- Normalize cover/ignore properties
            if area_declaration.cover_category then
                area.cover_categories = { area_declaration.cover_category }
            else
                area.cover_categories = area_declaration.cover_categories or { }
            end

            if area_declaration.ignore_category then
                area.ignore_categories = { area_declaration.ignore_category }
            else
                area.ignore_categories = area_declaration.ignore_categories or { }
            end

            if area_declaration.cover_talent_type then
                area.cover_talent_types = { area_declaration.cover_talent_type }
            else
                area.cover_talent_types = area_declaration.cover_talent_types or { }
            end

            if area_declaration.ignore_talent_type then
                area.ignore_talent_types = { area_declaration.ignore_talent_type }
            else
                area.ignore_talent_types = area_declaration.ignore_talent_types or { }
            end

            if #area.cover_categories == 0 and #area.cover_talent_types == 0 then
                table.insert(area.cover_talent_types, area.name)
            end

            -- Normalize talent properties
            if not area_declaration.talent_type_groups then
                if area_declaration.talent_type then
                    area.talent_types = { resourceful_wanderers:define_talent_type(area_declaration.talent_type) }
                elseif area_declaration.talent_types then
                    local talent_type_group_declarations = { }
                    for _, talent_type_declaration in ipairs(area_declaration.talent_types) do
                        table.insert(talent_type_group_declarations, { talent_type_declaration })
                    end

                    area.talent_types = resourceful_wanderers:define_talent_types(talent_type_group_declarations)
                elseif area_declaration.talent_type_group then
                    area.talent_types = resourceful_wanderers:define_talent_types({ area_declaration.talent_type_group })
                end
            else
                area.talent_types = resourceful_wanderers:define_talent_types(area_declaration.talent_type_groups)
            end

            -- If the area has no talents, skip it
            if area.talent_types == nil or #area.talent_types == 0 then
                goto next_area_declaration
            end

            ---@diagnostic disable-next-line: undefined-field
            table.shuffle(area.talent_types)
            table.insert(areas, area)

            ::next_area_declaration::
        end

        return areas
    end

    -- Define talent types of an area from a declaration of groups of talent types
    function resourceful_wanderers:define_talent_types(talent_type_group_declarations)
        local talent_type_groups = { }
        for _, talent_type_group_declaration in ipairs(talent_type_group_declarations) do
            local talent_type_group = { }
            for _, talent_type_declaration in ipairs(talent_type_group_declaration) do
                table.insert(talent_type_group, resourceful_wanderers:define_talent_type(talent_type_declaration))
            end

            if talent_type_group ~= nil and #talent_type_group > 0 then
                table.insert(talent_type_groups, talent_type_group)
            end
        end

        if #talent_type_groups == 0 then
            return nil
        end

        ---@diagnostic disable-next-line: undefined-field
        table.shuffle(talent_type_groups)
        return talent_type_groups[1]
    end

    -- Define an area talent type from a talent type from either a string, or a declaration
    function resourceful_wanderers:define_talent_type(talent_type_declaration)
        if type(talent_type_declaration) == 'string' and self.talent_types then
            return self.talent_types[talent_type_declaration]
        else
            return self:define_talent_type_full(talent_type_declaration)
        end
    end

    -- Define an area talent type from a talent type declaration
    function resourceful_wanderers:define_talent_type_full(talent_type_declaration)
        -- Skip talent type if it doesn't meet addon requirements
        local addons
        if talent_type_declaration.addon then
            addons = { talent_type_declaration.addon }
        else
            addons = talent_type_declaration.addons or { }
        end

        for _, addon in ipairs(addons) do
            if not Game:isAddonActive(addon) then
                return nil
            end
        end

        local talent_type = {
            addons = addons,
            talent_learn_limit = talent_type_declaration.talent_learn_limit,
            on_cover = talent_type_declaration.on_cover or function(_, _) end
        }

        -- Normalize declaration properties and create the talent type
        if talent_type_declaration.names then
            ---@diagnostic disable-next-line: undefined-field
            table.shuffle(talent_type_declaration.names)
            talent_type.name = talent_type_declaration.names[1]
        elseif talent_type_declaration.name_pool then
            local name_pool = self.talent_type_name_pools[talent_type_declaration.name_pool]
            talent_type.name = name_pool[1]
            table.remove(name_pool, 1)
            talent_type.name_pool = nil
        else
            talent_type.name = talent_type_declaration.name
        end
        talent_type.name = 'wanderer/' .. talent_type.name

        talent_type.mastery = talent_type_declaration.mastery or -0.2
        talent_type.is_generic = talent_type_declaration.is_generic ~= nil and true or false

        if talent_type_declaration.talent_groups then
            local talent_groups = talent_type_declaration.talent_groups
            ---@diagnostic disable-next-line: undefined-field
            table.shuffle(talent_groups)
            talent_type.talents = talent_groups[1]

            if talent_type.talents.is_generic then
                talent_type.is_generic = talent_type.talents.is_generic
                talent_type.talents.is_generic = nil
            end
        else
            talent_type.talents = talent_type_declaration.talents
        end

        if talent_type_declaration.descriptions then
            ---@diagnostic disable-next-line: undefined-field
            table.shuffle(talent_type_declaration.descriptions)
            talent_type.description = talent_type_declaration.descriptions[1]
        elseif talent_type_declaration.description_pool then
            local description_pool = self.talent_type_description_pools[talent_type_declaration.description_pool]
            talent_type.description = description_pool[1]
            table.remove(description_pool, 1)
            talent_type.description_pool = nil
        else
            talent_type.description = talent_type_declaration.description
        end

        local talents = { }
        for _, talent_declaration in ipairs(talent_type.talents) do
            for _, talent in ipairs(resourceful_wanderers:define_talents(talent_declaration)) do
                table.insert(talents, talent)
            end
        end

        if #talents == 0 then
            return nil
        end

        talent_type.talents = talents
        ---@diagnostic disable-next-line: undefined-field
        table.shuffle(talent_type.talents)

        talent_type.max_talents = talent_type_declaration.max_talents or #talent_type.talents
        talent_type.own_remove_treshold = talent_type_declaration.own_remove_treshold or 0
        talent_type.disown_remove_treshold = talent_type_declaration.disown_remove_treshold or 100

        -- Create ToME talent type definition
        ActorTalents:newTalentType {
            allow_random = false,
            type = talent_type.name,
            name = _t(talent_type.name:gsub('.*/', ''), 'talent type'),
            generic = talent_type.is_generic,
            description = talent_type.description
        }

        return talent_type
    end

    -- Define area talents from a talent declaration
    function resourceful_wanderers:define_talents(talent_declaration)
        if type(talent_declaration) ~= 'string' then
            -- Check if the talent declaration is a group of talents
            for k, _ in pairs(talent_declaration) do
                if type(k) == 'number' then
                    ---@diagnostic disable-next-line: undefined-field
                    table.shuffle(talent_declaration)

                    local talents = { }
                    for i = 1, talent_declaration.take or 1 do
                        for _, talent in ipairs(self:define_talents(talent_declaration[i])) do
                            table.insert(talents, talent)
                        end
                    end

                    return talents
                end
            end
        end

        -- Don't use talents whose addon requirements aren't met
        local addons
        if talent_declaration.addon then
            addons = { talent_declaration.addon }
        else
            addons = talent_declaration.addons or { }
        end

        for _, addon in ipairs(addons) do
            if not Game:isAddonActive(addon) then
                return { }
            end
        end

        return {{
            id = talent_declaration.id or talent_declaration,
            addons = addons,
            is_signature = talent_declaration.is_signature or false,
            is_sticky = talent_declaration.is_sticky or false
        }}
    end

    -- Gets all competing mastery talents for the given talent
    function resourceful_wanderers:get_competing_mastery_talents(talent_id)
        local competing_talents = { }
        for _, group in ipairs(resourceful_wanderers.weapon_mastery_talent_groups) do
            local is_competing_group = false
            local other_talents = { }
            for _, group_talent in ipairs(group) do
                if group_talent == talent_id then
                    is_competing_group = true
                else
                    table.insert(other_talents, group_talent)
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

    -- Get the area which defines the talent type
    function resourceful_wanderers:get_talent_type_area(talent_type_id)
        for _, area in ipairs(self.areas) do
            for _, talent_type in ipairs(area.talent_types) do
                if talent_type.name == talent_type_id then
                    return area
                end
            end
        end

        return nil
    end

    -- Does an area define this talent type?
    function resourceful_wanderers:is_talent_type_from_area(talent_type_id)
        local retval = self:get_talent_type_area(talent_type_id) ~= nil
        if retval ~= nil then
            return retval
        end

        return false
    end

    -- Get talent type number of known talents
    function resourceful_wanderers:get_talent_type_number_of_known_talents(talent_type_id)
        local number_of_known_talents = 0
        for _, talent in ipairs(self.actor.talents_types_def[talent_type_id].talents) do
            if self.actor:knowTalent(talent.id) then
                number_of_known_talents = number_of_known_talents + 1
            end
        end

        return number_of_known_talents
    end

    -- Returns all areas which cover the talent type
    function resourceful_wanderers:find_covering_areas_for_talent_type(talent_type_id)
        local areas = { }
        for _, area in ipairs(self.areas) do
            if area.is_covered then
                goto next_area
            end

            for _, ignored_talent_type in ipairs(area.ignore_talent_types) do
                if ignored_talent_type == talent_type_id then
                    goto next_area
                end
            end

            for _, ignored_category in ipairs(area.ignore_categories) do
                if ignored_category == talent_type_id:gsub('/.*', '') then
                    goto next_area
                end
            end

            for _, covered_category in ipairs(area.cover_categories) do
                if covered_category == talent_type_id:gsub('/.*', '') then
                    table.insert(areas, area)
                    goto next_area
                end
            end

            for _, cover_talent_type in ipairs(area.cover_talent_types) do
                if cover_talent_type == talent_type_id then
                    table.insert(areas, area)
                    goto next_area
                end
            end

            ::next_area::
        end

        return areas
    end

    -- Make the talent, if it's managed, act as if it belongs to a wanderer category for the duration of the callback
    function resourceful_wanderers:with_managed_talent(talent, callback)
        for _, area in ipairs(self.areas) do
            for _, talent_type in ipairs(area.talent_types) do
                if self.actor:knowTalentType(talent_type.name) ~= nil then
                    for _, managed_talent in ipairs(talent_type.talents) do
                        if talent.id == managed_talent.id then
                            local orig_type = talent.type
                            talent.type = {
                                talent_type.name,
                                0
                            }

                            local retval = callback(talent_type, managed_talent, talent)

                            talent.type = orig_type
                            return retval
                        end
                    end
                end
            end
        end

        return callback(nil, nil, talent)
    end

    -- Remove all talent type's talents from all areas
    function resourceful_wanderers:unmanage_talent_type(talent_type_to_unmanage_id)
        local talent_type_to_unmanage_area = self:get_talent_type_area(talent_type_to_unmanage_id)

        local areas_to_keep = { }
        for _, area in ipairs(self.areas) do
            local talent_types_to_keep = { }
            for _, talent_type in ipairs(area.talent_types) do
                local talents_to_keep = { }
                local tome_talents_to_keep = { }
                local individual_talent_log_messages = { }
                local was_signature_talent_removed = false
                local has_sticky_talents = false

                -- If the talent type to unmanage is an area talent type, don't touch anything
                if talent_type.name == talent_type_to_unmanage_id then
                    goto next_talent_type
                end

                -- Remove all talents of talent type to unmanage
                for _, talent in ipairs(talent_type.talents) do
                    for _, talent_to_unmanage in ipairs(self.actor.talents_types_def[talent_type_to_unmanage_id].talents) do
                        if talent.id ~= talent_to_unmanage.id then
                            goto next_talent_to_unmanage
                        end

                        local talent_def_to_remove_name = tstring {
                            {'font', 'bold'},
                            self.actor.talents_def[talent.id].name,
                            {'font', 'normal'}
                        }

                        local log_message
                        if self.actor:knowTalent(talent.id) then
                            log_message =
                                '#GOLD#Your understanding of #LIGHT_BLUE#' ..
                                tostring(talent_def_to_remove_name) ..
                                '#GOLD# becomes deeper.'
                        else
                            log_message =
                                '#GOLD#You readjust the angle from which you should learn #LIGHT_BLUE#' ..
                                tostring(talent_def_to_remove_name) .. '#GOLD#.'
                        end

                        local talent_type_name = tstring {
                            {'font', 'bold'},
                                _t(talent_type.name:gsub('/.*', ''), 'talent category'):capitalize() ..
                                ' / ' ..
                                talent_type.name:gsub('.*/', ''):capitalize(),
                            {'font', 'normal'}
                        }

                        local talent_type_to_unmanage_name = tstring {
                            {'font', 'bold'},
                                _t(talent_type_to_unmanage_id:gsub('/.*', ''), 'talent category'):capitalize() ..
                                ' / ' ..
                                talent_type_to_unmanage_id:gsub('.*/', ''):capitalize(),
                            {'font', 'normal'}
                        }

                        table.insert(individual_talent_log_messages,
                            log_message ..
                            ' The talent has been removed from #LIGHT_BLUE#' .. tostring(talent_type_name) ..
                            '#GOLD# since you learned its original category, #LIGHT_BLUE#' .. tostring(talent_type_to_unmanage_name) .. '#GOLD#.'
                        )

                        -- If the talent type we're unmanaging is from an area, and the talent we're unmanaging is
                        -- signature in the iterating talent type, then make it sticky in the talent type
                        -- we're unmanaging (if it's not alreaday a signature talent)
                        if talent.is_signature then
                            if talent_type_to_unmanage_area then
                                for _, talent_type in ipairs(talent_type_to_unmanage_area.talent_types) do
                                    for _, talent_to_sticky in ipairs(talent_type.talents) do
                                        if talent.id == talent_to_sticky.id and not talent_to_sticky.is_signature then
                                            talent_to_sticky.is_sticky = true
                                            goto break_from_sticky
                                        end
                                    end
                                end
                            end

                            ::break_from_sticky::

                            was_signature_talent_removed = true
                        end

                        talent_type.disown_remove_treshold = talent_type.disown_remove_treshold - 1

                        goto next_talent

                        ::next_talent_to_unmanage::
                    end

                    table.insert(tome_talents_to_keep, self.actor.talents_def[talent.id])
                    table.insert(talents_to_keep, talent)

                    if talent.is_sticky and not talent.is_signature then
                        has_sticky_talents = true
                    end

                    ::next_talent::
                end

                if self.actor:knowTalentType(talent_type.name) ~= nil then
                    self.actor.talents_types_def[talent_type.name].talents = tome_talents_to_keep
                end
                talent_type.talents = talents_to_keep

                -- Remove the talent type completely if:
                -- - It has no sticky talents and:
                --     - A signature talent has been removed.
                --     - Category has number of talents less then or equal to `own_remove_treshold`.
                --     - Category has lost a number of talents more than or equal to `disown_remove_treshold`.
                -- Refund the category and talent points if any were spent.
                if
                    (
                        #talent_type.talents <= talent_type.own_remove_treshold or
                        talent_type.disown_remove_treshold <= 0 or
                        was_signature_talent_removed
                    ) and
                    not has_sticky_talents
                then
                    local talents_removed_string = ''
                    for _, talent in ipairs(talent_type.talents) do
                        local talent_def = self.actor.talents_def[talent.id]

                        if self.actor:knowTalentType(talent_type.name) then
                            local talent_removed_string = ''
                            if talents_removed_string ~= '' then
                                talent_removed_string = talent_removed_string .. '#GOLD#, '
                            end

                            local talent_name = tstring {
                                {'font', 'bold'},
                                talent_def.name,
                                {'font', 'normal'}
                            }

                            talent_removed_string = talent_removed_string .. '#LIGHT_BLUE#' .. tostring(talent_name)
                            talents_removed_string = talents_removed_string .. talent_removed_string
                        end

                        if talent_def.generic == true then
                            self.actor.unused_generics = self.actor.unused_generics + (self.actor.talents[talent.id] or 0)
                        else
                            self.actor.unused_talents = self.actor.unused_talents + (self.actor.talents[talent.id] or 0)
                        end

                        self.actor:unlearnTalentFull(talent_def.id)
                    end

                    local talent_type_name = tstring {
                        {'font', 'bold'},
                            _t(talent_type.name:gsub('/.*', ''), 'talent category'):capitalize() ..
                            ' / ' ..
                            talent_type.name:gsub('.*/', ''):capitalize(),
                        {'font', 'normal'}
                    }

                    local do_log = true
                    local log_message
                    if self.actor:knowTalentType(talent_type.name) then
                        log_message = '#GOLD#You solidify your knowledge of #LIGHT_BLUE#%s#GOLD# at the expense of flexibility. '
                        if talents_removed_string ~= '' then
                            log_message = log_message .. 'You forget the category along with all of the remaining talents: ' .. talents_removed_string .. '#GOLD#.'
                        else
                            log_message = log_message .. 'You forget the category.'
                        end

                        log_message = log_message .. ' Any spent talent or category points have been refunded.'
                    elseif self.actor:knowTalentType(talent_type.name) == false then
                        log_message = '#GOLD#Never taking an interest in #LIGHT_BLUE#%s#GOLD#, you forget all about it as if you never knew it.'
                    else
                        do_log = false
                    end

                    if self.actor.talents_types[talent_type.name] == true then
                        self.actor.unused_talents_types = self.actor.unused_talents_types + 1
                    end

                    self.actor.talents_types[talent_type.name] = nil
                    self.actor.talents_types_mastery[talent_type.name] = nil
                    self.actor.changed = true

                    if do_log then
                        game.log(log_message, tostring(talent_type_name))
                    end

                    goto next_talent_type_dont_keep
                end

                if self.actor:knowTalentType(talent_type.name) ~= nil then
                    for _, message in ipairs(individual_talent_log_messages) do
                        game.log(message)
                    end
                end

                ::next_talent_type::
                table.insert(talent_types_to_keep, talent_type)

                ::next_talent_type_dont_keep::
            end

            -- Don't keep empty areas
            area.talent_types = talent_types_to_keep
            if #area.talent_types > 0 then
                table.insert(areas_to_keep, area)
            end
        end

        self.areas = areas_to_keep
    end

    -- Covers an area
    function resourceful_wanderers:cover_area(area)
        if area == nil or area.is_covered then
            return
        end

        area.is_covered = true

        if #area.talent_types == 0 then
            return
        end

        -- Learn all area's talent types
        for _, talent_type in ipairs(area.talent_types) do
            -- Signature and sticky talents have priority
            local non_priority_talents = { }
            local talents_to_keep = { }
            for _, talent in ipairs(talent_type.talents) do
                if talent.is_signature or talent.is_sticky then
                    table.insert(talents_to_keep, talent)
                else
                    table.insert(non_priority_talents, talent)
                end
            end

            for _, talent in ipairs(non_priority_talents) do
                if #talents_to_keep >= talent_type.max_talents then
                    break
                end

                table.insert(talents_to_keep, talent)
            end

            talent_type.talents = talents_to_keep

            -- Sort talents in the talent type according to required level
            table.sort(talent_type.talents, function(talent_a, talent_b)
                local talent_a_def = self.actor.talents_def[talent_a.id]
                local talent_b_def = self.actor.talents_def[talent_b.id]

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

            for _, talent in ipairs(talent_type.talents) do
                table.insert(self.actor.talents_types_def[talent_type.name].talents, self.actor.talents_def[talent.id])
            end

            self.actor.talents_types_mastery[talent_type.name] = talent_type.mastery
            self.actor:learnTalentType(talent_type.name, false)

            -- Remove the talent type from other areas, possibly removing the area itself
            local areas_to_keep = { }
            for _, area_to_remove_from in ipairs(self.areas) do
                local talent_types_to_keep = { }

                -- Skip the area we're covering
                if area_to_remove_from.name == area.name then
                    goto next_area
                end

                for _, talent_type_to_keep in ipairs(area_to_remove_from.talent_types) do
                    if talent_type_to_keep.name ~= talent_type.name then
                        table.insert(talent_types_to_keep, talent_type_to_keep)
                    end
                end
                area_to_remove_from.talent_types = talent_types_to_keep

                if #area_to_remove_from.talent_types == 0 then
                    -- If it's still referenced somewhere, ensure it isn't used until it deallocates
                    area_to_remove_from.is_covered = true
                    goto next_area_dont_keep
                end

                ::next_area::
                table.insert(areas_to_keep, area_to_remove_from)

                ::next_area_dont_keep::
            end
            self.areas = areas_to_keep

            local talent_type_name = tstring {
                {'font', 'bold'},
                    _t(talent_type.name:gsub('/.*', ''), 'talent category'):capitalize() ..
                    ' / ' ..
                    talent_type.name:gsub('.*/', ''):capitalize(),
                {'font', 'normal'}
            }

            local log_message = {
                data = '#GOLD#You begin to intuit a few things about the world as you learn #LIGHT_BLUE#' .. tostring(talent_type_name) .. '#GOLD#.'
            }
            talent_type:on_cover(log_message)

            game.log(log_message.data)
        end

        area:on_cover()
    end

    -- Called before the player learns a talent type
    function resourceful_wanderers:after_learnTalentType(talent_type_id)
        if not self.actor.talents_types_def[talent_type_id] then
            return
        end

        self:unmanage_talent_type(talent_type_id)

        for _, covering_area in ipairs(self:find_covering_areas_for_talent_type(talent_type_id)) do
            self:cover_area(covering_area)
        end
    end

    resourceful_wanderers:construct(game.player)
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
