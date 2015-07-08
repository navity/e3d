
local wavefont = [[
# cube.obj with materials and documentation
#
mtllib cube-textures.mtl
g cube
# v1 is origin: back lower left (bll)
# v2=fll, v3=bul, v4=ful, v5=blr, v6=flr, v7=
v  0.0  0.0  0.0   v1 = back lower left (origin)
v  0.0  0.0  1.0   v2 = front lower left
v  0.0  1.0  0.0   v3 = back upper left
v  0.0  1.0  1.0   v4 = front upper left
v  1.0  0.0  0.0   v5 = back lower right
v  1.0  0.0  1.0   v6 = front lower right
v  1.0  1.0  0.0   v7 = back upper right
v  1.0  1.0  1.0   v8 = front upper right

vn  0.0  0.0  1.0
vn  0.0  0.0 -1.0
vn  0.0  1.0  0.0
vn  0.0 -1.0  0.0
vn  1.0  0.0  0.0
vn -1.0  0.0  0.0
 
vt 0.0 0.0  # vt=1 is upper left of texture
vt 0.0 1.0  # vt=2 is lower left of texture
vt 1.0 0.0  # vt=3 is upper right of texture
vt 1.0 1.0  # vt=4 is lower right of texture

# remember, syntax is v/vt/vn
g back face
usemtl buffy-gray
f  1/4/2  7/1/2  5/2/2
f  1/4/2  3/3/2  7/1/2 
g left face
usemtl buffy-blue
f  1/2/6  4/3/6  3/1/6 
f  1/2/6  2/4/6  4/3/6 
g top face
usemtl buffy-red
f  3/1/3  8/4/3  7/3/3 
f  3/1/3  4/2/3  8/4/3 
g right face
usemtl buffy-green
f  5/4/5  7/3/5  8/1/5 
f  5/4/5  8/1/5  6/2/5 
g bottom face
usemtl buffy-red
f  1/2/4  5/4/4  6/3/4 
f  1/2/4  6/3/4  2/1/4 
g front face
usemtl buffy-gray
f  2/2/1  6/4/1  8/3/1 
f  2/2/1  8/3/1  4/1/1 
]]

function printT2D(v)
local str = ""
for i=1,#v,1 do
	for j=1, #v[i],1 do
	str = str .. ' ' .. v[i][j]
	--print( v[i][1] .. ' , ' .. v[i][2] .. ' , ' .. v[i][3])
	end
	print(str)
	str =""
end
end

local res = { }
function res.load()

local vertices = {}
local normales = {}
local textures = {}
local faces = {}


local i=1
for v1,v2,v3 in wavefont:gmatch("v +(%-?%d*%.%d+) +(%-?%d*%.%d+) +(%-?%d*%.%d+)") do
  vertices[i] = {v1+.0,v2+.0,v3+.0}
  i = i+1
end

i=1
for vn1,vn2,vn3 in wavefont:gmatch("vn +(%-?%d*%.%d+) +(%-?%d*%.%d+) +(%-?%d*%.%d+)") do
  normales[i] = {vn1+.0,vn2+.0,vn3+.0}
  i = i+1
end

local i=1
for vt1,vt2 in wavefont:gmatch("vt +(%-?%d*%.%d+) +(%-?%d*%.%d+)") do
  textures[i] = {vt1+.0,vt2+.0}
  i = i+1
end

i=1
for fv1, ft1, fn1, fv2, ft2, fn2, fv3, ft3, fn3 in wavefont:gmatch("f +(%d+)/(%d+)/(%d+) +(%d+)/(%d+)/(%d+) +(%d+)/(%d+)/(%d+)") do
  faces[i] = {fv1+0,ft1+0,fn1+0,fv2+0,ft2+0,fn2+0,fv3+0,ft3+0,fn3+0}
  i = i+1
end

print("\nvertices")
printT2D(vertices)
print("\nnormales")
printT2D(normales)
print("\ntextures")
printT2D(textures)
print("\nfaces")
printT2D(faces)


local newVertices = {}
local newNormales = {}
local newTextures = {}
local index = {}

local j = 1

for i=1,#faces,1 do
	newVertices[j] = vertices[ faces[i][1]]
	newVertices[j+1] = vertices[ faces[i][4]]
	newVertices[j+2] = vertices[ faces[i][7]]

	newTextures[j] = textures[ faces[i][2]]
	newTextures[j+1] = textures[ faces[i][5]]
	newTextures[j+2] = textures[ faces[i][8]]

	newNormales[j] = normales[ faces[i][3]]
	newNormales[j+1] = normales[ faces[i][6]]
	newNormales[j+2] = normales[ faces[i][9]]	
	j = j+3
end

--function removeDoublons()
print("\nnew vertices")
printT2D(newVertices)

        local size = #newVertices
        local offset = -1
	for i=1, size,1 do
            if i > size then break end
		index[i] = i+offset

		for j=1, i-1, 1 do
			
			if newVertices[j][1] == newVertices[i][1] and newVertices[j][2] == newVertices[i][2] and newVertices[j][3] == newVertices[i][3] and
			   newNormales[j][1] == newNormales[i][1] and newNormales[j][2] == newNormales[i][2] and newNormales[j][3] == newNormales[i][3] and
			   newTextures[j][1] == newTextures[i][1] and newTextures[j][2] == newTextures[i][2] then

			   table.remove(newVertices,j)
			   table.remove(newNormales,j)
			   table.remove(newTextures,j)
                           
                           print(i,j)
                           index[i] = j+offset+1
                           offset = offset-1
			   
                           size = size -1
                           break
		   end
		end
                
	end

	print(offset)
        
        for i=1, #index,1 do
            print(index[i])
        end
--end


--removeDoublons()

print("\nnew vertices")
printT2D(newVertices)
print("\nnew normales")
printT2D(newNormales)
print("\nnew textures")
printT2D(newTextures)

return index, newVertices, newNormales, newTextures 
end


return res