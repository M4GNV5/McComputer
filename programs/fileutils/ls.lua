include("stdio")
import("chat")

local count = fcount()
for i = 0, count - 1 do
    local fd = fopen(i)

    if fd then
        local name = fgets(fd)
        fclose(fd)

        printf("%s ", name)
    end
end

printf("\n")
