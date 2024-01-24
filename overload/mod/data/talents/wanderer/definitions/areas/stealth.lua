return {
    {
        cover_talent_types = {
            'technique/assassination',
            'cunning/ambush'
        },
        talent_type_queue = {
            items = {
                names = {
                    _t'sneak',
                    _t'thief',
                    _t'burglar'
                },
                talent_queue = {
                    take_at_most = 4,
                    items = {
                        {
                            id = 'T_STEALTH',
                            is_signature = true
                        },
                        {
                            take_at_most = 2,
                            items = {
                                'T_SHADOWSTRIKE',
                                'T_SOOTHING_DARKNESS',
                                'T_SHADOW_DANCE',
                            }
                        },
                        {
                            take_at_most = 2,
                            items = {
                                'T_COUP_DE_GRACE',
                                'T_TERRORIZE',
                                'T_GARROTE',
                                'T_MARKED_FOR_DEATH'
                            }
                        }
                    }
                },
                descriptions = {
                    _t'I can definitely slip by.',
                    _t'Exploit their weakpoint.',
                    _t'They\'ll never see me coming...'
                }
            }
        }
    }
}
