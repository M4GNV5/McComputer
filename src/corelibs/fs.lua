-- fs at 1 10 5

import("./fs.js")

function fs_init() : void
    command("kill @e[type=ArmorStand,tag=fs]")
    command("kill @e[type=ArmorStand,tag=file]")
    command("summon ArmorStand 1 10 5 {Tags:[\"fs\"],NoGravity:true}")

    while not "/execute @e[type=ArmorStand,tag=fs] ~ ~ ~ testforblock ~ ~ ~ air" do
        command("execute @e[type=ArmorStand,tag=fs] ~ ~ ~ summon ArmorStand ~ ~ ~ {Tags:[\"file\"],NoGravity:true}")
        command("tp @e[type=ArmorStand,tag=fs] ~ ~3 ~")
    end
end

local currFd = 0

function fopen_id(id : int) : int
    command("summon ArmorStand 1 10 5 {Tags:[\"fopen\"],NoGravity:true}")

    scoreTp("@e[type=ArmorStand,tag=fopen]", id, 64, 0, 3, 0)

    if "/execute @e[type=ArmorStand,tag=fopen] ~ ~ ~ testforblock ~ ~ ~ wool" then
        currFd = currFd + 1
        local fd = score("@e[type=ArmorStand,tag=fopen]", OBJECTIVE_NAME)
        fd = currFd
        command("entitydata @e[type=ArmorStand,tag=fopen] {Tags:[\"fd\"]}")
        return currFd
    else
        return 0
    end
end

function fopen_name(name : table) : int
    command("execute @e[type=ArmorStand,tag=file] ~ ~ ~ summon ArmorStand ~ ~ ~ {Tags:[\"fopen\"],NoGravity:true}")

    name[#name + 1] = 0

    for i = 1, #name do

        local selfScore = score("@e[type=ArmorStand,tag=fopen,c=1]", OBJECTIVE_NAME)

        local curr = name[i]
        local left, right = curr / 16, curr % 16

        _fs_read_uint4("@e[type=ArmorStand,tag=fopen]", selfScore)
        command("execute @e[type=ArmorStand,tag=fopen] ~ ~ ~ " ..
            "scoreboard players operation @e[type=ArmorStand,tag=fopen,c=1] "..OBJECTIVE_NAME.." -= "..js_eval("left.name").." "..OBJECTIVE_NAME)
        command("kill @e[type=ArmorStand,tag=fopen,score_" .. OBJECTIVE_NAME .. "_min=1]")
        command("kill @e[type=ArmorStand,tag=fopen,score_" .. OBJECTIVE_NAME .. "=-1]")

        _fs_read_uint4("@e[type=ArmorStand,tag=fopen]", selfScore, 0, 0, 1)
        command("execute @e[type=ArmorStand,tag=fopen] ~ ~ ~ " ..
            "scoreboard players operation @e[type=ArmorStand,tag=fopen,c=1] "..OBJECTIVE_NAME.." -= "..js_eval("right.name").." "..OBJECTIVE_NAME)
        command("kill @e[type=ArmorStand,tag=fopen,score_" .. OBJECTIVE_NAME .. "_min=1]")
        command("kill @e[type=ArmorStand,tag=fopen,score_" .. OBJECTIVE_NAME .. "=-1]")

        command("tp @e[type=ArmorStand,tag=fopen] ~1 ~ ~")
    end

    local count = 0
    command("execute @e[type=ArmorStand,tag=fopen] ~ ~ ~ scoreboard players add " .. js_eval("count.name") .. " " .. OBJECTIVE_NAME .. " 1")

    if count == 1 then
        currFd = currFd + 1
        local fd = score("@e[type=ArmorStand,tag=fopen]", OBJECTIVE_NAME)
        fd = currFd
        command("tp @e[type=ArmorStand,tag=fopen] 1 ~ ~2")
        command("entitydata @e[type=ArmorStand,tag=fopen] {Tags:[\"fd\"]}")
        return currFd
    else
        return 0
    end
end

function fclose(fd : int) : void
    command("kill " + _fs_resolve_fd(fd))
end

function fgetc(fd : int) : int
    local val = 0
    _fs_read_uint8(fd, val, true)
    return val
end

function fgets(fd : int) : table
    local str = {}
    repeat
        local c = 0
        _fs_read_uint8(fd, c, true)
        str[#str + 1] = c
    until c == 0

    table_remove(str, #str)
    return str
end

function fwrite(fd : int, char : int) : void
    _fs_write_uint8(fd, char)
end

function fwrites(fd : int, str : table) : void
    str[#str + 1] = 0
    for i = 1, #str do
        _fs_write_uint8(fd, str[i])
    end
end

function fsetpos(fd : int, line : int, column : int) : void
    _fs_setpos(fd, line, column)
end

function fcreate(name : table) : int
    command("execute @e[type=ArmorStand,tag=fs] ~ ~ ~ summon ArmorStand ~ ~ ~ {Tags:[\"fcreate\"],NoGravity:true}")
    command("execute @e[type=ArmorStand,tag=fcreate] ~ ~ ~ summon ArmorStand ~ ~ ~ {Tags:[\"file\"],NoGravity:true}")
    command("tp @e[type=ArmorStand,tag=fs] ~ ~3 ~")

    currFd = currFd + 1
    local fd = score("@e[type=ArmorStand,tag=fcreate]", OBJECTIVE_NAME)
    fd = currFd
    command("entitydata @e[type=ArmorStand,tag=fcreate] {Tags:[\"fd\"]}")

    fwrites(currFd, name)
    fsetpos(currFd, 1, 0)

    return currFd
end
