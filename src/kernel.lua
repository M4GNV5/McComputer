import("./corelibs/terminal.lua")
import("./corelibs/fs.lua")
import("./corelibs/keyboard.lua")

fs_init()
terminal_init()

terminal_static_writeln("McComputer v0.0")

local fd = fopen("shell")
if fd == 0 then
    terminal_static_writeln("Could not start shell :O")
else
    fexec(fd)
    terminal_static_writeln("\nShell exited. Shutting down")
end
