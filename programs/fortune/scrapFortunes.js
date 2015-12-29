var spawn = require('child_process').spawn;
var fs = require("fs");

var fortunes = [];

function doNext()
{
    var p = spawn("fortune");

    var output = [];

    p.stdout.on("data", function (data)
    {
        output.push(data);
    });

    p.stderr.on("data", function (data)
    {
        output.push(data);
    });

    p.on("close", function()
    {
        var fortune = output.join("").replace(/\n/g, " ").replace(/\t/g, "  ");
        if(fortune.length < 40 && fortunes.indexOf(fortune) == -1)
            fortunes.push(fortune);

        if(fortunes.length < 20)
            setTimeout(doNext, 1);
        else
            fs.writeFileSync(__dirname + "/fortunes.txt", fortunes.join("\n"));
    });
}

setTimeout(doNext, 1);
