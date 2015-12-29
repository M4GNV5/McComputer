var write = scope.get("terminal_write");
var writestr = scope.get("terminal_write_str");
var swrite = scope.get("terminal_static_write");
var swriteln = scope.get("terminal_static_writeln");

exports.print_char = function(c)
{
    write(c);
}

exports.print_str = function(s)
{
    writestr(s);
}

exports.printf = function(msg)
{
    var printFormats = {
        "s": exports.print_str,
        "f": scope.get("print_float"),
        "d": scope.get("print_int"),
        "i": scope.get("print_int"),
        "b": scope.get("print_bool"),
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
