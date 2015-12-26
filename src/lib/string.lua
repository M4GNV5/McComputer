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
