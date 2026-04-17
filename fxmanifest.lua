fx_version 'cerulean'
game 'gta5'

name 'spz-appearance'
description 'SPiceZ-Core — MP Freemode ped, outfits, crew outfits'
version '1.0.0'
author 'SPiceZ-Core'

shared_scripts {
  '@spz-lib/shared/main.lua',
  '@spz-lib/shared/callbacks.lua',
  '@spz-lib/shared/logger.lua',
  '@spz-lib/shared/notify.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'config.lua',
  'server/crew_outfit.lua',
  'server/outfits.lua',
  'server/main.lua',
}

client_scripts {
  'config.lua',
  'client/outfits.lua',
  'client/commands.lua',
  'client/main.lua',
}

dependencies {
  'spz-lib',
  'spz-core',
  'spz-identity',
  'oxmysql',
}
