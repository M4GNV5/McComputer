import("terminal.js")

function terminal_init() : void
    --40x24
    command("fill 1 10 0 40 34 0 air")
    command("fill 1 9 1 40 34 1 wool 15")
    command("kill " + terminal_selector)
    command("summon ArmorStand 40 34 0 {CustomName:\"terminal\",NoGravity:true}")
end

function terminal_clear() : void
    command("fill 0 10 0 40 34 0 air")
    command("tp " + terminal_selector + " 40 34 0")
end

function terminal_write(char : int) : void
    if char == 8 then       -- backspace
        command("tp " + terminal_selector + " ~1 ~ ~")
        command("execute " + terminal_selector + " ~ ~ ~ detect ~ ~ ~1 air -1 tp " + terminal_selector + " 1 ~2 ~")
        command("execute " + terminal_selector + " ~ ~ ~ setblock ~ ~ ~ wall_banner 2 replace " + bannertag(" "))
    elseif char == 9 then   -- tab
        terminal_static_write("    ")
    elseif char == 10 then  -- new line
        terminal_static_writeln("")
    else
        _terminal_write(char)
    end
end

function terminal_write_str(str : table) : void
    for i = 1, #str do
        _terminal_write(str[i])
    end
end
