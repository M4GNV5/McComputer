import("./libs/terminal.lua")
import("./libs/keyboard.lua")
import("./libs/fs.lua")
import("./libs/util.js")
import("chat")

function shell()
    repeat
        local program = {}
        local args = {}

        terminal_static_write(">")

        local c = 0
        repeat
            c = keyboard_get()

            if c == 8 then
                table_remove(program, #program)
            elseif c == charCode(" ") then
                -- new line
            else
                program[#program + 1] = c
            end

            terminal_write(c)
        until c == charCode(" ") or c == charCode("\n")

        if c ~= charCode("\n") then
            repeat
                c = keyboard_get()

                if c == 8 then
                    table_remove(args, #args)
                elseif c == charCode("\n") then
                    -- new line
                else
                    args[#args + 1] = c
                end

                terminal_write(c)
            until c == charCode("\n")
        end

        proghash = program[1] * (2 ^ 16) + program[2] * (2 ^ 8) + program[3]

        if proghash == strHash("help") then
            help(args)
        elseif proghash == strHash("echo") then
            echo(args)
        elseif proghash == strHash("cat") then
            cat(args)
        elseif proghash == strHash("pwd") then
            pwd(args)
        else
            terminal_static_writeln("Unknown command")
        end
    until false
end

function help(args)
    terminal_static_writeln("Commands: help, echo, cat, pwd")
end

function echo(args)
    for i = 1, #args do
        terminal_write(args[i])
    end
    terminal_static_writeln("")
end

function cat(args)
    local fd = fopen(args)
    if fd == 0 then
        terminal_static_writeln("Error: could not open file!")
    else
        local c = 0
        repeat
            c = fgetc(fd)
            terminal_write(c)
        until c == 0

        if c ~= 10 then
            terminal_static_writeln("")
        end

        fclose(fd)
    end
end

function pwd(args)
    terminal_static_writeln("There is only one directory you fool")
end
