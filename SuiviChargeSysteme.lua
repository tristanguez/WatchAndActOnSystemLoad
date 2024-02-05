-- Suivi de charge systeme
--

--
--Utilities
--
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
			print(key .. "=" .. value)
		end
	end

	return couples
end

--
--
-- Main
--
--

local inits = ini_read(arg[0]:gsub("%.lua$", ".ini"))

local loadavg_filename = inits["LoadAVG"] == nil and "/proc/loadavg" or inits["LoadAVG"]
local file = io.open(loadavg_filename, "r")

if file == nil then
	print("Impossible d'ouvrir le fichier !")
else
	local premiere_ligne = file:read()

	-- print(premiere_ligne)

	file:close()

	local index = 1
	local tableau_resultat = {}

	for field in premiere_ligne:gmatch("%S+") do
		-- print(field)
		tableau_resultat[index] = field
		-- print(tableau_resultat[index])
		index = index + 1
	end

	print("Troisieme champ : " .. tableau_resultat[3])
end
