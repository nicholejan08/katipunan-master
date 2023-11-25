game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page "html/ui.html"

shared_script {
    'config.lua'
}

client_script {
    'client.lua'
}

server_scripts {
    'server.lua',
}

 
files{
    'html/ui.html',
    'html/style.css',
    'html/*.png',
	'stream/boxing_gloves_left.ytyp',
	'stream/boxing_gloves_right.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/boxing_gloves_left.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/boxing_gloves_right.ytyp'