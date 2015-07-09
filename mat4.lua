
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
    local x,y,z = vec.x, vec.y, vec.z
  
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
	dest[12] = self[0] * x + self[4] * y + self[8] * z + self[12];
	dest[13] = self[1] * x + self[5] * y + self[9] * z + self[13];
	dest[14] = self[2] * x + self[6] * y + self[10] * z + self[14];
	dest[15] = self[3] * x + self[7] * y + self[11] * z + self[15];

	return dest
end

function mat4:rotate(dest,angle,vec)
    if not dest then dest = mat4:new() end
    
    local x,y,z = vec.x, vec.y, vec.z
    
    local c,s = math.cos(angle), math.sin(angle)
    local t = 1 - c
    
    local   r11, r12, r13,
            r21, r22, r23,
            r31, r32, r33 =	x*x + (1-x)*c,  x*y*t-z*s,  x*z*t+s,
				x*y*(1-c)+z*s,  y*y+(1-y*y)*c,  y*z*t-x*s,
				x*z*t-y*s,      y*z*t+x*s,      z*z+(1-z*z)*c
    
    local	m11, m12, m13, m14,
		m21, m22, m23, m24,
		m31, m32, m33, m34,
		m41, m42, m43, m44 =	self[0], self[1], self[2], self[3],
					self[4], self[5], self[6], self[7],
					self[8], self[9], self[10], self[11],
					self[12], self[13], self[14], self[15]
					
					
    dest[0] = m11 * r11 + m21 * r12 + m31 * r13
    dest[1] = m12 * r11 + m22 * r12 + m32 * r13
    dest[2] = m13 * r11 + m23 * r12 + m33 * r13
    dest[3] = m14 * r11 + m24 * r12 + m34 * r13
    
    dest[4] = m11 * r21 + m21 * r22 + m31 * r23
    dest[5] = m12 * r21 + m22 * r22 + m32 * r23
    dest[6] = m13 * r21 + m23 * r22 + m33 * r23
    dest[7] = m14 * r21 + m24 * r22 + m34 * r23
    
    dest[8] = m11 * r31 + m21 * r32 + m31 * r33
    dest[9] = m12 * r31 + m22 * r32 + m32 * r33
    dest[10] = m13 * r31 + m23 * r32 + m33 * r33
    dest[11] = m14 * r31 + m24 * r32 + m34 * r33
    

    dest[12] = self[12]
    dest[13] = self[13]
    dest[14] = self[14]
    dest[15] = self[15]

    return dest
end


function mat4:perspective(dest, fov, ratio, near, far)

	local halfTanFov = math.tan( fov / 2)
	local range = near - far

	dest[0] = 1 / ratio*halfTanFov
	dest[1] = 0
	dest[2] = 0
	dest[3] = 0
	dest[4] = 0
	dest[5] = 1 / halfTanFov
	dest[6] = 0
	dest[7] = 0
	dest[8] = 0
	dest[9] = 0
	dest[10] = ( -near-far ) / range
	dest[11] = (2*far*near) / range
	dest[12] = 0
	dest[13] = 0
	dest[14] = 1
	dest[15] = 0

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
