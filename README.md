<h1 align=center>list.lua 📜</h1>
<h3 align=center>A collection of handy table functions 📄</h3>


# Installation

## Luarocks

If you are using [luarocks](https://luarocks.org), just run:

```
luarocks install list
```

## Manual

Copy the [list.lua](list.lua) file somewhere where your Lua interpreter will be able to find it and require it accordingly:

```lua
local list = require("list")
```

# Interface Summary

|                                                 |                                                          |
|-------------------------------------------------|----------------------------------------------------------|
| **Varargs**                                     |                                                          |
| `list.pack(...) -> t`                           | pack varargs                                             |
| `list.unpack(t[, i[, j]]`                       | unpack varargs                                           |
| **Tables**                                      |                                                          |
| `list.count(t[, maxn]) -> n`                    | number of keys in table                                  |
| `list.index(t) -> dt`                           | switch keys with values                                  |
| `list.keys(t[, cmp]) -> dt`                     | make a list of all the keys                              |
| `list.values(t[, cmp]) -> dt`                   | make a list of all the values                            |
| `list.sortedpairs(t [, cmp]) -> iter() -> k, v` | like pairs() but in key order                            |
| `list.clone(t) -> dt`                           | copies a table                                           |
| `list.update(dt, t1, ...) -> dt`                | merge tables - overwrites keys                           |
| `list.merge(dt, t1, ...) -> dt`                 | merge tables - no overwriting                            |
| `list.find(t, v) -> v`                          | search for a value                                       |
| `list.each(t, f, ...) -> t`                     | iterate on all key-value pairs                           |
| `list.eachi(t, f, ...) -> t`                    | iterate on all elements                                  |
| `list.reverse(t) -> t`                          | reverse table                                            |
| `list.attr(t, k1 [, v])[k2] = v`                | autofield pattern                                        |
| **Arrays**                                      |                                                          |
| `list.extend(dt, t1, ...) -> dt`                | extend an array                                          |
| `list.append(dt, v1, ...) -> dt`                | append non-nil values to an array                        |
| `list.isarray(t) -> b`                          | check if table is an array                               |
| `list.sample(t) -> v`                           | picks a random element                                   |
| `list.shuffle(t) -> t`                          | randomises order of elements                             |
| `list.shift(t, i, n) -> t`                      | shift array elements                                     |
| `list.max(t) -> n`                              | maximum value                                            |
| `list.min(t) -> n`                              | minimum value                                            |
| `list.avg(t) -> n`                              | average value                                            |
| `list.at(t, i) -> v`                            | value at an index                                        |
| `list.get(t, k) -> v`                           | value of a key                                           |
| `list.pop(t) -> v`                              | removes and returns the last element                     |
| `list.head(t) -> v`                             | removes and returns the first element                    |
| `list.last(t) -> v`                             | last element                                             |
| `list.first(t) -> v`                            | first element                                            |
| `list.map(t, f, ...) -> t`                      | map f over t or select a column from an array of records |
| `list.stringify(t, i) -> s`                     | converts a table to a prettified string                  |
|                                                 |                                                          |

# Interface

### Varargs

`list.pack(...)` Packs varargs

```lua
list.pack(1, 2, 3) -> { 1, 2, 3 }
```

Arguments:

* `...` `(any)` - Elements to pack

Returns:

* `(table)` - Table of packed elements

---
`list.unpack(t,[, i][, j])` Unpacks varargs

```lua
list.unpack({1, 2, 3}) -> 1, 2, 3
```

Arguments:

* `t` `(table)` - Table to unpack
* `i` `(number)` - Start index
* `j` `(number)` - End index

Returns:

* `(any)` - Tuple of unpacked table

---

### Tables

`list.count(t[, maxn])` Count the keys in a table, optionally up to `maxn`.

```lua
list.count({1, 2, 3}) -> 3
```

Arguments:

* `t` `(table)` - Table to count
* `maxn` `(number)` - Maximum count

Returns:

* `(number)` - Number of keys, optionally up to `maxn`

---
`list.index(t)` Swaps table keys with values.

```lua
list.index({["foo"] = 1, ["bar"] = 2}) -> { [1] = "foo", [2] = "bar" }
```

Arguments:

* `t` `(table)` - Table to invert

Returns:

* `(table)` - Table of inverted keys and values

---
`list.keys(t[, cmp])` Makes an array with all the keys of `t`, optionally sorted.  The second arg may be `'true'`, `'asc'`, `'desc'` or a comparison function.

```lua
list.keys({["foo"] = 1, ["bar"] = 2}, "asc") -> { "bar", "foo" }
```

Arguments:

* `t` `(table)` - Table to get keys from
* `cmp` `(boolean | string | function)` - Comparison method

Returns:

* `(table)` - Array of keys

---
`list.values(t[, cmp])` Makes an array with all the values of `t`, optionally sorted.  The second arg may be `'true'`, `'asc'`, `'desc'` or a comparison function.

```lua
list.values({["foo"] = 1, ["bar"] = 2}, "desc") -> { 2, 1 }
```

Arguments:

* `t` `(table)` - Table to get values from
* `cmp` `(boolean | string | function)` - Comparison method

Returns:

* `(table)` - Array of values

---
`list.sortedpairs(t[, cmp]) -> iter() -> k, v` Like `pairs` but in key order. the implementation creates a temporary table to sort the keys in.

```lua
for k, v in list.sortedpairs({["foo"] = 1, ["bar"] = 2}) do
    print(k, v)
end
```

Arguments:

* `t` `(table)` - Table to iterate over
* `cmp` `(boolean | string | function)` - Comparison method

Returns:

* `k` `(any)` - A key from `t`
* `v` `(any)` - A value from `t`

---
`list.clone(t)` Deep clones each key-value pair of the input table.

```lua
list.clone({1, 2, 3}) -> { 1, 2, 3 }
```

Arguments:

* `t` `(table)` - Table to clone

Returns:

* `(table)` - Clone of `t`

---
`list.update(dt, t, ...)` Update a table with elements of other tables, overwriting any existing keys. Falsey arguments are skipped.

```lua
list.update({1, 2, 3}, {4, 5, 6}) -> { 4, 5, 6 }
```

Arguments:

* `dt` `(table)` - Table to update
* `t` `(table)` - Table to update with
* `...` `(table)` - Same use as `t`

Returns:

* `(table)` - Table with updated elements

---
`list.merge(dt, t, ...)` Update a table with elements of other tables skipping any existing keys.

```lua
list.merge({1, 2, 3}, {4, 5, 6}) -> { 1, 2, 3, 4, 5, 6 }
```

Arguments:

* `dt` `(table)` - Base table
* `t` `(table)` - Table to merge
* `...` `(table)` - Same use as `t`

Returns:

* `(table)` - Merged table

---
`list.find(t, v) -> v` Searches a table for the given value.

```lua
list.find({1, 2, 3}, 2) -> 2
```

Arguments:

* `t` `(table)` - Table to search
* `v` `(any)` - Value to search for

Returns:

* `(any)` - `v` if found, `nil` if not

---
`list.each(t, f, ...)` Applies the given function on all key-value pairs of the table.

```lua
list.each({1, 2, 3}, print) -> 1, 2, 3
```

Arguments:

* `t` `(table)` - Table to iterate
* `f` `(function)` - Callback function
* `...` `(any)` - Arguments passed to `f`

---
`list.eachi(t, f, ...)` Applies the given function to all elements of the table.

```lua
list.eachi({1, 2, 3}, print) -> 1, 2, 3
```

Arguments:

* `t` `(table)` - Table to iterate
* `f` `(function)` - Callback function
* `...` `(any)` - Arguments passed to `f`

---
`list.reverse(t)` Returns a table which original values are in opposite order.

```lua
list.reverse({1, 2, 3}) -> { 3, 2, 1 }
```

Arguments:

* `t` `(table)` - Table to reverse

Returns:

* `(table)` - Reversed version of `t`

---
`list.attr(t, k1[, v])[k2] = v` Idiom for `t[k1][k2] = v` with auto-creating of `t[k1]` if not present.


```lua
list.attr({}, "foo")["bar"] = "baz"
```

Arguments:

* `t` `(table)` - Table to get data from
* `k1` `(any)` - Key index from table
* `v` `(any)` - value to be set to `k1`
* `k2` `(any)` - Key to find from `k1`

---

### Arrays

`list.extend(dt, ...)` Extends a list with the elements of other lists. Falsey arguments are skipped.

```lua
list.extend({1, 2}, 3) -> { 1, 2, 3 }
```

Arguments:

* `dt` `(table)` - Table to be extended
* `...` `(any)` - elements to be added to `dt`

Returns:

* `(table)` - Extended table

---
`list.append(dt, ...)` Append non-nil arguments to an array.

```lua
list.append({2, 3}, 1) -> { 1, 2, 3 }
```

Arguments:

* `dt` `(table)` - Table to be appended
* `...` `(any)` - elements to be added to `dt`

Returns:

* `(table)` - appended table

---
`list.isarray(t)` Returns a boolean of whether a table is an array.

```lua
list.isarray({1, 2, 3}) -> true
```

Arguments:

* `t` `(table)` - Table to be checked

Returns:

* `(boolean)` - `true` if only has numeric keys, `false` if not

---
`list.sample(t)` Returns a random element of a table.

```lua
list.sample({1, 2, 3}) -> 2
```

Arguments:

* `t` `(table)` - Table to sample

Returns:

* `(any)` - Random value of `t`

---
`list.shuffle(t)` Mixes the values inside the given table.

```lua
list.shuffle({1, 2, 3}) -> { 3, 1, 2 }
```

Arguments:

* `t` `(table)` - Table to shuffle

Returns:

* `(table)` - Shuffled table of `t`

---
`list.shift(t, i, n) -> t` Shifts all the elements on the right of `i` (`i` inclusive) by `n` to the left or further to the right.

```lua
list.shift({1, 2, 3}, 2, 2) -> { 1, 2, 3, 2, 3 }
```

Arguments:

* `t` `(table)` - Table to shift
* `i` `(number)` - Start index
* `n` `(number)` - Shift amount

Returns:

* `(table)` - Shifted table

---
`list.max(t) -> max` Returns the biggest value inside the table.

```lua
list.max({1, 2, 3}) -> 3
```

Arguments:

* `t` `(table)` - Table to search

Returns:

* `(number)` - Largest number from `t`

---
`list.min(t) -> min` Returns the smallest value inside the table.

```lua
list.min({1, 2, 3}) -> 1
```

Arguments:

* `t` `(table)` - Table to search

Returns:

* `(number)` - Smallest number from `t`

---
`list.avg(t) -> avg` Returns the average value inside table.

```lua
list.avg({1, 2, 3}) -> 2
```

Arguments:

* `t` `(table)` - Table to search

Returns:

* `(number)` - Average number of `t`

---
`list.at(t, i) -> v` Returns the element at the given index.

```lua
list.at({1, 2, 3}, 2) -> 2
```

Arguments:

* `t` `(table)` - Table to search
* `i` `(number)` - Index to find

Returns:

* `(any)` - Value at index `i`

---
`list.get(t, k) -> v` Returns the element at the given key.

```lua
list.get({["foo"] = 1, ["bar"] = 2}, "bar") -> 2
```

Arguments:

* `t` `(table)` - Tab;e to search
* `k` `(any)` - Key to find

Returns:

* `(any)` - `v` if the key exists, `nil` if not

---
`list.pop(t)` Removes and returns the last element of a table.

```lua
list.pop({1, 2, 3}) -> 3
```

Arguments:

* `t` `(table)` - Table to _"pop"_

Returns:

* `(any)` - Last value of `t`

---
`list.head(t)` Removes and returns the first element of a table.

```lua
list.head({1, 2, 3}) -> 1
```

Arguments:

* `t` `(table)` - Table to _"head"_

Returns:

* `(any)` - First value of `t`

---
`list.last(t)` Returns the last element of a table.

```lua
list.last({1, 2, 3}) -> 3
```

Arguments:

* `t` `(table)` - Table to search

Returns:

* `(any)` - Last value of `t`

---
`list.first(t)` Returns the first element of a table.

```lua
list.first({1, 2, 3}) -> 1
```

Arguments:

* `t` `(table)` - Table to search

Returns:

* `(any)` - First value of `t`

---
`list.map(t, f, ...)` Maps `f` over `t` or extract a column from a list of records.

```lua
list.map({"foo", "bar", "baz"}, string.upper) -> { "FOO", "BAR", "BAZ" }
```

Arguments:

* `t` `(table)` - Table to map
* `f` `(function)` - Callback function
* `...` `(any)` - Arguments passed to `f`

Returns:

* `(table)` - Mapped table

---
`list.stringify(t[, i])` Returns a pretty-printed string of a table.

```lua
list.stringify({1, ["hello"] = "world", 2, ["foo"] = "bar", 3})

--> {
-->     [1] = 1,
-->     [2] = 2,
-->     [3] = 3,
-->     ['hello'] = 'world',
-->     ['foo'] = 'bar'
--> }
```

Arguments:

* `t` `(table)` - Table to stringify
* `i` `(number)` - Indenation size

Returns:

* `(string)` - Stringified table

# License

This library is free software; You may redistribute and/or modify it under the terms of the MIT license. See [LICENSE](LICENSE) for details.
