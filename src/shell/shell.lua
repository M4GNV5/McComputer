include("stdio")
include("string")
include("dictionary")
import("time")

local printTime = false
shell_args = {}
local starttime = 0

local function shell() : void

    local fd = fopen("shell.conf")
    if fd == 0 then
        printf("creating shell.conf...\n")
        local conf = {}
        conf = dict_set(conf, str("printTime"), str("false"))
        fd = fcreate(str("shell.conf"))
        fwrites(fd, conf)
    else
        printf("reading shell.conf...\n")
        local conf = fgets(fd)
        local pTime = dict_get(conf, str("printTime"))
        if strcmp(pTime, str("true")) then
            printTime = true
        end
    end
    fclose(fd)

    local lastInput = {}

    repeat
        printf(">")

        local input = {}
        repeat
            local c = getchar()

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

        local program = {}
        program, shell_args = strsplit(input, charCode(" "))

        starttime = gametime()

        local fd = fopen(program)

        if fd == 0 then
            printf("unknown command %s\n", program)
        else
            fexec(fd)
            if printTime then
                local diff = 0.0
                diff = gametime() - starttime
                diff = diff / 20
                printf("execution took %f seconds\n", diff)
            end
        end
    until false
end

shell()
