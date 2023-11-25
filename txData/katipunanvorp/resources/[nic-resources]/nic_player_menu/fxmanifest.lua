game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page "html/index.html"

client_scripts {
    'config.lua',
    'client.lua'
 }

 server_scripts {
    'config.lua',
    'server.lua'
}

files {
    'html/index.html',
    'html/assets/css/style.css',
    'html/assets/css/reset.css',
    'html/assets/img/*.png',
    'html/assets/img/*.jpg',
    'html/assets/js/script.js'
}