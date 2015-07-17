#include <GL/gl.h>
#include <SDL2/SDL.h>
#include <stdio.h>
   #include <time.h>

#include "mat4.h"

GLbyte vertexShader[] =
"attribute vec3 position;\n"
"uniform mat4 matrix;\n"
"void main()\n"
"{\n"
"  gl_Position =  matrix * vec4(position,1.0);\n"
"}\n";


GLbyte fragmentShader[] =
"void main()\n"
"{\n"
"  gl_FragColor = vec4( 1.0,0.1,1.0 , 1.0);\n"
"}\n";

struct Vec3{
float x;
float y;
float z;
};

struct Vec2{
float x;
float y;
};

struct shader{
	GLuint prgm;
	GLuint fragment;
	GLuint vertex;
	GLuint uMatrix;

	GLint position;
	GLint normal;
	//	float *matrix;

};

struct Object {

	GLuint normales;
	GLuint vbo;
	GLuint ibo;
	GLuint nbi;
	GLuint *tex;
};

struct Data {
	struct Vec3 *vertex;
	struct Vec3 *normal;
	struct vec2 *texCoord;
	unsigned short *index;
	unsigned short nbIndex;


	unsigned char *tex;
};

struct Node{
	struct Node *deb;
	struct Node *fin;
	struct Node *max;

	struct Object *object;
	float *mat;
};

void initNode(struct Node *node,float *mat){
	if(node){
		if(!mat) mat = newMat4();
		node->deb = malloc(sizeof(struct Node));
		node->max = node->deb+1;
		node->fin = node->deb;

		node->mat = mat;

		node->deb->deb = NULL;
		node->deb->fin = NULL;
		node->deb->max = NULL;
	}
}


void freeNode(struct Node *node) {

	if(node){
		struct Node *ptr = node->deb;
		while( ptr < node->fin) {
			free(ptr->mat);
			ptr++;
		}
		free(node->deb);
	}

}


int nodeLength( struct Node *node){
	if(node)
		return node->fin - node->deb;
	else return -1;
}

void pushNode(struct Node *node, struct Object *object, float *mat){

	if(node ){
		if(node->max <= node->fin) {
			int len = node->max - node->deb;
			printf("node new length %d\n",len*2);
			struct Node *newNode = realloc(node->deb, sizeof(struct Node)*len*2);
			if(newNode){
				node->deb = newNode;
				node->fin = &newNode[len];
				node->max = &newNode[len*2];
			} else
				printf("memoire sature\n");
		}

		node->fin->object = object;


		node->fin->mat = mat;
		node->fin->deb = NULL;

		node->fin ++;
	}
}


void setMatrix(struct Node *n, float *mat){
	if(n) n->mat = mat;
}




void loadShader(struct shader* sh, GLbyte *vertexshader, GLbyte *fragmentshader){
printf("loadshader\n");

printf("%s\n-----\n%s\n",vertexshader,fragmentshader);


	sh->vertex = glCreateShader(GL_VERTEX_SHADER);
	const GLint lv = strlen(vertexshader);
	glShaderSource(sh->vertex, 1, &vertexshader, &lv );
	glCompileShader(sh->vertex);

	GLint vertexOK = 0;
	glGetShaderiv(sh->vertex, GL_COMPILE_STATUS, &vertexOK);

	sh->fragment = glCreateShader(GL_FRAGMENT_SHADER);
	const GLint lf = strlen(fragmentshader);
	glShaderSource(sh->fragment, 1, &fragmentshader, &lf);
	glCompileShader(sh->fragment);

	GLint fragmentOK = 0;
	glGetShaderiv(sh->fragment, GL_COMPILE_STATUS, &fragmentOK);

	GLchar strErr[128];
	GLsizei Errlen = 0;

	if( vertexOK != GL_TRUE) {  
		glGetShaderInfoLog(sh->vertex, 128, &Errlen, strErr);
		printf("%s\n",strErr);
	}

	if( fragmentOK != GL_TRUE) {
		glGetShaderInfoLog(sh->fragment, 128, &Errlen, strErr);
		printf("%s\n",strErr);
	}

	sh->prgm = glCreateProgram();

	glAttachShader(sh->prgm, sh->vertex);
	glAttachShader(sh->prgm, sh->fragment);

	glLinkProgram(sh->prgm);

	GLint prgmOK=0;
	glGetProgramiv(sh->prgm, GL_LINK_STATUS, &prgmOK);

	if( prgmOK != GL_TRUE ) {
		glGetProgramInfoLog(sh->prgm, 128, &Errlen, strErr);
		printf("%s\n", strErr);
	}

	glUseProgram(sh->prgm);

	sh->position = glGetAttribLocation(sh->prgm, "position");
	sh->normal = glGetAttribLocation(sh->prgm, "normal"); 
	sh->uMatrix = glGetUniformLocation(sh->prgm, "matrix");
	printf("pos:%d normal:%d matrix:%d\n",sh->position, sh->normal, sh->uMatrix);
}



