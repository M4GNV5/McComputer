import("math")
import("./libs/terminal.lua")
import("./libs/keyboard.lua")

terminal_init()
terminal_static_writeln("Hello World")

i = 0
repeat
    val = random()
    val = abs(val) % 37

    if val < 10 then
        val = val + 48    --number 0-9
    elseif val == 36 then
        val = 32          --space
    else
        val = val + 55    --char a-z
    end

    terminal_write(val)

    i = i + 1
until i > 10

repeat
    char = keyboard_get()
    terminal_write(char)
until false
