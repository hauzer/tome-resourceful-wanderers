return {
    {
        cover_talent_types = {
            'technique/pugilism',
            'technique/finishing-moves',
            'technique/grappling',
            'technique/unarmed-discipline'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'monk',
                        _t'karatist',
                        _t'disciple'
                    },
                    is_generic = true,
                    talent_queue = {
                        take_at_most = 3,
                        items = {
                            {
                                id = 'T_UNARMED_MASTERY',
                                is_signature = true
                            },
                            'T_UNIFIED_BODY',
                            'T_HEIGHTENED_REFLEXES',
                            'T_REFLEX_DEFENSE'
                        }
                    },
                    descriptions = {
                        _t'In a healthy body, a healthy mind.',
                        _t'Relax your muscles, feel the flow around you.',
                        _t'Misplaced strength is as dangerous as any opponent.'
                    }
                }
            }
        }
    },
    {
        cover_talent_types = {
            'technique/finishing-moves',
            'technique/grappling',
            'technique/unarmed-discipline'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'bruiser',
                        _t'ringster',
                        _t'boxer'
                    },
                    talent_queue = {
                        take_at_most = 4,
                        items = {
                            {
                                id = 'T_DOUBLE_STRIKE',
                                is_signature = true
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_SPINNING_BACKHAND',
                                    'T_AXE_KICK',
                                    'T_FLURRY_OF_FISTS'
                                }
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_UPPERCUT',
                                    'T_CONCUSSIVE_PUNCH',
                                    'T_BUTTERFLY_KICK'
                                }
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_HAYMAKER',
                                    'T_PUSH_KICK',
                                    'T_RELENTLESS_STRIKES'
                                }
                            }
                        }
                    },
                    descriptions = {
                        _t'One, two, three! That\'s how you do it.',
                        _t'I didn\'t see his left hook coming...',
                        _t'I need to train!'
                    }
                }
            }
        }
    }
}
