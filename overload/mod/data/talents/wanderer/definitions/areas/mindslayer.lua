return {
    {
        cover_talent_types = {
            'psionic/charged-mastery'
        },
        talent_type_queue = {
            items = {
                {
                    name_pool = 'electricity',
                    talent_queue = {
                        take_at_most = 4,
                        take_at_least = 3,
                        items = {
                            'T_CHARGED_SHIELD',
                            'T_CHARGE_LEECH',
                            'T_CHARGED_AURA',
                            'T_CHARGED_STRIKE',
                            'T_BRAIN_STORM'
                        }
                    },
                    description_pool = 'electricity'
                }
            }
        }
    },
    {
        cover_talent_types = {
            'psionic/kinetic-mastery'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'kineticist'
                    },
                    talent_queue = {
                        take_at_most = 4,
                        take_at_least = 3,
                        items = {
                            'T_KINETIC_SHIELD',
                            'T_KINETIC_LEECH',
                            'T_KINETIC_AURA',
                            'T_KINETIC_STRIKE',
                            'T_MINDLASH'
                        }
                    },
                    descriptions = {
                        _t'Heey what, did I move that cup?!',
                        _t'Heh, funny. The rock just bounced off of me.',
                        _t'I think my body is going to atrophy if I continue doing this.'
                    }
                }
            }
        }
    },
    {
        cover_talent_types = {
            'psionic/thermal-mastery'
        },
        talent_type_queue = {
            items = {
                {
                    name_pool = 'fire',
                    talent_queue = {
                        take_at_most = 4,
                        take_at_least = 3,
                        items = {
                            'T_THERMAL_SHIELD',
                            'T_THERMAL_LEECH',
                            'T_THERMAL_AURA',
                            'T_THERMAL_STRIKE',
                            'T_PYROKINESIS'
                        }
                    },
                    description_pool = 'fire'
                }
            }
        }
    }
}
