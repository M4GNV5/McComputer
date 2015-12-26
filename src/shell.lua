include("stdio")
include("string")

import("./generate_shell.js")
import("./shell_launch.lua")

function shell()
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

        local program, args = strsplit(input, charCode(" "))

        shell_launch(program, args)
    until false
end
