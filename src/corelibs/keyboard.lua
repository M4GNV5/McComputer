import("chat")
import("./keyboard.js")

function keyboard_get() : int
    val = 0
    --command("gamerule sendCommandFeedback false")
    keyboard_show(val)

    repeat
        --wait
    until val ~= 0

    return val
end
