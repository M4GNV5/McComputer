include("stdio")
include("string")

-- {keylen, vallen, key1, key2, key3, val1, val2, val3}

function dict_find(dict : table, needle : table) : int, int, int
    local i = 1
    repeat
        local keylen, vallen = dict[i], dict[i + 1]
        local keypos = i + 2
        local key = dict
        table_slice(key, keypos, keypos + keylen - 1)

        if strcmp(key, needle) then
            return i, keylen, vallen
        end

        i = i + keylen + vallen + 2
    until i > #dict

    return -1, 0, 0
end

function dict_get(dict : table, key : table) : table
    local i, keylen, vallen = dict_find(dict, key)

    if i < 0 then
        return {-1}
    end

    local val = dict
    table_slice(val, i + 2 + keylen, i + 1 + keylen + vallen)
    return val
end

function dict_set(dict : table, key : table, val : table) : table
    local i, keylen, vallen = dict_find(dict, key)
    local newkeylen, newvallen = #key, #val
    if i < 0 then
        i = #dict + 1
    else
        -- make room or shrink to size of new entry
        local sizediff = newkeylen + newvallen - keylen - vallen
        if sizediff < 0 then
            sizediff = -sizediff
            for ii = 1, sizediff do
                table_remove(dict, i + ii)
            end
        elseif sizediff > 0 then
            for ii = 1, sizediff do
                table_insert(dict, i + ii, 0)
            end
        end
    end

    local vallenpos, keypos, valpos = i + 1, i + 2, i + 2 + newkeylen
    dict[i] = newkeylen
    dict[vallenpos] = newvallen

    for i = 1, newkeylen do
        local pos = keypos + i - 1
        dict[pos] = key[i]
    end
    for i = 1, newvallen do
        local pos = valpos + i - 1
        dict[pos] = val[i]
    end

    return dict
end

function dict_dump(dict : table): void
    local i = 1
    repeat
        local keylen, vallen = dict[i], dict[i + 1]
        i = i + 2

        local key = dict
        table_slice(key, i, i + keylen - 1)
        i = i + keylen + 1

        local val = dict
        table_slice(val, i, i + vallen - 1)
        i = i + vallen + 1

        printf("%s = %s\n", key, val)
    until i > #dict
end
