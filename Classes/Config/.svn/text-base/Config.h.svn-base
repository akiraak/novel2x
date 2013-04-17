#import "MS.h"

class Config: public ms::Object{

public:
	Config();
	virtual ~Config();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	void draw2D();
	virtual void onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther);
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	void start(NSString* _dirName);
private:
	enum LINE {
		LINE_NONE = -1,
		
		LINE_LEFT = 0,
		LINE_RIGHT,
		LINE_TOP,
		LINE_BOTTOM,
		
		LINE_COUNT,
	};
	enum STATE {
		STATE_DISABLE = 0,
		STATE_INIT,
		STATE_LOAD_WAIT,
		STATE_FADEIN_INIT,
		STATE_FADEIN,
		STATE_VIEW,
		STATE_FADEOUT_INIT,
		STATE_FADEOUT,
	};
	STATE			state;
	ms::GLTexture*	paperTexture;
	ms::GLSprite*	paperSprite;
	ms::Vector2f	paperSpriteSize;
	ms::GLSprite*	lineSprite[LINE_COUNT];
	ms::GLSprite*	lineMarkSprite[LINE_COUNT];
	ms::GLSprite*	showAreaDarkSprite[LINE_COUNT];
	ms::GLSprite*	topBackSprite;
	ms::GLSprite*	topTitleSprite;
	ms::GLButton*	readButton;
	LINE			editLine;
	float			showArea[LINE_COUNT];
	ms::Vector2f	touchPosPrev;
	BOOL			drawFlag;
	NSString*		dirName;
	BOOL			showAlert;
	
	NotifyNode		readButtonNotifyNode;

	void setupSprite();
};



