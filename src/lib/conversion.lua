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
        table_insert(str, 1, charCode("0") + val % 10)
        val = val / 10
    end

    if neg then
        table_insert(str, 1, charCode("-"))
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

function atof(str)
    local val = 0.0
    local neg = false

    local i = 1
    while i < #str and str[i] ~= charCode(".") do
        val = val * 10 + str[i] - charCode("0")
        i = i + 1
    end

    if str[i] == charCode(".") then
        local digit1 = float(str[i + 1] - charCode("0")) / 10
        local digit2 = float(str[i + 2] - charCode("0")) / 100
        val = val + digit1 + digit2
    end

    if neg then
        return -val
    end
    return val
end

function ftoa(val)
    local base = js_eval("val.base")
    local left, right = base / 100, base % 100

    local result = itoa(left)

    if right < 0 then
        right = -right
    end

    local len = #result
    result[len + 1] = charCode(".")
    result[len + 2] = right / 10 + charCode("0")
    result[len + 3] = right % 10 + charCode("0")

    return result
end
