# Luau Extended Table
A simple class designed to provide additional features for working with [Luau](https://roblox.github.io/luau/) tables. Many of its methods come in the standard libraries for other languages. Some others are inspired by various frameworks that extend those libraries for other languages.

## Usage
```lua
-- Replace `script.Parent` with the path in your project
local Table = require(script.Parent.Table)

-- Example of using a method
print(Table.isArray({})) -- false
```

## API

### `Table.Implode(array: table, glue: string)`
Returns a string containing all of the elements within an array separated by `glue`.

**Parameters**
- array: `table` The table to implode.
- glue: `string` The string to separate each value with.

**Returns**
- `string` A string containing all of the elements within an array separated by `glue`.

**Example**
```lua
local array = {"red", "green", "blue", "orange", "yellow"}
print(Table.Implode(array, ", ")) -- red, green, blue, orange, yellow
```

---

### `Table.IsArray(array: table)`
Returns a boolean indicating whether or not the table is an array. An array is defined as a table containing positive integer indexes.

**Parameters**
- array: `table` The table to evaluate.

**Returns**
- `boolean` Whether or not the table is an array.

**Example**
```lua
print(Table.IsArray(nil)) -- false
print(Table.IsArray({})) -- false
print(Table.IsArray({"red", "green", "blue"})) -- true
print(Table.IsArray({animal="Dog", name="Spot"})) -- false
```

---

### `Table.IsDictionary(array: table)`
Returns a boolean indicating whether or not the table is a dictionary. A dictionary is defined as a table containing keys that are not positive integers.

**Parameters**
- array: `table` The table to evaluate.

**Returns**
- `boolean` Whether or not the table is a dictionary.

**Example**
```lua
print(Table.IsDictionary(nil)) -- false
print(Table.IsDictionary({})) -- false
print(Table.IsDictionary({"red", "green", "blue"})) -- false
print(Table.IsDictionary({animal="Dog", name="Spot"})) -- true
```

---

### `Table.IsEmpty(array: table)`
Returns a boolean indicating whether or not the table is empty.

**Parameters**
- array: `table` The table to evaluate.

**Returns**
- `boolean` Whether or not the table is empty.

**Example**
```lua
print(Table.IsEmpty(nil)) -- false
print(Table.IsEmpty({})) -- true
print(Table.IsEmpty({"red", "green", "blue"})) -- false
print(Table.IsEmpty({animal="Dog", name="Spot"})) -- false
```

---

### `Table.Length(array: table)`
Returns the number of non-nil elements that exist within a table. Works on all tables, including dictionaries.

**Parameters**
- array: `table` The table whose length to return.

**Returns**
- `number` The number of elements that exist within a table.

**Example**
```lua
local array = {"red", "green", nil, "blue"}
local dictionary = {animal = "Dog", name = "Spot", age = nil}

-- Arrays
print(#array) -- 4
print(Table.Length(array)) -- 3

-- Dictionaries
print(#dictionary) -- 0
print(Table.Length(dictionary)) -- 2
```

---

### `Table.Map(array: table, callback: function)`
Returns a mapped version of a table based on the values returned by `callback` for each element in the array. The callback will be passed `value`, and `key` from the key/value pairs within the table.

**Parameters**
- array: `table` The table to map.
- callback: `function` The callback function that determines the mapped value of table elements.

**Returns**
- `table` A table containing the mapped table elements.

**Example**
```lua
local array = {2, 4, 6, 8}
local result = Table.Map(array, function(value, key)
    return value * 10
end)

print(result) -- {20, 40, 60, 80}
```

---

### `Table.Clone(array: table)`
Returns a deep copy of the table.

**Parameters**
- array: `table` The table to deep copy.

**Returns**
- `table` A deep copy of the origin table.

**Example**
```lua
local object = {animal = "Dog"}

local newObject = Table.Clone(object)
newObject.animal = "Cat"

print(object.animal) -- Dog
print(newObject.animal) -- Cat
```

---

### `Table.Collapse(array: table)`
Collapses a table consisting of multiple tables into a single table.

**Parameters**
- array: `table` The table to collapse.

**Returns**
- `table`

**Example**
```lua
print(Table.Collapse({{"purple", "magenta", "violet"}, {"red", "maroon", "crimson"}})) -- {"purple", "magenta", "violet", "red", "maroon", "crimson"}
```

---

### `Table.Divide(array: table)`
Divides a table into two arrays: one containing the keys, one containing the values.

**Parameters**
- array: `table` The table whose keys and values should be returned as separate arrays.

**Returns**
- `table` An array containing the table's keys.
- `table` An array containing the table's values.

**Example**
```lua
local keys, values = Table.Divide({animal = "Dog", name = "Spot"})
print(keys) -- {"name", "animal"}
print(values) -- {"Spot", "Dog"}
```

---

### `Table.Has(array: table, key: any)`
Returns a boolean indicating whether or not the array has the requested key.

**Parameters**
- array: `table` The table to search.
- key: `any` The key to search for within the array.

**Returns**
- `boolean`

**Example**
```lua
local object = {animal = "Dog", name = "Spot"}
print(Table.Has(object, "name")) -- true
print(Table.Has(object, "breed")) -- false
```

---

### `Table.HasAny(array: table, keys: table)`
Returns a boolean indicating whether or not the array has any of the requested keys.

**Parameters**
- array: `table` The table whose keys to evaluate.
- keys: `table` An array of keys to search for within the table.

**Returns**
- `boolean`

**Parameters**
```lua
local object = {animal = "Dog", name = "Spot"}
print(Table.HasAny(object, {"id", "name"})) -- true
```

---

### `Table.Keys(array: table)`
Returns all of the keys within a table.

**Parameters**
- array: `table` The table whose keys to return.

**Returns**
- `table`

**Example**
```lua
print(Table.Keys({animal = "Dog", name = "Spot"})) -- {"name", "animal"}
```

---

### `Table.Merge(...)`
Merges the elements one or more tables together. Number indexes will be appended to the new array, receiving a new index. Non-number indexes will be retained, and will overwritten by values from later tables with the same property. Accepts a list of tables as arguments.

**Returns**
- `table`

**Example**
```lua
print(Table.Merge({"Red", "Green", "Blue"}, {"White", "Gray", "Black"}))
-- {"Red", "Green", "Blue", "White", "Gray", "Black"}

print(Table.Merge(
    { animal = "Dog", name = "Spot" },
    { name = "Fluffy" }
))
--[[
    ["animal"] = "Dog",
    ["name"] = "Fluffy"
]]
```

---

### `Table.Random(array: table)`
Returns a random value from the table. Also returns the selected key.

**Parameters**
- array: `table` The table from which to select a random value.

**Returns**
- `any` A random value from the table.
- `any` The randomly selected key from the table.

**Example**
```lua
local randomValue, randomKey = Table.Random({"Red", "Green", "Blue"})
print(randomValue) -- Green
print(randomKey) -- 2
```

---

### `Table.Reverse(array: table)`
Returns a reversed version of `array`.

**Parameters**
- array: `table` The table to reverse.

**Returns**
- `table`

**Example**
```lua
print(Table.Reverse({1, 2, 3})) -- {3, 2, 1}
```

---

### `Table.Shuffle(array: table)`
Returns a shuffled variant of `array`. In other words, the values within the array will be randomly assigned to different indexes.

**Parameters**
- array: `table` The table to shuffle.

**Returns**
- `table` The shuffled table.

**Example**
```lua
print(Table.Shuffle({1, 2, 3}))
```

---

### `Table.Values(array: table)`
Returns all of the values within a table.

**Parameters**
- array: `table` The table whose values to return.

**Returns**
- `table`

**Example**
```lua
print(Table.Values({animal = "Dog", name = "Spot"})) -- {"Spot", "Dog"}
```

---

### `Table.Add(array: table, key: any, value: any)`
Adds a property to a table if it does not already exist.

**Parameters**
- array: `table` The table to alter.
- key: `any` The key to assign to.
- value: `any` The value to assign to array[key]

**Returns**
- `table`

**Example**
```lua
local object = { animal = "Dog", name = "Spot" }
Table.Add(object, "breed", "Retriever")
Table.Add(object, "name", "Default Name")
print(object)
--[[
    ["animal"] = "Dog",
    ["breed"] = "Retriever",
    ["name"] = "Spot"
]]
```

---

### `Table.Pull(array: table, key: any)`
Returns the value of `key` in a table and removes it from that table.

**Parameters**
- array: `table` The table to pull from.
- key: `any` The key to pull from the table.

**Returns**
- `any` The value pulled from `array[key]`

**Example**
```lua
local object = { animal = "Dog", name = "Spot" }
print(Table.Pull(object, "name")) -- "Spot"
print(object) -- { ["animal"] = "Dog" }
```

---

### `Table.Except(array: table, blacklist: table)`
Returns a filtered version of `array` ommitting the blacklisted properties.

**Parameters**
- array: `table` The table.
- blacklist: `table` An array of keys to omit from the results.

**Returns**
- `table` The table without blacklisted properties.

**Example**
```lua
local object = { species = "Mammal", animal = "Dog", name = "Spot" }
print(Table.Except(object, {"name"}))
--[[
    ["animal"] = "Dog"
    ["species"] = "Mammal"
]]

```

---

### `Table.Filter(array: table, callback: function)`
Returns a filtered version of a table containing elements for which `callback` returns a truthy value. The callback will be passed `value`, and `key` from the key/value pairs within the table.

**Parameters**
- array: `table` The table to filter.
- callback: `function` A callback function that determines whether or not an element should be filtered.

**Returns**
- `table` A table containing the filtered table elements.

**Example**
```lua
local array = {1, 2, 3, 4, 5, 6}
local filteredArray = Table.Filter(array, function(value)
    return value > 3
end)
print(filteredArray) -- {4, 5, 6}
```

---

### `Table.First(array: table, callback: function)`
Returns the first value in the table for which `callback` returns `true`.

**Parameters**
- array: `table` The table to evaluate.
- callback: `function` The callback.

**Returns**
- `any` The first value in the array for which `callback` returns `true`.

**Example**
```lua
local array = {1, 2, 3, 4, 5, 6}
local firstAboveThree = Table.First(array, function(value)
    return value > 3
end)
print(firstAboveThree) -- 4
```

---

### `Table.Last(array: table, callback: function)`
Returns the last value in the table for which `callback` returns `true`.

**Parameters**
- array: `table` The table to evaluate.
- callback: `function` The callback.

**Returns**
- `any` The last value in the array for which `callback` returns `true`.

**Example**
```lua
local array = {1, 2, 3, 4, 5, 6}
local firstAboveThree = Table.Last(array, function(value)
    return value < 3
end)
print(firstAboveThree) -- 2
```

---

### `Table.Only(array: table, whitelist: table)`
Returns a table containing only the whitelisted keys from `array`.

**Parameters**
- array: `table` The table to search.
- whitelist: `table` An array of keys from the original array to whitelist.

**Returns**
- `table` A table only containing whitelisted key/pair values from `array`.

**Example**
```lua
local object = { species = "Mammal", animal = "Dog", name = "Spot" }
print(Table.Only(object, {"species", "animal"})) -- { ["animal"] = "Dog", ["species"] = "Mammal" }
```

---

### `Table.Slice(array: table, offset: number, length: number)`
Returns the values associated with the indexes between array[offset] and array[offset + length] in a new array.

**Parameters**
- array: `table` The origin table.
- offset: `number` The array index to begin with.
- length: `number` The number of indexes that should be selected.

**Returns**
- `table`

```lua
local array = {"red", "green", "blue", "yellow", "purple", "orange"}
print(Table.Slice(array, 1, 3)) -- {"red", "green", "blue"}
```

---

### `Table.Concat(array: table, separator: string, beginIndex: number, lastIndex: number)`
Returns a string resulting from concatenating all of the values within this array. Only works on arrays. Use `Table.implode()` for support for dictionaries as well.

**Parameters**
- array: `table` The table to concatenate.
- separator: `string` ? The string to concatenate between array elements.
- beginIndex: `number` The first element in the table to concatenate.
- lastIndex: `number` The last element in the table to concatenate.

**Returns**
- `string`

---

### `Table.Create(count: number, value: any)`
Creates an array sized for `count` elements. Populated by `value` if set.

**Parameters**
- count: `number` The number of elements to size the array for.
- value: `any` The value to optionally populate the array with `count` times.

**Returns**
- `table`

---

### `Table.Find(haystack: table, needle: any, beginIndex: number)`
Returns the key of the first occurence of `needle` in the array `haystack` after `haystack[init]`.

**Parameters**
- haystack: `table` The table to search.
- needle: `any` The value to search for.
- beginIndex: `number` The index to begin searching at.

**Returns**
- `any`

---

### `Table.ForEach(array: table, callback: function)`
Iterates through the provided table, calling `callback()` and passing the key/value for each element as arguments.

**Parameters**
- array: `table` The table to iterate through.
- callback: `function` The function to call for each iteration.

---

### `Table.ForEachIPairs(array: table, callback: function)`
Iterates through the provided array, calling `callback()` and passing the index/value for each element as arguments. Basically the same as `Table.foreach()` except uses `ipairs()` instead of `pairs()` for the iteration.

**Parameters**
- array: `table` The table to iterate through.
- callback: `function` The function to call for each iteration.

---

### `Table.GetN(array: table)`
Returns the number of elements in the array passed. Will not work for dictionary tables, use `Table.length()` for that instead.

**Parameters**
- array: `table` The table whose length to return.

**Returns**
- `number`

---

### `Table.Insert(array: table, pos: number, value: any)`
Appends `value` to `pos` or, if `pos` is empty, to the end of the array.

**Parameters**
- array: `table` The table to append to.
- pos: `number` The position to append to. Defaults to `#array + 1`.
- value: `any` The value to append to the array.

---

### `Table.Move(arrayOne: table, firstIndex: number, lastIndex: number, insertIndex: number, arrayTwo: table)`
Moves elements from one table to another.

**Parameters**
- arrayOne: `table` The first table.
- firstIndex: `number` The first index in `a1` to move elements from.
- lastIndex: `number` The last index in `a2` to move elements from.
- insertIndex: `number` The index to begin inserting elements from `a1` into `a2` at.
- arrayTwo: `table` The second table. Defaults to `a1`.

**Returns**
- `table`

---

### `Table.Pack()`
Returns a new table with each argument as an element inside an array.

---

### `Table.Remove(array: table, pos: number)`
Removes and returns an element from an array at the specified position.

**Parameters**
- array: `table` The table to remove from.
- pos: `number` The position of the element to remove.

---

### `Table.Sort(array: table, callback: function)`
Sorts elements in a table based on the return values of the callback. The callback should return `true` when the first argument should come before the second argument in the sorted table. If a callback is not provided, the Lua operator `<` is used to compare elements.

**Parameters**
- array: `table` The table to sort.
- callback: `function` The callback used to determine the sorting order.

---

### `Table.Unpack(array: table, beginIndex: number, finalIndex: number)`
Returns the selected elements from the table `list`.

**Parameters**
- array: `table` The table whose elements to return.
- beginIndex: `number` The starting index.
- finalIndex: `number` The final index to return.

**Returns**
- `Tuple`