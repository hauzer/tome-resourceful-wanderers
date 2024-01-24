return {
    {
        addons = {
            'orcs'
        },
        cover_talent_types = {
            'steamtech/magnetism'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'contraptor',
                        _t'mechanic',
                        _t'gadgeteer'
                    },
                    talent_queue = {
                        items = {
                            'T_DEPLOY_TURRET',
                            {
                                take_at_most = 1,
                                items = {
                                    'T_OVERCLOCK',
                                    'T_UPGRADE',
                                    'T_HUNKER_DOWN'
                                }
                            },
                            'T_MECHARACHNID',
                            {
                                take_at_most = 1,
                                items = {
                                    'T_STORMCOIL_GENERATOR',
                                    'T_MECHARACHNID_CHASSIS',
                                    'T_MECHARACHNID_PILOTING'
                                }
                            }
                        }
                    },
                    descriptions = {
                        _t'What does this button do?',
                        _t'... it isn\'t supposed to do that!',
                        _t'Heh, I can take back control of it, just give me a minute...'
                    }
                }
            }
        }
    }
}
