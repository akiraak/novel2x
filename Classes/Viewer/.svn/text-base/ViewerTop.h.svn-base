#import "MS.h"
#import "AppData.h"

class ViewerTop: public ms::Object{
public:
	ViewerTop();
	virtual ~ViewerTop();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther);
	static void show(BOOL enable, ms::Uint32 _showTime);
	static BOOL getShow();
	static ViewerTop* I(){ASSERT(instance);return instance;}
	enum NOTIFY{
		NOTIFY_AREA=0,
		NOTIFY_MOVE,
		NOTIFY_NOTE,
		NOTIFY_TWITTER,
		NOTIFY_BOOKS,
		NOTIFY_VIEWER_MODE_NORMAL,
		NOTIFY_VIEWER_MODE_CONVERT,
	};
private:
	static ViewerTop* instance;
	enum {
		BUTTON_W_COUNT = 5,
	};
	enum BUTTON {
		BUTTON_AREA = 0,
		BUTTON_MOVE,
		BUTTON_NOTE,
		BUTTON_TWITTER,
		BUTTON_BOOKS,

		BUTTON_CONVERT,
		
		BUTTON_COUNT,
	};
	enum STATE {
		STATE_HIDE = 0,
		STATE_SHOW,
		STATE_IN_INIT,
		STATE_IN,
		STATE_OUT,
	};
	STATE				state;
	float				top;
	float				topMin;
	float				topMax;
	ms::GLSprite*		backSprite;
	ms::GLButton*		button[BUTTON_W_COUNT];
	ms::GLButton*		convertButton[VIEWER_MODE_COUNT];

	BOOL				drawFlag;
	ms::Uint32			showTime;
	ms::Uint32			showTimer;
	VIEWER_MODE			viewerMode;
	VIEWER_MODE			viewerModePrev;

	NotifyNode			buttonNotifyNode[BUTTON_COUNT];
	NotifyNode			convertButtonNotifyNode[VIEWER_MODE_COUNT];
	
	void setupSprite();
};



