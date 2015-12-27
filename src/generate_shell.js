var fs = require("fs");
var programs = require("./../data/programs.json");
var strHash = require("./corelibs/util.js").static_strhash;

var base = "{0}\n\n" +
"function shell_launch(program, args)\n"+
"local proghash = strhash(program)\n" +
"local exitcode = 0\n" +
"\n" +
"{1}\n" +
"else\n" +
"\texitcode = -1\n" +
"end\n" +
"return exitcode\n" +
"end";

var files = [];
var launchCases = [];

for(var key in programs)
{
    var prog = programs[key];
    if(files.indexOf(prog.file) == -1)
        files.push(prog.file);

    var arg = prog.args ? "args" : "";
    var hash = strHash(key);
    var lCase = "elseif proghash == {0} then\n\texitcode = int({1}({2}))".format(hash, prog.function, arg);
    launchCases.push(lCase);
}

var imports = [];
for(var i = 0; i < files.length; i++)
{
    imports.push("import(\"{0}\")".format(files[i]));
}

var code = base.format(imports.join("\n"), launchCases.join("\n").substr(4));
fs.writeFileSync("shell_launch.lua", code);
