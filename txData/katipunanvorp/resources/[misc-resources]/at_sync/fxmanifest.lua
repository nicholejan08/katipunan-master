-- Don't delete the copyright, thank you

-- Discord https://discord.gg/mv8XxxjxZP

-- github account https://github.com/IRISK77



fx_version 'adamant'
games {'rdr3'}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
    'ss_shared_functions.lua',
    'config/Keybinds.lua',
    'config/ServerSync.lua',
   -- 'ss_cli_traffic_crowd.lua',
    'ss_cli_time.lua'
}

server_scripts {
    'ss_shared_functions.lua',
    'config/ServerSync.lua',
    'ss_srv_time.lua'
}
