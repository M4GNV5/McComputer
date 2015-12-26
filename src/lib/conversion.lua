function itoa(val)
    local str = {}

    if val < 0 then
        terminal_static_write("-")
        val = -val
    elseif val == 0 then
        return {charCode("0")}
    end

    while val > 0 do
        table_insert(str, 0, charCode("0") + val % 10)
        val = val / 10
    end

    return str
end

function atoi(str)

end
