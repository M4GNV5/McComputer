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

    for(var i = 0; i < lines.length; i++)
    {
        var line = lines[i];
        exports.terminal_static_free(line.length);
        for(var ii = 0; ii < line.length; ii++)
        {
            var tag = bannertag(line[ii]);
            command("execute {0} ~ ~ ~ setblock ~-{1} ~ ~ wall_banner 2 replace {2}"
                .format(selector, ii, tag));
        }

        if(i + 1 < lines.length)
            command("tp {0} 40 ~-2 ~".format(selector));
        else
            command("tp {0} ~-{1} ~ ~".format(selector, lines[i].length));
    }
}

exports.terminal_static_free = function(length)
{
    if(length > 0)
        command("execute {0} ~ ~ ~ detect ~-{1} ~ ~1 air -1 tp {0} 40 ~-2 ~".format(selector, length - 1));

    command("execute {0} ~ ~ ~ detect ~ ~ ~1 air -1 clone 0 10 0 40 32 0 0 12 0 replace force".format(selector));
    command("execute {0} ~ ~ ~ detect ~ ~ ~1 air -1 fill 0 9 0 40 10 0 air".format(selector));
    command("execute {0} ~ ~ ~ detect ~ ~ ~1 air -1 tp {0} 40 10 0".format(selector));
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
