_M = loadPrevious(...)


local base_init = _M.init
function _M:init(t, no_default)
    local retval = base_init(self, t, no_default)

    if not self.hauzer then
        self.hauzer = { }
    end

    return retval
end


return _M
