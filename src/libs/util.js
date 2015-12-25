exports.charCode = function(s)
{
    return s.charCodeAt(0);
}

exports.strTable = function(s)
{
    s = (s || "").toUpperCase();
    var val = [];
    for(var i = 0; i < s.length; i++)
        val.push(s.charCodeAt(i));
    return [val];
}

exports.log = console.log.bind(console);
