fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'

description 'object spawner for fivem'
author 'qw-scripts'
version '0.2.0'

client_scripts {
    'client/**/*'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**/*'
}

shared_scripts {
    'shared/**/*',
    '@ox_lib/init.lua'
}

lua54 'yes'
