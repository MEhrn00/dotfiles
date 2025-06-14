set -q LUA_PATH; or set -gx LUA_PATH "$HOME/.luarocks/share/lua/5.4/?.lua;$HOME/.luarocks/share/lua/5.4/?/init.lua;/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua"
set -q LUA_CPATH; or set -gx LUA_CPATH "$HOME/.luarocks/lib64/lua/5.4/?.so;/usr/lib64/lua/5.4/?.so"

