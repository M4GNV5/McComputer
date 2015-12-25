var scoreName = scope.get("OBJECTIVE_NAME");
var tmpScoreName = "MoonCraftTmp";
var int = scope.get("int");

exports._fs_uint4 = function(fd, val, offsetX, offsetY, offsetZ, mode)
{
    var sel = exports.resolve_fd(fd);

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
}

exports._fs_uint8 = function(fd, val, autoNewline)
{
    var sel = exports.resolve_fd(fd);
    var left = int();
    var right = int();

    exports._fs_uint4(sel, left);
    exports._fs_uint4(sel, right, 0, 0, 1);

    command("tp {0} ~1 ~ ~".format(sel));

    if(autoNewline)
        command("execute {0} ~ ~ ~ detect ~ ~ ~ air -1 tp @e[type=ArmorStand,c=1] 1 ~ ~2".format(sel));

    left.multiplicate(16);
    left.add(right);
    val.set(left);
}

exports.resolve_fd = function(fd)
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
