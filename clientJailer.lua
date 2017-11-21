local cJ = false
local eJE = false


--ESX base

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("JP1")
AddEventHandler("JP1", function(jT)
	if cJ == true then
		return
	end
	local pP = GetPlayerPed(-1)
	if DoesEntityExist(pP) then
		
		Citizen.CreateThread(function()
			local playerOldLoc = GetEntityCoords(pP, true)
			SetEntityCoords(pP, 459.5500793457, -994.46508789063, 23.914855957031)--{x = 459.5500793457,y = -994.46508789063,z = 23.914855957031 },
			cJ = true
			eJE = false
			while jT > 0 and not eJE do
				pP = GetPlayerPed(-1)
				-- RemoveAllPedWeapons(pP, true)
				SetEntityInvincible(pP, true)
				if IsPedInAnyVehicle(pP, false) then
					ClearPedTasksImmediately(pP)
				end
				if jT % 30 == 0 then
					TriggerEvent('chatMessage', 'SYSTEM', { 0, 0, 0 }, jT .." secondes avant d'être libéré.")
				end
				Citizen.Wait(500)
				local pL = GetEntityCoords(pP, true)
				local D = Vdist(459.5500793457, -994.46508789063, 23.914855957031, pL['x'], pL['y'], pL['z'])
				if D > 2 then -- distance#######################################################################################
					SetEntityCoords(pP, 459.5500793457, -994.46508789063, 23.914855957031)
					if D > 4 then
						jT = jT + 60
						if jT > 1500 then
							jT = 1500
						end
						TriggerEvent('chatMessage', 'JUDGE', { 0, 0, 0 }, "Ton temps de prison a été prologé.")
					end
				end
				jT = jT - 0.5
			end
			TriggerServerEvent('chatMessageEntered', "SYSTEM", { 0, 0, 0 }, GetPlayerName(PlayerId()) .." a été libéré de la prison.")
			SetEntityCoords(pP, 432.95864868164, -981.41455078125, 29.710334777832)--{x = 432.95864868164,y = -981.41455078125,z = 29.710334777832 },
			cJ = false
			SetEntityInvincible(pP, false)
		end)
	end
end)

RegisterNetEvent("JP2")
AddEventHandler("JP2", function(jT)
	if cJ == true then
		return
	end
	local pP = GetPlayerPed(-1)
	if DoesEntityExist(pP) then
		
		Citizen.CreateThread(function()
			local playerOldLoc = GetEntityCoords(pP, true)
			SetEntityCoords(pP, 458.41693115234, -997.93572998047, 23.914854049683)-- {x = 458.41693115234,y = -997.93572998047,z = 23.914854049683 },
			cJ = true
			eJE = false
			while jT > 0 and not eJE do
				pP = GetPlayerPed(-1)
				-- RemoveAllPedWeapons(pP, true)
				SetEntityInvincible(pP, true)
				if IsPedInAnyVehicle(pP, false) then
					ClearPedTasksImmediately(pP)
				end
				if jT % 30 == 0 then
					TriggerEvent('chatMessage', 'SYSTEM', { 0, 0, 0 }, jT .." secondes avant d'être libéré.")
				end
				Citizen.Wait(500)
				local pL = GetEntityCoords(pP, true)
				local D = Vdist(458.41693115234, -997.93572998047, 23.914854049683, pL['x'], pL['y'], pL['z'])
				if D > 2 then
					SetEntityCoords(pP, 458.41693115234, -997.93572998047, 23.914854049683)
					if D > 4 then
						jT = jT + 60
						if jT > 1500 then
							jT = 1500
						end
						TriggerEvent('chatMessage', 'JUDGE', { 0, 0, 0 }, "Ton temps de prison a été prologé.")
					end
				end
				jT = jT - 0.5
			end
			TriggerServerEvent('chatMessageEntered', "SYSTEM", { 0, 0, 0 }, GetPlayerName(PlayerId()) .." a été libéré de la prison.")
			SetEntityCoords(pP, 432.95864868164, -981.41455078125, 29.710334777832)
			cJ = false
			SetEntityInvincible(pP, false)
		end)
	end
end)

RegisterNetEvent("JP3")
AddEventHandler("JP3", function(jT)
	if cJ == true then
		return
	end
	local pP = GetPlayerPed(-1)
	if DoesEntityExist(pP) then
		
		Citizen.CreateThread(function()
			local playerOldLoc = GetEntityCoords(pP, true)
			SetEntityCoords(pP, 458.29275512695, -1001.5576782227, 23.914852142334)-- {x = 458.29275512695,y = -1001.5576782227,z = 23.914852142334 },
			cJ = true
			eJE = false
			while jT > 0 and not eJE do
				pP = GetPlayerPed(-1)
				-- RemoveAllPedWeapons(pP, true)
				SetEntityInvincible(pP, true)
				if IsPedInAnyVehicle(pP, false) then
					ClearPedTasksImmediately(pP)
				end
				if jT % 30 == 0 then
					TriggerEvent('chatMessage', 'SYSTEM', { 0, 0, 0 }, jT .." secondes avant d'être libéré.")
				end
				Citizen.Wait(500)
				local pL = GetEntityCoords(pP, true)
				local D = Vdist(458.29275512695, -1001.5576782227, 23.914852142334, pL['x'], pL['y'], pL['z'])
				if D > 2 then
					SetEntityCoords(pP, 458.29275512695, -1001.5576782227, 23.914852142334)
					if D > 4 then
						jT = jT + 60
						if jT > 1500 then
							jT = 1500
						end
						TriggerEvent('chatMessage', 'JUDGE', { 0, 0, 0 }, "Ton temps de prison a été prologé.")
					end
				end
				jT = jT - 0.5
			end
			TriggerServerEvent('chatMessageEntered', "SYSTEM", { 0, 0, 0 }, GetPlayerName(PlayerId()) .." a été libéré de la prison.")
			SetEntityCoords(pP, 432.95864868164, -981.41455078125, 29.710334777832)
			cJ = false
			SetEntityInvincible(pP, false)
		end)
	end
end)

RegisterNetEvent("UnJP")
AddEventHandler("UnJP", function()
	eJE = true
end)
