import("./fs.js")

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
function fopen(name)
    command("execute @e[type=ArmorStand,tag=file] ~ ~ ~ summon ArmorStand ~ ~ ~ {Tags:[\"fopen\"],NoGravity:true}")

    name[#name + 1] = 0

    for i = 1, #name do

        local selfScore = score("@e[type=ArmorStand,tag=fopen,c=1]", OBJECTIVE_NAME)
        _fs_uint8("@e[type=ArmorStand,tag=fopen]", selfScore)

        local curr = name[i]
        command("execute @e[type=ArmorStand,tag=fopen] ~ ~ ~ " ..
            "scoreboard players operation @e[type=ArmorStand,tag=fopen,c=1] "..OBJECTIVE_NAME.." -= "..js_eval("curr.name").." "..OBJECTIVE_NAME)

        command("kill @e[type=ArmorStand,tag=fopen,score_" .. OBJECTIVE_NAME .. "_min=1]")
        command("kill @e[type=ArmorStand,tag=fopen,score_" .. OBJECTIVE_NAME .. "=-1]")
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

function fgetc(fd)
    local val = 0
    _fs_uint8(fd, val, true)
    return val
end
