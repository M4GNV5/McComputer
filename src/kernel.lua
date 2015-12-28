import("./corelibs/terminal.lua")
import("./corelibs/fs.lua")
import("./corelibs/keyboard.lua")

fs_init()
terminal_init()

terminal_static_writeln("McComputer v0.0")

if not fexec(str("shell")) then
    terminal_static_writeln("Could not start shell :O")
end
