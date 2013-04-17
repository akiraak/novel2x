#import "MS.h"
#import "ViewerMoveTop.h"

class ViewerMove: public ms::Object{

public:
	ViewerMove();
	virtual ~ViewerMove();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	virtual void onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther);
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	void start(ms::Uint32 _pageCount, ms::Uint32 _pageIndex);
	ms::Uint32 getPageIndex(){return pageIndex;}
private:
	enum STATE {
		STATE_DISABLE = 0,
		STATE_FADEIN_INIT,
		STATE_FADEIN,
		STATE_IDLE,
		STATE_MOVE_FADEOUT_INIT,
		STATE_MOVE_FADEOUT,
		STATE_CANCEL_FADEIN_INIT,
		STATE_CANCEL_FADEIN,
	};
	STATE			state;
	ms::GLSprite*		barBodySprite;
	ms::GLSprite*		barKnobSprite;
	ms::GLSprite*		pageSlashSprite;
	ms::GLKeyedSprite*	pageTotalSprite;
	ms::GLKeyedSprite*	pageNoSprite;
	ms::Uint32			timer;
	ms::Uint32			pageCount;
	ms::Uint32			pageIndex;
	BOOL				drawFlag;
	ViewerMoveTop*		top;

	NotifyNode			topNotifyNode;
	
	void updatePageIndex(const ms::Vector2f& touchPos);
	void setPageNo(ms::Uint32 no);
};



