command("execute @e[type=ArmorStand,tag=stack,score_" .. OBJECTIVE_NAME .. "=1] ~ ~ ~ setblock ~ ~ ~ command_block 0 replace {Command:\"setblock ~ ~ ~ air\",auto:1b}")
command("kill @e[type=ArmorStand,tag=stack,score_" .. OBJECTIVE_NAME .. "=1]");
command("scoreboard players remove @e[type=ArmorStand,tag=stack] " .. OBJECTIVE_NAME .. " 1");
