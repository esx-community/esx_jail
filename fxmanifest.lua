fx_version 'adamant'

game 'gta5'

description 'ESX Jail'

version '1.1.0'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/br.lua',
	'locales/sv.lua',
	'locales/dk.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/br.lua',
	'locales/sv.lua',
	'locales/dk.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended',
	'async'
}
