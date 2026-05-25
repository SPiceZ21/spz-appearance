fx_version 'cerulean'
game 'gta5'

name 'spz-appearance'
description 'SPiceZ-Core — MP Freemode ped, outfits, crew outfits'
version '2.0.0'
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
  'client/outfits.lua',
  'client/main.lua',
  'client/commands.lua',
}

server_exports {
  'PropagateCrewOutfit',
  'GetCrewOutfit',
  'ClearCrewOutfit',
}

dependencies {
  'spz-lib',
  'spz-core',
  'spz-identity',
  'oxmysql',
}
