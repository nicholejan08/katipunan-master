game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page "html/ui.html"

shared_scripts {
   'config.lua'
}

client_scripts {
    'client.lua'
 }
 
 server_scripts {
    'server.lua'
 }

 files {
    'stream/antman_helmet.ytyp'
 }
 
 data_file 'DLC_ITYP_REQUEST' 'stream/antman_helmet.ytyp'
