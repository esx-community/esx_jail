ESX = nil

--ESX base
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- jail command, obsolete
TriggerEvent('es:addGroupCommand', 'jail', 'admin', function(source, args, user)
	TriggerEvent('esx_jailer:sendToJail', tonumber(args[1]), tonumber(args[2] * 60))
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = "Put a player in jail", params = {{name = "id", help = "target id"}, {name = "time", help = "jail time in seconds"}}})

-- unjail
TriggerEvent('es:addGroupCommand', 'unjail', 'admin', function(source, args, user)
	TriggerEvent('esx_jailer:unjailQuest', tonumber(args[1]))
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = "Unjail people from jail", params = {{name = "id", help = "target id"}}})

-- send to jail and register in database
RegisterServerEvent('esx_jailer:sendToJail')
AddEventHandler('esx_jailer:sendToJail', function(source, jailTime)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier=@id', {['@id'] = identifier}, function(gotInfo)
		if gotInfo[1] ~= nil then
			MySQL.Sync.execute("UPDATE jail SET jail_time=@jt WHERE identifier=@id", {['@id'] = identifier, ['@jt'] = jailTime})
		else
			MySQL.Async.execute("INSERT INTO jail (identifier,jail_time) VALUES (@identifier,@jail_time)", {['@identifier'] = identifier, ['@jail_time'] = jailTime})
		end
	end)
	
	TriggerClientEvent('chatMessage', -1, _U('judge'), { 147, 196, 109 }, GetPlayerName(source) .. _U('jailed_msg1') .. round(jailTime / 60) .. _U('jailed_msg2'))
	TriggerClientEvent('esx_jailer:jail', source, jailTime)
end)

-- should the player be in jail?
RegisterServerEvent('esx_jailer:checkjail')
AddEventHandler('esx_jailer:checkjail', function()
	local player = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(player)[1] -- get steam identifier
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier=@id', {['@id'] = identifier}, function(gotInfo)
		if gotInfo[1] ~= nil then
			TriggerClientEvent('chatMessage', -1, _U('judge'), { 147, 196, 109 }, GetPlayerName(player) .. _U('jailed_msg1') .. round(gotInfo[1].jail_time / 60) .. _U('jailed_msg2'))
			TriggerClientEvent('esx_jailer:jail', player, tonumber(gotInfo[1].jail_time))
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
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier=@id', {['@id'] = identifier}, function(gotInfo)
		if gotInfo[1] ~= nil then
			MySQL.Sync.execute("UPDATE jail SET jail_time=@jt WHERE identifier=@id", {['@id'] = identifier, ['@jt'] = jailTime})
		end
	end)
end)

function unjail(target)
	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier=@id', {['@id'] = identifier}, function(gotInfo)
		if gotInfo[1] ~= nil then
			MySQL.Async.execute('DELETE from jail WHERE identifier = @id', {['@id'] = identifier})
			TriggerClientEvent('chatMessage', -1, _U('judge'), { 147, 196, 109 }, GetPlayerName(target) .. _U('unjailed'))
		end
	end)
	TriggerClientEvent('esx_jailer:unjail', target)
end

function round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end
