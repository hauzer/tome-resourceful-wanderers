_M = loadPrevious(...)


function _M:get_resourceful_wanderers()
    self.resourceful_wanderers = self.resourceful_wanderers or {
        is_active = false
    }

    return self.resourceful_wanderers
end


return _M
