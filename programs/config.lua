include("stdio")
include("string")
include("dictionary")

local fd = fopen(arguments)
local dict = {}

if fd == 0 then
    printf("Error: could not open file\n")
else
    printf("reading file...\n")
    local dict = fgets(arguments)
    printf("entering interactive mode, commands: get, set, dump, save, quit\n")

    repeat
        printf(">>")

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

        local cmd, args = strsplit(input, charCode(" "))
        local cmdhash = strhash(cmd)

        if cmdhash == static_strhash("get") then
            local val = dict_get(dict, args)
            printf("%s = %s\n", args, val)
        elseif cmdhash == static_strhash("set") then
            local key, val = strsplit(args, charCode(" "))
            dict = dict_set(dict, key, val)
            printf("value set\n")
        elseif cmdhash == static_strhash("dump") then
            dict_dump(dict)
        elseif cmdhash == static_strhash("save") then
            fsetpos(fd, 1, 0)
            printf("writing changes...\n")
            fwrites(fd, dict)
        elseif cmdhash == static_strhash("quit") then
            printf("goodbye\n")
            -- nothing
        else
            printf("Unknown command %s", cmd)
        end

    until cmdhash == static_strhash("quit")
end
