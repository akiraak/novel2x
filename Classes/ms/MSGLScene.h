@class MSGLScene;

namespace ms {
	class GLScene : public ms::Object {
	public:
		enum SCREEN_TYPE {
			SCREEN_TYPE_VERTICALITY = 0,
			SCREEN_TYPE_HORIZONTALLY,
			
			SCREEN_TYPE_COUNT,
		};
		GLScene();
		virtual ~GLScene();
		
		// init の前に呼び出しが必要な関数
		static void setScreenSize(const ms::Vector2n& size);
		void setSuportRetina(){suportRetina = TRUE;}

		virtual void init(CGRect _frame);
		virtual void start();
		virtual void stop();
		virtual BOOL update(Uint32 elapsedTime);
		virtual void draw();
		virtual void touchesBegan(const Vector2f* touchPos, Uint32 touchCount, NSSet* touches, UIEvent* event);
		virtual void touchesMoved(const Vector2f* touchPos, Uint32 touchCount, NSSet* touches, UIEvent* event);
		virtual void touchesEnded(const Vector2f* touchPos, Uint32 touchCount, NSSet* touches, UIEvent* event);
		virtual void touchesCancelled(const Vector2f* touchPos, Uint32 touchCount, NSSet* touches, UIEvent* event);
		virtual void onChangeSceneType(SCREEN_TYPE type);
		void onLayoutSubviews();
		void onUpdate();
		UIView* getView(){return (UIView*)view;}
		EAGLContext* getContext(){return context;}
		GLuint getViewRenderbuffer(){return viewRenderbuffer;}
		GLuint getViewFramebuffer(){return viewFramebuffer;}
		GLint getBackingWidth(){return backingWidth;}
		GLint getBackingHeight(){return backingHeight;}
		ms::Vector2n getScreenSize();
		void setScreenType(SCREEN_TYPE type);
		SCREEN_TYPE getScreenType(){return screenType;}
		void setContentScale(float _contentScale){contentScale = _contentScale;}
		float getContentScale(){return contentScale;}
		float getImageScale(){return 1.0f/contentScale;}
		void setNeedsDraw(){isDrawFlag = TRUE;}
		
		static int SCREEN_SIZE_W;
		static int SCREEN_SIZE_H;
		enum {
			TOUCH_MAX		= 4,
		};
	private:
		MSGLScene* view;
		GLint backingWidth;
		GLint backingHeight;
		EAGLContext* context;
		GLuint viewRenderbuffer;
		GLuint viewFramebuffer;
		GLuint depthRenderbuffer;
		NSTimer* animationTimer;
		Uint32 prevUpdateTime;
		SCREEN_TYPE screenType;
		float contentScale;
		BOOL isDrawFlag;
		BOOL suportRetina;

		void createFramebuffer();
		void destroyFramebuffer();
	};
};

@interface MSGLScene : UIView {
	ms::GLScene* scene;
}
-(id)initWithFrame:(CGRect)frame parent:(ms::GLScene*)_scene;
@end
