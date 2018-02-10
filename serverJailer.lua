ESX = nil

--ESX base
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- jail command, obsolete
TriggerEvent('es:addGroupCommand', 'jail', 'admin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' then
		TriggerClientEvent("esx_jailer:jail", tonumber(args[1]), tonumber(args[2]))
		TriggerClientEvent('chatMessage', source, 'DOMARE', { 0, 0, 0 }, GetPlayerName(tonumber(args[1])) ..' sitter nu i fängelse för '.. round(tonumber(args[2]) / 60) ..' minuter')
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficient Permissions.")
	end

end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = "Put a player in jail", params = {{name = "id", help = "target id"}, {name = "time", help = "jail time in seconds"}}})

-- unjail
TriggerEvent('es:addGroupCommand', 'unjail', 'user', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' then
		TriggerClientEvent("esx_jailer:unjail", tonumber(args[1]))
		TriggerClientEvent('chatMessage', source, 'DOMARE', { 0, 0, 0 }, GetPlayerName(tonumber(args[1])) ..' har blitt befriad från fängelse')
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficient Permissions.")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = "Unjail people from jail", params = {{name = "id", help = "target id"}}})

function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

RegisterServerEvent('esx_jailer:sendToJail')
AddEventHandler('esx_jailer:sendToJail', function(source, jailTime)
  TriggerClientEvent('esx_jailer:jail', source, jailTime)
end)