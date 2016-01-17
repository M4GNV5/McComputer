include("stdio")
include("stdlib")
include("string")
import("./cc.js")

local OPERATOR = 2 ^ 31 - 1

local precedence = {}
precedence[charCode("=")] = 1
precedence[charCode("|") * 256 + charCode("|")] = 2 -- ||
precedence[charCode("&") * 256 + charCode("&")] = 3 -- &&
precedence[charCode("<")] = 4
precedence[charCode(">")] = 4
precedence[charCode("=") * 256 + charCode("=")] = 4 -- ==
precedence[charCode("!") * 256 + charCode("=")] = 4 -- !=
precedence[charCode("<") * 256 + charCode("=")] = 4 -- <=
precedence[charCode(">") * 256 + charCode("=")] = 4 -- >=
precedence[charCode("+")] = 5
precedence[charCode("-")] = 5
precedence[charCode("*")] = 6
precedence[charCode("/")] = 6
precedence[charCode("%")] = 6
precedence[charCode("!")] = 7
precedence[charCode("+") * 256 + charCode("+")] = 8 -- ++

local function main()
	local infile, outfile = strsplit(arguments, charCode(" ")) -- cc <in> <out>

	if not (#infile and #outfile) then
		printf("Usage: cc <input> <output>\n")
		return
	end

	local fd = fopen(infile)
	if fd == 0 then
		printf("Could not open file %s\n", infile)
		return
	end

	local outFd = fopen(outfile)
	if outFd == 0 then
		outFd = fcreate(outfile)
	end

	printf("Reading file...\n")
	local src = fgets(fd) -- we could just do fgetc whenever we need but fgets is faster
	fclose(fd)
	local opstack, postfix = {}, {}
	local i, curr = 1, src[i]

	printf("Compiling...\n")
	out_init(outFd)

	local function readMasked(min : int, max : int) : table
		local val = {}
		while curr >= min and curr <= max do
			val[#val + 1] = curr
			i = i + 1
			curr = src[i]
		end

		return val
	end

	local function skipSpaces() : void
		while curr == charCode(" ") or curr == charCode("\n") or curr == charCode("\t") do
			i = i + 1
			curr = src[i]
		end
	end

	local function consume(val : table) : bool
		skipSpaces()
		for j = 1, #val do
			if curr ~= val[j] then
				printf("Expecting %s got \"%c\" at %d\n", val, curr, i)
				return true
			end
			i = i + 1
			curr = src[i]
		end

		return false
	end

	local function readIdentifier() : bool, table
		local val = readMasked(charCode("A"), charCode("Z"))
		if #val > 0 then
			return false, val
		else
			return true, {curr}
		end
	end

	local function createNum(val : int)
		simpleOp("set", "edx", 0)
		local vals = {}
		if val >= 16 then
			while val > 0 do
				table_insert(vals, 1, val % 16)
				val = val / 16
			end

			simpleOp("set", "static16", 16)
		else
			vals = {val}
		end

		for j = 1, #vals do
			if j > 1 then
				operation("edx", "*=", "static16")
			end
			_createNum(vals[j], "edx")
		end
	end

	local function handleOp(op : int)
		local opPrecedence = precedence[op]
		while precedence[opstack[1]] >= opPrecedence and #opstack do
			postfix[#postfix + 1] = OPERATOR
			postfix[#postfix + 1] = opstack[1]
			table_remove(opstack, 1)
		end

		table_insert(opstack, 1, op)
	end

	local function compileExpression() : bool

		while curr ~= charCode(";") and curr ~= 0 do

			curr = src[i]
			local next = src[i + 1]
			skipSpaces()

			if curr >= charCode("0") and curr <= charCode("9") then
				local val = readMasked(charCode("0"), charCode("9"))
				postfix[#postfix + 1] = atoi(val)
			elseif precedence[curr * 256 + next] then
				handleOp(curr * 256 + next)
				i = i + 2
			elseif precedence[curr] then
				handleOp(curr)
				i = i + 1
			elseif curr == charCode("(") then
				table_insert(opstack, 1, charCode("("))
				i = i + 1
			elseif curr == charCode(")") then
				while opstack[1] ~= charCode("(") and #opstack do
					postfix[#postfix + 1] = OPERATOR
					postfix[#postfix + 1] = opstack[1]
					table_remove(opstack, 1)
				end
				table_remove(opstack, 1)
				i = i + 1
			else
				printf("Unexpected token \"%d\"\n", curr)
				return true
			end
		end

		handleOp(0) -- add all remaining ops on opstack to postfix
		table_remove(opstack, 1)

		if curr == charCode(";") then
			i = i + 1
			curr = src[i]
		else
			printf("Expecting ; got \"%c\"\n", curr)
			return true
		end

		for j = 1, #postfix do
			if postfix[j] == OPERATOR then
				j = j + 1
				local op = postfix[j]

				local function postCompareOp()
					simpleOp("set", getStack(1), 1, true)
					negate(-2)
					simpleOp("set", getStack(1), 0, true)
				end
				local function postNegateOp()
					simpleOp("set", getStack(1), 0, true)
					negate(-2)
					simpleOp("set", getStack(1), 1, true)
				end

				if op == charCode("=") then
					--TODO
				elseif op == charCode("|") * 256 + charCode("|") then
					test(getStack(2), 0, 0)
					operation(getStack(2), "=", getStack(1), true)
					pop()
				elseif op == charCode("&") * 256 + charCode("&") then
					test(getStack(2), 0, 0)
					negate()
					operation(getStack(2), "=", getStack(1), true)
					pop()
				elseif op == charCode("<") then
					math("-=")
					test(getStack(1), "*", 1)
					postCompareOp()
				elseif op == charCode(">") then
					math("-=")
					test(getStack(1), 1, "*")
					postCompareOp()
				elseif op == charCode("=") * 256 + charCode("=") then
					math("-=")
					test(getStack(1), 0, 0)
					postCompareOp()
				elseif op == charCode("!") * 256 + charCode("=") then
					math("-=")
					test(getStack(1), 0, 0)
					postNegateOp()
				elseif op == charCode("<") * 256 + charCode("=") then
					math("-=")
					test(getStack(1), "*", 0)
					postCompareOp()
				elseif op == charCode(">") * 256 + charCode("=") then
					math("-=")
					test(getStack(1), 0, "*")
					postCompareOp()
				elseif op == charCode("+") then
					math("+=")
				elseif op == charCode("-") then
					math("-=")
				elseif op == charCode("*") then
					math("*=")
				elseif op == charCode("/") then
					math("/=")
				elseif op == charCode("%") then
					math("%=")
				elseif op == charCode("!") then
					test(getStack(1), 0, 0)
					postNegateOp()
				elseif op == charCode("+") * 256 + charCode("+") then
					simpleOp("add", getStack(1), 1)
				end
			else
				push(postfix[j])
			end
		end

		return false
	end

	local function compileBody() : bool
		local err = consume(str("{"))

		while curr ~= charCode("}") and curr ~= 0 and not err do
			err = compileExpression()
			skipSpaces()
		end

		err = err or consume(str("}"))
		if err then
			return true
		end
		return false
	end

	skipSpaces()
	while i <= #src do
		local err, type = readIdentifier()
		local typeHash = strhash(type)
		if err or (typeHash ~= static_strhash("void") and typeHash ~= static_strhash("int")) then
			printf("Expecting \"void\" or \"int\" got %s at %d\n", type, i)
			--printPos()
			return
		end

		skipSpaces()
		local err, name = readIdentifier()
		if err then
			printf("Expecting IDENTIFIER got %s\n", type)
			--printPos()
			return
		end

		consume(str("("))
		-- TODO function arguments
		consume(str(")"))
		compileBody()
		skipSpaces()
	end

	fclose(outFd)
	printf("Done, type \"%s\" to run the program\n", outfile)
end
main()
