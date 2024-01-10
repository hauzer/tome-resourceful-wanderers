local ActorTalents = require("engine.interface.ActorTalents")


class:bindHook("ToME:load", function(self, data)
    ActorTalents:loadDefinition("/data-resourceful-wanderers/talents/wanderer/wanderer.lua")
end)
