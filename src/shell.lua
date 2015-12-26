include("stdio")
include("string")

import("./generate_shell.js")
import("./shell_launch.lua")

function shell()
    local lastInput = {}

    repeat
        printf(">")

        local input = {}
        repeat
            c = getchar()

            if c == 8 then -- backspace
                table_remove(input, #input)
            elseif c == charCode("\n") then
                -- dont append new lines to input
            else
                input[#input + 1] = c
            end

            printf("%c", c)
        until c == charCode("\n")

        if #input == 1 and input[1] == charCode(".") then
            input = lastInput
        else
            lastInput = input
        end

        local program, args = strsplit(input, charCode(" "))

        local exitcode = shell_launch(program, args)

        if exitcode == -1 then
            printf("Unknown command %s\n", program)
        elseif exitcode ~= 0 then
            printf("Program exited with code %d\n", exitcode)
        end
    until false
end
