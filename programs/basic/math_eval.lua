include("stdio")
include("dictionary")

local OPERATOR = 2 ^ 31 - 1

local precedence = {}
precedence[charCode("=")] = 1
precedence[charCode("<")] = 1
precedence[charCode(">")] = 1
precedence[charCode("=") * 256] = 1 --<> aka !=
precedence[charCode("<") * 256] = 1 --<=
precedence[charCode(">") * 256] = 1 -->=
precedence[charCode("+")] = 2
precedence[charCode("-")] = 2
precedence[charCode("*")] = 3
precedence[charCode("/")] = 3
precedence[charCode("%")] = 3

local postfix = {}
local opstack = {} -- top element is 1, push is insert at 1, pop is remove at 1
local scope = {}

local function handleOp(op : int)
	local opPrecedence = precedence[op]
	while precedence[opstack[1]] >= opPrecedence do
		postfix[#postfix + 1] = OPERATOR
		postfix[#postfix + 1] = opstack[1]
		table_remove(opstack, 1)
	end

	table_insert(opstack, 1, op)
end

function math_eval(str : table, scope : table) : bool, int

	-- convert to postfix
	postfix = {}
	opstack = {}

	for i = 1, #str do
		local curr = str[i]

		if curr == charCode(" ") then
			-- ignore
		elseif curr == charCode("+")
			or curr == charCode("-")
			or curr == charCode("*")
			or curr == charCode("/")
			or curr == charCode("%") then

			handleOp(curr)

		elseif curr >= charCode("<") and curr <= charCode(">") then --[<=>]
			local next = str[i + 1]
			if curr ~= charCode("=") and next >= charCode("<") and next <= charCode(">") then
				curr = curr * 256
				i = i + 1
			end
			handleOp(curr)

		elseif curr >= charCode("A") and curr <= charCode("Z") then --[A-Z]
			local name = {}
			repeat
				name[#name + 1] = curr
				i = i + 1
				curr = str[i]
			until  curr < charCode("A") or curr > charCode("Z")
			i = i - 1

			local val = dict_get(scope, name)
			--asert val[1] == NUMBER

			postfix[#postfix + 1] = val[2]

		elseif curr >= charCode("0") and curr <= charCode("9") then --[0-9]
			local val = 0
			repeat
				val = val * 10 + curr - charCode("0")
				i = i + 1
				curr = str[i]
			until curr < charCode("0") or curr > charCode("9")
			i = i - 1

			postfix[#postfix + 1] = val

		else
			-- unexpected char curr
		end
	end

	for i = 1, #opstack do
		postfix[#postfix + 1] = OPERATOR
		postfix[#postfix + 1] = opstack[i]
	end

	local stack = {} --top element is 1, push is insert at 1, pop is remove at 1
	for i = 1, #postfix do
		local curr = postfix[i]
		if curr == OPERATOR then
			i = i + 1
			curr = postfix[i]

			local left, right, result = stack[2], stack[1], 0
			table_remove(stack, 1)

			if curr == charCode("=") then
				result = left == right
			elseif curr == charCode("<") then
				result = left < right
			elseif curr == charCode(">") then
				result = left > right
			elseif curr == charCode("=") * 256 then --<> aka ~= aka !=
				result = left ~= right
			elseif curr == charCode("<") * 256 then --<=
				result = left <= right
			elseif curr == charCode(">") * 256 then -->=
				result = left >= right
			elseif curr == charCode("+") then
				result = left + right
			elseif curr == charCode("-") then
				result = left - right
			elseif curr == charCode("*") then
				result = left * right
			elseif curr == charCode("/") then
				result = left / right
			elseif curr == charCode("%") then
				result = left % right
			end

			stack[1] = result
		else
			table_insert(stack, 1, curr)
		end
	end

	return false, stack[1]
end
