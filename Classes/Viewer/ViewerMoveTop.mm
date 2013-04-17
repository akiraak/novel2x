#import "ViewerMoveTop.h"
#import "Scene.h"
#import "SceneDebugString.h"

#define IN_SPEED				(200.0f)
#define OUT_SPEED				(200.0f)
#define BUTTON_POS_Y			(10.0f)

//--------------------------------
ViewerMoveTop* ViewerMoveTop::instance = NULL;

//--------------------------------
ViewerMoveTop::ViewerMoveTop():
state((STATE)0),
topMin(0.0f),
topMax(0.0f),
backSprite(NULL),
showTime(0),
showTimer(0)
{
	ASSERT(!instance);
	instance = this;
	memset(button, 0, sizeof(button));
	for(int i = 0; i < ARRAYSIZE(buttonNotifyNode); i++){
		buttonNotifyNode[i].init(this);
	}
}
//--------------------------------
ViewerMoveTop::~ViewerMoveTop(){
	for(int i = 0; i < ARRAYSIZE(buttonNotifyNode); i++){
		button[i]->removeChildNotifyMessage(buttonNotifyNode[i]);
	}
	MS_SAFE_DELETE(backSprite);
	for(int i = 0; i < ARRAYSIZE(button); i++){
		MS_SAFE_DELETE(button[i]);
	}
	ASSERT(instance);
	instance = NULL;
}
//--------------------------------
void ViewerMoveTop::init(){
	ms::Object::init();
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_viewer_move_top_back);
		ms::GLSprite* object = new ms::GLSprite;
		object->init();
		object->setTexture(texture);
		object->alignParamToTexture();
		object->setVisible(FALSE);
		ASSERT(!backSprite);
		backSprite = object;
	}
	{
		ms::GLTexture* textureTable[] ={
			Texture::getStatic(Texture::STATIC_viewer_move_top_button_cancel),
			Texture::getStatic(Texture::STATIC_viewer_move_top_button_ok),
		};
		ASSERT(ARRAYSIZE(textureTable) == ARRAYSIZE(button));
		for(int i = 0; i < ARRAYSIZE(button); i++){
			ms::GLTexture* texture = textureTable[i];
			ms::Vector2f textureSize = texture->getTextureSize();
			ms::Vector2f imageSize = texture->getImageSize();
			ms::GLButton* object = new ms::GLButton;
			ASSERT(object);
			object->init();
			object->setTextureWithState(ms::GLButton::VISIBLE_TYPE_IDLE, texture);
			object->setTextureWithState(ms::GLButton::VISIBLE_TYPE_PUSH, texture);
			object->setUVWithState(ms::GLButton::VISIBLE_TYPE_IDLE, ms::UVMake(0.0f, 0.0f, textureSize.x/textureSize.x, textureSize.y/textureSize.y));
			object->setUVWithState(ms::GLButton::VISIBLE_TYPE_PUSH, ms::UVMake(0.0f, 0.0f, textureSize.x/textureSize.x, textureSize.y/textureSize.y));
			object->setSizeWithState(ms::GLButton::VISIBLE_TYPE_IDLE, imageSize);
			object->setSizeWithState(ms::GLButton::VISIBLE_TYPE_PUSH, imageSize);
			Scene* scene = Scene::getInstance();
			object->setViewTouch(scene->getView());
			object->addChildNotifyMessage(buttonNotifyNode[i]);
			ASSERT(!button[i]);
			button[i] = object;
		}
	}
	topMin = -(backSprite->getTexture()->getImageSize().y);
	topMax = 0.0f;
	top = topMin;
	setupSprite();
}
//--------------------------------
BOOL ViewerMoveTop::update(ms::Uint32 elapsedTime){
	BOOL isDraw = drawFlag;
	for(int i = 0; i < ARRAYSIZE(button); i++){
		if(button[i]->update(elapsedTime)){
			isDraw = TRUE;
		}
	}
	switch(state){
		case STATE_HIDE:
			break;
		case STATE_SHOW:
			if(showTime > 0){
				showTimer += elapsedTime;
				if(showTimer >= showTime){
					show(FALSE, 0);
				}
			}
			break;
		case STATE_IN:
			top += IN_SPEED * elapsedTime / 1000.0f;
			if(top >= topMax){
				top = topMax;
				state = STATE_SHOW;
			}
			isDraw = TRUE;
			break;
		case STATE_OUT:
			top -= OUT_SPEED * elapsedTime / 1000.0f;
			if(top <= topMin){
				top = topMin;
				backSprite->setVisible(FALSE);
				state = STATE_HIDE;
			}
			isDraw = TRUE;
			break;
	}
	if(isDraw){
		setupSprite();
	}
	drawFlag = FALSE;
	return isDraw;
}
//--------------------------------
void ViewerMoveTop::draw(){
	if(state != STATE_HIDE){
		backSprite->draw();
		for(int i = 0; i < ARRAYSIZE(button); i++){	
			button[i]->draw();
		}
	}
}
//--------------------------------
void ViewerMoveTop::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state == STATE_SHOW){
		for(int i = 0; i < ARRAYSIZE(button); i++){
			button[i]->touchesBegan(touchPos, touchCount, touches, event);
		}
	}
}
//--------------------------------
void ViewerMoveTop::onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther){
	if(sender == button[BUTTON_CANCEL]){
		sendChildNotifyMessage(NOTIFY_CANCEL, NULL);
	}
	if(sender == button[BUTTON_OK]){
		sendChildNotifyMessage(NOTIFY_OK, NULL);
	}
}
//--------------------------------
void ViewerMoveTop::show(BOOL enable, ms::Uint32 _showTime){
	ASSERT(instance);
	instance->showTime = _showTime;
	instance->showTimer = 0;
	if(enable){
		if(instance->state != STATE_SHOW && instance->state != STATE_IN){
			instance->state = STATE_IN;
		}
		for(int i = 0; i < ARRAYSIZE(instance->button); i++){
			instance->button[i]->clean();
		}
		instance->drawFlag = TRUE;
	}else{
		if(instance->state != STATE_HIDE && instance->state != STATE_OUT){
			instance->state = STATE_OUT;
		}
	}
}
//--------------------------------
BOOL ViewerMoveTop::getShow(){
	ASSERT(instance);
	return (instance->state != STATE_HIDE);
}
//--------------------------------
void ViewerMoveTop::setupSprite(){
	ms::Vector2n screenSize = Scene::getInstance()->getScreenSize();
	if(state != STATE_HIDE &&
	   top+backSprite->getSize().y >= 0)
	{
		backSprite->setVisible(TRUE);
		backSprite->setPos(ms::Vector3fMake(0.0f, top, 0.0f));
		{
			ms::GLTexture* textureTable[] ={
				Texture::getStatic(Texture::STATIC_viewer_move_top_button_cancel),
				Texture::getStatic(Texture::STATIC_viewer_move_top_button_ok),
			};
			ms::Vector3f posTable[] = {
				ms::Vector3fMake(0.0f, top+BUTTON_POS_Y, 0.0f),
				ms::Vector3fMake(ms::GLScene::SCREEN_SIZE_W-textureTable[1]->getImageSize().x, top+BUTTON_POS_Y, 0.0f),
			};
			ASSERT(ARRAYSIZE(textureTable) == ARRAYSIZE(button));
			ASSERT(ARRAYSIZE(posTable) == ARRAYSIZE(button));
			for(int i = 0; i < ARRAYSIZE(button); i++){
				ms::Vector2f imageSize = textureTable[i]->getImageSize();
				ms::Vector3f pos = posTable[i];
				button[i]->setPos(pos);
				button[i]->setReactionRect(CGRectMake(pos.x, pos.y-20.0f, imageSize.x, imageSize.y+40.0f));
				button[i]->setVisible(TRUE);
			}
		}
	}else{
		backSprite->setVisible(FALSE);
		for(int i = 0; i < ARRAYSIZE(button); i++){
			button[i]->setVisible(FALSE);
		}
	}
}
