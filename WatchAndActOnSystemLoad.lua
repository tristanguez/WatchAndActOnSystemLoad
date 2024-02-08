--
-- Watch System Load and Trigger an external program if a Threshold is reached
--
-- License SPDX-Licence-Identifier: LGPL-3.0-only or CeCill-C in France/Europe
-- SPDX-FileCopyrightText: 2024 Tristan Guez tristan.guez@gmail.com
--

---
-- Utilities
---
local ini = require("ManageINIfiles")

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

-- ----------------------------------
--
--		Main
--
-- ----------------------------------

ini.init_module()

-- Gets the system load filename
local loadavg_filename = ini.LoadWithDefVal("LoadAVG", "/proc/loadavg")
local FieldToWatch = ini.LoadWithDefVal("FieldToWatch", 3)
local TriggerLevel = ini.LoadWithDefVal("TriggerLevel", 0.00)
local ProgramToExecute = ini.LoadWithDefVal("ProgramToExecute", "xeyes")
local SleepProg = ini.LoadWithDefVal("SleepProg", "sleep 2")

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
