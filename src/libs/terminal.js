var letters = require("./../../data/letters.json");

var sizeX = exports.terminal_size_x = 40;
var sizeY = exports.terminal_size_y = 24;
var selector = exports.terminal_selector = "@e[name=terminal,type=ArmorStand]";

var scoreName = scope.get("OBJECTIVE_NAME");

exports.terminal_static_writeln = function(s)
{
    s = s || "";
    exports.terminal_static_write(s + "\n");
}

exports.terminal_static_write = function(s)
{
    var _lines = s.split("\n");
    var lines = [];
    for(var i = 0; i < _lines.length; i++)
        lines = lines.concat(_lines[i].match(/[^\n]{1,40}/g) || _lines[i]);

    exports.terminal_static_free(lines[0].length);

    for(var i = 0; i < lines.length; i++)
    {
        var line = lines[i];
        for(var ii = 0; ii < line.length; ii++)
        {
            var tag = bannertag(line[ii]);
            command("execute {0} ~ ~ ~ setblock ~-{1} ~-{2} ~ wall_banner 2 replace {3}"
                .format(selector, ii, i * 2, tag));
        }
    }

    var x = 40 - lines[lines.length - 1].length;
    var y = lines.length * 2 - 2;
    command("tp {0} {1} ~-{2} ~".format(selector, x, y));
}

exports.terminal_static_free = function(length)
{
    if(length < 1)
        return;

    command("execute {0} ~ ~ ~ detect ~-{1} ~ ~1 air -1 tp {0} 40 ~-2 ~".format(selector, length - 1));
}

exports._terminal_write = function(val)
{
    command("scoreboard players operation {0} {2} = {1} {2}".format(selector, val.name, scoreName));
    exports.terminal_static_free(1);
    var supportedLetters = Object.keys(letters);
    for(var i = 0; i < supportedLetters.length; i++)
    {
        var tag = letters[supportedLetters[i]];
        var charCode = supportedLetters[i].charCodeAt(0);
        var sel = "@e[name=terminal,type=ArmorStand,score_{0}_min={1},score_{0}={1}]".format(scoreName, charCode);
        command("execute {0} ~ ~ ~ setblock ~ ~ ~ wall_banner 2 replace {1}".format(sel, tag));
    }
    command("tp {0} ~-1 ~ ~".format(selector));
}

var bannertag = exports.bannertag = function(s)
{
    if(typeof f == "number")
        s = String.fromCharCode(s).toUpperCase();
    else
        s = s.toString().toUpperCase()[0];
    return letters[s];
}
