#import "MS.h"

class ViewerTouchMoveDark: public ms::Object{
	
public:
	ViewerTouchMoveDark();
	virtual ~ViewerTouchMoveDark();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	void setPosRight(float posRight);
	void hide();
	BOOL getHide(){return state == STATE_HIDE;}
private:
	enum STATE {
		STATE_HIDE = 0,
		STATE_HIDE_INIT,
		STATE_HIDE_WAIT,
		STATE_SHOW,
	};
	STATE			state;
	ms::GLSprite*	sprite;
	ms::Uint32		timer;
	BOOL			drawFlag;
};
