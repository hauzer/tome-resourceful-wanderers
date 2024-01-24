return {
    {
        cover_talent_types = {
            'spell/storm'
        },
        talent_type_queue = {
            items = {
                {
                    name_pool = 'electricity',
                    talent_queue = {
                        items = {
                            'T_LIGHTNING',
                            {
                                take_at_most = 2,
                                items = {
                                    'T_CHAIN_LIGHTNING',
                                    'T_FEATHER_WIND',
                                    'T_THUNDERSTORM'
                                }
                            }
                        }
                    },
                    description_pool = 'electricity'
                }
            }
        }
    },
    {
        cover_talent_types = {
            'spell/wildfire'
        },
        talent_type_queue = {
            items = {
                {
                    name_pool = 'fire',
                    talent_queue = {
                        items = {
                            'T_FLAME',
                            {
                                take_at_most = 2,
                                items = {
                                    'T_FLAMESHOCK',
                                    'T_FIREFLASH',
                                    'T_INFERNO'
                                }
                            }
                        }
                    },
                    description_pool = 'fire'
                }
            }
        }
    },
    {
        cover_talent_types = {
            'spell/aether',
            'spell/meta'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'apprentice',
                        _t'novice',
                        _t'neophyte'
                    },
                    talent_queue = {
                        items = {
                            'T_MANATHRUST',
                            'T_DISRUPTION_SHIELD',
                            {
                                take_at_most = 1,
                                items = {
                                    'T_ARCANE_POWER',
                                    'T_ARCANE_VORTEX'
                                }
                            }
                        }
                    },
                    descriptions = {
                        _t'When is this book going to get GOOD?!',
                        _t'That\'s not the right incantation!',
                        _t'Focus... Must focus...'
                    }
                }
            }
        }
    }
}
