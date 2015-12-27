include("stdio")
include("string")
include("config")

import("./generate_shell.js")
import("./shell_launch.lua")
import("time")

local printTime = false
local printErrorCode = false

function shell()
    local lastInput = {}

    printf("Loading shell config...\n")
    local config = config_parse(str("shell.conf"))
    printTime = config[static_strhash("time")]
    printErrorCode = config[static_strhash("code")]

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

        local starttime = gametime()

        if #input == 1 and input[1] == charCode(".") then
            input = lastInput
        else
            lastInput = input
        end

        local program, args = strsplit(input, charCode(" "))
        local exitcode = shell_launch(program, args)

        if exitcode == -1 then
            printf("Unknown command %s\n", program)
        elseif exitcode ~= 0 and printErrorCode then
            printf("Program exited with code %d\n", exitcode)
        elseif printTime then
            local diff = 0.0
            diff = gametime() - starttime
            diff = diff / 20
            printf("execution took %f seconds\n", diff)
        end
    until false
end
