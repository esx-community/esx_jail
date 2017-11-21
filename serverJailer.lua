ESX 				= nil
local defaultsecs   = 300
local maxsecs 		= 1000

-----------------------------

--ESX base
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local xPlayers 		= ESX.GetPlayers()

AddEventHandler('chatMessage', function(source, n, message)
	cm = stringsplit(message, " ")
	local xPlayer 		= ESX.GetPlayerFromId(source)
		
		if cm[1] == "/unjail" then
			if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
				CancelEvent()
				local tPID = tonumber(cm[2])
				if GetPlayerName(tPID) ~= nil then
					print("relaché ".. GetPlayerName(tPID).. " par ".. GetPlayerName(source))
					TriggerClientEvent("UnJP", tPID)
				end
			else
				TriggerClientEvent('chatMessage', -1, 'SYSTEM', { 0, 0, 0 }, "Tu n'as pas le droit de mettre des personnes en prison !")
			end
		elseif cm[1] == "/jail1" then
			if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
				CancelEvent()
				local tPID = tonumber(cm[2])
				local jT = defaultsecs
					if cm[3] ~= nil then
						jT = tonumber(cm[3])				
					end
				if jT > maxsecs then
					jT = maxsecs
				end
				if GetPlayerName(tPID) ~= nil then
					print("Mettre en prison ".. GetPlayerName(tPID).. " pour ".. jT .." secs - commande entrée par ".. GetPlayerName(source))
					TriggerClientEvent("JP1", tPID, jT)
					TriggerClientEvent('chatMessage', -1, 'JUGE', { 0, 0, 0 }, GetPlayerName(tPID) ..' est en prison 1 pour '.. jT ..' secs')
				end
			else
				TriggerClientEvent('chatMessage', -1, 'SYSTEM', { 0, 0, 0 }, "Tu n'as pas le droit de mettre des personnes en prison !")
			end
		elseif cm[1] == "/jail2" then
			if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
				CancelEvent()
				local tPID = tonumber(cm[2])
				local jT = defaultsecs
					if cm[3] ~= nil then
						jT = tonumber(cm[3])				
					end
				if jT > maxsecs then
					jT = maxsecs
				end
				if GetPlayerName(tPID) ~= nil then
					print("Mettre en prison ".. GetPlayerName(tPID).. " pour ".. jT .." secs - commande entrée par ".. GetPlayerName(source))
					TriggerClientEvent("JP2", tPID, jT)
					TriggerClientEvent('chatMessage', -1, 'JUGE', { 0, 0, 0 }, GetPlayerName(tPID) ..' est en prison 2 pour '.. jT ..' secs')
				end
			else
				TriggerClientEvent('chatMessage', -1, 'SYSTEM', { 0, 0, 0 }, "Tu n'as pas le droit de mettre des personnes en prison !")
			end
		elseif cm[1] == "/jail3" then
			if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' then
				CancelEvent()
				local tPID = tonumber(cm[2])
				local jT = defaultsecs
					if cm[3] ~= nil then
						jT = tonumber(cm[3])				
					end
				if jT > maxsecs then
					jT = maxsecs
				end
				if GetPlayerName(tPID) ~= nil then
					print("Mettre en prison ".. GetPlayerName(tPID).. " pour ".. jT .." secs - commande entrée par ".. GetPlayerName(source))
					TriggerClientEvent("JP3", tPID, jT)
					TriggerClientEvent('chatMessage', -1, 'JUGE', { 0, 0, 0 }, GetPlayerName(tPID) ..' est en prison 3 pour '.. jT ..' secs')
				end
			else
				TriggerClientEvent('chatMessage', -1, 'SYSTEM', { 0, 0, 0 }, "Tu n'as pas le droit de mettre des personnes en prison !")
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