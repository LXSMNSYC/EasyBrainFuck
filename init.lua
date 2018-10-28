local DEBUG_MODE = false 

local COMMENT = "#"

local TOKENS = {
	"left", "right", "add", "sub", "while", "end", "write", "read", 
}
local TOKEN_COUNT = #TOKENS

local PARAMS = {
	true, true, true, true, false, false, false, false
}


local SIZES = {8, 16, 32}
local VALUES = {2^SIZES[1], 2^SIZES[2], 2^SIZES[3]}

local function validAlpha(str)
	return string.match(str, "%a+")
end 

local function validNum(str)
	return string.match(str, "%d+")
end 

local function validHex(str)
	return string.match(str, "0x+%x+")
end 

local function validateToken(token)
	if(validAlpha) then 
		for i = 1, TOKEN_COUNT do 
			if(token == TOKENS[i]) then return i end 
		end 
	end
	return nil
end



local function parseProgram(program, output, params)
	program = program:lower()
	
	local ignore = false 
	local include = output
	local param = false
	
	local prevWord = ""
	local prevR = 0
	
	local tokenCount = 1
	
	local n = 1
	
	for word in program:gmatch("%S+") do 
		if(word == COMMENT) then 
			ignore = not ignore 
		end
		if(not ignore) then 
			local result = validateToken(word)
			if(result and param) then 
				print("Compile Error: ", "expected a parameter for "..prevWord, "Token: "..tokenCount)
				return false 
			end
			
			if(param) then 
				if(not (validNum(word))) then
					print("Compile Error: ", "value provided for the parameter \""..prevWord.."\" is not a valid number.")
					return false 
				else 
					output[n] = prevR
					params[n] = tonumber(word)
					param = false
					n = n + 1
				end 
			else 
				param = PARAMS[result or 0]
				if(not param) then
					output[n] = result
					n = n + 1
				else 
					prevWord = word
					prevR = result
				end
			end 
			
			
			
			tokenCount = tokenCount + 1
		end 
	end 
	
	if(DEBUG_MODE) then 
		print("Token ID", "Token")
		for k, v in ipairs(output) do 
			print(k, v)
		end
	end
	
	return true
end 

local function bound(v, s, p)
	if(p == 0) then 
		return v 
	end
	v = v + p
	if(p < 0) then 
		while(v < 0) do 
			v = s + v 
		end 
	elseif(p > 0) then 
		v = v % s 
	end 
	return v
end

local function evaluate(program, params, size, mem)
	local index = 1
	local position = 1
	local memory = {}
	local ls = {}
	local lss = 0
	local p = #program 
	
	local v = 0
	while(index <= p) do
		local keyword = program[index] 
		local param = params[index]
		
		if(DEBUG_MODE) then 
			print(index, keyword, param)
		end
		
		if keyword == 1 then
			memory[position] = v
			position = bound(position, mem, -param)
			v = memory[position] or 0
		elseif keyword == 2 then 
			memory[position] = v
			position = bound(position, mem, param)
			v = memory[position] or 0
		elseif keyword == 3 then 
			v = bound(v, mem, param)
		elseif keyword == 4 then 
			v = bound(v, mem, -param)
		elseif keyword == 5 then 
			lss = lss + 1
			ls[lss] = index 
		elseif keyword == 6 then 
			if(v > 0) then 
				index = ls[lss]
			else 
				ls[lss] = nil 
				lss = lss - 1
			end 
		elseif keyword == 7 then 
			io.write(string.char(v))
		elseif keyword == 8 then 
			v = string.byte((io.read() or string.char(0)):sub(1, 1))
		end
		
		
		index = index + 1
	end 
end 

return function (program, size, mem)
	local si = 0
	for i = 1, #SIZES do 
		if(size == SIZES[i]) then 
			si = i
			break
		end 
	end 
	local p, params = {}, {}
	if(parseProgram(program, p, params)) then 
		evaluate(p, params, VALUES[si] or VALUES[1], mem or 30000)
	end 
end