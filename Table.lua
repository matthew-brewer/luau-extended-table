--[[
    Class Table

	The `Table` class is designed to provide additional features for working with Lua tables.
	Many of these features come standard in libraries for other languages. Some others are inspired by Laravel's
	Arr class.

	Matthew Brewer - January 2021
--]]

local Table = {}
Table.__index = Table

--[[
    Utilities
--]]

--- Returns a string containing all of the elements within an array separated by `glue`.
---
--- @param array table The table to implode.
--- @param glue string The string to separate each value with.
--- @return string result A string containing all of the elements within an array separated by `glue`.
function Table.Implode(array, glue)
	-- Set a default value for `glue`.
	if not glue then glue = "," end
	
	local arrayString = ""
	
	-- Iterate through each value in the array and concatenate them to the string
	for index, value in pairs(array) do
		arrayString = arrayString .. tostring(value)

		-- If this is not the last index in the array
		if index ~= #array then
			arrayString = arrayString .. glue
		end
	end
	
	return arrayString
end

--- Returns a boolean indicating whether or not the table is an array.
--- An array is defined as a table containing positive integer indexes.
---
--- @param array table The table to evaluate.
--- @return boolean isArray Whether or not the table is an array.
function Table.IsArray(array)
	-- Return false if the table is nil
	if typeof(array) ~= "table" then
		return false
	end

	-- Make sure the table is not empty
	if next(array) == nil then
		return false
	end

	-- Make sure that all keys are positive integers
	for key, value in pairs(array) do
		if typeof(key) ~= "number" or key % 1 ~= 0 or key < 1 then
			return false
		end
	end

	return true
end

--- Returns a boolean indicating whether or not the table is a dictionary.
--- A dictionary is defined as a table containing keys that are not positive integers.
---
--- @param array table The table to evaluate.
--- @return boolean isDictionary Whether or not the table is a dictionary.
function Table.IsDictionary(array)
	return typeof(array) == "table" and not Table.IsEmpty(array) and not Table.IsArray(array)
end

--- Returns a boolean indicating whether or not the table is empty.
---
--- @param array table The table to evaluate.
--- @return boolean isEmpty Whether or not the table is empty.
function Table.IsEmpty(array)
	return type(array) == "table" and next(array) == nil
end

--- Returns the number of elements that exist within a table. Works on all tables, including dictionaries.
---
--- @param array table The table whose length to return.
--- @return number length The number of elements that exist within a table.
function Table.Length(array)
	return #Table.Values(array)
end

--- Returns a mapped version of a table based on the values returned by `callback` for each element in the array.
---
--- The callback will be passed `value`, and `key` from the key/value pairs within the table.
---
--- @param array table The table to map.
--- @param callback function The callback function that determines the mapped value of table elements.
--- @return table results A table containing the mapped table elements.
function Table.Map(array, callback)
	local results = {}

	-- Iterate through the array and set each key/value pair to the result of calling `callback()` on them
	for key, value in pairs(array) do
		results[key] = callback(value, key)
	end

	return results
end

--[[
	Getters
--]]

