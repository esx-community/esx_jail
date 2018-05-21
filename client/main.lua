local IsJailed = false
local unjail = false
local JailTime = 0
local JailLocation = Config.JailLocation
ESX = nil

--ESX base
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_jailer:jail')
AddEventHandler('esx_jailer:jail', function(jailTime)
	if IsJailed then -- don't allow multiple jails
		return
	end

	JailTime = jailTime
	local sourcePed = GetPlayerPed(-1)
	if DoesEntityExist(sourcePed) then
		Citizen.CreateThread(function()
		
			-- Assign jail skin to user
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].female)
				end
			end)
			
			-- Clear player
			SetPedArmour(sourcePed, 0)
			ClearPedBloodDamage(sourcePed)
			ResetPedVisibleDamage(sourcePed)
			ClearPedLastWeaponDamage(sourcePed)
			ResetPedMovementClipset(sourcePed, 0)
			
			SetEntityCoords(sourcePed, JailLocation.x, JailLocation.y, JailLocation.z)
			IsJailed = true
			unjail = false
			while JailTime > 0 and not unjail do
				sourcePed = GetPlayerPed(-1)
				RemoveAllPedWeapons(sourcePed, true)
				if IsPedInAnyVehicle(sourcePed, false) then
					ClearPedTasksImmediately(sourcePed)
				end

				if JailTime % 120 == 0 then
					TriggerServerEvent('esx_jailer:updateRemaining', JailTime)
				end

				Citizen.Wait(20000)

				-- Is the player trying to escape?
				if GetDistanceBetweenCoords(GetEntityCoords(sourcePed), JailLocation.x, JailLocation.y, JailLocation.z) > 10.0001 then
					SetEntityCoords(sourcePed, JailLocation.x, JailLocation.y, JailLocation.z)
					TriggerEvent('chatMessage', _U('judge'), { 147, 196, 109 }, _U('escape_attempt'))
				end
				
				JailTime = JailTime - 20
			end

			-- jail time served
			TriggerServerEvent('esx_jailer:unjailTime', -1)
			SetEntityCoords(sourcePed, Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
			IsJailed = false

			-- Change back the user skin
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end)
	end
end)

Citizen.CreateThread(function()
	local fastTimer = 0
	while true do
		Citizen.Wait(1)

		if JailTime > 0 then
			if fastTimer == 0 then
				fastTimer = JailTime
			end

			draw2dText(_U('remaining_msg', round(fastTimer)), { 0.175, 0.955 } )
			fastTimer = fastTimer - 0.01
		else
			Citizen.Wait(5000)
		end
	end
end)

RegisterNetEvent('esx_jailer:unjail')
AddEventHandler('esx_jailer:unjail', function(source)
	unjail = true
end)

-- When player respawns / joins
AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent('esx_jailer:checkJail')
end)

-- When script starts
Citizen.CreateThread(function()
	Citizen.Wait(2000) -- wait for mysql-async to be ready, this should be enough time
	TriggerServerEvent('esx_jailer:checkJail')
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
	SetBlipSprite(blip, 237)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 1.5)
	SetBlipColour(blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(_U('blip_name'))
	EndTextCommandSetBlipName(blip)
end)

function draw2dText(text, coords)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(table.unpack(coords))
end

function round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end