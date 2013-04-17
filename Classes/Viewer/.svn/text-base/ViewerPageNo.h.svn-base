#import "MS.h"
#import "ViewerPaperOne.h"

class ViewerPageNo: public ms::Object{

public:
	ViewerPageNo();
	virtual ~ViewerPageNo();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	void showPageNo();
	void setPageNo(int pageNo, int total);
private:
	ms::GLSprite*		pageBackSprite;
	ms::GLSprite*		pageSlashSprite;
	ms::GLKeyedSprite*	pageTotalSprite;
	ms::GLKeyedSprite*	pageNoSprite;

	enum STATE {
		STATE_HIDE = 0,
		STATE_SHOW_INIT,
		STATE_SHOW,
		STATE_FADEOUT_INIT,
		STATE_FADEOUT,
	};
	STATE		state;
	ms::Uint32	timer;
};



