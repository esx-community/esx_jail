local cJ = false
local unjail = false

--ESX base

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("esx_jailer:jail")
AddEventHandler("esx_jailer:jail", function(jailTime)
	if cJ == true then
		return
	end
	local pP = GetPlayerPed(-1)
	if DoesEntityExist(pP) then
		
		Citizen.CreateThread(function()
			local playerOldLoc = GetEntityCoords(pP, true)
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					local clothesSkin = {
						['tshirt_1'] = 15, ['tshirt_2'] = 0,
						['torso_1'] = 146, ['torso_2'] = 0,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 0,
						['pants_1'] = 3, ['pants_2'] = 7,
						['shoes_1'] = 12, ['shoes_2'] = 12,
						['chain_1'] = 50, ['chain_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				else
					local clothesSkin = {
						['tshirt_1'] = 3, ['tshirt_2'] = 0,
						['torso_1'] = 38, ['torso_2'] = 3,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 2,
						['pants_1'] = 3, ['pants_2'] = 15,
						['shoes_1'] = 66, ['shoes_2'] = 5,
						['chain_1'] = 0, ['chain_2'] = 2
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				end
				local playerPed = GetPlayerPed(-1)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
				ResetPedMovementClipset(playerPed, 0)
			end)
			SetEntityCoords(pP, 1641.64, 2571.08, 45.56)
			cJ = true
			unjail = false
			while jailTime > 0 and not unjail do
				pP = GetPlayerPed(-1)
				RemoveAllPedWeapons(pP, true)
				SetEntityInvincible(pP, true)
				if IsPedInAnyVehicle(pP, false) then
					ClearPedTasksImmediately(pP)
				end
				if jailTime % 30 == 0 then
					TriggerEvent('chatMessage', 'DOMARE', { 0, 0, 0 }, "Det kvarstår " .. round(jailTime / 60).. " minuter tills du släpps från fängelset")
					TriggerServerEvent('esx_jailer:updateRemaining', -1, jailTime)
				end
				Citizen.Wait(500)
				local pL = GetEntityCoords(pP, true)
				local D = Vdist(1641.64, 2571.08, 45.56, pL['x'], pL['y'], pL['z'])
				if D > 10 then
					SetEntityCoords(pP, 1641.64, 2571.08, 45.56)
					TriggerEvent('chatMessage', 'DOMARE', { 0, 0, 0 }, "Du får inte rymma från fängelset!")
				end
				jailTime = jailTime - 0.5
			end
			-- jail time served
			TriggerServerEvent('esx_jailer:unjailTime', -1)
			
			SetEntityCoords(pP, 432.95864868164, -981.41455078125, 29.710334777832)
			cJ = false
			SetEntityInvincible(pP, false)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				local model = nil

				if skin.sex == 0 then
					model = GetHashKey("mp_m_freemode_01")
				else
					model = GetHashKey("mp_f_freemode_01")
				end

				RequestModel(model)
				while not HasModelLoaded(model) do
					RequestModel(model)
					Citizen.Wait(1)
				end

				SetPlayerModel(PlayerId(), model)
				SetModelAsNoLongerNeeded(model)

				TriggerEvent('skinchanger:loadSkin', skin)
				TriggerEvent('esx:restoreLoadout')
			end)
		end)
	end
end)

RegisterNetEvent("esx_jailer:unjail")
AddEventHandler("esx_jailer:unjail", function(source)
	unjail = true
end)

AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent('esx_jailer:checkjail')
end)

function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end