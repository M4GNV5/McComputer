include("stdio")

local count = fcount()

for i = 0, count - 1 do
    local fd = fopen(i)

    if fd then
        local c = fgetc(fd)
        repeat
            printf("%c", c)
            c = fgetc(fd)
        until c == charCode("\n")
        fclose(fd)
    end
    printf(" ")
end
printf("\n")
