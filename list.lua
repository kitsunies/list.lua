local list = {}

local pairs, ipairs, rawget = pairs, ipairs, rawget
local select, unpack = select, unpack or table.unpack

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

-- put keys in a list, optionally sorted.
function list.keys(t, cmp)
    local dt = {}
    for k in pairs(t) do
        dt[#dt + 1] = k
    end
    if cmp == true or cmp == "asc" then
        table.sort(dt)
    elseif cmp == "desc" then
        table.sort(
            dt,
            function(a, b)
                return a > b
            end
        )
    elseif cmp then
        table.sort(dt, cmp)
    end
    return dt
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

-- update a table with the contents of other table(s).
function list.update(dt, ...)
    for i = 1, select("#", ...) do
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
    for i = 1, select("#", ...) do
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
        return {n = select("#", ...), ...}
    end
end

--always use this because unpack/table.unpack's default j is #t not t.n.
function list.unpack(t, i, j)
    return unpack(t, i or 1, j or t.n or #t)
end

-- extend a list with the elements of other lists.
function list.extend(dt, ...)
    for j = 1, select("#", ...) do
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
    for i = 1, select("#", ...) do
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

function list.find(t, v)
    if not v or not t then
        return
    end
    for i = 1, #t do
        if v == t[i] then
            return t[i]
        end
    end
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

-- map f over t or extract a column from a list of records.
function list.map(t, f, ...)
    local dt = {}
    if #t == 0 then
        if type(f) == "function" then
            for k, v in pairs(t) do
                dt[k] = f(k, v, ...)
            end
        else
            for k, v in pairs(t) do
                local sel = v[f]
                if type(sel) == "function" then
                    dt[k] = sel(v, ...)
                else -- field to pluck
                    dt[k] = sel
                end
            end
        end
    else
        if type(f) == "function" then
            for i, v in ipairs(t) do
                dt[i] = f(v, ...)
            end
        else
            for i, v in ipairs(t) do
                local sel = v[f]
                if type(sel) == "function" then
                    dt[i] = sel(v, ...)
                else
                    dt[i] = sel
                end
            end
        end
    end
    return dt
end

return list
