import("./../corelibs/terminal.lua")
import("./../corelibs/util.js")

function print_str(str) --print char table
    for i = 1, #str do
        terminal_write(str[i])
    end
end

function print_float(val) -- print float
    local base = js_eval("val.base")
    local left, right = base / 100, base % 100

    print_int(left)

    if right < 0 then
        right = -right
    end

    print_char(charCode("."))
    print_char(right / 10 + charCode("0"))
    print_char(right % 10 + charCode("0"))
end

function print_int(val) --print integer
    if val < 0 then
        terminal_static_write("-")
        val = -val
    elseif val == 0 then
        terminal_static_write("0")
        return
    end

    local str = {}
    while val > 0 do
        str[#str + 1] = charCode("0") + val % 10
        val = val / 10
    end

    for i = #str, 1, -1 do
        terminal_write(str[i])
    end
end

--print char in print.js

function print_bool(bool) --print bool
    if bool then
        terminal_static_write("true")
        return
    else
        terminal_static_write("false")
        return
    end
end

import("./print.js")
