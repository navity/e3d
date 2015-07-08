local ffi = require("ffi")

ffi.cdef[[struct vec3{float x; float y; float z;};]]

local vec3 = {}
function vec3:new(...)
	local arg = { ... }
	if not (arg[1] and arg[2] and arg[3]) then arg = {0,0,0} end
	return setmetatable( { C = ffi.new("struct vec3",arg) },vec3)
end

vec3.__index = function(self,key)
	if key == 'x' or key == 'y' or key == 'z' then return self.C[key] else return vec3[key] end
end

vec3.__tostring = function(self)
	return '{ ' .. self.x .. ' ' .. self.y .. ' ' .. self.z .. ' }\n'
end

function vec3:set(...)
  local arg = { ... }
  if not (arg[1] and arg[2] and arg[3]) then arg = {0,0,0} end
  
  self.x = arg[1]
  self.y = arg[2]
  self.z = arg[3]
end

function vec3:add(dest,vec)
  if not dest then dest = vec3:new() end
  dest.x = self.x + vec.x
  dest.y = self.y + vec.y
  dest.z = self.z + vec.z
  return dest
end

return vec3