void deleteShader(struct shader *sh){
	glDetachShader(sh->prgm, sh->vertex);
	glDetachShader(sh->prgm, sh->fragment);
	glDeleteProgram(sh->prgm);
	glDeleteShader(sh->vertex);
	glDeleteShader(sh->fragment);
}


struct Object *createObject(struct Vec3 vertices[], struct Vec3 normales[], unsigned short nbVertices, unsigned short index[] , int nbIndex){
      	struct Object *obj = malloc(sizeof(struct Object));

	int i =0;
	 printf("nbv %d\n",nbVertices);
	for(i = 0; i<nbVertices; i++){
		printf("%f %f %f\n",vertices[i].x, vertices[i].y,vertices[i].z);
	}
	 
	printf("normales \n");
	for(i = 0; i<nbVertices; i++){
		printf("%f %f %f\n",normales[i].x, normales[i].y, normales[i].z);
	}
	
	 printf("nbindex %d\n",nbIndex);

	for(i = 0; i<nbIndex; i++){
		printf("%d ", index[i]);
	}
	printf("\n");

	GLuint ibo;
	glGenBuffers(1, &ibo);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(unsigned short)*nbIndex, index, GL_STATIC_DRAW);

	GLuint vbo;
	glGenBuffers(1, &vbo);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, sizeof(struct Vec3)*3*nbVertices, vertices, GL_STATIC_DRAW);

	GLuint normalbo;
	glGenBuffers(1, &normalbo);
	glBindBuffer(GL_ARRAY_BUFFER, normalbo);
	glBufferData(GL_ARRAY_BUFFER, sizeof(struct Vec3)*3*nbVertices, normales, GL_STATIC_DRAW);
	

	obj->normales = normalbo;
	obj->ibo = ibo;
	obj->vbo = vbo;
	obj->nbi = nbIndex;
	obj->tex = NULL;
	
	return obj;
}


struct Object *createTriangle(struct Vec3 vertices[3]){

	unsigned short index[] = {0,1,2};

	struct Object *obj = malloc(sizeof(struct Object));

	GLuint ibo;
	glGenBuffers(1, &ibo);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(unsigned short)*3, index, GL_STATIC_DRAW);

	GLuint vbo;
	glGenBuffers(1, &vbo);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, sizeof(struct Vec3)*3, vertices, GL_STATIC_DRAW);

	obj->ibo = ibo;
	obj->vbo = vbo;
	obj->nbi = 3;
	obj->tex = NULL;

	return obj;
}


struct Object *createCarre( struct Vec3 vertices[4]){

	struct Object *obj = malloc(sizeof(struct Object));

	unsigned short index[] = {0,1,2, 1,2,3};

	GLuint ibo;
	glGenBuffers(1, &ibo);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(unsigned short)*6, index, GL_STATIC_DRAW);

	GLuint vbo;
	glGenBuffers(1, &vbo);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glBufferData(GL_ARRAY_BUFFER, sizeof(struct Vec3)*4, vertices, GL_STATIC_DRAW);


	obj->ibo = ibo;
	obj->vbo = vbo;
	obj->nbi = 6;
	obj->tex = NULL;

	return obj;
}



void createTexture( struct Object *object, int width, int height, unsigned char *data) {
	object->tex = malloc(sizeof(GLuint));
	glGenTextures(1,object->tex);
	glBindTexture(GL_TEXTURE_2D, *object->tex);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_BGR, GL_UNSIGNED_BYTE, data);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
}


