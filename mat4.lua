
local ffi = require("ffi")
local vec3 = require("vec3")





	local mat4 = {}

function mat4:new(...)
	local arg = { ... }
	if arg[1] == nil then
		arg = { 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1}
	end
	return setmetatable({ C = ffi.new("float[16]",arg ) },mat4)
end





function mat4:identity()
	self[0] = 1;	self[1] = 0;	self[2] = 0;	self[3] = 0
	self[4] = 0;	self[5] = 1;	self[6] = 0;	self[7] = 0
	self[8] = 0;	self[9] = 0;	self[10] = 1;	self[11] = 0
	self[12] = 0;	self[13] = 0;	self[14] = 0;	self[15] = 1
end




function mat4:mult(dest, m)
	if m and ffi.istype("float[16]",m.C) then

	if not dest then dest = mat4:new() end


	local a1, a2, a3, a4,
	b1, b2, b3, b4,
	c1, c2, c3, c4,
	d1, d2, d3, d4 =
	m[0], m[1], m[2], m[3],
	m[4], m[5], m[6], m[7],
	m[8], m[9], m[10], m[11],
	m[12], m[13], m[14], m[15]

	local m1, m2, m3, m4 = self[0], self[1], self[2], self[3]
	dest[0] = m1 * a1 + m2 * b1 + m3 * c1 + m4 * d1
	dest[1] = m1 * a2 + m2 * b2 + m3 * c2 + m4 * d2
	dest[2] = m1 * a3 + m2 * b3 + m3 * c3 + m4 * d3
	dest[3] = m1 * a4 + m2 * b4 + m3 * c4 + m4 * d4

	m1, m2, m3, m4 = self[4], self[5], self[6], self[7]
	dest[4] = m1 * a1 + m2 * b1 + m3 * c1 + m4 * d1
	dest[5] = m1 * a2 + m2 * b2 + m3 * c2 + m4 * d2
	dest[6] = m1 * a3 + m2 * b3 + m3 * c3 + m4 * d3
	dest[7] = m1 * a4 + m2 * b4 + m3 * c4 + m4 * d4

	m1, m2, m3, m4 = self[8], self[9], self[10], self[11]
	dest[8] =  m1 * a1 + m2 * b1 + m3 * c1 + m4 * d1
	dest[9] =  m1 * a2 + m2 * b2 + m3 * c2 + m4 * d2
	dest[10] = m1 * a3 + m2 * b3 + m3 * c3 + m4 * d3
	dest[11] = m1 * a4 + m2 * b4 + m3 * c4 + m4 * d4

	m1, m2, m3, m4 = self[12], self[13], self[14], self[15]
	dest[12] = m1 * a1 + m2 * b1 + m3 * c1 + m4 * d1
	dest[13] = m1 * a2 + m2 * b2 + m3 * c2 + m4 * d2
	dest[14] = m1 * a3 + m2 * b3 + m3 * c3 + m4 * d3
	dest[15] = m1 * a4 + m2 * b4 + m3 * c4 + m4 * d4
	end
	return dest
end


function mat4:translate(dest, vec)
  
	if not dest then dest = mat4:new() end

	dest[0] = self[0]
	dest[1] = self[1]
	dest[2] = self[2]
	dest[3] = self[3]
	dest[4] = self[4]
	dest[5] = self[5]
	dest[6] = self[6]
	dest[7] = self[7]
	dest[8] = self[8]
	dest[9] = self[9]
	dest[10] = self[10]
	dest[11] = self[11]
	dest[12] = self[0] * vec.x + self[4] * vec.y + self[8] * vec.z + self[12];
	dest[13] = self[1] * vec.x + self[5] * vec.y + self[9] * vec.z + self[13];
	dest[14] = self[2] * vec.x + self[6] * vec.y + self[10] * vec.z + self[14];
	dest[15] = self[3] * vec.x + self[7] * vec.y + self[11] * vec.z + self[15];

	return dest
end


mat4.__mul = function(self, m) return self:mult(NULL,m) end

mat4.__index = function(self, key) if type(key) == "number" then return self.C[key] else return mat4[key] end end

mat4.__newindex = function(self, key, value) self.C[key] = value end

mat4.__tostring = function(self) 
	return 	'[ ' .. self[0] .. ' ' .. self[1] .. ' ' .. self[2] .. ' ' ..self[3] .. '\n  ' ..
	self[4] .. ' ' .. self[5] .. ' ' .. self[6] .. ' ' ..self[7] .. '\n  ' ..
	self[8] .. ' ' .. self[9] .. ' ' .. self[10] .. ' ' ..self[11] .. '\n  ' ..
	self[12] .. ' ' .. self[13] .. ' ' .. self[14] .. ' ' ..self[15] .. ' ]\n';
end



return mat4
