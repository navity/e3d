package.path = package.path .. ";../?.lua" ;
local ffi = require('ffi')
local vec3 = require('vec3')
local mat4 = require('mat4')
local sdl2 = require('sdl2')
local loadobj = require('loadObj') 

local idx, vert, normal = loadobj.load()


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

void initNode(struct Node *node,float *mat);

void freeNode(struct Node *node);

int nodeLength( struct Node *node);

void pushNode(struct Node *node, struct Object *object, float *mat);

void setMatrix(struct Node *n, float *mat);

void loadShader(struct shader* sh, GLbyte *vertexshader, GLbyte *fragmentshader);
void deleteShader(struct shader *sh);

struct Object *createObject(struct Vec3 vertices[], struct Vec3 normales[], int nbVert, unsigned short index[] , int nbIndex);
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
attribute vec3 normal;
uniform mat4 matrix;
varying vec3 pos;
void main()
{
	pos = normal+vec3(1.0,1.0,1.0);
  gl_Position =  matrix * vec4(position,1.0);
}]]


local fragmentShader = [[
varying vec3 pos;
void main()
{
  gl_FragColor = vec4(normalize(pos),1.0);
}]]

local win = ffi.new("SDL_Window*")
win = engine.createWindow()



local mat = mat4:new()

local vectorx = vec3:new(1.0,0.0,0.0)
local vectory = vec3:new(0.0,1.0,0.0)

local time = 0.0

local perspectivemat = mat4:new()

perspectivemat = perspectivemat:translate(perspectivemat, vec3:new(0,0,-3))
perspectivemat = perspectivemat:mult(perspectivemat, perspectivemat:perspective(mat4:new(),1,0.7,1,10))
--perspectivemat = perspectivemat:translate(perspectivemat,vec3:new(0,0,1)):mult(perspectivemat:perspective(mat4:new(),2.7,1,0.1,10),perspective)

	local anglex = 0.0
	local angley = 0.0

	

engine.onKeyPress( function(evt)


	local kc = evt
--	print(kc)
	  if		kc == 1073741903 then 	anglex = anglex + 0.01
	  elseif	kc == 1073741904 then 	anglex = anglex - 0.01
	  elseif	kc == 1073741905 then 	angley = angley + 0.01
	  elseif	kc == 1073741906 then 	angley = angley - 0.01 end
	  
	  if kc > 1000000 then  
		mat = mat:identity():rotate(mat,anglex,vectorx):mult(mat,mat:rotate(mat,angley,vectory))
	end
	print(mat)
end)



local c_str_vertex = ffi.cast("unsigned char*",vertexShader)
local c_str_fragment = ffi.cast("unsigned char*",fragmentShader)

engine.loadShader(shader, c_str_vertex, c_str_fragment)

engine.initNode(nodes,perspectivemat.C)


local cvec3 = {}
engine.pushNode(nodes, engine.createObject(ffi.new("struct Vec3[36]",vert), ffi.new("struct Vec3[27]",normal),27,ffi.new("unsigned short[36]",idx),36), mat.C)

engine.mainLoop(nodes, shader, win)