--- Returns a deep copy of the table.
---
--- @param array table The table to deep copy.
--- @return table copy A deep copy of the origin table.
function Table.Clone(array)
	-- Create a new array with memory allocated for the size we know it will be
	local result = Table.Create(#array)

	-- Iterate through each value of the original array and add them to the new array
	for key, value in pairs(array) do
		-- If the value is a table, call `Table.clone()` on that as well, to make it a deep copy.
		if type(value) == "table" then
			value = Table.Clone(value)
		end

		result[key] = value
	end

	return result
end

--- Collapses a table consisting of multiple tables into a single table.
---
--- @param array table The table to collapse.
--- @return table
function Table.Collapse(array)
	return Table.Merge(unpack(array))
end

--- Divides a table into two arrays: one containing the keys, one containing the values.
---
--- @param array table The table whose keys and values should be returned as separate arrays.
--- @return table keys An array containing the table's keys.
--- @return table values An array containing the table's values.
function Table.Divide(array)
	return Table.Keys(array), Table.Values(array)
end

--- Returns a boolean indicating whether or not the array has the requested key.
---
--- @param array table The table to search.
--- @param key any The key to search for within the array.
--- @return boolean
function Table.Has(array, key)
	return array[key] ~= nil
end

--- Returns a boolean indicating whether or not the array has any of the requested keys.
---
--- @param array table The table whose keys to evaluate.
--- @param keys table An array of keys to search for within the table.
--- @return boolean
function Table.HasAny(array, keys)
	for index, value in ipairs(keys) do
		if Table.Has(array, value) then
			return true
		end
	end
end

--- Returns all of the keys within a table.
---
--- @param array table The table whose keys to return.
--- @return table
function Table.Keys(array)
	local keys = {}

	for key in pairs(array) do
		table.insert(keys, key)
	end

	return keys
end

--- Merges the elements one or more tables together. Number indexes will be appended to the new array, receiving a new index.
--- Non-number indexes will be retained, and will overwritten by values from later tables with the same property.
---
--- Accepts a list of tables as arguments.
---
--- @return table
function Table.Merge(...)
	local arguments = {...}
	local results = {}
	
	for tableIndex, array in pairs(arguments) do
		for key, value in pairs(array) do
			if typeof(key) == "number" then
				table.insert(results, value)
			else
				results[key] = value
			end
		end
	end

	return results
end

--- Returns a random value from the table. Also returns the selected key.
---
--- @param array table The table from which to select a random value.
--- @return any value A random value from the table.
--- @return any key The randomly selected key from the table.
function Table.Random(array)
	local keys = Table.Keys(array)
	
	local randomGenerator = Random.new()
	local randomKey = keys[randomGenerator:NextInteger(1, #keys)]
	return array[randomKey], randomKey
end

--- Returns a reversed version of `array`.
---
--- @param array table The table to reverse.
--- @return table
function Table.Reverse(array)
	local result = table.create(#array)
	local reverseIterator = #array

	for iterator = 1, #array do
		result[reverseIterator] = array[iterator]
		reverseIterator = reverseIterator - 1
	end

	return result
end

--- Returns a shuffled copy of `array`.
---
--- @param array table The table to shuffle.
--- @return table result The shuffled table.
function Table.Shuffle(array)
	local result = Table.Clone(array)

	for i = #result, 2, -1 do
		local randomGenerator = Random.new()
		local randomIndex = math.random(randomGenerator:NextInteger(1, i))
		result[i], result[randomIndex] = result[randomIndex], result[i]
	end

	return result
end

--- Returns all of the values within a table.
---
--- @param array table The table whose values to return.
--- @return table
function Table.Values(array)
	local values = {}

	for key, value in pairs(array) do
		table.insert(values, value)
	end

	return values
end

--[[
	Mutators
	--
	These methods alter the original table.
--]]

--- Adds a property to a table if it does not already exist.
---
--- @param array table The table to alter.
--- @param key any The key to assign to.
--- @param value any The value to assign to array[key]
--- @return table
function Table.Add(array, key, value)
	if not array[key] then
		array[key] = value
	end

	return array
end

--- Returns the value of `key` in `array` and removes it from `array`.
--- @param array table The table to pull from.
--- @param key any The key to pull from the table.
--- @return any value The value pulled from `array[key]`
function Table.Pull(array, key)
	local value = array[key]
	array[key] = nil
	return value
end

--[[
	Filters
	--
	These methods return filtered tables without impacting the original table.
--]]

--- Returns a filtered version of `array` ommitting the blacklisted properties.
---
--- @param array table The table.
--- @param blacklist table An array of keys to omit from the results.
--- @return table results The table without blacklisted properties.
function Table.Except(array, blacklist)
	local results = Table.Clone(array)

	for index, value in ipairs(blacklist) do
		results[value] = nil
	end

	return results
end

--- Returns a filtered version of a table containing elements for which `callback` returns a truthy value.
---
--- The callback will be passed `value`, and `key` from the key/value pairs within the table.
---
--- @param array table The table to filter.
--- @param callback function A callback function that determines whether or not an element should be filtered.
--- @return table results A table containing the filtered table elements.
function Table.Filter(array, callback)
	local results = {}

	for key, value in pairs(array) do
		if callback(value, key) then
			results[key] = value
		end
	end

	return results
end

--- Returns the first value in the table for which `callback` returns `true`.
--- @param array table The table to evaluate.
--- @param callback function The callback.
--- @return any first The first value in the array for which `callback` returns `true`.
function Table.First(array, callback)
	for key, value in pairs(array) do
		if callback(value) then
			return value
		end
	end
end

--- Returns the last value in the table for which `callback` returns `true`.
--- @param array table The table to evaluate.
--- @param callback function The callback.
--- @return any first The last value in the array for which `callback` returns `true`.
function Table.Last(array, callback)
	return Table.First(Table.Reverse(array), callback)
end

--- Returns a table containing only the whitelisted keys from `array`.
---
--- @param array table The table to search.
--- @param whitelist table An array of keys from the original array to whitelist.
--- @return table results A table only containing whitelisted key/pair values from `array`.
function Table.Only(array, whitelist)
	local results = {}

	for index, arrayKey in ipairs(whitelist) do
		local arrayValue = array[arrayKey]
		if arrayValue then
			results[arrayKey] = arrayValue
		end
	end

	return results
end

--- Returns the values associated with the indexes between array[offset] and array[offset + length] in a new array.
---
--- @param array table The origin table.
--- @param offset number The array index to begin with.
--- @param length number The number of indexes that should be selected.
--- @return table
function Table.Slice(array, offset, length)
	local results = {}

	for index = offset or 1, length or #array do
		table.insert(results, array[index])
	end

	return results
end

--[[
	Wrapper Methods
	--
	These methods are simply wrappers over the standard `table` liibrary.
	
	While they are provided here in order to provide a consistent API for interacting with tables, it is usually
	adviseable to use the `table` library directly for better performance.
--]]

--- Returns a string resulting from concatenating all of the values within this array.
--- Only works on arrays. Use `Table.implode()` for support for dictionaries as well.
---
--- @param array table The table to concatenate.
--- @param separator string? The string to concatenate between array elements.
--- @param beginIndex number The first element in the table to concatenate.
--- @param lastIndex number The last element in the table to concatenate.
--- @return string
function Table.Concat(array, separator, beginIndex, lastIndex)
	return table.concat(array, separator, beginIndex, lastIndex)
end

--- Creates an array sized for `count` elements. Populated by `value` if set.
---
--- @param count number The number of elements to size the array for.
--- @param value any The value to optionally populate the array with `count` times.
--- @return table
function Table.Create(count, value)
	return table.create(count, value)
end

--- Returns the key of the first occurence of `needle` in the array `haystack` after `haystack[init]`.
---
--- @param haystack table The table to search.
--- @param needle any The value to search for.
--- @param beginIndex number The index to begin searching at.
--- @return any
function Table.Find(haystack, needle, beginIndex)
	return table.find(haystack, needle, beginIndex)
end

--- Iterates through the provided table, calling `callback()` and passing the key/value for each element as arguments.
---
--- @param array table The table to iterate through.
--- @param callback function The function to call for each iteration.
function Table.ForEach(array, callback)
	return table.foreach(array, callback)
end

--- Iterates through the provided array, calling `callback()` and passing the index/value for each element as arguments.
--- Basically the same as `Table.foreach()` except uses `ipairs()` instead of `pairs()` for the iteration.
---
--- @param array table The table to iterate through.
--- @param callback function The function to call for each iteration.
function Table.ForEachIPairs(array, callback)
	return table.foreachi(array, callback)
end

--- Returns the number of elements in the array passed. Will not work for dictionary tables, use `Table.length()` for that instead.
---
--- @param array table The table whose length to return.
--- @return number
function Table.GetN(array)
	return table.getn(array)
end

--- Appends `value` to `pos` or, if `pos` is empty, to the end of the array.
--- @param array table The table to append to.
--- @param pos number The position to append to. Defaults to `#array + 1`.
--- @param value any The value to append to the array.
function Table.Insert(array, pos, value)
	return table.insert(array, pos, value)
end

--- Moves elements from one table to another.
---
--- @param arrayOne table The first table.
--- @param firstIndex number The first index in `a1` to move elements from.
--- @param lastIndex number The last index in `a2` to move elements from.
--- @param insertIndex number The index to begin inserting elements from `a1` into `a2` at.
--- @param arrayTwo table The second table. Defaults to `a1`.
--- @return table
function Table.Move(arrayOne, firstIndex, lastIndex, insertIndex, arrayTwo)
	return table.move(arrayOne, firstIndex, lastIndex, insertIndex, arrayTwo)
end

--- Returns a new table with each argument as an element inside an array.
function Table.Pack(...)
	return table.pack(...)
end

--- Removes and returns an element from an array at the specified position.
---
--- @param array table The table to remove from.
--- @param pos number The position of the element to remove.
function Table.Remove(array, pos)
	return table.remove(array, pos)
end

--- Sorts elements in a table based on the return values of the callback.
---
--- The callback should return `true` when the first argument should come before
--- the second argument in the sorted table.
---
--- If a callback is not provided, the Lua operator `<` is used to compare elements.
---
--- @param array table The table to sort.
--- @param callback function The callback used to determine the sorting order.
function Table.Sort(array, callback)
	return table.sort(array, callback)
end

--- Returns the selected elements from the table `list`.
---
--- @param array table The table whose elements to return.
--- @param beginIndex number The starting index.
--- @param finalIndex number The final index to return.
--- @return Tuple
function Table.Unpack(array, beginIndex, finalIndex)
	return table.unpack(array, beginIndex, finalIndex)
end

--[[
	Module
--]]

return Table
