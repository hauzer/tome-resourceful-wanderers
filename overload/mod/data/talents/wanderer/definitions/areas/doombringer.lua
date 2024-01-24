return {
    {
        addons = {
            'ashes-urhrok'
        },
        cover_talent_types = {
            'corruption/heart-of-fire'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'incinerator'
                    },
                    talent_queue = {
                        take_at_most = 3,
                        items = {
                            {
                                id = 'T_INCINERATING_BLOWS',
                                is_signature = true
                            },
                            'T_FIERY_GRASP',
                            'T_FEARSCAPE_SHIFT',
                            'T_CAUTERIZE_SPIRIT',
                            'T_INFERNAL_BREATH_DOOM',
                            'T_FEARSCAPE_AURA'
                        }
                    },
                    descriptions = {
                        _t'The smell of sulfur follows you everywhere you go.',
                        _t'You\'re drawn to fire like a moth. Bathe in it.',
                        _t'Set the world ablaze!'
                    }
                }
            }
        }
    },
    {
        addons = {
            'ashes-urhrok'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'destroyer'
                    },
                    talent_queue = {
                        take_at_most = 4,
                        take_at_least = 3,
                        items = {
                            'T_DRAINING_ASSAULT',
                            'T_RECKLESS_STRIKE',
                            'T_ABDUCTION',
                            'T_INCINERATING_BLOWS',
                            'T_FEARSCAPE_AURA'
                        }
                    },
                    descriptions = {
                        _t'You\'ve never been more vital. You just feel the need to take it out on something, or someone.',
                        _t'Muscles ache from bulging, release the pain!',
                        _t'Something drives you to DESTROY!'
                    }
                }
            }
        }
    }
}
