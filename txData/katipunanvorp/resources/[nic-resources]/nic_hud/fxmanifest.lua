game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page "ui/index.html"

client_script {
    'client.lua'
}

server_scripts {
    'server.lua',
}

files{
    'ui/index.html',
    'ui/assets/css/*.css',
    'ui/assets/js/*.js',
    'ui/assets/img/*.png',
    'ui/assets/img/*.jpg',
}