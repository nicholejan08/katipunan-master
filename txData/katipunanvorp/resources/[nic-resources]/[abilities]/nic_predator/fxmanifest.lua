fx_version "adamant"

games {"rdr3"}

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_script {
    'config.lua'
}

client_script {
    'client.lua'
}

server_scripts {
    'server.lua',
}

files {
	'stream/predator_claws.ytyp',
	'stream/bone_mask.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'stream/predator_claws.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bone_mask.ytyp'