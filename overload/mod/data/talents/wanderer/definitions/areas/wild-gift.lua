return {
    cover_category = 'wild-gift',
    ignore_talent_types = {
        'wild-gift/fungus',
        'wild-gift/harmony'
    },
    talent_type_queue = {
        items = {
            {
                names = {
                    _t'recluse',
                    _t'hermit',
                    _t'eremite'
                },
                is_generic = true,
                mastery = 1.0,
                talent_queue = {
                    take_at_most = 3,
                    take_at_least = 2,
                    items = {
                        'T_MEDITATION',
                        'T_ANCESTRAL_LIFE',
                        'T_HEALING_NEXUS'
                    }
                },
                descriptions = {
                    _t'Patient solitude leads to greater understanding.',
                    _t'You never enjoyed living in the world.',
                    _t'Give what you have, take what is offered.',
                }
            },
            {
                names = {
                    _t'wilderman',
                    _t'forager',
                    _t'beast'
                },
                talent_queue = {
                    take_at_most = 4,
                    take_at_least = 3,
                    items = {
                        'T_SWALLOW',
                        'T_MUCUS',
                        'T_JELLY',
                        'T_NATURE_S_DEFIANCE'
                    }
                },
                descriptions = {
                    _t'The forest calls out to you.',
                    _t'Mother Nature shall fight back!',
                    _t'Ah! It\'s a good day to take a stroll and never come back.'
                }
            }
        }
    }
}
