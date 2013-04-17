namespace ms {
	class GLProgressBar : public GLRender {
	public:
		GLProgressBar();
		virtual ~GLProgressBar();	
		virtual void init(GLTexture* _bgTexture, GLTexture* _bodyLeftTexture, GLTexture* _bodyRightTexture, GLTexture* _bodyCenterTexture, Vector2f& _bodyPos, ms::Vector2f& _bodyCenterSize, float _imageScale, float _uvAnimSpeed);
		virtual BOOL update(ms::Uint32 elapsedTime);
		virtual void draw();
		virtual void setVisible(BOOL _visible);
		virtual void setPos(const ms::Vector3f& _pos);
		virtual void setRate(float _rate);
	private:
		GLSprite*	bgSprite;
		GLSprite*	bodyLeftSprite;
		GLSprite*	bodyRightSprite;
		GLSprite*	bodyCenterSprite[2];
		Vector2f	bodyPos;
		Vector2f	bodyCenterSize;
		float		rate;
		float		uvAnimSpeed;
		float		uvAnimRate;
		float		imageScale;
		enum DRAW_STATE {
			DRAW_STATE_NONE = 0,
			DRAW_STATE_ONE,
			DRAW_STATE_ALL,
		};
		DRAW_STATE	drawState;

		void updateBar();
	};
}
