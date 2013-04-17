namespace ms {
	class GLSprite3D : public GLRender {
	public:
		GLSprite3D();
		virtual ~GLSprite3D();	
		virtual void init();
		virtual void setTexture(ms::GLTexture* _texture){texture = _texture;}
		GLTexture* getTexture(){return texture;}
		virtual void setPos(Uint32 index, const Vector3f& _pos);
		virtual void setColor(Uint32 index, const Color4f& _colors);
		virtual void setUV(Uint32 index, const Vector2f& _uv);
		virtual void setAlphaTest(BOOL status){alphaTest = status;}
		virtual void draw();
		virtual ms::Vector3f getPos(Uint32 index){ASSERT(index>=0&&index<4);return pos[index];}
		virtual ms::Vector2f getUV(Uint32 index){ASSERT(index>=0&&index<4);return uv[index];}
	private:
		ms::GLTexture*	texture;
		Vector3f		pos[4];
		Vector2f		uv[4];
		Color4f			colors[4];
		BOOL			alphaTest;
	};
}
