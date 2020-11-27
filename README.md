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

# Interface

## Varargs

### `glue.pack(...) -> t`
packs varargs.

### `glue.unpack(t,[i][,j]) -> ...`
Unpacks varargs.

---
## Tables

### `list.count(t[, maxn]) -> n`
Count the keys in a table, optionally up to `maxn`.

### `list.index(t) -> dt`
Switchs table keys with values.

### `list.keys(t[, cmp]) -> dt`
Makes an array with all the keys of `t`, optionally sorted.  The second arg may be `'true'`, `'asc'`, `'desc'` or a comparison function.

### `list.values(t[, cmp]) -> dt`
Makes an array with all the values of `t`, optionally sorted.  The second arg may be `'true'`, `'asc'`, `'desc'` or a comparison function.

### `glue.sortedpairs(t[, cmp]) -> iter() -> k, v`
Like `pairs` but in key order. the implementation creates a temporary table to sort the keys in.

### `list.clone(t) -> dt`
deep clones each key-value pair of the input table.

### `glue.update(dt, t1, ...) -> dt`
Update a table with elements of other tables, overwriting any existing keys. Falsey arguments are skipped.

###  `glue.merge(dt,t1,...) -> dt`
Update a table with elements of other tables skipping any existing keys.

### `list.find(t, v) -> v`
Searches a table for the given value.

### `list.each(t, f, ...) -> t`
Applies the given function on all key-value pairs of the table.

### `list.eachi(t, f, ...) -> t`
Applies the given function to all elements of the table.

### `table.reverse(t) -> t`
Returns a table which original values are in opposite order.

### `list.attr(t, k1[, v])[k2] = v`
Idiom for `t[k1][k2] = v` with auto-creating of `t[k1]` if not present.

---
## Arrays

### `list.extend(dt, ...) -> dt`
Extends a list with the elements of other lists. Falsey arguments are skipped.

### `list.append(dt, ...) -> dt`
Append non-nil arguments to an array.

### `list.insert(t, i, n)`
Insert `n` elements at `i`, shifting elements on the right of `i` to the right.

### `list.remove(t, i, n)`
Remove `n` elements at `i`, shifting elements on the right of `i` to the left.

### `list.isarray(t) -> b`
Returns a boolean of whether a table is an array.

### `list.sample(t) -> v`
Returns a random element of a table.

### `list.shuffle(t) -> t`
Mixes the values inside the given table.

### `list.shift(t, i, n) -> t`
Shifts all the elements on the right of `i` to the left or further to the right.

### `list.max(t) -> max`
Returns the biggest value inside the table.

### `list.min(t) -> min`
Returns the smallest value inside the table.

### `list.avg(t) -> avg`
Returns the average value inside table.

### `list.at(t, i) -> v`
Returns the element at the given index.

### `list.get(t, k) -> v`
Returns the element at the given key.

### `list.pop(t) -> v`
Removes and returns the last element of a table.

### `list.head(t) -> v`
Removes and returns the first element of a table.

### `list.last(t) -> v`
Returns the last element of a table.

### `list.first(t) -> v`
Returns the first element of a table.

### `list.map(t, f, ...) -> dt`
Maps `f` over `t` or extract a column from a list of records.

### `list.stringify(t, i) -> s`
Returns a pretty-printed string of a table.

# License

This library is free software; You may redistribute and/or modify it under the terms of the MIT license. See [LICENSE](LICENSE) for details.
