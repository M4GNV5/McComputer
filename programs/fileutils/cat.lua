include("stdio")

local fd = fopen(arguments)
if fd == 0 then
    printf("Error: could not open file\n")
else
    local c = 0
    repeat
        c = fgetc(fd)
        printf("%c", c)
    until c == 0

    if c ~= 10 then
        printf("\n")
    end

    fclose(fd)
end
