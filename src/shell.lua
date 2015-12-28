include("stdio")
include("string")
import("time")

local printTime = false
local printErrorCode = false
local args = {}
local starttime = 0
local exitcode = 0

function shell_args() : table
    return args
end

function exit(code : int) : void
    if exitcode ~= 0 and printErrorCode then
        printf("Program exited with code %d\n", exitcode)
    elseif printTime then
        local diff = 0.0
        diff = gametime() - starttime
        diff = diff / 20
        printf("execution took %f seconds\n", diff)
    end

    fexec(str("shell"))
end

function shell_reload() : void
    printf("Loading shell config...\n")
end

local function shell() : void
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

        starttime = gametime()

        if fexec(program) then
            break
        else
            printf("unknown command %s", program)
        end
    until false
end

shell()
