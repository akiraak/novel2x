#import "MS.h"

class ViewerTouchFlash: public ms::Object{

public:
	ViewerTouchFlash();
	virtual ~ViewerTouchFlash();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();

	enum AREA {
		AREA_TOP = 0,
		AREA_MOVE_PAGE,
		
		AREA_COUNT,
	};
	void setRect(AREA _area, const ms::Rect& _rect);
	void start(AREA _area);
private:
	enum STATE {
		STATE_HIDE = 0,
		STATE_SHOW_INIT,
		STATE_SHOW,
	};
	STATE			state;
	ms::GLSprite*	sprite[AREA_COUNT];
	AREA			area;
	ms::Uint32		timer;
};
