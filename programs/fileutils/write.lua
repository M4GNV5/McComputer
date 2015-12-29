include("stdio")
include("string")

local file, content = strsplit(arguments, charCode(" "))

local fd = fopen(file)
if fd == 0 then
    printf("Creating file...\n")
    fd = fcreate(file)
end

printf("Writing content...\n")
for i = 1, #content do
    fwrite(fd, content[i])
end
fwrite(fd, 0)
fclose(fd)
