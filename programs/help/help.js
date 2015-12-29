var fs = require("fs");
var path = require("path");

exports.commandList = function()
{
    var commands = [];
    function scanDir(dir)
    {
        var files = fs.readdirSync(dir);
        for(var i = 0; i < files.length; i++)
        {
            var extName = path.extname(files[i]);
            var name = path.basename(files[i], extName);

            if(extName == ".lua" && commands.indexOf(name) == -1)
                commands.push(name);
            else if(extName == "")
                scanDir(path.join(dir, files[i]));
        }
    }
    scanDir("./programs/");

    return commands.join(", ");
}
