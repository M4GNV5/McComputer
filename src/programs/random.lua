include("stdio")
include("stdlib")
include("string")
import("random")

function random(args)
    local max = atoi(args)
    local val = rand_fast()

    if val < max then
        val = -val
    end
    val = val % (max + 1)
    
    printf("%d\n", val)
end
