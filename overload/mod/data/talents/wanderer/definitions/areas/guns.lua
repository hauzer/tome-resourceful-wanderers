return {
    {
        addons = {
            'orcs'
        },
        cover_talent_types = {
            'steamtech/bullets-mastery',
            'steamtech/elusiveness',
            'steamtech/gunslinging'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'pistolero',
                        _t'gunfighter',
                        _t'gunner'
                    },
                    talent_queue = {
                        take_at_most = 4,
                        items = {
                            {
                                id = 'T_STEAMGUN_MASTERY',
                                is_signature = true
                            },
                            {
                                take_at_most = 2,
                                items = {
                                    'T_DOUBLE_SHOTS',
                                    'T_UNCANNY_RELOAD',
                                    'T_STATIC_SHOT'
                                }
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_STRAFE',
                                    'T_STARTLING_SHOT',
                                    'T_EVASIVE_SHOTS',
                                    'T_TRICK_SHOT'
                                }
                            }
                        }
                    },
                    descriptions = {
                        _t'Nothing better in life than the smell of gunpowder.',
                        _t'Fastest hand in the West... and East.',
                        _t'It\'s high noon.'
                    }
                }
            }
        }
    },
    {
        addons = {
            'orcs'
        },
        cover_talent_types = {
            'steamtech/artillery',
            'steamtech/heavy-weapons',
            'steamtech/chemical-warfare'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'modder',
                        _t'gunsmith',
                        _t'overclocker'
                    },
                    talent_queue = {
                        take_at_most = 4,
                        items = {
                            {
                                id = 'T_AUTOLOADER',
                                is_signature = true
                            },
                            {
                                take_at_most = 2,
                                items = {
                                    'T_OVERHEAT_BULLETS',
                                    'T_SUPERCHARGE_BULLETS',
                                    'T_PERCUSSIVE_BULLETS',
                                    'T_COMBUSTIVE_BULLETS'
                                }
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_DOUBLE_SHOTS',
                                    'T_UNCANNY_RELOAD',
                                    'T_STATIC_SHOT'
                                }
                            }
                        }
                    },
                    descriptions = {
                        _t'There\'s always a way to juice out some more power.',
                        _t'Gotta pick the right tool for the job. And the job is killing stuff.',
                        _t'I wonder if I can make these two parts compatible...'
                    }
                }
            }
        }
    },
    {
        addons = {
            'orcs'
        },
        cover_talent_types = {
            'steamtech/dread',
            'steamtech/mechstar'
        },
        talent_type_queue = {
            items = {
                {
                    names = {
                        _t'terrorist',
                        _t'hitman',
                        _t'gunman'
                    },
                    talent_queue = {
                        take_at_most = 4,
                        items = {
                            {
                                id = 'T_PSYSHOT',
                                is_signature = true
                            },
                            {
                                take_at_most = 1,
                                items = {
                                    'T_BOILING_SHOT',
                                    'T_BLUNT_SHOT',
                                    'T_VACUUM_SHOT'
                                }
                            },
                            'T_UNCANNY_RELOAD',
                            'T_LUCID_SHOT',
                            'T_PSY_WORM'
                        }
                    },
                    descriptions = {
                        _t'Meditate on the shot before pulling the trigger.',
                        _t'It\'s not about accuracy, it\'s about terror.',
                        _t'Break their mind before firing a single shot. Then they\'re easy marks.'
                    }
                }
            }
        }
    }
}
