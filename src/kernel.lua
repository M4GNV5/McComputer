import("chat")
import("./libs/terminal.lua")
import("./libs/keyboard.lua")
import("./libs/fs.lua")
import("./libs/util.js")

fs_init()
terminal_init()
terminal_static_writeln("McComputer v0")

terminal_static_writeln("Opening file readme")

local fd = fopen(strTable("readme"))

if fd == 0 then
    terminal_static_writeln("failed to open file")
else
    repeat
        local c = fgetc(fd)
        terminal_write(c)
    until c == 0
end

repeat
    local c = keyboard_get()
    terminal_write(c)
until false
