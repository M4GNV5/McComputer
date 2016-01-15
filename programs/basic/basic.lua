import("./math_eval.lua")
include("stdio")
include("stdlib")
include("dictionary")

local function main()
	local fd = fopen(arguments)
	if fd == 0 then
		printf("could not open file %s", arguments)
	end

	local INT, FLOAT, STRING = 1, 2, 3
	local i, curr, line = 1, 0, 1
	local src, scope, lines = {}, {}, {}

	local function readUntil(abort : int) : table
		local val = {}
		repeat
			val[#val + 1] = curr
			curr = fgetc(fd)
		until curr == abort or curr == charCode("\n") or curr == 0

		return val
	end

	local function skipSpaces() : void
		while curr == charCode(" ") do
			curr = fgetc(fd)
		end
	end

	local function readNumber() : bool, int
		skipSpaces()
		if curr < charCode("0") or curr > charCode("9") then
			printf("Expecting number got \"%c\" near line %d\n", curr, line)
			return true, 0
		end

		local val = atoi(readUntil(charCode(" ")))
		return false, val
	end

	local function readIdentifier() : bool, table
		skipSpaces()
		if curr < charCode("A") or curr > charCode("Z") then
			printf("Expecting indentifier got \"%c\" near line %d\n", curr, line)
			return true, {}
		end

		local val = readUntil(charCode(" "))
		return false, val
	end

	local function parseExpression() : bool, table
		skipSpaces()

		if curr == charCode("\"") then
			curr = fgetc(fd)
			local val = readUntil(charCode("\""))
			table_insert(val, 1, STRING)
			curr = fgetc(fd)

			return false, val
		else
			local expression = readUntil(charCode(" "))
			local err, result = math_eval(expression, scope)
			return err, {INT, result}
		end
	end

	local function jump(_target : table) : bool
		local target = 1
		if _target[1] == INT then
			target = _target[2]
		elseif _target[1] == FLOAT then
			target = _target[2] / 100
		else
			printf("Invalid jump target near line %d\n", line)
			return true
		end

		if lines[target] == 0 then
			printf("Line %d does not exist near line %d\n", target, line)
			return true
		end

		fsetpos(fd, lines[target], 0)
		return false
	end

	local function consume(val : table) : bool
		skipSpaces()
		for j = 1, #val do
			if curr ~= val[j] then
				printf("Expecting %s got %c near line %d\n", val, curr, line)
				return true
			end
			curr = fgetc(fd)
		end

		return false
	end

	local function parseLine() : bool

		local err1, err2, err3, err4 = false, false, false, false
		err1, line = readNumber()

		local op = {}
		err2, op = readIdentifier()

		if err1 or err2 then
			return true
		end

		local opHash = strhash(op)

		if opHash == static_strhash("REM") then
			return false

		elseif opHash == static_strhash("LET") then
			local name, value = {}, {}
			err1, name = readIdentifier()
			err2 = consume(str("="))
			err3, value = parseExpression()

			scope = dict_set(scope, name, value)

		elseif opHash == static_strhash("IF") then
			local condition, target = {}, {}
			err1, condition = parseExpression()
			err2 = consume(str("THEN"))
			err3, target = parseExpression()

			if condition[1] == INT or condition[1] == FLOAT then
				if condition[2] then
					err4 = jump(target)
				end
			else
				printf("Invalid condition in if statement near line %d\n", line)
				return true
			end

		elseif opHash == static_strhash("PRINT") then
			local val = {}
			err1, val = parseExpression()

			if val[1] == INT then
				printf("%d", val[2])
			--[[elseif val[1] == FLOAT then
				printf("%f", floatFromBase(val[2])) TODO]]
			elseif val[1] == STRING then
				table_remove(val, 1)
				printf("%s", val)
			end
			printf("\n")

		elseif opHash == static_strhash("INPUT") then
			local input, name = {}, {}
			err1, name = readIdentifier()

			if err1 then
				return true
			end

			repeat --copy pasta from shell until we get scanf
	            local c = getchar()

	            if c == 8 then -- backspace
	                table_remove(input, #input)
	            elseif c == charCode("\n") then
	                -- dont append new lines to input
	            else
	                input[#input + 1] = c
	            end

	            printf("%c", c)
	        until c == charCode("\n")

			local val = atoi(input)
			scope = dict_set(scope, name, {INT, val})

		elseif opHash == static_strhash("END") or opHash == static_strhash("STOP") then
			return true

		else
			printf("Invalid statement %s near line %d\n", op, line)
			return true
		end

		if err1 or err2 or err3 or err4 then
			import("debug")
			debug()
			return true
		end

		return false
	end

	local function parseLineNumbers() : bool
		local fLine = 1
		repeat
			fsetpos(fd, fLine, 0)
			curr = fgetc(fd)
			if curr == 0 then
				fsetpos(fd, 1, 0)
				return false
			end

			local err, line = readNumber()
			if err then
				return true
			end

			lines[line] = fLine
			fLine = fLine + 1
		until false
	end

	if parseLineNumbers() then
		return
	end

	repeat
		curr = fgetc(fd)
		local err = parseLine()
		if err then
			fclose(fd)
			return
		end

		if curr ~= charCode("\n") then
			skipSpaces()
			local rest = readUntil(charCode("\n"))
			if #rest > 0 then
				printf("Expecting \\n got \"%s\" near line %d\n", rest, line)
				return
			end
		end
	until false
end

main()
