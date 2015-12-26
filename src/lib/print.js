var write = scope.get("terminal_write");
var swrite = scope.get("terminal_static_write");
var swriteln = scope.get("terminal_static_writeln");

var print_str = scope.get("print_str");
var print_float = scope.get("print_float");
var print_int = scope.get("print_int");
var print_bool = scope.get("print_bool");

exports.print_char = function(c)
{
    write(c);
}

exports.printf = function(msg)
{
    var printFormats = {
        "s": print_str,
        "f": print_float,
        "d": print_int,
        "i": print_int,
        "b": print_bool,
        "c": exports.print_char
    };

    var i = 1;
    var index = msg.indexOf("%");
    var start = 0;
    while(index != -1)
    {
        var format = msg[index + 1];
        if(printFormats.hasOwnProperty(format))
        {
            var before = msg.substring(0, index);
            if(before.length > 0)
                swrite(before);

            printFormats[format](arguments[i]);
            i++;
            msg = msg.substr(index + 2);
        }
        else
        {
            start += 2;
        }

        index = msg.indexOf("%", start);
    }
    if(msg.length > 0)
        swrite(msg);
}
