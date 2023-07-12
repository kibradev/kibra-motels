fx_version "adamant"

game "gta5"

author "Kibra#9999"

description "My Discord Server: Web on, https://dc.kibra.online"

client_scripts {
    "func.lua",
    "client.lua",
    "lang.lua"
}

server_scripts {
    -- "@mysql-async/lib/MySQL.lua",
    "@oxmysql/lib/MySQL.lua",
    "time.lua",
    "server.lua",
    "lang.lua",
}

shared_script "config.lua"

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/index.js",
    "ui/style.css",
    "ui/img/*.png"
}

lua54 'yes'
