return {
    {
        addons = {
            'orcs'
        },
        cover_talent_types = {
            'steamtech/sawmaiming',
            'steamtech/battlefield-management',
            'steamtech/automated-butchery'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'butcher',
                        _t'gorefiend',
                        _t'decapitator'
                    },
                    talent_queue = {
                        take_at_most = 4,
                        items = {
                            {
                                id = 'T_STEAMSAW_MASTERY',
                                is_signature = true
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_OVERHEAT_SAWS',
                                    'T_TEMPEST_OF_METAL',
                                    'T_OVERCHARGE_SAWS'
                                }
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_TO_THE_ARMS',
                                    'T_BLOODSTREAM',
                                    'T_SPINAL_BREAK'
                                }
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_SAW_WHEELS',
                                    'T_GRINDING_SHIELD',
                                    'T_PUNISHMENT'
                                }
                            },
                            'T_CONTINUOUS_BUTCHERY'
                        }
                    },
                    descriptions = {
                        _t'Cut, cut, cut, cut!',
                        _t'They spin so hypnotically...',
                        _t'Dismember, maim, cut, disembowel!'
                    }
                }
            }
        }
    }
}
