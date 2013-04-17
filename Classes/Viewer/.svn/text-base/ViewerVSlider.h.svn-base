#import "MS.h"

class ViewerVSlider: public ms::Object{

public:
	ViewerVSlider();
	virtual ~ViewerVSlider();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw2D();
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	float getWidth();
private:
	ms::GLSprite*	topSprite;
	ms::GLSprite*	bottomSprite;
	ms::GLSprite*	middleSprite;
};



