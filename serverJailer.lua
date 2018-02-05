ESX 				= nil
local defaultsecs   = 300

--ESX base
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local xPlayers 		= ESX.GetPlayers()

AddEventHandler('chatMessage', function(source, n, message)
	cm = stringsplit(message, " ")
	local xPlayer = ESX.GetPlayerFromId(source)
		if cm[1] == "/unjail" then
			if xPlayer.job.name == 'police' then
				CancelEvent()
				local targetPID = tonumber(cm[2])
				if GetPlayerName(targetPID) ~= nil then
					print("Befriade ".. GetPlayerName(targetPID).. " under ".. GetPlayerName(source) .. "s befäl")
					TriggerClientEvent("esx_jailer:unjail", targetPID)
				end
			else
				TriggerClientEvent('chatMessage', -1, 'SYSTEM', { 0, 0, 0 }, "Du har inte rätt att sätta folk i fängelse!")
			end
		elseif cm[1] == "/jail" then
			if xPlayer.job.name == 'police' then
				CancelEvent()
				local targetPID = tonumber(cm[2])
				local jailTime = defaultsecs
					if cm[3] ~= nil then
						jailTime = tonumber(cm[3])
					end
				if GetPlayerName(targetPID) ~= nil then
					print("Sätter ".. GetPlayerName(targetPID).. " i fängelse för ".. jailTime .." sekunder, av ".. GetPlayerName(source))
					TriggerClientEvent("esx_jailer:jail", targetPID, jailTime)
					TriggerClientEvent('chatMessage', -1, 'DOMARE', { 0, 0, 0 }, GetPlayerName(targetPID) ..' sitter nu i fängelse i '.. jailTime ..' sekunder')
				end
			else
				TriggerClientEvent('chatMessage', -1, 'SYSTEM', { 0, 0, 0 }, "Du har inte rätt att sätta folk i fängelse!")
			end
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

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end