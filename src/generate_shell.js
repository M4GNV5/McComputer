var fs = require("fs");
var programs = require("./../data/programs.json");
var strHash = require("./corelibs/util.js").strHash;

var base = "{0}\n\n" +
"function shell_launch(program, args)\n"+
"local proghash1 = program[1] * (2 ^ 16) + program[2] * (2 ^ 8) + program[3]\n" +
"local proghash2 = program[4] * (2 ^ 16) + program[5] * (2 ^ 8) + program[6]\n" +
"\n" +
"{1}\n" +
"end";

var files = [];
var launchCases = [];

for(var key in programs)
{
    var prog = programs[key];
    if(files.indexOf(prog.file) == -1)
        files.push(prog.file);

    var arg = prog.args ? "args" : "";
    var hash1 = strHash(key.substr(0, 3));
    var hash2 = strHash(key.substr(3, 3));
    var lCase = "elseif proghash1 == {0} and proghash2 == {1} then\n\t{2}({3})".format(hash1, hash2, prog.function, arg);
    launchCases.push(lCase);
}

var imports = [];
for(var i = 0; i < files.length; i++)
{
    imports.push("import(\"{0}\")".format(files[i]));
}

var code = base.format(imports.join("\n"), launchCases.join("\n").substr(4) + "\nend");
fs.writeFileSync("shell_launch.lua", code);
