namespace ms {
	class GLButton : public GLSprite {
	public:
		GLButton();
		virtual ~GLButton();									
		virtual void init();
		virtual void clean();
		virtual void draw();
		virtual void setViewTouch(UIView* _viewTouch){viewTouch = _viewTouch;}
		virtual BOOL update(ms::Uint32 elapsedTime);
		virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
		void alignParamToTexture(float scale);
		void setEnable(BOOL enable);
		void setReactionRect(const CGRect& rect);
		void setReactionPos(const ms::Vector2f& _pos);
		CGRect getReactionRect(){return reactionRect;}
		BOOL getPush();
		
		enum NOTIFY {
			NOTIFY_PUSH = 0,
		} NOTIFY;

		enum VISIBLE_TYPE {
			VISIBLE_TYPE_IDLE = 0,
			VISIBLE_TYPE_PUSH,	
			VISIBLE_TYPE_DISABLE,
			
			VISIBLE_TYPE_COUNT,
		};
		
		void setTextureWithState(ms::GLButton::VISIBLE_TYPE _visibleType, GLTexture* _texture);
		void setUVWithState(ms::GLButton::VISIBLE_TYPE _visibleType, const UV& _uv);
		void setSizeWithState(ms::GLButton::VISIBLE_TYPE _visibleType, const ms::Vector2f& _size);
		ms::Vector2f getSizeWithState(ms::GLButton::VISIBLE_TYPE _visibleType);
	private:
		enum STATE {
			STATE_IDLE = 0,
			STATE_PUSH_WAIT_INIT,
			STATE_PUSH_WAIT,
			STATE_PUSH,
		};
		STATE			state;
		VISIBLE_TYPE	visibleType;
		GLTexture*		textureState[VISIBLE_TYPE_COUNT];
		UV				uv[VISIBLE_TYPE_COUNT];
		ms::Vector2f	size[VISIBLE_TYPE_COUNT];
		UIView*			viewTouch;
		CGRect			reactionRect;
		BOOL			isDrawFlag;
		int				timer;
	};
}
