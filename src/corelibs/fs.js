var scoreName = scope.get("OBJECTIVE_NAME");
var tmpScoreName = "MoonCraftTmp";

var int = scope.get("int");
var util = require("./util.js");
var scoreTp = util.scoreTp;
var strTable = util.strTable;

var fopen_id = scope.get("fopen_id");
var fopen_name = scope.get("fopen_name");

exports.fopen = function(file)
{
    if(typeof file == "number" || file.constructor.name == "Integer")
        return fopen_id(file);
    else if(typeof file == "string")
        return fopen_name(strTable(file)[0]);
    else if(file instanceof Array || file.constructor.name == "Table")
        return fopen_name(file);

    throw "invalid fopen " + file;
}

exports.fcount = function()
{
    var val = int();
    command("execute @e[type=ArmorStand,tag=file] ~ ~ ~ scoreboard players add {0} {1} 1".format(val.name, scoreName));
    return val;
}

exports._fs_setpos = function(fd, line, column)
{
    var sel = exports._fs_resolve_fd(fd);
    command("execute {0} ~ ~ ~ tp {0} @e[type=ArmorStand,tag=file,c=1]".format(sel));
    scoreTp(sel, line, 12, 0, 0, 2);
    scoreTp(sel, column, 40, 1, 0, 0);
}

exports._fs_read_uint4 = function(fd, val, offsetX, offsetY, offsetZ, autoNewline)
{
    var sel = exports._fs_resolve_fd(fd);

    offsetX = "~" + (offsetX || "");
    offsetY = "~" + (offsetY || "");
    offsetZ = "~" + (offsetZ || "");

    var valSel = val.selector || val.name;
    var _scoreName = val.scoreName || scoreName;

    for(var i = 0; i < 16; i++)
    {
        command("execute {0} ~ ~ ~ detect {1} {2} {3} wool {4} scoreboard players set {5} {6} {4}"
            .format(sel, offsetX, offsetY, offsetZ, i, valSel, _scoreName));
    }

    if(autoNewline)
        command("execute {0} ~ ~ ~ detect ~ ~ ~ air -1 scoreboard players set {1} {2} {3}".format(sel, valSel, _scoreName, 10));
}

exports._fs_read_uint8 = function(fd, val, autoNewline)
{
    var sel = exports._fs_resolve_fd(fd);
    var left = int();
    var right = int();

    exports._fs_read_uint4(sel, left);
    exports._fs_read_uint4(sel, right, 0, 0, 1, autoNewline);

    if(autoNewline)
        command("execute {0} ~ ~ ~ detect ~ ~ ~ air -1 tp @e[type=ArmorStand,c=1] 0 ~ ~2".format(sel));

    command("tp {0} ~1 ~ ~".format(sel));

    left.multiplicate(16);
    left.add(right);
    val.set(left);
}

exports._fs_write_uint4 = function(fd, val, offsetX, offsetY, offsetZ)
{
    var sel = exports._fs_resolve_fd(fd);

    offsetX = "~" + (offsetX || "");
    offsetY = "~" + (offsetY || "");
    offsetZ = "~" + (offsetZ || "");

    var valSel = val.selector || val.name;
    var _scoreName = val.scoreName || scoreName;

    var _sel = "@e[type=ArmorStand,tag=fwrite]";
    command("scoreboard players operation {0} {1} = {2} {3}".format(_sel, scoreName, valSel, _scoreName));

    for(var i = 0; i < 16; i++)
    {
        _sel = "@e[type=ArmorStand,tag=fwrite,score_{0}_min={1},score_{0}={1}]".format(scoreName, i);
        command("execute {0} ~ ~ ~ execute {1} ~ ~ ~ setblock {2} {3} {4} wool {5} replace" //
            .format(_sel, sel, offsetX, offsetY, offsetZ, i));
    }
}

exports._fs_write_uint8 = function(fd, val)
{
    var sel = exports._fs_resolve_fd(fd);
    var left = int(val);
    var right = int(val);
    left.divide(16);
    right.mod(16);

    command("summon ArmorStand ~ ~ ~ {Tags:[\"fwrite\"],NoGravity:true}");

    exports._fs_write_uint4(sel, left);
    exports._fs_write_uint4(sel, right, 0, 0, 1);

    command("tp {0} ~1 ~ ~".format(sel));

    command("kill @e[type=ArmorStand,tag=fwrite]");
}

exports._fs_resolve_fd = function(fd)
{
    if(typeof fd == "string")
    {
        return fd;
    }
    else
    {
        var sel = "@e[type=ArmorStand,tag=fd]";
        var fdScoreName = fd.scoreName || scoreName;
        var selfSel = "@e[type=ArmorStand,c=1,r=0,tag=fd]";

        command("execute {0} ~ ~ ~ scoreboard players operation {1} {2} = {1} {3}".format(sel, selfSel, tmpScoreName, scoreName));
        command("execute {0} ~ ~ ~ scoreboard players operation {1} {2} -= {3} {4}".format(sel, selfSel, tmpScoreName, fd.name, scoreName));

        return "@e[type=ArmorStand,tag=fd,score_{0}_min=0,score_{0}=0]".format(tmpScoreName);
    }
}
