return {
    {
        cover_talent_types = {
            'technique/sniper',
            'technique/reflexes',
            'technique/archery-training',
            'technique/archery-prowess'
        },
        talent_type_queue = {
            names = {
                _t'marksman',
                _t'hunter',
                _t'bowman'
            },
            talent_queue = {
                take_at_most = 4,
                items = {
                    {
                        id = 'T_MASTER_MARKSMAN',
                        is_signature = true
                    },
                    {
                        take_at_most = 1,
                        items = {
                            'T_FIRST_BLOOD',
                            'T_FLARE',
                            'T_TRUESHOT'
                        }
                    },
                    {
                        take_at_most = 1,
                        items = {
                            'T_STEADY_SHOT',
                            'T_PIN_DOWN',
                            'T_FRAGMENTATION_SHOT',
                            'T_SCATTER_SHOT'
                        }
                    },
                    {
                        take_at_most = 1,
                        items = {
                            'T_SHOOT_DOWN',
                            'T_INTUITIVE_SHOTS',
                            'T_SENTINEL'
                        }
                    }
                }
            },
            descriptions = {
                _t'I will pierce your heart.',
                _t'Steady, steady... Fire!',
                _t'Mind the wind, adjust the trajectory...'
            }
        }
    },
    {
        cover_talent_types = {
            'cunning/called-shots',
            'technique/agility',
            'technique/buckler-training',
            'technique/reflexes',
            'technique/archery-training',
            'technique/archery-prowess'
        },
        talent_type_queue = {
            names = {
                _t'slinger',
                _t'pebbler',
                _t'catapulter'
            },
            talent_queue = {
                take_at_most = 4,
                items = {
                    {
                        id = 'T_SKIRMISHER_SLING_SUPREMACY',
                        is_signature = true
                    },
                    {
                        take_at_most = 1,
                        items = {
                            'T_SKIRMISHER_SWIFT_SHOT',
                            'T_SKIRMISHER_HURRICANE_SHOT',
                            'T_SKIRMISHER_BOMBARDMENT'
                        }
                    },
                    {
                        take_at_most = 1,
                        items = {
                            'T_FLARE',
                            'T_TRUESHOT'
                        }
                    },
                    {
                        take_at_most = 1,
                        items = {
                            'T_STEADY_SHOT',
                            'T_PIN_DOWN',
                            'T_FRAGMENTATION_SHOT',
                            'T_SCATTER_SHOT'
                        }
                    },
                    {
                        take_at_most = 1,
                        items = {
                            'T_SHOOT_DOWN',
                            'T_INTUITIVE_SHOTS',
                            'T_SENTINEL'
                        }
                    },
                    {
                        take_at_most = 1,
                        items = {
                            'T_BULL_SHOT',
                            'T_RAPID_SHOT',
                        }
                    },
                    {
                        take_at_most = 1,
                        items = {
                            'T_SKIRMISHER_KNEECAPPER',
                            'T_SKIRMISHER_THROAT_SMASHER',
                            'T_SKIRMISHER_NOGGIN_KNOCKER'
                        }
                    }
                }
            },
            descriptions = {
                _t'Bombard them from afar.',
                _t'Even one good sling is enough to fell down a giant.',
                _t'I can break skulls with these stones.'
            }
        }
    }
}
