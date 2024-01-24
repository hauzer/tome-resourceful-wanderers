return {
    {
        addons = {
            'cults',
        },
        cover_talent_types = {
            'demented/oblivion'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'entropist',
                        _t'nihilist',
                        _t'antirealist'
                    },
                    talent_queue = {
                        take_at_most = 3,
                        take_at_least = 2,
                        items = {
                            'T_NETHERBLAST',
                            'T_RIFT_CUTTER',
                            'T_SPATIAL_DISTORTION',
                            'T_POWER_OVERWHELMING'
                        }
                    },
                    descriptions = {
                        _t'Reality is an illusion. Shatter it!',
                        _t'Let the unbecoming essence of the universe wash over you...',
                        _t'It\'s as though there\'s less of you each passing moment.'
                    }
                }
            }
        }
    }
}
