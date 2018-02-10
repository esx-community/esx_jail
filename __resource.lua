resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Jailer'

version '1.0.0'

client_scripts {
	'@mysql-async/lib/MySQL.lua',
	'clientJailer.lua'

}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'serverJailer.lua'
}