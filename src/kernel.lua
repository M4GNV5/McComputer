import("math")
import("./libs/terminal.lua")
import("./libs/keyboard.lua")

terminal_init()
terminal_static_writeln("McComputer v0")

local input = {}

terminal_static_write("input ")

while char ~= charCode("\n") do
    char = keyboard_get()
    input[#input + 1] = char

    terminal_write(char)
end

terminal_static_write("you wrote ")

for i = 1, #input do
    terminal_write(input[i])
end
