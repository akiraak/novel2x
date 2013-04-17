#import "MS.h"

namespace ms {
	//--------------------------------
	const CGPoint GLSprite::LT = { 0.0f, 0.0f };
	const CGPoint GLSprite::CT = { 0.5f, 0.0f };
	const CGPoint GLSprite::RT = { 1.0f, 0.0f };
	const CGPoint GLSprite::LC = { 0.0f, 0.5f };
	const CGPoint GLSprite::CC = { 0.5f, 0.5f };
	const CGPoint GLSprite::RC = { 1.0f, 0.5f };
	const CGPoint GLSprite::LB = { 0.0f, 1.0f };
	const CGPoint GLSprite::CB = { 0.5f, 1.0f };
	const CGPoint GLSprite::RB = { 1.0f, 1.0f };

	//--------------------------------
	GLSprite::GLSprite():
	imageSize(Vector2fMake(0.0f, 0.0f)),
	textureSize(Vector2fMake(0.0f, 0.0f)),
	size(Vector2fMake(0.0f, 0.0f)),
	scale(CGPointMake(1.0f, 1.0f)),
	scalePoint(CC),
	currentScalePoint(CGPointMake(0.0f, 0.0f)),
	r(0.0f),
	uv(UVMake(0.0f, 0.0f, 0.0f, 0.0f)),
	texture(NULL),
	alphaTest(FALSE)
	{
		memset(vertexColors, 0, sizeof(vertexColors));
	}
	//--------------------------------
	GLSprite::~GLSprite(){
	}
	//--------------------------------
	void GLSprite::init(){
		setColor([UIColor colorWithWhite:1.0 alpha:1.0]);
	}
	//--------------------------------
	void GLSprite::setTexture(GLTexture* _texture){
		texture = _texture;
		if(_texture){
			imageSize = _texture->getImageSize();
			textureSize = _texture->getTextureSize();
		}
	}
	//--------------------------------
	void GLSprite::alignParamToTexture(float imageScale){
		uv = UVMake(0.0f, 0.0f, imageSize.x / textureSize.x, imageSize.y / textureSize.y);
		size = ms::Vector2fMake(imageSize.x*imageScale, imageSize.y*imageScale);
	}
	//--------------------------------
	void GLSprite::setPos(const ms::Vector3f& _pos){
		//ms::Vector3f pos = ms::Vector3fMake((int)_pos.x, (int)_pos.y, (int)_pos.z);
		GLRender::setPos(_pos);
	}
	//--------------------------------
	void GLSprite::setSize(const Vector2f& _size){
		//size = ms::Vector2fMake((int)_size.x, (int)_size.y);
		size = _size;
	}
	//--------------------------------
	void GLSprite::setColor(UIColor* color){
		CGColorRef cgcolor = [color CGColor];
		int numComponents = CGColorGetNumberOfComponents(cgcolor);
		if (numComponents == 2)
		{
			const CGFloat *comp = CGColorGetComponents(cgcolor);
			GLfloat colors[16] = {
				comp[0], comp[0], comp[0], comp[1],
				comp[0], comp[0], comp[0], comp[1],
				comp[0], comp[0], comp[0], comp[1],
				comp[0], comp[0], comp[0], comp[1],
			};
			memcpy(vertexColors, colors, sizeof(colors));		
		}
		else
		{
			const CGFloat *comp = CGColorGetComponents(cgcolor);
			GLfloat colors[16] = {
				comp[0], comp[1], comp[2], comp[3],
				comp[0], comp[1], comp[2], comp[3],
				comp[0], comp[1], comp[2], comp[3],
				comp[0], comp[1], comp[2], comp[3],
			};
			memcpy(vertexColors, colors, sizeof(colors));
		}
	}
	//--------------------------------
	void GLSprite::setColor(const Color4f& color){
		for(int i = 0; i < 4; i++){
			vertexColors[(i*4)+0] = color.r;
			vertexColors[(i*4)+1] = color.g;
			vertexColors[(i*4)+2] = color.b;
			vertexColors[(i*4)+3] = color.a;
		}
	}
	//--------------------------------
	Color4f GLSprite::getColor(){
		Color4f color = Color4fMake(vertexColors[0], vertexColors[1], vertexColors[2], vertexColors[3]);
		return color;
	}
	//--------------------------------
	void GLSprite::draw(){
		if(getVisible()){
			GLfloat		coordinates[] =
			{
				uv.u0,	uv.v0,
				uv.u1,	uv.v0,
				uv.u0,	uv.v1,
				uv.u1,	uv.v1,
			};
			Vector3f pos = getPos();
			Vector2f drawSize = Vector2fMake(size.x*scale.x, size.y*scale.y);
			GLfloat	widthHalf = drawSize.x * 0.5;
			GLfloat	heightHalf = drawSize.y * 0.5;
			GLfloat	centerX = pos.x + widthHalf;
			GLfloat	centerY = pos.y + heightHalf;
			
			// rotate at center
			CGPoint theScalePoint = CGPointMake(pos.x + drawSize.x * scalePoint.x - centerX, pos.y + drawSize.y * scalePoint.y - centerY);
			CGPoint lt = CGPointMake(centerX + ((-widthHalf)*cos(r) + (-heightHalf)*sin(r)),	centerY + ((-widthHalf)*-sin(r) + (-heightHalf)*cos(r)));
			CGPoint rt = CGPointMake(centerX + (( widthHalf)*cos(r) + (-heightHalf)*sin(r)),	centerY + (( widthHalf)*-sin(r) + (-heightHalf)*cos(r)));
			CGPoint lb = CGPointMake(centerX + ((-widthHalf)*cos(r) + ( heightHalf)*sin(r)),	centerY + ((-widthHalf)*-sin(r) + ( heightHalf)*cos(r)));
			CGPoint rb = CGPointMake(centerX + (( widthHalf)*cos(r) + ( heightHalf)*sin(r)),	centerY + (( widthHalf)*-sin(r) + ( heightHalf)*cos(r)));
			theScalePoint = CGPointMake(centerX + ((theScalePoint.x)*cos(r) + (theScalePoint.y)*sin(r)),	centerY + ((theScalePoint.x)*-sin(r) + (theScalePoint.y)*cos(r)));
			currentScalePoint = theScalePoint;
			
			// scale from scalepoint
			GLfloat	vertices[] =
			{
				(lt.x - theScalePoint.x)*scale.x + theScalePoint.x,	(lt.y - theScalePoint.y)*scale.y + theScalePoint.y,	pos.z,
				(rt.x - theScalePoint.x)*scale.x + theScalePoint.x,	(rt.y - theScalePoint.y)*scale.y + theScalePoint.y,	pos.z,
				(lb.x - theScalePoint.x)*scale.x + theScalePoint.x,	(lb.y - theScalePoint.y)*scale.y + theScalePoint.y,	pos.z,
				(rb.x - theScalePoint.x)*scale.x + theScalePoint.x,	(rb.y - theScalePoint.y)*scale.y + theScalePoint.y,	pos.z,
			};
			if(texture){
				GLuint textureName = texture->getTextureName();
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
				glBindTexture(GL_TEXTURE_2D, textureName);
				glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
				glEnableClientState(GL_TEXTURE_COORD_ARRAY);
			}else{
				glDisable(GL_TEXTURE_2D);
			}
			glVertexPointer(3, GL_FLOAT, 0, vertices);
			glEnableClientState(GL_VERTEX_ARRAY);
			
			glColorPointer(4, GL_FLOAT, 0, vertexColors);
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
/*	//--------------------------------
	CGSize GLSprite::getRenderSize(){
		if(sizeFixedEnable){
			return sizeFixed;
		}else{
			return ms::Vector2fMake((GLfloat)textureSize.x * (uv.u1 - uv.u0) * scale.x,
							  (GLfloat)textureSize.y * (uv.v1 - uv.v0) * scale.y);
		}
	}
*/
}

