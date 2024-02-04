-- Suivi de charge systeme
--
local file = io.open("/proc/loadavg", "r")

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
