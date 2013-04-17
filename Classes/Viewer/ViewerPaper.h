#import "MS.h"
#import "ViewerPaperOne.h"
#import "ViewerTouchMoveDark.h"

class ViewerPaper: public ms::Object{

public:
	ViewerPaper();
	virtual ~ViewerPaper();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	void draw2D();
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	void setShowArea(const ms::Rect& _showArea);
	void setDirPath(NSString* dirPath);
	void changeViewerMode(VIEWER_MODE _mode);
	void start();
	void pause(BOOL status);
	void touchMoveNext();
	enum NOTIFY {
		NOTIFY_CHANGE_PAGE = 0,
		NOTIFY_INIT_END,
	};
	struct NOTIFY_INFO {
		ms::Uint32 pageCount;
		ms::Uint32 pageIndex;
	};
	void showDebug(BOOL status);
private:
	enum STATE {
		STATE_DISABLE = 0,
		STATE_INIT,
		STATE_FIRST_WAIT,
		STATE_FADE_IN_INIT,
		STATE_FADE_IN,
		STATE_OTHER_WAIT,
		STATE_IDLE,
		STATE_TOUCH_MOVE_INIT,
		STATE_TOUCH_MOVE,
		STATE_TOUCH_MOVE_DARK_HIDE_WAIT,
		STATE_PAGE_LOAD_PREV_INIT,
		STATE_PAGE_LOAD_PREV,
		STATE_PAGE_LOAD_NEXT_INIT,
		STATE_PAGE_LOAD_NEXT,
		STATE_CHANGE_VIEWER_MODE_INIT,
		STATE_CHANGE_VIEWER_MODE_FADEOUT_WAIT,
		STATE_CHANGE_VIEWER_MODE_FADEIN_WAIT,
		STATE_CONVERT_DEBUG_INIT,
		STATE_CONVERT_DEBUG_FADEOUT_WAIT,
		STATE_CONVERT_DEBUG,
		STATE_CONVERT_DEBUG_FADEIN_WAIT,
		STATE_PAUSE,
	};
	enum SPRITE {
		SPRITE_PREV = 0,
		SPRITE_NOW,
		SPRITE_NEXT,
		
		SPRITE_COUNT,
	};
	STATE state;
	BOOL			fastInit;
	VIEWER_MODE		viewerMode;
	ms::GLTexture*	texture[SPRITE_COUNT];
	ms::GLSprite*	sprite[SPRITE_COUNT];
	ms::GLTexture*	updateTexture;
	ms::Rect		showArea;
	BOOL			drawFlag;
	float			zoom;
	BOOL			touchStart;
	ms::Vector2f	touchStartPos;
	ms::Vector2f	touchPosPrev;
	ms::Vector2f	posBase;
	ms::Vector2f	addPos;
	float			moveSpeed;
	float			moveEndPos;
	float			moveDarkPosRight;
	float			changeEndPos;
	SPRITE			updateSprite;
	BOOL			isCheckPageLoad;
	float			pageLoadCenterPosX;
	ViewerTouchMoveDark* touchMoveDark;
	
	enum{
		FILE_PATH_MAX	= 4096,
		FILE_NAME_MAX	= 256,
	};
	ms::Sint32		fileCount;
	NSString*		fileBasePath;
	char**			fileNameArray;
	ms::Uint32		pageIndex;
	
	ViewerPaperOne* paperOne[SPRITE_COUNT];
	
	void setupSprite();
	void checkPageLoad();
	void sendPageChange();
};



