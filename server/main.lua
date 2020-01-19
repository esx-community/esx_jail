ESX = nil
local playersInJail = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	MySQL.Async.fetchAll('SELECT jail_time FROM jail WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1] then
			TriggerEvent('esx_jail:sendToJail', xPlayer.source, result[1].jail_time, true)
		end
	end)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	playersInJail[playerId] = nil
end)

MySQL.ready(function()
	Citizen.Wait(2000)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers do
		Citizen.Wait(100)
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		MySQL.Async.fetchAll('SELECT jail_time FROM jail WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1] then
				TriggerEvent('esx_jail:sendToJail', xPlayer.source, result[1].jail_time, true)
			end
		end)
	end
end)

TriggerEvent('es:addGroupCommand', 'jail', 'admin', function(source, args, user)
	if args[1] and GetPlayerName(args[1]) then
		if args[2] and tonumber(args[2]) then
			TriggerEvent('esx_jail:sendToJail', tonumber(args[1]), tonumber(args[2] * 60))
		else
			TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Invalid jail time.'}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Player not online.'}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Insufficient Permissions.'}})
end, {help = 'Jail a player', params = {
	{name = 'playerId', help = 'player id'},
	{name = 'time', help = 'jail time in minutes'}
}})

TriggerEvent('es:addGroupCommand', 'unjail', 'admin', function(source, args, user)
	if args[1] and GetPlayerName(args[1]) then
		unjailPlayer(tonumber(args[1]))
	else
		TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Player not online.'}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Insufficient Permissions.'}})
end, {help = 'Unjail a player', params = {{name = 'playerId', help = 'player id'}}})

RegisterNetEvent('esx_jail:sendToJail')
AddEventHandler('esx_jail:sendToJail', function(playerId, jailTime, quiet)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		if not playersInJail[playerId] then
			xPlayer.triggerEvent('esx_policejob:unrestrain')
			xPlayer.triggerEvent('esx_jail:jailPlayer', jailTime)
			playersInJail[playerId] = jailTime

			if not quiet then
				TriggerClientEvent('chat:addMessage', -1, {args = {_U('judge'), _U('jailed_msg', xPlayer.getName(), ESX.Math.Round(jailTime / 60))}, color = {147, 196, 109}})
			end
		end
	end
end)

function unjailPlayer(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		if playersInJail[playerId] then
			MySQL.Async.fetchAll('SELECT 1 FROM jail WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(result)
				if result[1] then
					MySQL.Async.execute('DELETE FROM jail WHERE identifier = @identifier', {
						['@identifier'] = xPlayer.identifier
					})

					TriggerClientEvent('chat:addMessage', -1, {args = {_U('judge'), _U('unjailed', xPlayer.getName())}, color = {147, 196, 109}})
				end
			end)

			playersInJail[playerId] = nil
			xPlayer.triggerEvent('esx_jail:unjailPlayer')
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		for playerId,timeRemaining in pairs(playersInJail) do
			playersInJail[playerId] = timeRemaining - 1

			if timeRemaining < 1 then
				unjailPlayer(playerId, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.JailTimeSyncInterval)
		local tasks = {}

		for playerId,timeRemaining in pairs(playersInJail) do
			local task = function(cb)
				MySQL.Async.execute('UPDATE users SET jail_time = @time_remaining WHERE identifier = @identifier', {
					['@identifier'] = GetPlayerIdentifiers(playerId)[1],
					['@time_remaining'] = timeRemaining
				}, function(rowsChanged)
					cb(rowsChanged)
				end)
			end

			table.insert(tasks, task)
		end

		Async.parallelLimit(tasks, 4, function(results) end)
	end
end)
