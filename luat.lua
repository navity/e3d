package.path = package.path .. ";../?.lua" ;
local ffi = require('ffi')
local vec3 = require('vec3')
local mat4 = require('mat4')
local sdl2 = require('sdl2')
local loadobj = require('loadObj') 

local idx, vert = loadobj.load()


ffi.cdef[[
  
  typedef unsigned int GLuint;
  
  typedef int GLint;
  
  typedef unsigned char GLbyte;
  
  struct Vec2{
    float x;
    float y;
  };
  
  struct Vec3 {float x;float y;float z;};
  
  struct shader{
	GLuint prgm;
	GLuint fragment;
	GLuint vertex;
	GLuint uMatrix;
	GLint vec4;
};

struct Object {

	GLuint vbo;
	GLuint ibo;
	GLint nbi;
	GLuint *tex;
};

struct Node{
	struct Node *deb;
	struct Node *fin;
	struct Node *max;

	struct Object *object;
	float *mat;
};

SDL_Window* createWindow();
void mainLoop(struct Node* node, struct shader *sh, SDL_Window* win);

void initNode(struct Node *node);

void freeNode(struct Node *node);

int nodeLength( struct Node *node);

void pushNode(struct Node *node, struct Object *object, float *mat);

void setMatrix(struct Node *n, float *mat);

void loadShader(struct shader* sh, GLbyte *vertexshader, GLbyte *fragmentshader);
void deleteShader(struct shader *sh);

struct Object *createObject(float vertices[], int nbVertices, unsigned short index[] , int nbIndex);
struct Object *createTriangle(struct Vec3 vertices[3]);
struct Object *createCarre( struct Vec3 vertices[4]);
void createTexture( struct Object *object, int width, int height, unsigned char *data);

void drawScene(struct Node *node, struct shader *sh);


void onKeyDown(void(*)(int evt));
void onKeyPress(void(*)(int evt));
void onKeyUp(void (*)(int evt));
]]

local engine = ffi.load("engine")

engine.onKeyUp( function(evt)
	print("yoc moi")
end)


local nodes = ffi.new("struct Node[1]")
local shader = ffi.new("struct shader[1]")

local vertexShader = [[
attribute vec3 position;
uniform mat4 matrix;
void main()
{
  gl_Position =  matrix * vec4(position,1.0);
}]]


local fragmentShader = [[
void main()
{
  gl_FragColor = vec4( 1.0,0.1,1.0 , 1.0);
}]]

local win = ffi.new("SDL_Window*")
win = engine.createWindow()



local mat = mat4:new()

--local vector = vec3:new(0,0,0)
local vectord = vec3:new(0.001,0.001,0.0)

local time = 0.0

engine.onKeyPress( function(evt)

	local kc = evt
--	print(kc)
	  if		kc == 1073741903 then 	vectord:set(  0.03,  0.0,  0.0)
	  elseif	kc == 1073741904 then 	vectord:set( -0.03,  0.0,  0.0)
	  elseif	kc == 1073741905 then 	vectord:set(  0.0,  -0.03,  0.0)
	  elseif	kc == 1073741906 then 	vectord:set( -0.0,  0.03,  0.0) end
	  
	mat = mat:translate(mat,vectord)
end)

local c_str_vertex = ffi.cast("unsigned char*",vertexShader)
local c_str_fragment = ffi.cast("unsigned char*",fragmentShader)

engine.loadShader(shader, c_str_vertex, c_str_fragment)

engine.initNode(nodes)


local cvec3 = {}

print(vert)

local nbvert = 0
for i=1,#vert,3 do
    --print(cube[2][i][1])
   cvec3[i] = vert[i][1]
    cvec3[i+1] = vert[i][2]
     cvec3[i+2] = vert[i][3]
     print('v',cvec3[i],cvec3[i+1],cvec3[i+2])
     nbvert = i
end

print(nbvert)


engine.pushNode(nodes, engine.createObject(ffi.new("float[84]",cvec3),nbvert,ffi.new("unsigned short[28]",idx),28), mat.C)

engine.mainLoop(nodes, shader, win)


































