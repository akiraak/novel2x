#import "ViewerTouchFlash.h"

#define POS_X			(Scene::SCREEN_SIZE_W*0.5f)
#define POS_Y			(Scene::SCREEN_SIZE_H*0.5f)
#define POS_W			(Scene::SCREEN_SIZE_W)
#define POS_H			(100.0f)
#define FLASH_TIME		(500)
#define COLOR_A_MAX		(0.1f)

//--------------------------------
ViewerTouchFlash::ViewerTouchFlash():
state((STATE)0),
area((AREA)0)
{
	bzero(sprite, sizeof(sprite));
}
//--------------------------------
ViewerTouchFlash::~ViewerTouchFlash(){
	for(int i = 0; i < ARRAYSIZE(sprite); i++){
		MS_SAFE_DELETE(sprite[i]);
	}
}
//--------------------------------
void ViewerTouchFlash::init(){
	ms::Object::init();
	for(int i = 0; i < ARRAYSIZE(sprite); i++){
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(FALSE);
		object->setColor(ms::Color4fMake(0.0f, 0.0f, 1.0f, 0.5f));
		ASSERT(!sprite[i]);
		sprite[i] = object;
	}
}
//--------------------------------
BOOL ViewerTouchFlash::update(ms::Uint32 elapsedTime){
	BOOL isDraw = FALSE;
	switch(state){
		case STATE_HIDE:
			break;
		case STATE_SHOW_INIT:
		{
			for(int i = 0; i < ARRAYSIZE(sprite); i++){
				sprite[area]->setVisible(FALSE);
			}
			timer = 0;
			state = STATE_SHOW;
			//break;
		}
		case STATE_SHOW:
		{
			timer += elapsedTime;
			if(timer >= FLASH_TIME){
				state = STATE_HIDE;
				sprite[area]->setVisible(FALSE);
			}else{
				ms::Color4f color = sprite[area]->getColor();
				color.a = COLOR_A_MAX-(COLOR_A_MAX*timer/FLASH_TIME);
				sprite[area]->setColor(color);
				sprite[area]->setVisible(TRUE);
			}
			isDraw = TRUE;
			break;
		}
	}
	return isDraw;
}
//--------------------------------
void ViewerTouchFlash::draw(){
	if(state != STATE_HIDE){
		for(int i = 0; i < ARRAYSIZE(sprite); i++){
			sprite[i]->draw();
		}
	}
}
//--------------------------------
void ViewerTouchFlash::setRect(AREA _area, const ms::Rect& _rect){
	ASSERT(_area >= (AREA)0 && _area < AREA_COUNT);
	sprite[_area]->setPos(ms::Vector3fMake(_rect.pos.x, _rect.pos.y, 0.0f));
	sprite[_area]->setSize(ms::Vector2fMake(_rect.size.x, _rect.size.y));
}
//--------------------------------
void ViewerTouchFlash::start(AREA _area){
	area = _area;
	state = STATE_SHOW_INIT;
}
