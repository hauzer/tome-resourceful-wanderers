return {
    addons = {
        'cults'
    },
    cover_categories = {
        'demented'
    },
    ignore_talent_types = {
        'demented/entropy',
        'demented/nether',
        'demented/tentacles',
        'demented/slow-death',
        'demented/madness',
        'demented/scourge-drake',
        'demented/oblivion'
    },
    talent_type_queue = {
        items = {
            {
                names = {
                    _t'madman',
                    _t'mutant',
                    _t'specimen'
                },
                talent_queue = {
                    take_at_most = 4,
                    take_at_least = 3,
                    items = {
                        'T_MUTATED_HAND',
                        'T_DARK_WHISPERS',
                        'T_DIGEST',
                        'T_CARRION_FEET',
                        {
                            take_at_most = 1,
                            items = {
                                'T_TENTACLED_WINGS',
                                'T_DECAYING_GROUNDS'
                            }
                        },
                        'T_BLACK_MONOLITH'
                    }
                },
                descriptions = {
                    _t'You feel -- *something* -- stirring inside of you.',
                    _t'Hahh-ahhah!',
                    _t'That alchemist is going to have a taste of his own medicine.'
                }
            }
        }
    }
}
