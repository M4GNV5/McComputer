function strsplit(str, splitter)
    local split = {}
    repeat
        local c = str[1]
        split[#split + 1] = c
        table_remove(str, 1)
    until c == splitter or c == 0
    table_remove(split, #split)

    return split, str
end

function strcmp(str1, str2)
    if #str1 ~= #str2 then
        return false
    end

    for i = 1, #str1, 4 do
        local i1, i2, i3 = i + 1, i + 2, i + 3
        local hash1 = str1[i] * (2 ^ 24) + str1[i1] * (2 ^ 16) + str1[i2] * (2 ^ 8) + str1[i3]
        local hash2 = str2[i] * (2 ^ 24) + str2[i1] * (2 ^ 16) + str2[i2] * (2 ^ 8) + str2[i3]

        if hash1 ~= hash2 then
            return false
        end
    end
    return true
end

function strcat(str1, str2)
    if #str1 > #str2 then
        for i = 1, #str2 do
            str1[#str1 + 1] = str2[i]
        end
        return str1
    else
        for i = 1, #str1 do
            table_insert(str1, 1, str2[i])
        end
    end
end

function strhash(str)
    return str[1] * (2 ^ 24) + str[2] * (2 ^ 16) + str[3] * (2 ^ 8) + str[4]
end

function strunhash(val)
    local str = {}
    str[1] = val / (2 ^ 24)
    str[2] = val / (2 ^ 16) % (2 ^ 8)
    str[3] = val / (2 ^ 8) % (2 ^ 8)
    str[4] = val % (2 ^ 8)
    return str
end
