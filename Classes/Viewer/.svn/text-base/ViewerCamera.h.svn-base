#import "MS.h"

class ViewerCamera: public ms::Object{

public:
	ViewerCamera();
	virtual ~ViewerCamera();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	void setSize(const ms::Vector2f& _viewSize, const ms::Vector2f& _paperSize);
private:
	enum STATE {
		STATE_IDLE = 0,
		STATE_SCROLL,
	};
	STATE			state;
	ms::GLCamera*	camera;
	ms::Vector2f	moveSpeed;
	ms::Rect		cameraControlRect;
	ms::Vector2f	viewSize;
};



