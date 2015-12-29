include("stdio")
import("random")

import("./scrapFortunes.js")

local fd = fopen("fortunes.txt")
if fd == 0 then
    printf("Fortune file not found :[\n")
end

local fortuneCount = 20
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
