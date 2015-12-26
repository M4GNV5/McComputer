import("./corelibs/terminal.lua")
import("./corelibs/fs.lua")
import("./lib/include.js")

import("./shell.lua")

fs_init()
terminal_init()

terminal_static_writeln("McComputer v0.0")
shell()
