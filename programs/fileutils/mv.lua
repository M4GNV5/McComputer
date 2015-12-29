include("stdio")
include("string")

local old, new = strsplit(arguments, charCode(" "))
local fd = fopen(old)

if fd == 0 then
    printf("Error: file not found\n")
else
    fsetpos(fd, 0, 0)
    fwrites(fd, new)
    fclose(fd)
end
