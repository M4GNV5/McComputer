var path = require("path");
var fs = require("fs");

var luaImport = scope.get("import");

exports.include = function(name)
{
    var luaFile = path.join(__dirname, name + ".lua");
    var jsFile = path.join(__dirname, name + ".js");
    if(fs.existsSync(luaFile))
    {
        luaImport(luaFile);
    }
    else if(fs.existsSync(jsFile))
    {
        luaImport(jsFile);
    }
    else
    {
        throw "Cannot include " + name;
    }
}
