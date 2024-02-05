-- Suivi de charge systeme
--

---
-- Utilities
---
function ini_read(FileName)
	local inifile = io.open(FileName, "r")

	if inifile == nil then
		return {}
	end

	local couples = {}

	for line in inifile:lines() do
		local key, value = line:match("(%S+)%s*=%s*(%S+)") -- S: non-space s: space +: at least one *: 0 or more

		if key then
			if value == nil then
				value = ""
			end
			couples[key] = tonumber(value) or value:gsub("\"", "")
			-- print(key .. "=" .. value)
		end
	end

	return couples
end

---
-- Watch the system load
---
function watch_load(loadavg_filename, FieldToWatch)
	local file = io.open(loadavg_filename, "r")

	if file == nil then
		print("Unable to open the file!")
	else
		local first_line = file:read()

		-- print(first_line)

		file:close()

		local index = 1
		local resulting_table = {}

		for field in first_line:gmatch("%S+") do
			-- print(field)
			resulting_table[index] = field
			-- print(resulting_table[index])
			index = index + 1
		end

		print(FieldToWatch .. "th field: " .. resulting_table[FieldToWatch])
	end
end


--
--
-- Main
--
--

local inits = ini_read(arg[0]:gsub("%.lua$", ".ini")) -- Read ini file

-- Gets the system load filename
local loadavg_filename = inits["LoadAVG"] == nil and "/proc/loadavg" or inits["LoadAVG"]
local FieldToWatch = inits["FieldToWatch"] == nil and 3 or inits["FieldToWatch"]

watch_load(loadavg_filename, FieldToWatch)
