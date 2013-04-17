namespace ms {
	class GLKeyedSprite : public GLRender {
	public:
		GLKeyedSprite();
		virtual ~GLKeyedSprite();	

		struct KEY_INFO {
			int	key;
			UV	uv;
		};
		enum POS_TYPE {
			POS_TYPE_LT = 0,
			POS_TYPE_RT,
			
			POS_TYPE_COUNT,
		};
		
		virtual void init(ms::Uint32 _keyCount, ms::Uint32 _spriteMax);
		virtual void setPos(const ms::Vector3f& _pos);
		virtual void setPosType(POS_TYPE _posType);
		virtual void setTexture(ms::GLTexture* _texture, float _imageScale=1.0f);
		virtual void setColor(UIColor* color);
		virtual void setColor(const Color4f& color);
		virtual void setKeyInfo(ms::Uint32 _keyIndex, const KEY_INFO& _keyInfo);
		virtual void setRenderKey(const int* keys, ms::Uint32 keysCount);
		virtual void setRenderKeyWithCString(const char* string);
		virtual void setGapPos(const ms::Vector2f& _gapPos){gapPos = _gapPos;}
		virtual void draw();
		
	private:
		ms::Uint32		keyCount;
		ms::Uint32		spriteMax;
		ms::Uint32		renderKeysCount;
		KEY_INFO*		keyInfo;
		int*			renderKeys;
		ms::GLTexture*	texture;
		ms::GLSprite**	sprite;
		ms::Vector2f	gapPos;
		POS_TYPE		posType;
		float			imageScale;
		
		const KEY_INFO* getKeyInfo(int key);
	};
}
