import("terminal.js")

function terminal_init()
    --40x24
    command("fill 1 10 0 40 34 0 air")
    command("fill 1 10 1 40 34 1 wool 15")
    command("kill " + terminal_selector)
    command("summon ArmorStand 40 34 0 {CustomName:\"terminal\",NoGravity:true}")
end

function terminal_clear()
    command("fill 0 10 0 40 34 0 air")
    command("tp " + terminal_selector + " 40 34 0")
end

function terminal_write(char)
    _terminal_write(char)
end
