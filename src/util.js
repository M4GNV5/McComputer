var path = require("path");
var fs = require("fs");

var score = scope.get("score");
var scoreName = scope.get("OBJECTIVE_NAME");

var luaImport = scope.get("import");
var includes = require("./includes.json");

exports.include = function(name)
{
    if(!includes.hasOwnProperty(name))
        throw "Cannot include " + name;

    var files = includes[name];

    for(var i = 0; i < files.length; i++)
    {
        var file = path.resolve(path.join(__dirname, files[i]));
        luaImport(file);
    }
}

exports.charCode = function(s)
{
    return s.charCodeAt(0);
}

exports.str = function(s)
{
    s = (s || "").toUpperCase();
    var val = [];
    for(var i = 0; i < s.length; i++)
        val.push(s.charCodeAt(i));
    return [val];
}

exports.static_strhash = function(s)
{
    s = s.toUpperCase();
    var val0 = s.charCodeAt(0) << 24 || 0;
    var val1 = s.charCodeAt(1) << 16 || 0;
    var val2 = s.charCodeAt(2) << 8 || 0;
    var val3 = s.charCodeAt(3) || 0;
    return val0 + val1 + val2 + val3;
}

exports.scoreTp = function(sel, val, max, x, y, z)
{
    var start;
    for(var i = 1; i < max; i++)
    {
        if(Math.pow(2, i) >= max)
        {
            start = i;
            break;
        }
    }

    command("summon ArmorStand ~ ~ ~ {Tags:[\"scoreTp\"]}");
    var tpScore = score("@e[type=ArmorStand,tag=scoreTp]", scoreName);
    tpScore.set(val);

    for(var i = start; i >= 0; i--)
    {
        var step = Math.pow(2, i);
        var tpSel = "@e[type=ArmorStand,tag=scoreTp,score_{0}_min={1}]".format(scoreName, step);
        command("execute {0} ~ ~ ~ tp {1} ~{2} ~{3} ~{4}"
            .format(tpSel, sel, x * step, y * step, z * step));

        command("scoreboard players remove {0} {1} {2}".format(tpSel, scoreName, step));
    }

    command("kill @e[type=ArmorStand,tag=scoreTp]");
}

exports.log = console.log.bind(console);
