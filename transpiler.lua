local tokens = {
	"+", "-", ">", "<", ".", ",", "[", "]"
}

local transfer = {
	"add", "sub", "right", "left", "write", "read", "while", "end"
}

local params = {
	true, true, true, true, false, false, false, false
}

local function validateToken(c)
	for i = 1, #tokens do 
		if(c == tokens[i]) then 
			return i 
		end 
	end 
	return nil
end 

return function (bf)
	local result = ""
	local count = 0
	local ct = ""
	local pt = ""
	local cp = false 
	for c in bf:gmatch(".") do
		local index = validateToken(c)
		if(index) then
			if(cp) then 
				if(pt == c) then 
					count = count + 1 
				else 
					result = result..ct.." "..count.." "
					count = 0
					ct = ""
					cp = false
				end 
			end 
			
			if(not cp) then 
				cp = params[index]
				if(cp) then 
					ct = transfer[index]
					count = 1
				else 
					result = result..transfer[index].." "
				end
			end
		
			pt = c
		end 
	end
	
	return result
end 