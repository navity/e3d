#include <stdio.h>
#include <stdlib.h>
#include <math.h>

float *newMat4(){

	float *mat = malloc(16*sizeof(float));

	mat[0] = 1;
	mat[1] = 0;
	mat[2] = 0;
	mat[3] = 0;
	mat[4] = 0;
	mat[5] = 1;
	mat[6] = 0;
	mat[7] = 0;
	mat[8] = 0;
	mat[9] = 0;
	mat[10] = 1;
	mat[11] = 0;
	mat[12] = 0;
	mat[13] = 0;
	mat[14] = 0;
	mat[15] = 1;

	return mat;
}

float *identityMat4(float *dest){


	if(!dest)
		dest = newMat4();
	else{
		dest[0] = 1;
		dest[1] = 0;
		dest[2] = 0;
		dest[3] = 0;
		dest[4] = 0;
		dest[5] = 1;
		dest[6] = 0;
		dest[7] = 0;
		dest[8] = 0;
		dest[9] = 0;
		dest[10] = 1;
		dest[11] = 0;
		dest[12] = 0;
		dest[13] = 0;
		dest[14] = 0;
		dest[15] = 1;
	}
	return dest;
}


float *copyMat4(float *dest, float *mat){

	if(!dest)
		dest = newMat4();

	dest[0] = mat[0];
	dest[1] = mat[1];
	dest[2] = mat[2];
	dest[3] = mat[3];
	dest[4] = mat[4];
	dest[5] = mat[5];
	dest[6] = mat[6];
	dest[7] = mat[7];
	dest[8] = mat[8];
	dest[9] = mat[9];
	dest[10] = mat[10];
	dest[11] = mat[11];
	dest[12] = mat[12];
	dest[13] = mat[13];
	dest[14] = mat[14];
	dest[15] = mat[15];

	return dest;
}

float getMat4(float *mat, short i, short j){
	return mat[j*4+i];
}


float *multMat4(float *dest, float *mat1, float *mat2) {
	
	if(!dest)
		dest = newMat4();

	float m11 = mat1[0] * mat2[0] 	+ mat1[1] * mat2[4] 	+ mat1[2] * mat2[8] 	+ mat1[3] * mat2[12];
	float m12 = mat1[0] * mat2[1] 	+ mat1[1] * mat2[5] 	+ mat1[2] * mat2[9] 	+ mat1[3] * mat2[13];
	float m13 = mat1[0] * mat2[2] 	+ mat1[1] * mat2[6] 	+ mat1[2] * mat2[10] 	+ mat1[3] * mat2[14];
	float m14 = mat1[0] * mat2[3] 	+ mat1[1] * mat2[7] 	+ mat1[2] * mat2[11] 	+ mat1[3] * mat2[15];

	float m21 = mat1[4] * mat2[0] 	+ mat1[5] * mat2[4] 	+ mat1[6] * mat2[8] 	+ mat1[7] * mat2[12];
	float m22 = mat1[4] * mat2[1] 	+ mat1[5] * mat2[5] 	+ mat1[6] * mat2[9] 	+ mat1[7] * mat2[13];
	float m23 = mat1[4] * mat2[2] 	+ mat1[5] * mat2[6] 	+ mat1[6] * mat2[10] 	+ mat1[7] * mat2[14];
	float m24 = mat1[4] * mat2[3] 	+ mat1[5] * mat2[7] 	+ mat1[6] * mat2[11] 	+ mat1[7] * mat2[15];

	float m31 = mat1[8] * mat2[0] 	+ mat1[9] * mat2[4] 	+ mat1[10] * mat2[8] 	+ mat1[11] * mat2[12];
	float m32 = mat1[8] * mat2[1] 	+ mat1[9] * mat2[5] 	+ mat1[10] * mat2[9] 	+ mat1[11] * mat2[13];
	float m33 = mat1[8] * mat2[2] 	+ mat1[9] * mat2[6] 	+ mat1[10] * mat2[10] 	+ mat1[11] * mat2[14];
	float m34 = mat1[8] * mat2[3] 	+ mat1[9] * mat2[7] 	+ mat1[10] * mat2[11] 	+ mat1[11] * mat2[15];

	float m41 = mat1[12] * mat2[0] 	+ mat1[13] * mat2[4] 	+ mat1[14] * mat2[8] 	+ mat1[15] * mat2[12];
	float m42 = mat1[12] * mat2[1] 	+ mat1[13] * mat2[5] 	+ mat1[14] * mat2[9] 	+ mat1[15] * mat2[13];
	float m43 = mat1[12] * mat2[2] 	+ mat1[13] * mat2[6] 	+ mat1[14] * mat2[10] 	+ mat1[15] * mat2[14];
	float m44 = mat1[12] * mat2[3] 	+ mat1[13] * mat2[7] 	+ mat1[14] * mat2[11] 	+ mat1[15] * mat2[15];


	dest[0] = m11; dest[1] = m12; dest[2] = m13; dest[3] = m14;
	dest[4] = m21; dest[5] = m22; dest[6] = m23; dest[7] = m24;
	dest[8] = m31; dest[9] = m32; dest[10] = m33; dest[11] = m34;
	dest[12] = m41; dest[13] = m42; dest[14] = m43; dest[15] = m44;

	return dest;
}

