#import "MS.h"

namespace ms {
	//--------------------------------
	GLSprite3D::GLSprite3D():
	texture(NULL),
	alphaTest(FALSE)
	{
		
		memset(pos, 0, sizeof(pos));
		memset(uv, 0, sizeof(uv));
		memset(colors, 0, sizeof(colors));
	}
	//--------------------------------
	GLSprite3D::~GLSprite3D(){
	}
	//--------------------------------
	void GLSprite3D::init(){
	}
	//--------------------------------
	void GLSprite3D::setPos(Uint32 index, const Vector3f& _pos){
		ASSERT(index <= 4);
		pos[index] = _pos;
	}
	//--------------------------------
	void GLSprite3D::setColor(Uint32 index, const Color4f& _colors){
		ASSERT(index <= 4);
		colors[index] = _colors;
	}
	//--------------------------------
	void GLSprite3D::setUV(Uint32 index, const Vector2f& _uv){
		ASSERT(index <= 4);
		uv[index] = _uv;
	}
	//--------------------------------
	void GLSprite3D::draw(){
		if(getVisible()){
			if(texture){
				GLuint textureName = texture->getTextureName();
				glBindTexture(GL_TEXTURE_2D, textureName);
				glTexCoordPointer(2, GL_FLOAT, 0, (float*)&uv);
				glEnableClientState(GL_TEXTURE_COORD_ARRAY);
			}else{
				glDisable(GL_TEXTURE_2D);
			}

			glVertexPointer(3, GL_FLOAT, 0, pos);
			glEnableClientState(GL_VERTEX_ARRAY);
			
			glColorPointer(4, GL_FLOAT, 0, colors);
			glEnableClientState(GL_COLOR_ARRAY);
			
			if(alphaTest){
				glEnable(GL_ALPHA_TEST);
			}
			
			glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
			
			if(alphaTest){
				glDisable(GL_ALPHA_TEST);
			}
			if(!texture){
				glEnable(GL_TEXTURE_2D);
			}
		}
	}
}

