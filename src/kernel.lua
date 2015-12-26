import("./libs/terminal.lua")
import("./libs/fs.lua")
import("./programs.lua")

fs_init()
terminal_init()

terminal_static_writeln("McComputer v0.0")
shell()
