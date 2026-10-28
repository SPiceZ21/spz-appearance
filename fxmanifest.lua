fx_version 'cerulean'
game 'gta5'

name 'spz-appearance'
description 'SPiceZ-Core — MP Freemode ped, outfits, crew outfits'
version '1.0.2'
author 'SPiceZ-Core'

shared_scripts {
  '@ox_lib/init.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua',
  'server/outfits.lua',
  'server/crew_outfit.lua',
}

client_scripts {
  'client/outfits.lua',
  'client/main.lua',
  'client/commands.lua',
}

dependencies {
  'ox_lib',
  'spz-core',
  'spz-identity',
  'fivem-appearance',
  'oxmysql',
}
