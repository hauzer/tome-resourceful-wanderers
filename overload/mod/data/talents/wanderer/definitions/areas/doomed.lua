return {
    {
        cover_talent_types = {
            'cursed/advanced-shadowmancy',
            'cursed/one-with-shadows'
        },
        talent_type_queue = {
            items = {
                names = {
                    _t'umbra',
                    _t'silhoutte',
                    _t'contour'
                },
                talent_queue = {
                    take_at_most = 4,
                    items = {
                        {
                            id = 'T_CALL_SHADOWS',
                            is_signature = true
                        },
                        {
                            id = 'T_SHADOW_WARRIORS',
                            is_signature = true
                        },
                        {
                            id = 'T_SHADOW_MAGES',
                            is_signature = true
                        },
                        'T_SHADOW_SENSES',
                        'T_SHADOWS_EMPATHY',
                        'T_SHADOW_TRANSPOSITION',
                        'T_SHADOW_DECOY',
                        'T_MERGE',
                        'T_STONE',
                        'T_SHADOW_S_PATH',
                        'T_CURSED_BOLT'
                    }
                },
                descriptions = {
                    _t'Darkness... soothing...',
                    _t'Light scares away the friends.',
                    _t'The shadows in the corner of your eye are starting to show themselves rather frequently as of late.'
                }
            }
        }
    }
}
