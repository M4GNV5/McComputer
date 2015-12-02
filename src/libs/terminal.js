var letters = require("./letters.json");

var sizeX = exports.terminal_size_x = 40;
var sizeY = exports.terminal_size_y = 24;
var selector = exports.terminal_selector = "@e[name=terminal,type=ArmorStand]";

exports.terminal_static_writeln = function(s)
{
    var lines = s.match(/[^\n]{1,40}/g);
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

    var y = lines.length * 2;
    command("tp {0} 40 ~-{1} ~".format(selector, y));
}

exports.terminal_static_free = function(length)
{
    command("execute {0} ~ ~ ~ detect ~-{1} ~ ~1 air -1 tp {0} 40 ~-2 ~".format(selector, length));
}

exports._terminal_write = function(val)
{
    command("scoreboard players operation {0} cplVars = {1} cplVars".format(selector, val.name));
    exports.terminal_static_free(1);
    var supportedLetters = Object.keys(letters);
    for(var i = 0; i < supportedLetters.length; i++)
    {
        var tag = letters[supportedLetters[i]];
        var charCode = supportedLetters[i].charCodeAt(0);
        var sel = "@e[name=terminal,type=ArmorStand,score_cplVars_min={0},score_cplVars={0}]".format(charCode);
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
