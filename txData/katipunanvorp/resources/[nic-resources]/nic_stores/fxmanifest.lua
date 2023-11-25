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

server_export "isInventoryFull"

files {
    "html/index.html",
    "html/styles.css",
    "html/*.png",
    "html/*.jpg",
    "html/items/*.png",
    "html/items/*.jpg",
    "html/reset.css",
    "html/listener.js"
}
