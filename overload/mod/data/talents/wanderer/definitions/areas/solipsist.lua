return {
    {
        cover_talent_types = {
            'psionic/discharge'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'lunatic',
                        _t'psycho',
                        _t'maniac'
                    },
                    talent_queue = {
                        items = {
                            'T_MIND_SEAR',
                            'T_PSYCHIC_LOBOTOMY',
                            'T_SUNDER_MIND'
                        }
                    },
                    descriptions = {
                        _t'Get them out of my head, GET THEM OUT!!',
                        _t'Pity the confessor unfortunate enough to have to hear you.',
                        _t'In an insane world, it\'s only natural to go crazy.'
                    }
                },
                {
                    names = {
                        _t'mystic',
                        _t'guru',
                        _t'yogi'
                    },
                    talent_queue = {
                        take_at_most = 3,
                        items = {
                            {
                                id = 'T_BIOFEEDBACK',
                                is_signature = true
                            },
                            'T_RESONANCE_FIELD',
                            'T_AMPLIFICATION',
                            'T_CONVERSION'
                        }
                    },
                    descriptions = {
                        _t'Take the path of becoming one with all.',
                        _t'Take the path of becoming all with one.',
                        _t'Take the path of becoming.'
                    }
                }
            }
        }
    }
}
