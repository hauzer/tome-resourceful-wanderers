local Nilable = require('mod.class.resourcefulwanderer.Nilable')


-- An ordered data structure which can contain generic items and other nested Queues.
-- It supports "taking" a number of items between `take_at_least` and `take_at_most`
-- from itself. This returns a group of items gathered from itself, and/or nested Queues,
-- depending on the ordering, which removes the taken items from it, and any nested Queues.
--
-- If taking items from a nested queue would put the group over its limit, then the next item
-- is examined.
--
-- It supports prioritizing items, serving the prioritized items before all non-prioritized ones.
-- Prioritized items are sorted according to their priority integer value, from highest to lowest.
-- Item priority from nested queue doesn't bubble up to parent queues.
module(..., package.seeall, class.inherit(Nilable))


-- Not a very good method, but it's going to have to do.
function _M:isQueue()
    return self.take_at_most ~= nil and self.take_at_least ~= nil and self.items ~= nil
end


function _M:init(definition)
    if definition.take_exactly ~= nil then
        self.take_at_most = definition.take_exactly
        self.take_at_least = definition.take_exactly
    else
        self.take_at_most = definition.take_at_most == nil and 1/0 or definition.take_at_most
        self.take_at_least = definition.take_at_least == nil and 1 or definition.take_at_least
    end

    self.can_take_altogether = definition.can_take_altogether == nil and 1/0 or definition.can_take_altogether
    self.items = definition.items == nil and { } or definition.items

    local items_to_keep = { }
    for _, item in ipairs(self.items) do
        if self.isQueue(item) then
            item = self.new(item)
        elseif definition.item_new then
            item = definition.item_new(item)
        end

        if Nilable.isNil(item) then
            goto next_item
        end

        table.insert(items_to_keep, item)

        ::next_item::
    end
    self.items = items_to_keep
    self.taken_altogether = 0

    self.should_rebuild_groups = true
end


function _M:isNil()
    return #self.items == 0 or Nilable.isNil(self)
end


-- Gets the priority of an item. Intended to be overloaded by a child class.
-- Returns nil if the item doesn't have a priority, and a number otherwise,
-- where lower is a lower priority.
function _M:getItemPriority(item)
    return nil
end


-- Tests equality of two items. Intented to be used by child classes.
function _M:areItemsEqual(a, b)
    return a == b
end


-- Consolidates all items, including those of subqueues, into groups of items.
function _M:rebuildGroups(take)
    local take_at_least
    local take_at_most

    if take ~= nil then
        if take.exactly ~= nil then
            take_at_least = take.exactly
            take_at_most = take.exactly
        else
            take_at_least = take.at_least == nil and self.take_at_least or take.at_least
            take_at_most = take.at_most == nil and self.take_at_most or take.at_most
        end
    else
        take_at_least = self.take_at_least
        take_at_most = self.take_at_most
    end

    if
        not self.should_rebuild_groups and
        (
            self.previous_rebuild_groups_take == nil or
            (
                self.previous_rebuild_groups_take ~= nil and
                self.previous_rebuild_groups_take.at_least == take_at_least and
                self.previous_rebuild_groups_take.at_most == take_at_most
            )
        )
    then
        return
    end

    -- Rebuild subqueues groups.
    local subqueues_groups = { }
    for i, item in ipairs(self.items) do
        if self.isQueue(item) then
            local subqueue = item
            subqueue:rebuildGroups()

            -- Make copies of each group list. This is used to keep track of which
            -- subqueue groups have been incorporated.
            local groups_copy = { }
            for _, group in ipairs(subqueue.groups) do
                table.insert(groups_copy, group)
            end

            subqueues_groups[i] = groups_copy
        end
    end

    -- Get priority items, sort them and prepend them to other itens
    local priority_items = { }
    local non_priority_items = { }
    for _, item in ipairs(self.items) do
        if not self.isQueue(item) then
            local priority = self:getItemPriority(item)
            if priority ~= nil then
                table.insert(priority_items, {
                    item = item,
                    priority = priority
                })
            else
                table.insert(non_priority_items, item)
            end
        end
    end

    table.sort(priority_items, function(a, b)
        return a.priority > b.priority
    end)

    local items = { }
    for _, item in ipairs(priority_items) do
        table.insert(items, item)
    end

    for _, item in ipairs(non_priority_items) do
        table.insert(items, item)
    end

    -- Create groups of sizes less or equal to than `take_at_most`.
    local groups = { }
    local group = { }
    for i, item in ipairs(self.items) do
        -- Group is full, start building the next one
        if #group > take_at_most then
            table.insert(groups, group)
            group = { }
        end

        -- If the item is a subqueue, try to extend the group with its first group
        if self.isQueue(item) then
            local subqueue = item
            if #subqueue.groups == 0 then
                goto next_item
            end

            local subqueue_group = subqueue.groups[1]
            if #group + #subqueue_group > take_at_most then
                goto next_item
            end

            for _, subqueue_group_item in ipairs(subqueue_group) do
                table.insert(group, subqueue_group_item)
            end

            table.remove(subqueues_groups[i], 1)
        -- If it's an item, add it to the group
        else
            -- We use this structure in groups to make it easier to
            -- remove the items when the group is taken
            table.insert(group, {
                queue = self,
                index = i
            })
        end

        ::next_item::
    end

    -- Go through each group, and if any has less than the minimum number of items,
    -- see if there's any leftover subqueue groups to incorporate. If not, discard
    -- the group.
    local groups_to_keep = { }
    for _, group in ipairs(groups) do
        for i, subqueue_groups in pairs(subqueues_groups) do
            if #group >= take_at_least then
                table.insert(groups_to_keep, group)
                goto next_group
            end

            local subqueue_groups_to_keep = { }
            for _, subqueue_group in ipairs(subqueue_groups) do
                if #group + #subqueue_group < take_at_least or #group + #subqueue_group > take_at_most then
                    table.insert(subqueue_groups_to_keep, subqueue_group)
                    goto next_subqueue_group
                end

                for _, subqueue_group_item in ipairs(subqueue_group) do
                    table.insert(group, subqueue_group_item)
                end

                table.insert(groups_to_keep, group)

                ::next_subqueue_group::
            end

            subqueues_groups[i] = subqueue_groups_to_keep
        end

        ::next_group::
    end

    self.groups = groups_to_keep

    self.previous_rebuild_groups_take = {
        at_least = take_at_least,
        at_most = take_at_most
    }

    self.should_rebuild_groups = false
