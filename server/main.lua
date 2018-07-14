ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- jail command
TriggerEvent('es:addGroupCommand', 'jail', 'admin', function(source, args, user)
	if args[1] and GetPlayerName(args[1]) ~= nil and tonumber(args[2]) then
		TriggerEvent('esx_jailer:sendToJail', tonumber(args[1]), tonumber(args[2] * 60))
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID or jail time!' } } )
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Put a player in jail", params = {{name = "id", help = "target id"}, {name = "time", help = "jail time in minutes"}}})

-- unjail
TriggerEvent('es:addGroupCommand', 'unjail', 'admin', function(source, args, user)
	if args[1] then
		if GetPlayerName(args[1]) ~= nil then
			TriggerEvent('esx_jailer:unjailQuest', tonumber(args[1]))
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID!' } } )
		end
	else
		TriggerEvent('esx_jailer:unjailQuest', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Unjail people from jail", params = {{name = "id", help = "target id"}}})

-- send to jail and register in database
RegisterServerEvent('esx_jailer:sendToJail')
AddEventHandler('esx_jailer:sendToJail', function(target, jailTime)
	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier=@id', {['@id'] = identifier}, function(result)
		if result[1] ~= nil then
			MySQL.Async.execute("UPDATE jail SET jail_time=@jt WHERE identifier=@id", {['@id'] = identifier, ['@jt'] = jailTime})
		else
			MySQL.Async.execute("INSERT INTO jail (identifier,jail_time) VALUES (@identifier,@jail_time)", {['@identifier'] = identifier, ['@jail_time'] = jailTime})
		end
	end)
	
	TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('jailed_msg', GetPlayerName(target), ESX.Round(jailTime / 60)) }, color = { 147, 196, 109 } })
	TriggerClientEvent('esx_policejob:unrestrain', target)
	TriggerClientEvent('esx_jailer:jail', target, jailTime)
end)

-- should the player be in jail?
RegisterServerEvent('esx_jailer:checkJail')
AddEventHandler('esx_jailer:checkJail', function()
	local player = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(player)[1] -- get steam identifier
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier=@id', {['@id'] = identifier}, function(result)
		if result[1] ~= nil then
			TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('jailed_msg', GetPlayerName(player), ESX.Round(result[1].jail_time / 60)) }, color = { 147, 196, 109 } })
			TriggerClientEvent('esx_jailer:jail', player, tonumber(result[1].jail_time))
		end
	end)
end)

-- unjail via command
RegisterServerEvent('esx_jailer:unjailQuest')
AddEventHandler('esx_jailer:unjailQuest', function(source)
	if source ~= nil then
		unjail(source)
	end
end)

-- unjail after time served
RegisterServerEvent('esx_jailer:unjailTime')
AddEventHandler('esx_jailer:unjailTime', function()
	unjail(source)
end)

-- keep jailtime updated
RegisterServerEvent('esx_jailer:updateRemaining')
AddEventHandler('esx_jailer:updateRemaining', function(jailTime)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier=@id', {['@id'] = identifier}, function(result)
		if result[1] ~= nil then
			MySQL.Async.execute("UPDATE jail SET jail_time=@jt WHERE identifier=@id", {['@id'] = identifier, ['@jt'] = jailTime})
		end
	end)
end)

function unjail(target)
	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier=@id', {['@id'] = identifier}, function(result)
		if result[1] ~= nil then
			MySQL.Async.execute('DELETE from jail WHERE identifier = @id', {['@id'] = identifier})
			TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('unjailed', GetPlayerName(target)) }, color = { 147, 196, 109 } })
		end
	end)

	TriggerClientEvent('esx_jailer:unjail', target)
end
