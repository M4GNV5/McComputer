function itoa(val)
    local str = {}
    local neg = false

    if val < 0 then
        neg = true
        val = -val
    elseif val == 0 then
        return {charCode("0")}
    end

    while val > 0 do
        table_insert(str, 0, charCode("0") + val % 10)
        val = val / 10
    end

    if neg then
        table_insert(str, 0, charCode("-"))
        return str
    end
    return str
end

function atoi(str)
    local val = 0
    local neg = false

    if str[1] == charCode("-") then
        neg = true
        table_remove(str, 1)
    end

    for i = 1, #str do
        val = val * 10 + str[i] - charCode("0")
    end

    if neg then
        return -val
    end
    return val
end

--TODO atof