end


-- Remove the first group's items from their respective queues, and return the group.
function _M:take(take)
    if self.can_take_altogether ~= nil then
        if self.taken_altogether >= self.can_take_altogether then
            return { }
        end

        if take.exactly ~= nil and take.exactly + self.taken_altogether > self.can_take_altogether then
            take.exactly = self.can_take_altogether - self.taken_altogether
        else
            if take.at_least ~= nil and take.at_least + self.taken_altogether > self.can_take_altogether then
                take.at_least = self.can_take_altogether - self.taken_altogether
            end

            if take.at_most == nil or take.at_most + self.taken_altogether > self.can_take_altogether then
                take.at_most = self.can_take_altogether - self.taken_altogether
            end
        end
    end

    self:rebuildGroups(take)

    local group = self.groups[1]
    if group == nil or #group < self.take_at_least then
        return { }
    end

    local items = { }
    for _, group_item in ipairs(group) do
        local queue = group_item.queue
        local index = group_item.index
        table.insert(items, queue.items[index])
        table.remove(queue.items, index)
    end

    self.taken_altogether = self.taken_altogether + #items
    self.should_rebuild_groups = true

    return items
end


-- Recursively remove items.
function _M:remove(items_to_remove_original, do_copy_items_to_remove)
    local items_to_remove
    if do_copy_items_to_remove == nil or do_copy_items_to_remove then
        items_to_remove = { }
        for _, item in ipairs(items_to_remove_original) do
            table.insert(items_to_remove, item)
        end
    else
        items_to_remove = items_to_remove_original
    end

    local was_item_removed = false
    local items_to_keep = { }
    for _, item in ipairs(self.items) do
        if #items_to_remove == 0 then
            break
        end

        if self.isQueue(item) then
            local subqueue = item

            local items_to_remove_size = #items_to_remove
            subqueue:remove(items_to_remove, false)

            if items_to_remove_size ~= #items_to_remove then
                self.taken_altogether = self.taken_altogether + (items_to_remove_size - #items_to_remove)
                was_item_removed = true
            end
        else
            for i, item_to_remove in ipairs(items_to_remove) do
                if self:areItemsEqual(item, item_to_remove) then
                    table.remove(items_to_remove, i)
                    was_item_removed = true
                    self.taken_altogether = self.taken_altogether + 1
                    goto next_item
                end
            end
        end

        table.insert(items_to_keep, item)

        ::next_item::
    end

    if was_item_removed then
        self.items = items_to_keep
        self.should_rebuild_groups = true
    end
end
