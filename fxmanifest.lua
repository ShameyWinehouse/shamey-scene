fx_version "adamant"

games {"rdr3"}

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/nui.lua',
	'client/main.lua'
}

files {
    'ui/dist/*',
    'ui/assets/*',
    'ui/assets/fonts/*'
}

ui_page 'ui/dist/index.html'

version '3.0.0'


author 'Shamey Winehouse'
description 'License: GPL-3.0-only'