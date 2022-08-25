fx_version 'cerulean'
game 'gta5'

name 'DaCmd'
author 'DaBurnerGermany#5985'
version '1.0.0'

client_scripts {
	'config.lua',
	'client/client.lua'
}
server_scripts {
	'config.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}


ui_page('html/index.html')
files {
    'html/index.html'
}