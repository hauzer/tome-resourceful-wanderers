return {
    {
        cover_talent_types = {
            'spell/age-of-dusk',
            'spell/death',
            'spell/glacial-waste',
            'spell/master-of-bones',
            'spell/master-of-flesh',
            'spell/rime-wraith'
        },
        talent_type_queue = {
            items = {
                'souls'
            }
        }
    },
    {
        cover_talent_types = {
            'spell/eradication',
            'spell/dreadmaster',
            'spell/grave',
            'spell/master-necromancer'
        },
        talent_type_queue = {
            items = {
                'souls',
                {
                    names = {
                        _t'gravekeeper',
                        _t'mortician',
                        _t'undertaker'
                    },
                    talent_queue = {
                        take_at_most = 4,
                        items = {
                            {
                                id = 'T_CALL_OF_THE_CRYPT',
                                is_sticky = true
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_SHATTERED_REMAINS',
                                    'T_ASSEMBLE',
                                    'T_LORD_OF_SKULLS'
                                }
                            },
                            {
                                id = 'T_CALL_OF_THE_MAUSOLEUM',
                                is_sticky = true
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_CORPSE_EXPLOSION',
                                    'T_PUTRESCENT_LIQUEFACTION',
                                    'T_DISCARDED_REFUSE'
                                }
                            }
                        }
                    },
                    descriptions = {
                        _t'Twitch, twitch! They still twitch.',
                        _t'From dust you came, to dust you shall return. And from dust you shall rise again once more.',
                        _t'I take such good care of you, no wonder death can\'t separate us.'
                    }
                }
            }
        }
    }
}
