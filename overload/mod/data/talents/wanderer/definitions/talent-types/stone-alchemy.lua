return {
    {
        id = 'stone-alchemy',
        names = {
            _t'jeweler',
            _t'gemologist',
            _t'crafstman'
        },
        talent_queue = {
            is_generic = true,
            items = {
                'T_EXTRACT_GEMS',
                'T_IMBUE_ITEM',
                {
                    take_at_most = 1,
                    items = {
                        'T_GEM_PORTAL',
                        'T_STONE_TOUCH'
                    }
                }
            }
        },
        descriptions = {
            _t'Shiny!',
            _t'Let\'s see what we got in this haul.',
            _t'My precious...'
        }
    }
}
