_M = loadPrevious(...)


local base_newBirthDescriptor = _M.newBirthDescriptor
function _M:newBirthDescriptor(descriptor)
    if descriptor.name == 'Wanderer' then
        for _, resolver in ipairs(descriptor.copy) do
            if resolver.__resolver == 'inventory' then
                table.insert(resolver[1], {
                    type='armor',
                    subtype='heavy',
                    name='iron mail armour',
                    ego_chance=-1000
                })
            end
        end
    end

    return base_newBirthDescriptor(self, descriptor)
end


return _M
