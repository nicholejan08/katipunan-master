--[[
██╗░░░██╗░█████╗░██╗░░░░░██████╗░███████╗  ░█████╗░░█████╗░██████╗░██╗███╗░░██╗░██████╗░
██║░░░██║██╔══██╗██║░░░░░██╔══██╗██╔════╝  ██╔══██╗██╔══██╗██╔══██╗██║████╗░██║██╔════╝░
╚██╗░██╔╝██║░░██║██║░░░░░██║░░██║█████╗░░  ██║░░╚═╝██║░░██║██║░░██║██║██╔██╗██║██║░░██╗░
░╚████╔╝░██║░░██║██║░░░░░██║░░██║██╔══╝░░  ██║░░██╗██║░░██║██║░░██║██║██║╚████║██║░░╚██╗
░░╚██╔╝░░╚█████╔╝███████╗██████╔╝███████╗  ╚█████╔╝╚█████╔╝██████╔╝██║██║░╚███║╚██████╔╝
░░░╚═╝░░░░╚════╝░╚══════╝╚═════╝░╚══════╝  ░╚════╝░░╚════╝░╚═════╝░╚═╝╚═╝░░╚══╝░╚═════╝░
]]--

fx_version 'adamant'

game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page 'ui/index.html'
files {
  'ui/index.html',
  'ui/style.css',
  'ui/img/updates.png',
  'ui/script.js'
}

client_script "client.lua"
