local IsJailed = false
local unjail = false
local JailTime = 0
local fastTimer = 0
local JailLocation = Config.JailLocation

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_jail:jail')
AddEventHandler('esx_jail:jail', function(jailTime)
	if IsJailed then -- don't allow multiple jails
		return
	end

	JailTime = jailTime
	local playerPed = PlayerPedId()
	if DoesEntityExist(playerPed) then
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
			SetPedArmour(playerPed, 0)
			ClearPedBloodDamage(playerPed)
			ResetPedVisibleDamage(playerPed)
			ClearPedLastWeaponDamage(playerPed)
			ResetPedMovementClipset(playerPed, 0)
			
			ESX.Game.Teleport(playerPed, JailLocation)
			IsJailed = true
			unjail = false
			while JailTime > 0 and not unjail do
				playerPed = PlayerPedId()

				RemoveAllPedWeapons(playerPed, true)
				if IsPedInAnyVehicle(playerPed, false) then
					ClearPedTasksImmediately(playerPed)
				end

				if JailTime % 120 == 0 then
					TriggerServerEvent('esx_jail:updateRemaining', JailTime)
				end

				Citizen.Wait(20000)

				-- Is the player trying to escape?
				if GetDistanceBetweenCoords(GetEntityCoords(playerPed), JailLocation.x, JailLocation.y, JailLocation.z) > 10 then
					ESX.Game.Teleport(playerPed, JailLocation)
					TriggerEvent('chat:addMessage', { args = { _U('judge'), _U('escape_attempt') }, color = { 147, 196, 109 } })
				end
				
				JailTime = JailTime - 20
			end

			-- jail time served
			TriggerServerEvent('esx_jail:unjailTime', -1)
			ESX.Game.Teleport(playerPed, Config.JailBlip)
			IsJailed = false

			-- Change back the user skin
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if JailTime > 0 and IsJailed then
			if fastTimer < 0 then
				fastTimer = JailTime
			end

			draw2dText(_U('remaining_msg', ESX.Math.Round(fastTimer)), { 0.175, 0.955 } )
			fastTimer = fastTimer - 0.01
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent('esx_jail:unjail')
AddEventHandler('esx_jail:unjail', function(source)
	unjail = true
	JailTime = 0
	fastTimer = 0
end)

-- When player respawns / joins
AddEventHandler('playerSpawned', function(spawn)
	if IsJailed then
		ESX.Game.Teleport(PlayerPedId(), JailLocation)
	else
		TriggerServerEvent('esx_jail:checkJail')
	end
end)

-- When script starts
Citizen.CreateThread(function()
	Citizen.Wait(2000) -- wait for mysql-async to be ready, this should be enough time
	TriggerServerEvent('esx_jail:checkJail')
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
	SetBlipSprite (blip, 188)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.9)
	SetBlipColour (blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(_U('blip_name'))
	EndTextCommandSetBlipName(blip)
end)

function draw2dText(text, pos)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(table.unpack(pos))
end