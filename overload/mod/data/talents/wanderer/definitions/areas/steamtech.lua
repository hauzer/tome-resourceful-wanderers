return {
    {
        addons = {
            'orcs'
        },
        cover_categories = {
            'steamtech'
        },
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
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'scrapper',
                        _t'technician',
                        _t'journeyman'
                    },
                    is_generic = true,
                    talent_queue = {
                        items = {
                            {
                                take_at_most = 2,
                                items = {
                                    'T_THERAPEUTICS',
                                    'T_CHEMISTRY',
                                    'T_EXPLOSIVES'
                                }
                            },
                            {
                                take_at_most = 2,
                                items = {
                                    'T_SMITH',
                                    'T_MECHANICAL',
                                    'T_ELECTRICITY'
                                }
                            }
                        }
                    },
                    descriptions = {
                        _t'Now, if I could just polarize this power converter...',
                        _t'*BANG!* *BANG!* *BANG!* Ooh, science is tough work!',
                        _t'Maybe the old professor was onto something.'
                    },
                    on_cover = function(actor, log_message)
                        -- Give the player some basic steamtech items
                        local items = {
                            {
                                amount = 1,
                                data = {
                                    defined = 'APE',
                                    base_list = 'mod.class.Object:/data-orcs/general/objects/quest-artifacts.lua',
                                    id = true,
                                    transmo = false
                                }
                            },
                            {
                                amount = 1,
                                data = {
                                    defined = 'TINKER_HEALING_SALVE1',
                                    base_list = 'mod.class.Object:/data-orcs/general/objects/tinker.lua',
                                    ego_chance = -1000,
                                    id = true,
                                    transmo = true
                                }
                            },
                            {
                                amount = 1,
                                data = {
                                    defined = 'TINKER_FROST_SALVE1',
                                    base_list = 'mod.class.Object:/data-orcs/general/objects/tinker.lua',
                                    ego_chance = -1000,
                                    id = true,
                                    transmo = true
                                }
                            },
                            {
                                amount = 2,
                                data = {
                                    type = 'scroll',
                                    subtype = 'implant',
                                    name = 'medical injector implant',
                                    base_list = 'mod.class.Object:/data-orcs/general/objects/inscriptions.lua',
                                    ego_chance = -1000,
                                    id = true,
                                    transmo = true
                                }
                            },
                            {
                                amount = 2,
                                data = {
                                    type = 'scroll',
                                    subtype = 'implant',
                                    name = 'steam generator implant',
                                    base_list = 'mod.class.Object:/data-orcs/general/objects/inscriptions.lua',
                                    ego_chance = -1000,
                                    id = true,
                                    transmo = true
                                }
                            },
                            {
                                amount = 2,
                                data = {
                                    type = 'weapon',
                                    subtype = 'steamsaw',
                                    name = 'iron steamsaw',
                                    base_list = 'mod.class.Object:/data-orcs/general/objects/steamsaw.lua',
                                    ego_chance = - 1000,
                                    id = true,
                                    transmo = true
                                }
                            },
                            {
                                amount = 2,
                                data = {
                                    type = 'weapon',
                                    subtype = 'steamgun',
                                    name = 'iron steamgun',
                                    base_list = 'mod.class.Object:/data-orcs/general/objects/steamgun.lua',
                                    ego_chance = -1000,
                                    id = true,
                                    transmo = true
                                }
                            }
                        }

                        for _, item in ipairs(items) do
                            for _ = 1, item.amount do
                                resolvers.resolveObject(actor, item.data)
                            end
                        end

                        log_message.data = log_message.data .. ' You also find some gadgets.'
                    end
                }
            }
        }
    }
}
