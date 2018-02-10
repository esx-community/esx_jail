# esx_jailer
Let cops jail people!

# How to jail
- Use the `esx_jailer:sendToJail(source, jailTime)` server side trigger
- Use the `/jail source jailTime` command

`jailTime` is the jail time in seconds, and `source` is the player id (for example `1`)

Example in `esx_policejob`
	```
		{label = _U('fine'),			value = 'fine'},
		{label = _U('jail'),			value = 'jail'}
		
...

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

Original script: https://forum.fivem.net/t/release-fx-jailer-1-1-0-0/41963

