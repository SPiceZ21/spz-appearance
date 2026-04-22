fx_version 'cerulean'
game 'gta5'

name 'spz-appearance'
description 'SPiceZ-Core — MP Freemode ped, outfits, crew outfits'
version '1.0.0'
author 'SPiceZ-Core'

shared_scripts {
  'config.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua',
  'server/outfits.lua',
  'server/crew_outfit.lua',
}

client_scripts {
  'client/main.lua',
  'client/outfits.lua',
  'client/commands.lua',
}

dependencies {
  'spz-lib',
  'spz-core',
  'spz-identity',
  'oxmysql',
}
