include("stdio")
include("stdlib")
include("string")

function config_parse(file)
    local config = {}
    local keys = {}
    local fd = fopen(file)

    if fd < 0 then
        return {}, {}
    end

    repeat
        local c = fgetc(fd)
        local key, val = {}, {}
        repeat
            key[#key + 1] = c
            c = fgetc(fd)
        until c == charCode("=") or c == charCode("\n") or c == 0

        local keyhash = strhash(key)
        keys[#keys + 1] = keyhash

        if c == charCode("=") then
            c = fgetc(fd)
            repeat
                val[#val + 1] = c
                c = fgetc(fd)
            until c == charCode("\n") or c == 0

            config[keyhash] = atoi(val)
        else
            config[keyhash] = 1
        end
    until c == 0

    fclose(fd)
    return config, keys
end
