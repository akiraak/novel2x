#import "MS.h"

class ViewerMoveTop: public ms::Object{
public:
	ViewerMoveTop();
	virtual ~ViewerMoveTop();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther);
	static void show(BOOL enable, ms::Uint32 _showTime);
	static BOOL getShow();
	static ViewerMoveTop* I(){ASSERT(instance);return instance;}
	enum NOTIFY{
		NOTIFY_CANCEL=0,
		NOTIFY_OK,
	};
private:
	static ViewerMoveTop* instance;
	enum BUTTON {
		BUTTON_CANCEL = 0,
		BUTTON_OK,
		
		BUTTON_COUNT,
	};
	enum STATE {
		STATE_HIDE = 0,
		STATE_SHOW,
		STATE_IN,
		STATE_OUT,
	};
	STATE				state;
	float				top;
	float				topMin;
	float				topMax;
	ms::GLSprite*		backSprite;
	ms::GLButton*		button[BUTTON_COUNT];

	BOOL				drawFlag;
	ms::Uint32			showTime;
	ms::Uint32			showTimer;

	NotifyNode			buttonNotifyNode[BUTTON_COUNT];

	void setupSprite();
};



