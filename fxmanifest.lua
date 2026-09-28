fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'
lua54 'yes'

description 'rsg-looting'
version '2.0.0'

shared_scripts {
  '@ox_lib/init.lua',
  'shared/config.lua',
}

client_script 'client/client.lua'

server_scripts {
  'server/sv_webhooks_config.lua',
  'server/sv_webhooks.lua',
  'server/server.lua',
  'server/versionchecker.lua'
}

files { 'locales/*.json' }

dependencies {
    'rsg-core',
    'rsg-inventory',
    'rsg-lawman',
    'ox_lib',
}

ox_lib 'locale'
