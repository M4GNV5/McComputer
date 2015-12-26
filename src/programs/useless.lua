include("stdio")
import("random")

function no_directories()
    printf("There is only one directory you fool\n")
end

function hcf()
    command("execute " .. terminal_selector .. " ~ ~ ~ setblock ~ ~ ~ fire 0 {alt:0,south:true}")
    command("kill @e[type=ArmorStand]")
end

function fortune()
    local fd = fopen("fortunes.txt")
    if fd == 0 then
        printf("Fortune file not found :[\n")
        return 1
    end

    local fortuneCount = 9
    local line = rand_fast()
    if line < 0 then
        line = -line
    end
    line = line % fortuneCount + 1

    fsetpos(fd, line, 0)

    repeat
        local c = fgetc(fd)
        printf("%c", c)
    until c == charCode("\n")

    fclose(fd)
    return 0
end