void drawScene(struct Node *node, struct shader *sh){

	glEnableVertexAttribArray(sh->position);
	glEnableVertexAttribArray(sh->normal);

	int i;

	//printf("pos:%d normal:%d matrix:%d\n",sh->position, sh->normal, sh->uMatrix);
	//printf("rr %d %p\n", node->fin - node->deb, node->mat);

	for(i=0; i < node->fin - node->deb; i++) {


		float *mat = copyMat4(NULL,node->mat);
		struct Node *n = &node->deb[i];
		//	printf("u %d\n",n->object->vb);
	//	mat = multMat4(mat, mat, n->mat);
		//		do{
		mat = multMat4(mat,mat, n->mat); 

		glUniformMatrix4fv(sh->uMatrix, 1, GL_FALSE, mat);

		glBindBuffer(GL_ARRAY_BUFFER, n->object->vbo);
		glVertexAttribPointer(sh->position, 3, GL_FLOAT, GL_FALSE, 0, NULL);
		glBindBuffer(GL_ARRAY_BUFFER, n->object->normales);
		glVertexAttribPointer(sh->normal,3, GL_FLOAT, GL_FALSE, 0, NULL);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, n->object->ibo);

		glDrawElements(GL_TRIANGLES, n->object->nbi, GL_UNSIGNED_SHORT, NULL);
		//			n = n->deb;
		//		}while( n );
	}

	glDisableVertexAttribArray(sh->position);
	glDisableVertexAttribArray(sh->normal);
}

SDL_Window* createWindow(){
  SDL_Window* fenetre = 0;
  	if(SDL_Init(SDL_INIT_VIDEO) < 0)
		printf("%s\n",SDL_GetError());

	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);

	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
	SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 16);
	//SDL_GL_SetAttribute(SDL_GL_SWAP_CONTROL, 1);
SDL_GL_SetSwapInterval(1);

	fenetre = SDL_CreateWindow("Test SDL 2.0", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL);

	
	if(fenetre == 0)
		printf("%s\n", SDL_GetError());
	
	  SDL_GLContext contexteOpenGL = 0;
	contexteOpenGL = SDL_GL_CreateContext(fenetre);

	if(contexteOpenGL == 0)
		printf("%s\n", SDL_GetError());
	
	
	return fenetre;
	
}

typedef void (*DoRuntimeChecks)(int evt);


struct Callback_event{
DoRuntimeChecks keydown;
DoRuntimeChecks keyup;
DoRuntimeChecks keypress;
};

struct Callback_event callback_event = {NULL,NULL,NULL};

void onKeyDown(void (*callback)(int evt)){
  callback_event.keydown = callback;
}

void onKeyPress(void (*callback)(int evt)){
  callback_event.keypress = callback;
}

void onKeyUp(void (*callback)(int evt)){
  callback_event.keyup = callback;
}

void mainLoop(struct Node* node, struct shader *sh, SDL_Window* win){
	glEnable(GL_DEPTH_TEST);


  GLuint Varrid;
	glGenVertexArrays(1, &Varrid);
	glBindVertexArray(Varrid);
	
	char terminer = 0;
	
	SDL_Event evenements;
	
	int lastKey = 0;
	char keypress = 0;
	while(!terminer)
	{
		while(SDL_PollEvent(&evenements) ){

			switch(evenements.type) {
				case SDL_QUIT	: terminer = 1;	break;
				case SDL_KEYDOWN :
					   keypress = 1;
					   lastKey = evenements.key.keysym.sym;
					   if(callback_event.keydown)
					  callback_event.keydown(evenements.key.keysym.sym);
				  break;
				case SDL_KEYUP :
					 keypress = 0; 
					  if(callback_event.keydown)
					  callback_event.keyup(evenements.key.keysym.sym);
				  break;
			}
		}
		
		if(keypress && callback_event.keypress)
		  callback_event.keypress(lastKey);
		
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		 usleep(4000);
		drawScene(node, sh);

		SDL_GL_SwapWindow(win);
		
		//glFlush();
	}
	SDL_DestroyWindow(win);
	SDL_Quit();
}


void quit(SDL_Window *win, SDL_GLContext *contexteOpenGL) {
  	//freeNode(&n);
	//deleteShader(&sh);

	SDL_GL_DeleteContext(contexteOpenGL);
	
}
