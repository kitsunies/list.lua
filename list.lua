local list = {}

-- count the keys in a table with an optional upper limit.
function list.count(t, maxn)
    local maxn = maxn or 1 / 0
    local n = 0
    for _ in pairs(t) do
        n = n + 1
        if n >= maxn then
            break
        end
    end
    return n
end

-- reverse keys with values.
function list.index(t)
    local dt = {}
    for k, v in pairs(t) do
        dt[v] = k
    end
    return dt
end

local function sort(t, cmp)
    if cmp == true or cmp == 'asc' then
        table.sort(t)
    elseif cmp == 'desc' then
        table.sort(
            t,
            function(a, b)
                return a > b
            end
        )
    elseif cmp then
        table.sort(t, cmp)
    end
    return t
end

-- put keys in a list, optionally sorted.
function list.keys(t, cmp)
    local dt = {}
    for k in pairs(t) do
        dt[#dt + 1] = k
    end
    return sort(dt, cmp)
end

-- put values in a list, optionally sorted.
function list.values(t, cmp)
    local dt = {}
    for i = 1, #t do
        dt[#dt + 1] = t[i]
    end
    return sort(dt, cmp)
end

-- stateless pairs() that iterate elements in key order.
function list.sortedpairs(t, cmp)
    local kt = list.keys(t, cmp or true)
    local i = 0
    return function()
        i = i + 1
        return kt[i], t[kt[i]]
    end
end

-- deep clones each key-value pair of the input table.
function list.clone(t)
    local dt = {}
    if type(t) == 'table' then
        for k, v in pairs(t) do
            dt[list.clone(k)] = list.clone(v)
        end
        setmetatable(dt, list.clone(getmetatable(t)))
    else
        dt = t
    end
    return dt
end

-- update a table with the contents of other table(s).
function list.update(dt, ...)
    for i = 1, select('#', ...) do
        local t = select(i, ...)
        if t then
            for k, v in pairs(t) do
                dt[k] = v
            end
        end
    end
    return dt
end

-- add the contents of other table(s) without overwrite.
function list.merge(dt, ...)
    for i = 1, select('#', ...) do
        local t = select(i, ...)
        if t then
            for k, v in pairs(t) do
                if rawget(dt, k) == nil then
                    dt[k] = v
                end
            end
        end
    end
    return dt
end

-- apply the given function on all (key, value) pairs of table
function list.each(t, f, ...)
    for k, v in pairs(t) do
        f(k, v, ...)
    end
    return t
end

-- apply the given function to all the elements of the table
function list.eachi(t, f, ...)
    for i = 1, #t do
        f(t[i], ...)
    end
    return t
end

-- return a table which values are in opposite order
function table.reverse(t)
    for i = 1, math.floor(#t * 0.5) do
        local k = #t - i + 1
        t[i], t[k] = t[k], t[i]
    end
    return t
end

-- get the value of a table field, and if there is no field present, creates and returns it as an empty table.
function list.attr(t, k, v0)
    local v = t[k]
    if v == nil then
        if v0 == nil then
            v0 = {}
        end
        v = v0
        t[k] = v
    end
    return v
end

if table.pack then
    list.pack = table.pack
else
    table.pack = function(...)
        return {n = select('#', ...), ...}
    end
end

-- always use this because unpack/table.unpack's default j is #t not t.n.
function list.unpack(t, i, j)
    return (unpack or table.unpack)(t, i or 1, j or t.n or #t)
end

-- extend a list with the elements of other lists.
function list.extend(dt, ...)
    for j = 1, select('#', ...) do
        local t = select(j, ...)
        if t then
            local j = #dt
            for i = 1, #t do
                dt[j + i] = t[i]
            end
        end
    end
    return dt
end

-- append non-nil arguments to a list.
function list.append(dt, ...)
    local j = #dt
    for i = 1, select('#', ...) do
        dt[j + i] = select(i, ...)
    end
    return dt
end

-- insert n elements at i, shifting elements on the right of i (i inclusive) to the right.
function list.insert(t, i, n)
    if n == 1 then
        table.insert(t, i, false)
        return
    end
    for p = #t, i, -1 do
        t[p + n] = t[p]
    end
end

-- remove n elements at i, shifting elements on the right of i (i inclusive) to the left.
function list.remove(t, i, n)
    n = min(n, #t - i + 1)
    if n == 1 then
        table.remove(t, i)
        return
    end
    for p = i + n, #t do
        t[p - n] = t[p]
    end
    for p = #t, #t - n + 1, -1 do
        t[p] = nil
    end
end

-- find the element v from a list t.
function list.find(t, v)
    if v == nil or t == nil then
        return
    end
    for i = 1, #t do
        if v == t[i] then
            return t[i]
        end
    end
end

-- check whether t this an array.
function list.isarray(t)
    for i in pairs(t) do
        if type(i) ~= 'number' then
            return false
        end
    end
    return true
end

-- returns a random element of the table.
function list.sample(t)
    return #t > 0 and t[math.random(size)]
end

-- mix the values inside the given table.
function list.shuffle(t)
    for i = 1, #t do
        local k = math.random(#t)
        t[i], t[k] = t[k], t[i]
    end
    return t
end

-- shift all the elements on the right of i (i inclusive) to the left or further to the right.
function list.shift(t, i, n)
    if n > 0 then
        list.insert(t, i, n)
    elseif n < 0 then
        list.remove(t, i, -n)
    end
    return t
end

-- return the biggest value inside the table in base of a comparator function.
function list.max(t)
    local max = t[1]
    for i = 2, #t do
        if t[i] >= max then
            max = t[i]
        end
    end
    return max
end

-- return the smallest value inside the table in base of a comparator function.
function list.min(t)
    local min = t[1]
    for i = 2, #t do
        if t[i] <= min then
            min = t[i]
        end
    end
    return min
end

-- return the average value inside table.
function list.avg(t)
    local avg = t[1]
    if avg == nil then
        return 0
    end
    for i = 2, #t do
        avg = avg + t[i]
    end
    return avg / #t
end

-- returns the element at the given index.
function list.at(t, i)
    if i >= 0 then
        return t[i]
    end
    return t[#t + i + 1]
end

-- returns the element at the given key.
function list.get(t, k)
    return t[k]
end

-- remove and return the last element into the table.
function list.pop(t)
    return table.remove(t, #t)
end

-- remove and return the first element into the table.
function list.head(t)
    return table.remove(t, 1)
end

-- return the last element into the table.
function list.last(t)
    return t[#t]
end

-- return the first value into the table.
function list.first(t)
    return t[1]
end

-- map f over t or extract a column from a list of records.
function list.map(t, f, ...)
    local dt = {}
    if #t == 0 then
        if type(f) == 'function' then
            for k, v in pairs(t) do
                dt[k] = f(k, v, ...)
            end
        else
            for k, v in pairs(t) do
                local sel = v[f]
                if type(sel) == 'function' then
                    dt[k] = sel(v, ...)
                else
                    dt[k] = sel
                end
            end
        end
    else
        if type(f) == 'function' then
            for i, v in ipairs(t) do
                dt[i] = f(v, ...)
            end
        else
            for i, v in ipairs(t) do
                local sel = v[f]
                if type(sel) == 'function' then
                    dt[i] = sel(v, ...)
                else
                    dt[i] = sel
                end
            end
        end
    end
    return dt
end

-- pretty-print t without deep recursion causing a stack overflow.
function list.stringify(t, i)
    local i = string.rep(' ', i or 4)
    local cache, stack, output = {}, {}, {}
    local depth = 1
    local output_str = '{\n'

    while true do
        local size = list.count(t)

        local cur_index = 1
        for k, v in pairs(t) do
            if cache[t] == nil or cur_index >= cache[t] then
                if string.find(output_str, '}', #output_str) then
                    output_str = output_str .. ',\n'
                elseif string.find(output_str, '\n', #output_str) == nil then
                    output_str = output_str .. '\n'
                end

                table.insert(output, output_str)
                output_str = ''

                local key
                if type(k) == 'number' or type(k) == 'boolean' then
                    key = '[' .. tostring(k) .. ']'
                else
                    key = '[\'' .. tostring(k) .. '\']'
                end

                if type(v) == 'number' or type(v) == 'boolean' then
                    output_str = output_str .. string.rep(i, depth) .. key .. ' = ' .. tostring(v)
                elseif type(v) == 'table' then
                    output_str = output_str .. string.rep(i, depth) .. key .. ' = {\n'
                    table.insert(stack, t)
                    table.insert(stack, v)
                    cache[t] = cur_index + 1
                    break
                else
                    output_str = output_str .. string.rep(i, depth) .. key .. ' = \'' .. tostring(v) .. '\''
                end

                if cur_index == size then
                    output_str = output_str .. '\n' .. string.rep(i, depth - 1) .. '}'
                else
                    output_str = output_str .. ','
                end
            else
                if cur_index == size then
                    output_str = output_str .. '\n' .. string.rep(i, depth - 1) .. '}'
                end
            end

            cur_index = cur_index + 1
        end

        if size == 0 then
            output_str = output_str .. '\n' .. string.rep(i, depth - 1) .. '}'
        end

        if #stack > 0 then
            t = stack[#stack]
            stack[#stack] = nil
            depth = cache[t] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    table.insert(output, output_str)

    return table.concat(output)
end

return list
