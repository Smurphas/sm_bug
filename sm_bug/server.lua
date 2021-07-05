webhookURL = '' -- insert the webhookURL
displayIdentifiers = true;

-------
function GetPlayers()
    local players = {}

    for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

RegisterCommand("bug", function(source, args, rawCommand)
    sm = stringsplit(rawCommand, " ");
    if #args < 2 then
    	TriggerClientEvent('chatMessage', source, "False usage: /bug <id> <bug>.")
    	return;
    end
    id = sm[2]
    if GetPlayerIdentifiers(id)[1] == nil then
    	TriggerClientEvent('chatMessage', source, "False usage: entered ID is not online")
    	return;
    end
	msg = ""
	local message = ""
	msg = msg .. " ^5(^5" .. GetPlayerName(source) .. "^5) ^5[^5" .. id .. "^5] "
	for i = 3, #sm do
		msg = msg .. sm[i] .. " "
		message = message .. sm[i] .. " "
	end

	if tonumber(id) ~= nil then
		-- Pranesimas
		TriggerClientEvent("Reports:CheckPermission:Client", -1, msg, false)
		TriggerClientEvent('chatMessage', source, "Sucscess: the bug has been sent to admins, thank you.")
		if not displayIdentifiers then 
			sendToDisc("New Bug: _[" .. tostring(id) .. "] " .. GetPlayerName(id) .. "_", 'Bug: **' .. message ..
				'**', "Bug reporter: [" .. source .. "] " .. GetPlayerName(source))
		else 
			-- Kas pranese apie buga 
			local ids = ExtractIdentifiers(id);
			local steam = ids.steam:gsub("Steamas:", "");
			local steamDec = tostring(tonumber(steam,16));
			steam = "https://steamcommunity.com/profiles/" .. steamDec;
			local gameLicense = ids.license;
			local discord = ids.discord;
			sendToDisc("New Bug: _[" .. tostring(id) .. "] " .. GetPlayerName(id) .. "_", 
				'Bug: **' .. message ..
				'**\n' ..
				'Steam: **' .. steam .. '**\n' ..
				'License: **' .. gameLicense .. '**\n' ..
				'Discord: **<@' .. discord:gsub('discord:', '') .. '>**\n' ..
				'Discord ID: **' .. discord:gsub('discord:', '') .. '**', "Bug reporter: [" .. source .. "] " .. GetPlayerName(source))
		end 

	else

		TriggerClientEvent('chatMessage', source, "False usage: /bug <id> <bug>.")
	end
end)

function sendToDisc(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = 16711680,
			["title"] = "**".. title .."**",
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	-- Startas
	PerformHttpRequest(webhookURL, 
	function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  -- Pabaiga
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

hasPermission = {}
doesNotHavePermission = {}

RegisterNetEvent("Reports:CheckPermission")
AddEventHandler("Reports:CheckPermission", function(msg, error)
	local src = source
	if IsPlayerAceAllowed(src, "BadgerReports.See") then 
		TriggerClientEvent('chatMessage', src, "^1[^1BUG^1] ^5" .. msg)
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end