#import "MS.h"
#import "ViewerPaper.h"
#import "ViewerCamera.h"
#import "ViewerVSlider.h"
#import "ViewerTop.h"
#import "ViewerMove.h"
#import "ViewerTouchFlash.h"
#import "ViewerPageNo.h"

enum AMAZON_URL_DELEGATE_STATE {
	AMAZON_URL_DELEGATE_STATE_IDLE = 0,
	AMAZON_URL_DELEGATE_STATE_ERROR,
	AMAZON_URL_DELEGATE_STATE_END,
};

@interface ViewerAmazonURLDelegate : NSObject {
	NSMutableData* webBookData;
	NSString* tinyURL;
	AMAZON_URL_DELEGATE_STATE state;
}

-(void)clean;
-(AMAZON_URL_DELEGATE_STATE)getState;

@property (nonatomic, retain) NSMutableData* webBookData;
@property (nonatomic, retain) NSString* tinyURL;

@end

@interface ViewerAlertDelegate : NSObject {
	NSString* bookTitle;
}

@property (nonatomic, retain) NSString* bookTitle;

@end

class Viewer: public ms::Object{

public:
	Viewer();
	virtual ~Viewer();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	void draw2D();
	void drawTop();
	virtual void onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther);
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	void setBookName(NSString* _dirName);
	void start();
	void returnOther();
	void setDisable();
	ms::Uint32 getPageIndex();
	void setPageIndex(ms::Uint32 pageIndex);
	ms::Uint32 getPageCount();
	void setViewerMode(VIEWER_MODE _mode);
	VIEWER_MODE getViewerMode();
	void setPosX(float posX);
	float getPosX();
	float getAreaLeft();
	float getAreaTop();
	float getAreaWidth();
	float getAreaHeight();
	void setArea(const ms::Rect& area);
private:
	enum STATE {
		STATE_DISABLE = 0,
		STATE_INIT,
		//STATE_IDLE_WAIT,
		//STATE_FADEIN_INIT,
		//STATE_FADEIN,
		STATE_IDLE,
		STATE_CHANGE_AREA_INIT,
		STATE_CHANGE_AREA,
		STATE_CHANGE_MOVE_INIT,
		STATE_CHANGE_MOVE,
		STATE_CHANGE_MOVE_WAIT,
		STATE_CHANGE_MOVE_CANCEL_INIT,
		STATE_CHANGE_MOVE_CANCEL,
		//STATE_CHANGE_MOVE_OK,
		STATE_CHANGE_NOTE_INIT,
		STATE_CHANGE_NOTE,
		STATE_CHANGE_BOOKS_INIT,
		STATE_CHANGE_BOOKS,
		STATE_CHANGE_TWITTER_INIT,
		STATE_CHANGE_TWITTER,
		STATE_CHANGE_TWITTER_SEND,
		STATE_RETURN,
	};
	STATE				state;
	ViewerCamera*		camera;
	ViewerPaper*		paper;
	ViewerVSlider*		vSlider;
	ViewerTop*			top;
	ViewerMove*			move;
	ViewerTouchFlash*	touchFlash;
	ViewerPageNo*		pageNo;
	NSString*			dirName;
	BOOL				drawFlag;
	static ms::Rect		touchRect[];
	
	ViewerPaper::NOTIFY_INFO paperNotifyInfo;
	
	ms::Vector2f	touchBeganPos;
	ms::Uint32		touchBeganTime;

	NotifyNode		paperNotifyNode;
	NotifyNode		topNotifyNode;
	NotifyNode		moveNotifyNode;
	
	ViewerAmazonURLDelegate* amazonUrlDelegate;
	ViewerAlertDelegate* alertDelegate;
};
