# esx_jailer
Let cops jail people! Custom built by the SCRP team
- [FiveM Forum thread](https://forum.fivem.net/t/release-esx-jailer/82896)

# Installation
1. Clone the project and add it to your resorces directory
2. Add the project to your `server.cfg`
3. Import `esx_jailer.sql` in your database
4. Select language in `config.lua`
5. (Optional) See below on how to jail via `esx_policejob`

# How to jail
- Use the `esx_jailer:sendToJail(source, jailTime)` server side trigger
- Use the `/jail playerID jailTime` command (only admins)
- Use the `/unjail playerID` to unjail a player (only admins)

# Features
- Jail people!
- Saves jail info to database, aka anti-combat
- Keeps jail time updated

# Requirements
- ES
- ESX
- esx_policejob
- skinchanger
- MySQL Async

# Based off
- [Original script](https://forum.fivem.net/t/release-fx-jailer-1-1-0-0/41963)
- [dbjailer](https://github.com/SSPU1W/dbjailer)

# Add to menu

Example in `esx_policejob: client/main.lua`:

```
		{label = _U('fine'),			value = 'fine'},
		{label = _U('jail'),			value = 'jail'}
		
		
		if data2.current.value == 'jail' then
			JailPlayer(GetPlayerServerId(closestPlayer))
		end

---

function JailPlayer(player)
	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'jail_menu',
		{
			title = _U('jail_menu_info'),
		},
	function (data2, menu)
		local jailTime = tonumber(data2.value)
		if jailTime == nil then
			ESX.ShowNotification(_U('invalid_amount'))
		else
			TriggerServerEvent("esx_jailer:sendToJail", player, jailTime * 60)
			menu.close()
		end
	end,
	function (data2, menu)
		menu.close()
	end
	)
end
```
