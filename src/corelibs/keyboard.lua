import("chat")
import("./keyboard.js")

function keyboard_get() : int
    command("gamerule sendCommandFeedback false")

    command("scoreboard objectives add k trigger Keyboard input")
    command("scoreboard players enable @a k")
    local trigger = score("@a", "k")
    trigger = 0
    keyboard_show(trigger)

    repeat
        --wait
    until trigger ~= 0

    local singleVal = score("@p[score_k_min=1]", "k")
    local val = int(singleVal)

    return val
end
