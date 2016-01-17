var scoreName = "cvar";
var indexScoreName = "cstack";
var score = scope.get("score");
var resolveFd = require("../../src/corelibs/fs.js")._fs_resolve_fd;
var sel;
var stack = "cstack";

var cmd = exports.cmd = function(_cmd, cond, condPlace)
{
	var data = cond ? 13 : 5;
	command("execute {0} ~ ~ ~ setblock ~ ~ ~ chain_command_block {1} replace {auto:1b,Command:{2}}"
		.format(sel, data, JSON.stringify(_cmd)), condPlace);
	command("tp {0} ~1 ~ ~".format(sel), true);
}
var getStack = exports.getStack = function(i)
{
	return "@e[type=ArmorStand,tag={0},score_{1}_min={2},score_{1}={2}]".format(stack, indexScoreName, i);
}
var simpleOp = exports.simpleOp = function(op, name, val, cond)
{
	cmd(["scoreboard players", op, name, scoreName, val].join(" "), cond);
}
var operation = exports.operation = function(a, op, b, cond)
{
	cmd(["scoreboard players operation", a, scoreName, op, b, scoreName].join(" "), cond);
}

exports.test = function(val, min, max)
{
	cmd(["scoreboard players test", val, scoreName, min, max].join(" "));
}
exports.negate = function(offset)
{
	offset = offset || -1;
	cmd("testforblock ~{0} ~ ~ minecraft:chain_command_block -1 {SuccessCount:0}".format(offset));
}

exports.out_init = function(outFd)
{
	sel = resolveFd(outFd);

	cmd("kill @e[type=ArmorStand,tag={0}]".format(stack));
	cmd("scoreboard objectives add {0} dummy".format(scoreName));
	cmd("scoreboard objectives add {0} dummy".format(indexScoreName));
}

exports.push = function(val)
{
	cmd("summon ArmorStand ~ ~1 ~ {NoGravity:1,Tags:[\"{0}\"],CustomName:\"C\"}".format(stack));
	cmd("scoreboard players add @e[type=ArmorStand,tag={0}] {1} 1".format(stack, indexScoreName));

	scope.get("createNum")(val);
	operation(getStack(1), "=", "edx");
}

exports.pop = function(val)
{
	if(val)
		operation(val, "=", getStack(1));

	cmd("kill " + getStack(1, stack));
	cmd("scoreboard players remove @e[type=ArmorStand,tag={0}] {1} 1".format(stack, indexScoreName));
}

exports.math = function(op)
{
	var a = getStack(2);
	var b = getStack(1);

	operation(a, op, b);
	exports.pop(undefined);
}

exports._createNum = function(val, name)
{
	for(var i = 0; i < 16; i++)
	{
		command(val.isExact(i));
		cmd("scoreboard players add {0} {1} {2}".format(name, scoreName, i), false, true);
	}
}
