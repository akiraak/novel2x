#import "MS.h"

namespace ms {
	namespace Matrix {
		//--------------------------------
		void zero(Matrixf& dstMatrix){
			static const Matrixf matrixIdentity = {
				0.0f, 0.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 0.0f, 0.0f,
			};
			dstMatrix = matrixIdentity;
		}
		//--------------------------------
		void zero(Matrix33f& dstMatrix){
			static const Matrix33f matrixIdentity = {
				0.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 0.0f,
			};
			dstMatrix = matrixIdentity;
		}
		//--------------------------------
		void identity(Matrixf& dstMatrix){
			static const Matrixf matrixZero = {
				1.0f, 0.0f, 0.0f, 0.0f,
				0.0f, 1.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 1.0f, 0.0f,
				0.0f, 0.0f, 0.0f, 1.0f,
			};
			dstMatrix = matrixZero;
		}
		//--------------------------------
		void identity(Matrix33f& dstMatrix){
			static const Matrix33f matrixZero = {
				1.0f, 0.0f, 0.0f,
				0.0f, 1.0f, 0.0f,
				0.0f, 0.0f, 1.0f,
			};
			dstMatrix = matrixZero;
		}
		//--------------------------------
		void mult(Matrixf& mat1, const Matrixf& mat2)
		{
/*			Matrixf dst;
			zero(dst);
			for(int i= 0; i < 4; i++){
				for(int j = 0; j < 4; j++){
					for(int k = 0; k < 4; k++){
						dst.m[i][j] += mat1.m[i][k]*mat2.m[k][j];
					}
				}
			}
			mat1 = dst;
*/
			Matrixf dst;
			zero(dst);
			//受け取った２つの行列の掛け算を行う。
			for(int i=0;i<4;i++) {
				for(int j=0;j<4;j++) {
					for(int k=0;k<4;k++) {
						dst.m[i][j]+=mat1.m[i][k]*mat2.m[k][j];
					}
				}
			}
			mat1=dst;
		}
		//--------------------------------
		void mult(Matrix33f& mat1, const Matrix33f& mat2){
			Matrix33f dst;
			zero(dst);
			//受け取った２つの行列の掛け算を行う。
			for(int i=0;i<3;i++) {
				for(int j=0;j<3;j++) {
					for(int k=0;k<3;k++) {
						dst.m[i][j]+=mat1.m[i][k]*mat2.m[k][j];
					}
				}
			}
			mat1=dst;
		}
		//--------------------------------
		void translate(Matrixf& dstMatrix, const Vector3f& pos){
			identity(dstMatrix);
			dstMatrix.m[3][0] = pos.x;
			dstMatrix.m[3][1] = pos.y;
			dstMatrix.m[3][2] = pos.z;
		}
		//--------------------------------
		void rotateX(Matrixf& dstMatrix, float radian){
			identity(dstMatrix);
			dstMatrix.m[1][1] = cosf(radian);
			dstMatrix.m[1][2] = -sinf(radian);
			dstMatrix.m[2][1] = sinf(radian);
			dstMatrix.m[2][2] = cos(radian);
		}
		//--------------------------------
		void rotateY(Matrixf& dstMatrix, float radian){
			identity(dstMatrix);
			dstMatrix.m[0][0] = cosf(radian);
			dstMatrix.m[0][2] = sinf(radian);
			dstMatrix.m[2][0] = -sinf(radian);
			dstMatrix.m[2][2] = cos(radian);
		}
		//--------------------------------
		void rotateZ(Matrixf& dstMatrix, float radian){
			identity(dstMatrix);
			dstMatrix.m[0][0] = cosf(radian);
			dstMatrix.m[0][1] = -sinf(radian);
			dstMatrix.m[1][0] = sinf(radian);
			dstMatrix.m[1][1] = cos(radian);
		}
		//--------------------------------
		void rotateX(Matrix33f& dstMatrix, float radian){
			identity(dstMatrix);
			dstMatrix.m[1][1] = cosf(radian);
			dstMatrix.m[1][2] = -sinf(radian);
			dstMatrix.m[2][1] = sinf(radian);
			dstMatrix.m[2][2] = cos(radian);
		}
		//--------------------------------
		void rotateY(Matrix33f& dstMatrix, float radian){
			identity(dstMatrix);
			dstMatrix.m[0][0] = cosf(radian);
			dstMatrix.m[0][2] = sinf(radian);
			dstMatrix.m[2][0] = -sinf(radian);
			dstMatrix.m[2][2] = cos(radian);
		}
		//--------------------------------
		void rotateZ(Matrix33f& dstMatrix, float radian){
			identity(dstMatrix);
			dstMatrix.m[0][0] = cosf(radian);
			dstMatrix.m[0][1] = -sinf(radian);
			dstMatrix.m[1][0] = sinf(radian);
			dstMatrix.m[1][1] = cos(radian);
		}
	};
	namespace Vector {
		//--------------------------------
		void cross(Vector3f& vec1, const Vector3f& vec2){
			Vector3f dstVec;
			dstVec.x = (vec1.y*vec2.z)-(vec2.y-vec1.z);
			dstVec.y = (vec1.z*vec2.x)-(vec2.z-vec1.x);
			dstVec.z = (vec1.x*vec2.y)-(vec2.x-vec1.y);
			vec1 = dstVec;
		}
		//--------------------------------
		float dot(const Vector3f& vec1, const Vector3f& vec2){
			return (vec1.x*vec2.x)+(vec1.y*vec2.y)+(vec1.z*vec2.z);
		}
	};
	namespace Math {
		//--------------------------------
		float avg(const float* values, int count){
			ASSERT(values);
			ASSERT(count > 0);
			float avg = 0.0f;
			for(int i = 0; i < count; i++){
				avg += values[i];
			}
			return avg / (float)count;
		}
		//--------------------------------
		int avg(const int* values, int count){
			ASSERT(values);
			ASSERT(count > 0);
			int avg = 0;
			for(int i = 0; i < count; i++){
				avg += values[i];
			}
			return avg / count;
		}
	};
}
