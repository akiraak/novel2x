#import "ViewerCamera.h"
#import "Scene.h"

#define TOUCH_SPACE_W	(32.0f)
#define TOUCH_SPACE_H	(32.0f)

//--------------------------------
ViewerCamera::ViewerCamera():
state((STATE)0),
camera(NULL),
moveSpeed(ms::Vector2fMake(0.0f, 0.0f)),
viewSize(ms::Vector2fMake(0.0f, 0.0f))
{
	cameraControlRect = ms::RectMake(TOUCH_SPACE_W, TOUCH_SPACE_H,
							ms::GLScene::SCREEN_SIZE_W-(TOUCH_SPACE_W*2.0f),
							ms::GLScene::SCREEN_SIZE_H-(TOUCH_SPACE_H*2.0f));
}
//--------------------------------
ViewerCamera::~ViewerCamera(){
}
//--------------------------------
void ViewerCamera::init(){
	ms::Object::init();
	camera = Scene::getCamera();
	camera->setTouchRect(cameraControlRect);
	camera->enableMove();
	camera->disableControlFlag(ms::GLCamera::CONTROL_FLAG_MOVE_V);
}
//--------------------------------
BOOL ViewerCamera::update(ms::Uint32 elapsedTime){
	BOOL isDraw = FALSE;
	if(camera->update(elapsedTime)){
		isDraw = TRUE;
	}
	switch(state){
		case STATE_IDLE:
			break;
		case STATE_SCROLL:
		{
			ms::Vector2f pos = camera->getPos();
			pos.x += moveSpeed.x*(float)elapsedTime/1000.0f;
			pos.y += moveSpeed.y*(float)elapsedTime/1000.0f;
			camera->setPos(pos);
			break;
		}
	}
	// ループ補間
/*	{
		ms::Vector2f pos = camera->getPos();
		if(pos.y < -viewSize.y/2.0f){
			pos.y = viewSize.y+pos.y;
		}else if(pos.y > viewSize.y/2.0f){
			pos.y = -viewSize.y+pos.y;
		}
		if(pos.x < -viewSize.x/2.0f){
			pos.x = viewSize.x+pos.x;
		}else if(pos.x > viewSize.x/2.0f){
			pos.x = -viewSize.x+pos.x;
		}
		camera->setPos(pos);
	}
*/
	return isDraw;
}
//--------------------------------
void ViewerCamera::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	camera->touchesBegan(touchPos, touchCount, touches, event);
	if(touchCount > 0 &&
	   !RectHit(cameraControlRect, touchPos[0]))
	{
		moveSpeed.y = (touchPos[0].y-(ms::GLScene::SCREEN_SIZE_H/2.0f))*5.0f;
		state = STATE_SCROLL;
		
		
	}
}
//--------------------------------
void ViewerCamera::touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	camera->touchesMoved(touchPos, touchCount, touches, event);
}
//--------------------------------
void ViewerCamera::touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	camera->touchesEnded(touchPos, touchCount, touches, event);
	state = STATE_IDLE;
}
//--------------------------------
void ViewerCamera::touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	camera->touchesCancelled(touchPos, touchCount, touches, event);
	state = STATE_IDLE;
}
//--------------------------------
void ViewerCamera::setSize(const ms::Vector2f& _viewSize, const ms::Vector2f& _paperSize){
	viewSize = _viewSize;
	
	ms::Vector2f cameraSize = ms::Vector2fMake(10000.0f, _paperSize.y);
	camera->setScreenSize(cameraSize);
	camera->cleanPos();
	camera->cleanScreenSize();
}
