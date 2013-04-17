namespace ms {
	class GLSprite : public GLRender {
	public:
		GLSprite();
		virtual ~GLSprite();	
		virtual void init();
		void setTexture(ms::GLTexture* _texture);
		GLTexture* getTexture(){return texture;}
		void alignParamToTexture(float imageScale = 1.0f);
		virtual void setPos(const ms::Vector3f& _pos);
		void setSize(const Vector2f& _size);
		Vector2f getSize(){return size;}
		void setUV(const UV& _uv){uv = _uv;}
		UV getUV(){return uv;}
		void setAlphaTest(BOOL status){alphaTest = status;}
		void setColor(UIColor* color);
		void setColor(const Color4f& color);
		Color4f getColor();
		void setFixedSize(Vector2f _size);
		void setScale(const CGPoint& _scale){scale=_scale;}
		void setScalePoint(const CGPoint& _scalePoint){scalePoint=_scalePoint;}
		void draw();

		static const CGPoint LT;
		static const CGPoint CT;
		static const CGPoint RT;
		static const CGPoint LC;
		static const CGPoint CC;
		static const CGPoint RC;
		static const CGPoint LB;
		static const CGPoint CB;
		static const CGPoint RB;
	private:
		Vector2f	imageSize;
		Vector2f	textureSize;
		Vector2f	size;
		CGPoint		scale;
		CGPoint		scalePoint;
		CGPoint		currentScalePoint;
		CGFloat		r;
		UV			uv;
		GLTexture*	texture;
		GLfloat		vertexColors[16];
		BOOL		alphaTest;
	};
}
