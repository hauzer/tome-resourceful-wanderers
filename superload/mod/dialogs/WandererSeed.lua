local ResourcefulWanderer = require('mod.class.ResourcefulWanderer')


_M = loadPrevious(...)


local base_makeWanderer = _M.makeWanderer
function _M:makeWanderer()
    -- I don't think this ever happens, but just to be sure
    if self.actor ~= game.player then
        base_makeWanderer(self)
    end

    -- We need to delay calls to randventurerLearn() and indirectly to learnTalentType() in base makeWanderer().
    -- This allows the addon to be set up before the player learns any talent types.
    local randventurerLearn_calls = {}
    local base_randventurerLearn = self.actor.randventurerLearn
    self.actor.randventurerLearn = function(_, what, silent)
        table.insert(randventurerLearn_calls, {
            what = what,
            silent = silent
        })
    end

    -- The first time this is called in base makeWanderer() is to set up the wanderer seed.
    -- The second time is to reset the seed to the current time.
    -- We only allow the first call to go through, so we can use the wanderer seed. The second call is delayed.
    local time_seed
    local got_wanderer_seed = false
    local base_rng_seed = rng.seed
    rng.seed = function(seed)
        if not got_wanderer_seed then
            got_wanderer_seed = true
            base_rng_seed(seed)
        elseif time_seed == nil then
            time_seed = seed
        else
            assert(false, 'resourceful-wanderers: rng.seed() called more than two times in makeWanderer()')
        end
    end

    -- Also delay the call to finish() so the talent types appear on character creation
    local base_finish = self.finish
    self.finish = function(...) end

    -- Call base makeWanderer() and restore hijacked functions
    base_makeWanderer(self)
    self.actor.randventurerLearn = base_randventurerLearn
    rng.seed = base_rng_seed
    self.finish = base_finish

    -- Make the player a resourceful wanderer
    self.actor.resourceful_wanderer = ResourcefulWanderer.new(self.actor, self.actor.resourceful_wanderer_configuration)
    rng.seed(time_seed)

    -- Execute the delayed randventurerLearn() calls
    for _, call in ipairs(randventurerLearn_calls) do
        self.actor:randventurerLearn(call.what, call.silent)
    end

    -- Execute the delayed finish() call
    self.finish()
end


return _M
