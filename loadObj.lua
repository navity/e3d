
local wavefont = [[
v  0.0  0.0  0.0
v  0.0  0.0  1.0
v  0.0  1.0  0.0
v  0.0  1.0  1.0
v  1.0  0.0  0.0
v  1.0  0.0  1.0
v  1.0  1.0  0.0
v  1.0  1.0  1.0

vn  0.0  0.0  1.0
vn  0.0  0.0 -1.0
vn  0.0  1.0  0.0
vn  0.0 -1.0  0.0
vn  1.0  0.0  0.0
vn -1.0  0.0  0.0

vt 0.0 0.0
vt 0.0 1.0
vt 1.0 0.0
vt 1.0 1.0


f  1/4/2  7/1/2  5/2/2
f  1/4/2  3/3/2  7/1/2 

f  1/2/6  4/3/6  3/1/6 
f  1/2/6  2/4/6  4/3/6 

f  3/1/3  8/4/3  7/3/3 
f  3/1/3  4/2/3  8/4/3 

f  5/4/5  7/3/5  8/1/5 
f  5/4/5  8/1/5  6/2/5 

f  1/2/4  5/4/4  6/3/4 
f  1/2/4  6/3/4  2/1/4

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
		--print(vertices[i],i)
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


	local newVertices = {}
	local newNormales = {}
	local newTextures = {}
	local index = {}
	local offset = 0
	local lastIdx = 0

	i=1
	for fv1, fvt1, fvn1, fv2, fvt2, fvn2, fv3, fvt3, fvn3 in wavefont:gmatch("f +(%d+)/(%d+)/(%d+) +(%d+)/(%d+)/(%d+) +(%d+)/(%d+)/(%d+)") do
		local	iv1,ivt1,ivn1,
			iv2,ivt2,ivn2,
			iv3,ivt3,ivn3=	fv1+0, fvt1+0, fvn1+0,
					fv2+0, fvt2+0, fvn2+0,
					fv3+0, fvt3+0, fvn3+0
		--i = i+1

		--print(vertices[iv1],iv1)

		local findAt1 = 0
		local findAt2 = 0
		local findAt3 = 0

		local maxIdx = lastIdx

		for j=1, lastIdx-1, 1 do
			if j >= maxIdx then break end

			if findAt1 == 0  and	vertices[iv1][1]  == newVertices[j][1] and vertices[iv1][2]  == newVertices[j][2] and vertices[iv1][3]  == newVertices[j][3] and
						normales[ivn1][1] == newNormales[j][1] and normales[ivn1][2] == newNormales[j][2] and normales[ivn1][3] == newNormales[j][3] and
						textures[ivt1][1] == newTextures[j][1] and textures[ivt1][2] == newTextures[j][2] then
				findAt1 = j
				maxIdx = maxIdx+1
			end

			if findAt2 == 0  and	vertices[iv2][1]  == newVertices[j][1] and vertices[iv2][2]  == newVertices[j][2] and vertices[iv2][3]  == newVertices[j][3] and
						normales[ivn2][1] == newNormales[j][1] and normales[ivn2][2] == newNormales[j][2] and normales[ivn2][3] == newNormales[j][3] and
						textures[ivt2][1] == newTextures[j][1] and textures[ivt2][2] == newTextures[j][2] then
				findAt2 = j
				maxIdx = maxIdx+1
			end
			
			if findAt3 == 0  and	vertices[iv3][1]  == newVertices[j][1] and vertices[iv3][2]  == newVertices[j][2] and vertices[iv3][3]  == newVertices[j][3] and
						normales[ivn3][1] == newNormales[j][1] and normales[ivn3][2] == newNormales[j][2] and normales[ivn3][3] == newNormales[j][3] and
						textures[ivt3][1] == newTextures[j][1] and textures[ivt3][2] == newTextures[j][2] then
				findAt3 = j
				maxIdx = maxIdx+1
			end
		end

		if findAt1 == 0 then
			lastIdx = lastIdx+1
			newVertices[lastIdx] = vertices[ iv1]
			newTextures[lastIdx] = textures[ ivt1]
			newNormales[lastIdx] = normales[ ivn1]
			index[#index+1] = #index+offset
		else
			offset = offset -1
			index[#index+1] = findAt1-1
		end


		if findAt2 == 0 then
			lastIdx = lastIdx+1
			newVertices[lastIdx] = vertices[ iv2]
			newTextures[lastIdx] = textures[ ivt2]
			newNormales[lastIdx] = normales[ ivn2]
			index[#index+1] = #index+offset
		else
			offset = offset -1
			index[#index+1] = findAt2
		end

		for j=1, lastIdx-1, 1 do 
		end


		if findAt3 == 0 then
			lastIdx = lastIdx+1
			newVertices[lastIdx] = vertices[ iv3]
			newTextures[lastIdx] = textures[ ivt3]
			newNormales[lastIdx] = normales[ ivn3]
			index[#index+1] = #index+offset
		else
			offset = offset -1
			index[#index+1] = findAt3
		end

	end

	print("size")
	print(#newVertices)
	print(#index)
	print("---")

	return index, newVertices, newNormales, newTextures 
end


return res