float *translateMat4(float *dest, float *mat, float vec3[3]){

	float *transmat = newMat4();
/*
	transmat[3] = vec3[0];
	transmat[7] = vec3[1];
	transmat[11] = vec3[2];
*/
	transmat[12] = vec3[0];
	transmat[13] = vec3[1];
	transmat[14] = vec3[2];

	dest = multMat4(dest,mat,transmat);
	free(transmat);
	return dest;
}

float *scaleMat4(float *dest, float *mat, float vec3[3]){
	float *scalemat = newMat4();

	scalemat[0] = vec3[0];
	scalemat[5] = vec3[1];
	scalemat[10] = vec3[2];

	
	dest = multMat4(dest,mat,scalemat);
	free(scalemat);
	return dest;
}

float *orthoMat4( float left, float right, float bottom, float top, float near, float far) {

	float *dest = newMat4();

float rl = right - left;
float tb = top - bottom;
float fn = far - near;

dest[0] = 2 / rl;
dest[5] = 2 / tb;
dest[10] = -2/ fn;
dest[12] = -( left + right) / rl;
dest[13] = -( top + bottom) / tb;
dest[14] = -( far + near) / fn;

	return dest;
}



float* lookatMat4(float *dest, float eye[3], float center[3], float up[3]) {
    if (!dest) { dest = newMat4(); }

    double x0, x1, x2, y0, y1, y2, z0, z1, z2, len,
        eyex = eye[0],
        eyey = eye[1],
        eyez = eye[2],
        upx = up[0],
        upy = up[1],
        upz = up[2],
        centerx = center[0],
        centery = center[1],
        centerz = center[2];

    if (eyex == centerx && eyey == centery && eyez == centerz) {
        return newMat4();
    }

    //vec3.direction(eye, center, z);
    z0 = eyex - centerx;
    z1 = eyey - centery;
    z2 = eyez - centerz;

    // normalize (no check needed for 0 because of early return)
    len = 1 / sqrt(z0 * z0 + z1 * z1 + z2 * z2);
    z0 *= len;
    z1 *= len;
    z2 *= len;

    //vec3.normalize(vec3.cross(up, z, x));
    x0 = upy * z2 - upz * z1;
    x1 = upz * z0 - upx * z2;
    x2 = upx * z1 - upy * z0;
    len = sqrt(x0 * x0 + x1 * x1 + x2 * x2);
    if (!len) {
        x0 = 0;
        x1 = 0;
        x2 = 0;
    } else {
        len = 1 / len;
        x0 *= len;
        x1 *= len;
        x2 *= len;
    }

    //vec3.normalize(vec3.cross(z, x, y));
    y0 = z1 * x2 - z2 * x1;
    y1 = z2 * x0 - z0 * x2;
    y2 = z0 * x1 - z1 * x0;

    len = sqrt(y0 * y0 + y1 * y1 + y2 * y2);
    if (!len) {
        y0 = 0;
        y1 = 0;
        y2 = 0;
    } else {
        len = 1 / len;
        y0 *= len;
        y1 *= len;
        y2 *= len;
    }

    dest[0] = x0;
    dest[1] = y0;
    dest[2] = z0;
    dest[3] = 0;
    dest[4] = x1;
    dest[5] = y1;
    dest[6] = z1;
    dest[7] = 0;
    dest[8] = x2;
    dest[9] = y2;
    dest[10] = z2;
    dest[11] = 0;
    dest[12] = -(x0 * eyex + x1 * eyey + x2 * eyez);
    dest[13] = -(y0 * eyex + y1 * eyey + y2 * eyez);
    dest[14] = -(z0 * eyex + z1 * eyey + z2 * eyez);
    dest[15] = 1;

    return dest;
}


void printMat4( float *mat){

	printf( 	"\nmat4 \n { %f %f %f %f\n"
			"            %f %f %f %f\n"
			"            %f %f %f %f\n"
			"            %f %f %f %f } \n",  
			mat[0], mat[1], mat[2], mat[3],
			mat[4], mat[5], mat[6], mat[7],
			mat[8], mat[9], mat[10], mat[11],
			mat[12], mat[13], mat[14], mat[15] );

}





/*
int main(){

	//float *mat = newMat4();
	float *mat2 = newMat4();

	int i;

	for(i = 0; i < 16; i++){
		mat2[i] = i;
	}

	float vec3[] = {1,2,3};
	float *mat = translateMat4(NULL, mat2, vec3);

	afficheMat4(mat);

	return 0;
}*/
