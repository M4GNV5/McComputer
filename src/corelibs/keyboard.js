var fs = require("fs");
var layout = fs.readFileSync(__dirname + "/../../data/keyboardlayout.txt").toString();
var supportedLetters = Object.keys(require("./../../data/letters.json"));

var specialChars = {
    "ENTER": "\n".charCodeAt(0),
    "SPACE": " ".charCodeAt(0),
    "TAB": "\t".charCodeAt(0),
    "BACKSPACE": 8
}

var tellraw = scope.get("tellraw");
var chat_message = scope.get("chat_message");
var chat_event = scope.get("chat_event");

var scoreName = scope.get("OBJECTIVE_NAME");

exports.keyboard_show = function(val)
{
    var cmd = "/trigger {0} set ".format(val.scoreName);
    var lines = layout.split("\n");

    tellraw((new Array(20 - lines.length + 1)).join("\n"));

    for(var i = 0; i < lines.length; i++) //split into multiple commands or command is too long for rcon
    {
        var args = [];
        var line = lines[i];

        for(var ii = 0; ii < line.length; ii++)
        {
            var cont = false;
            for(var key in specialChars)
            {
                if(line.substr(ii).indexOf(key) == 0)
                {
                    var ev = chat_event("run_command", cmd + specialChars[key]);
                    args.push(chat_message(key, "red", false, ev));

                    ii += key.length - 1;
                    cont = true;
                    break;
                }
            }
            if(cont)
                continue;

            var code = line.charCodeAt(ii);
            var ev = chat_event("run_command", cmd + code);

            if(supportedLetters.indexOf(line[ii]) == -1 || code == 32) //not supported or char is space
                args.push(line[ii]);
            else
                args.push(chat_message(line[ii], false, false, ev));
        }

        if(args.length > 0)
            tellraw.apply(undefined, args);
    }
}
