const MOONCRAFT = "/home/jakob/Documents/Github/MoonCraft/src/main.js";
var path = require("path");
var spawn = require('child_process').spawn;
var stuff = require("./compile.json");

String.prototype.format = function()
{
	var val = this;
	for(var i = 0; i < arguments.length; i++)
		val = val.replace(new RegExp("\\{" + i + "\\}", "g"), arguments[i]);
	return val;
};

var nextY = 10;
next(0);

function next(i)
{
    if(i >= stuff.length)
        return;

    var name = stuff[i].name;
    var files = stuff[i].files;

    var y = nextY;
    if(stuff[i].y)
        y = stuff[i].y;
    else
        nextY += 3;

    console.log("\n\ncompiling {0}\n".format(name));

    var args = "{0} -x 1 -y {1} -z 7 --export ./include/{2}.d.lua ./src/util.lua {3} {4}"
        .format(MOONCRAFT, y, name, files.join(" "), stuff[i].args || "").trim();

    run("node", args, next.bind(undefined, i + 1));
}

function run(cmd, args, cb)
{
    if(typeof args == "string")
        args = args.split(" ");

    console.log(cmd + " " + args.join(" "));
    var p = spawn(cmd, args);

    p.stdout.on("data", function (data)
    {
		var _data = data.toString().trim();
		if(_data.length > 0)
        	console.log(_data);
    });

    p.stderr.on("data", function (data)
    {
		var _data = data.toString().trim();
		if(_data.length > 0)
        	console.log(_data);
    });

    p.on("close", function(code)
    {
        if(code != 0)
            process.exit(code);

        cb();
    });
}
