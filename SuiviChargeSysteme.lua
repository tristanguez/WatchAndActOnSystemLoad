-- Suivi de charge systeme
--

---
-- Utilities
---
function ini_read(FileName)
	local inifile = io.open(FileName, "r")

	print("-- Begin reading ini file --")
	if inifile == nil then
		return {}
	end

	local couples = {}

	for line in inifile:lines() do
		 -- S: non-space s: space +: at least one *: 0 or more []: optional
		local key, value = line:match('([%S^=]+)=["]*(.*[^"])["]*')

		if key == nil then
			print("line skipped: " .. line)
		else
			if value == nil then
				value = ""
			end
			couples[key] = tonumber(value) or value
			print(key .. "=" .. couples[key])
		end
	end

	print("-- End reading ini file --")

	return couples
end

---
-- Watch the system load
---
function watch_load(loadavg_filename, FieldToWatch)
	local file = io.open(loadavg_filename, "r")

	if file == nil then
		print("Unable to open the file!")

		return nil
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

		return tonumber(resulting_table[FieldToWatch])
	end
end


local function LoadWithDefVal(inits, key, defval)
	return inits[key] == nil and defval or inits[key]
end

--
--
-- Main
--
--

local inits = ini_read(arg[0]:gsub("%.lua$", ".ini")) -- Read ini file

-- Gets the system load filename
local loadavg_filename = LoadWithDefVal(inits, "LoadAVG", "/proc/loadavg")
local FieldToWatch = LoadWithDefVal(inits, "FieldToWatch", 3)
local TriggerLevel = LoadWithDefVal(inits, "TriggerLevel", 0.00)
local ProgramToExecute = LoadWithDefVal(inits, "ProgramToExecute", "xeyes")
local SleepProg = LoadWithDefVal(inits, "SleepProg", "sleep 2")

print("loadavg_filename=" .. loadavg_filename)
print("FieldToWatch=" .. FieldToWatch)
print("TriggerLevel=" .. TriggerLevel)
print("ProgramToExecute=" .. ProgramToExecute)
print("SleepProg=" .. SleepProg)

repeat
	local currVal = watch_load(loadavg_filename, FieldToWatch)

	if currVal >= TriggerLevel then
		print("Alert level!")
		os.execute(ProgramToExecute)
	end
	os.execute(SleepProg)
until false
