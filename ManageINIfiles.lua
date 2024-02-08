---
-- Utilities
---

local ManageINIfiles = {}

local couples = {}

local initialized = false

function ManageINIfiles.ini_read(FileName)
	local inifile = io.open(FileName, "r")

	print("-- Begin reading " .. FileName .. " file --")
	if inifile == nil then
		return {}
	end

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

	print("-- End reading " .. FileName .. " file --")

	return couples
end

function ManageINIfiles.init_module()
	couples = ManageINIfiles.ini_read(arg[0]:gsub("%.lua$", ".ini")) -- Read ini file

	initialized = true

	return couples
end

---
-- Load a key with a default value, if not available
---
function ManageINIfiles.LoadWithDefVal(key, defval)
	if initialized == false then
		error("Module not initialized, please insert a call to init_module() at the appropriate place of your code")
		return nil
	end

	return couples[key] == nil and defval or couples[key]
end

return ManageINIfiles
