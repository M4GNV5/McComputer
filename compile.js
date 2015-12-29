const MOONCRAFT = "/home/jakob/Documents/Github/MoonCraft/src/main.js";
const RCON = "/home/jakob/Documents/Github/MoonCraft/src/output/rcon.js";

var path = require("path");
var fs = require("fs");
var spawn = require('child_process').spawn;

var stuff = require("./compile.json");
var mtimeCache = {};
if(fs.existsSync("./compile-cache.json"))
	mtimeCache = require("./compile-cache.json");

var options = GLOBAL.options = require("./config.json");
var rconOutput = require(RCON);

var blocks = [];

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
    {
		if(blocks.length > 0)
		{
			console.log("\n\noutputting filenames and static files\n");
			rconOutput(blocks, []);
		}

		fs.writeFileSync("./compile-cache.json", JSON.stringify(mtimeCache, undefined, 4));
		return;
	}

    var name = stuff[i].name;
	var files = stuff[i].files;
	var type = stuff[i].type;

    var y = nextY;
    if(stuff[i].y)
        y = stuff[i].y;
    else
        nextY += 3;

	var lastCompile = mtimeCache[name];
	for(var ii = 0; ii < files.length; ii++)
	{
		var mtime = new Date(fs.statSync(files[ii]).mtime).getTime();

		if(ii + 1 == files.length && mtime < lastCompile)
		{
			console.log("\n\nignoring {0}".format(name));
			next(i + 1);
			return;
		}
		else if(mtime < lastCompile)
		{
			continue;
		}

		break;
	}

    console.log("\n\ncompiling {0}\n".format(name));

	if(type == "lib")
	{
		files = ["./src/util.js"].concat(files);
		var exp = "./include/{0}.d.lua".format(name);
		compile(1, y, 7, exp, files, stuff[i].args, function()
		{
			mtimeCache[name] = new Date().getTime();
			next(i + 1);
		});
		createFile(name, undefined, 1, y, 5);
	}
	else if(type == "program")
	{
		files = ["./src/program_head.lua"].concat(files, "./src/program_foot.lua");
		var exp = "./include/{0}.d.lua".format(name);
		compile(1, y, 7, undefined, files, stuff[i].args, function()
		{
			mtimeCache[name] = new Date().getTime();
			next(i + 1);
		});
		createFile(name, undefined, 1, y, 5);
	}
	else if(type == "text")
	{
		var content = fs.readFileSync(files[0]);
		createFile(name, content, 1, y, 5);
		next(i + 1);
	}
}

function compile(x, y, z, exp, files, args, cb)
{
	exp = exp ? "--export " + exp : "";
	var args = "{0} -x {1} -y {2} -z {3} {4} {5} {6}"
        .format(MOONCRAFT, x, y, z, exp, files.join(" "), args || "").replace(/\s\s+/g, " ").trim();

    run("node", args, cb);
}


function createFile(name, content, x, y, z)
{
	x = x || 1;
	z = z || 5;

	function writeChar(c)
	{
		c = c.toUpperCase();
		var code = c.charCodeAt(0);
		var left = (code >> 4) & 0xF;
		var right = code & 0xF;

		writeUInt8(left);
		z++;
		writeUInt8(right);
		z--;
	}
	function writeUInt8(val)
	{
		blocks.push({x: x, y: y, z: z, tagName: "wool", data: val});
	}

	var lines = [name + String.fromCharCode(0)];
	if(content)
		lines = lines.concat(content.split("\n"));

	var _x = x;
	for(var i = 0; i < lines.length; i++)
	{
		for(var ii = 0; ii < lines[i].length; ii++)
		{
			writeChar(lines[i][ii]);
			x++;
		}

		if(i + 1 == lines.length && content)
			writeChar(String.fromCharCode(0));

		z += 2;
		x = _x;
	}
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
		{
			fs.writeFileSync("./compile-cache.json", JSON.stringify(mtimeCache, undefined, 4));
			process.exit(code);
		}

        cb();
    });
}
