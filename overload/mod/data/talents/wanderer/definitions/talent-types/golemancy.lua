return {
    {
        id = 'golemancy',
        names = {
            _t'sculptor',
            _t'carver',
            _t'idolatrol'
        },
        talent_queue = {
            items = {
                'T_GOLEM_POWER',
                'T_GOLEM_RESILIENCE',
                {
                    take_at_most = 1,
                    items = {
                        'T_INVOKE_GOLEM',
                        'T_GOLEM_PORTAL'
                    }
                }
            }
        },
        descriptions = {
            _t'It\'s alive!',
            _t'I brought you to life, and I shall command you!',
            _t'Oh, powerful spirit inhabiting this construct, aid me and protect me from my foes.'
        }
    }
}
