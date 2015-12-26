import("./util.js")

-- fs at 1 10 5

function fs_init()
    command("kill @e[type=ArmorStand,tag=fs]")
    command("kill @e[type=ArmorStand,tag=file]")
    command("summon ArmorStand 1 10 5 {Tags:[\"fs\"],NoGravity:true}")

    while not "/execute @e[type=ArmorStand,tag=fs] ~ ~ ~ testforblock ~ ~ ~ air" do
        command("execute @e[type=ArmorStand,tag=fs] ~ ~ ~ summon ArmorStand ~ ~ ~ {Tags:[\"file\"],NoGravity:true}")
        command("tp @e[type=ArmorStand,tag=fs] ~ ~3 ~")
    end
end

local currFd = 0

function fopen_id(id)
    command("summon ArmorStand 1 10 5 {Tags:[\"fopen\"],NoGravity:true}")

    command("setblock ~ ~1 ~ sponge")
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

function fopen_name(name)
    command("execute @e[type=ArmorStand,tag=file] ~ ~ ~ summon ArmorStand ~ ~ ~ {Tags:[\"fopen\"],NoGravity:true}")

    name[#name + 1] = 0

    for i = 1, #name do

        local selfScore = score("@e[type=ArmorStand,tag=fopen,c=1]", OBJECTIVE_NAME)

        local curr = name[i]
        local left, right = curr / 16, curr % 16

        _fs_uint4("@e[type=ArmorStand,tag=fopen]", selfScore)
        command("execute @e[type=ArmorStand,tag=fopen] ~ ~ ~ " ..
            "scoreboard players operation @e[type=ArmorStand,tag=fopen,c=1] "..OBJECTIVE_NAME.." -= "..js_eval("left.name").." "..OBJECTIVE_NAME)
        command("kill @e[type=ArmorStand,tag=fopen,score_" .. OBJECTIVE_NAME .. "_min=1]")
        command("kill @e[type=ArmorStand,tag=fopen,score_" .. OBJECTIVE_NAME .. "=-1]")

        _fs_uint4("@e[type=ArmorStand,tag=fopen]", selfScore, 0, 0, 1)
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

function fclose(fd)
    command("kill " + resolve_fd(fd))
end

function fcreate(name)
    command("setblock ~ ~1 ~ sponge")
    command("execute @e[type=ArmorStand,tag=fs] ~ ~ ~ summon ArmorStand ~ ~ ~ {Tags:[\"fcreate\"],NoGravity:true}")
    command("execute @e[type=ArmorStand,tag=fcreate] ~ ~ ~ summon ArmorStand ~ ~ ~ {Tags:[\"file\"],NoGravity:true}")
    command("tp @e[type=ArmorStand,tag=fs] ~ ~3 ~")

    currFd = currFd + 1
    local fd = score("@e[type=ArmorStand,tag=fcreate]", OBJECTIVE_NAME)
    fd = currFd
    command("entitydata @e[type=ArmorStand,tag=fcreate] {Tags:[\"fd\"]}")

    for i = 1, #name do
        fwrite(currFd, name[i])
    end
    fsetpos(currFd, 1, 0)

    return currFd
end

function fgetc(fd)
    local val = 0
    _fs_uint8(fd, val, true)
    return val
end

function fwrite(fd, char)
    _fs_write_uint8(fd, char)
end

function fsetpos(fd, line, column)
    _fs_setpos(fd, line, column)
end

import("./fs.js")
