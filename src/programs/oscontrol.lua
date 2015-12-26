function shutdown()
    command("kill @e[type=ArmorStand]")
end

function reboot()
    command("kill @e[type=ArmorStand]")
    command("setblock 0 5 0 command_block 0 replace {Command:\"setblock ~ ~ ~ air\",auto:true}")
end
