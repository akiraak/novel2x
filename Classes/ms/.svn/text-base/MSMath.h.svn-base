#ifndef PI
#define PI (3.1415926535)
#endif

#ifndef ANG2RAD
#define ANG2RAD(a) ((a)*PI/180.0)
#define RAD2ANG(a) ((a)*180.0/PI)
#endif

namespace ms {
	namespace Matrix {
		
		void zero(Matrixf& dstMatrix);
		void zero(Matrix33f& dstMatrix);
		void identity(Matrixf& dstMatrix);
		void identity(Matrix33f& dstMatrix);
		void mult(Matrixf& mat1, const Matrixf& mat2);
		void mult(Matrix33f& mat1, const Matrix33f& mat2);
		void translate(Matrixf& dstMatrix, const Vector3f& pos);
		void rotateX(Matrixf& dstMatrix, float radian);
		void rotateY(Matrixf& dstMatrix, float radian);
		void rotateZ(Matrixf& dstMatrix, float radian);
		void rotateX(Matrix33f& dstMatrix, float radian);
		void rotateY(Matrix33f& dstMatrix, float radian);
		void rotateZ(Matrix33f& dstMatrix, float radian);
	}
	namespace Vector {
		void cross(Vector3f& vec1, const Vector3f& vec2);
		float dot(const Vector3f& vec1, const Vector3f& vec2);
	};
	namespace Math {
		float avg(const float* values, int count);
		int avg(const int* values, int count);
	};
}
