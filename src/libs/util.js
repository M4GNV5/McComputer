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

exports.strHash = function(s)
{
    s = s.toUpperCase()
    return (s.charCodeAt(0) << 16) + (s.charCodeAt(1) << 8) + s.charCodeAt(2);
}

exports.log = console.log.bind(console);
