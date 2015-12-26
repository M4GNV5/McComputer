function no_directories()
    terminal_static_writeln("There is only one directory you fool")
end

function hcf()
    command("execute " .. terminal_selector .. " ~ ~ ~ setblock ~ ~ ~ fire 0 {alt:0,south:true}")
    command("kill @e[type=ArmorStand]")
end
