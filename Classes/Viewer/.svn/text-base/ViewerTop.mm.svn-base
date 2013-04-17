#import "ViewerTop.h"
#import "Scene.h"
#import "SceneDebugString.h"

#define IN_SPEED				(200.0f)
#define OUT_SPEED				(200.0f)
#define BUTTON_POS_Y			(25.0f)

//--------------------------------
ViewerTop* ViewerTop::instance = NULL;

//--------------------------------
ViewerTop::ViewerTop():
state((STATE)0),
topMin(0.0f),
topMax(0.0f),
backSprite(NULL),
showTime(0),
showTimer(0),
viewerMode((VIEWER_MODE)0),
viewerModePrev((VIEWER_MODE)0)
{
	ASSERT(!instance);
	instance = this;
	memset(button, 0, sizeof(button));
	for(int i = 0; i < ARRAYSIZE(buttonNotifyNode); i++){
		buttonNotifyNode[i].init(this);
	}
	bzero(convertButton, sizeof(convertButton));
	for(int i = 0; i < ARRAYSIZE(convertButtonNotifyNode); i++){
		convertButtonNotifyNode[i].init(this);
	}
}
//--------------------------------
ViewerTop::~ViewerTop(){
	for(int i = 0; i < ARRAYSIZE(buttonNotifyNode); i++){
		button[i]->removeChildNotifyMessage(buttonNotifyNode[i]);
	}
	for(int i = 0; i < ARRAYSIZE(convertButtonNotifyNode); i++){
		convertButton[i]->removeChildNotifyMessage(convertButtonNotifyNode[i]);
	}
	MS_SAFE_DELETE(backSprite);
	for(int i = 0; i < ARRAYSIZE(button); i++){
		MS_SAFE_DELETE(button[i]);
	}
	for(int i = 0; i < ARRAYSIZE(convertButton); i++){
		MS_SAFE_DELETE(convertButton[i]);
	}
	ASSERT(instance);
	instance = NULL;
}
//--------------------------------
void ViewerTop::init(){
	ms::Object::init();
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_viewer_top_back);
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
			Texture::getStatic(Texture::STATIC_viewer_top_button_area),
			Texture::getStatic(Texture::STATIC_viewer_top_button_move),
			Texture::getStatic(Texture::STATIC_viewer_top_button_note),
			Texture::getStatic(Texture::STATIC_viewer_top_button_twitter),
			Texture::getStatic(Texture::STATIC_viewer_top_button_books),
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
			object->setUVWithState(ms::GLButton::VISIBLE_TYPE_IDLE, ms::UVMake(0.0f, 0.0f, imageSize.x/textureSize.x, imageSize.y/textureSize.y));
			object->setUVWithState(ms::GLButton::VISIBLE_TYPE_PUSH, ms::UVMake(0.0f, 0.0f, imageSize.x/textureSize.x, imageSize.y/textureSize.y));
			object->setSizeWithState(ms::GLButton::VISIBLE_TYPE_IDLE, imageSize);
			object->setSizeWithState(ms::GLButton::VISIBLE_TYPE_PUSH, imageSize);
			Scene* scene = Scene::getInstance();
			object->setViewTouch(scene->getView());
			object->addChildNotifyMessage(buttonNotifyNode[i]);
			ASSERT(!button[i]);
			button[i] = object;
		}
	}
	// CONVERT ボタン
	{
		ms::GLTexture* textureTable[] ={
			Texture::getStatic(Texture::STATIC_viewer_top_convert_off),
			Texture::getStatic(Texture::STATIC_viewer_top_convert_on),
		};
		ASSERT(ARRAYSIZE(textureTable) == ARRAYSIZE(convertButton));
		for(int i = 0; i < ARRAYSIZE(convertButton); i++){
			ms::GLTexture* texture = textureTable[i];
			ms::Vector2f textureSize = texture->getTextureSize();
			ms::Vector2f imageSize = texture->getImageSize();
			ms::GLButton* object = new ms::GLButton;
			ASSERT(object);
			object->init();
			object->setVisible(FALSE);
			object->setTextureWithState(ms::GLButton::VISIBLE_TYPE_IDLE, texture);
			object->setTextureWithState(ms::GLButton::VISIBLE_TYPE_PUSH, texture);
			object->setUVWithState(ms::GLButton::VISIBLE_TYPE_IDLE, ms::UVMake(0.0f, 0.0f, imageSize.x/textureSize.x, imageSize.y/textureSize.y));
			object->setUVWithState(ms::GLButton::VISIBLE_TYPE_PUSH, ms::UVMake(0.0f, 0.0f, imageSize.x/textureSize.x, imageSize.y/textureSize.y));
			object->setSizeWithState(ms::GLButton::VISIBLE_TYPE_IDLE, imageSize);
			object->setSizeWithState(ms::GLButton::VISIBLE_TYPE_PUSH, imageSize);
			Scene* scene = Scene::getInstance();
			object->setViewTouch(scene->getView());
			object->addChildNotifyMessage(convertButtonNotifyNode[i]);
			ASSERT(!convertButton[i]);
			convertButton[i] = object;
		}
	}
	topMin = -(backSprite->getTexture()->getImageSize().y);
	topMax = 0.0f;
	top = topMin;
	setupSprite();
}
//--------------------------------
BOOL ViewerTop::update(ms::Uint32 elapsedTime){
	BOOL isDraw = drawFlag;
	for(int i = 0; i < ARRAYSIZE(button); i++){
		if(button[i]->update(elapsedTime)){
			isDraw = TRUE;
		}
	}
	for(int i = 0; i < ARRAYSIZE(convertButton); i++){
		if(convertButton[i]->update(elapsedTime)){
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
		case STATE_IN_INIT:
			for(int i = 0; i < ARRAYSIZE(button); i++){
				button[i]->clean();
			}
			for(int i = 0; i < ARRAYSIZE(convertButton); i++){
				convertButton[i]->clean();
			}
			state = STATE_IN;
			//break;
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
	{
		if(viewerModePrev != viewerMode){
			switch(viewerMode){
				case VIEWER_MODE_NORMAL:
					convertButton[0]->clean();
					convertButton[0]->setVisible(TRUE);
					convertButton[1]->clean();
					convertButton[1]->setVisible(FALSE);
					break;
				case VIEWER_MODE_CONVERT:
					convertButton[0]->clean();
					convertButton[0]->setVisible(FALSE);
					convertButton[1]->clean();
					convertButton[1]->setVisible(TRUE);
					break;
			}
			viewerModePrev = viewerMode;
		}
	}
	if(isDraw){
		setupSprite();
	}
	drawFlag = FALSE;
	return isDraw;
}
//--------------------------------
void ViewerTop::draw(){
	if(state != STATE_HIDE){
		backSprite->draw();
		for(int i = 0; i < ARRAYSIZE(button); i++){
			button[i]->draw();
		}
		for(int i = 0; i < ARRAYSIZE(convertButton); i++){
			convertButton[i]->draw();
		}
	}
}
//--------------------------------
void ViewerTop::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state == STATE_SHOW){
		for(int i = 0; i < ARRAYSIZE(button); i++){
			button[i]->touchesBegan(touchPos, touchCount, touches, event);
		}
		for(int i = 0; i < ARRAYSIZE(convertButton); i++){
			convertButton[i]->touchesBegan(touchPos, touchCount, touches, event);
		}
	}
}
//--------------------------------
void ViewerTop::onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther){
	if(sender == button[BUTTON_AREA]){
		sendChildNotifyMessage(NOTIFY_AREA, NULL);
	}
	if(sender == button[BUTTON_MOVE]){
		sendChildNotifyMessage(NOTIFY_MOVE, NULL);
	}
	if(sender == button[BUTTON_NOTE]){
		sendChildNotifyMessage(NOTIFY_NOTE, NULL);
	}
	if(sender == button[BUTTON_BOOKS]){
		sendChildNotifyMessage(NOTIFY_BOOKS, NULL);
	}
	if(sender == button[BUTTON_TWITTER]){
		sendChildNotifyMessage(NOTIFY_TWITTER, NULL);
	}
	if(sender == convertButton[0]){
		sendChildNotifyMessage(NOTIFY_VIEWER_MODE_CONVERT, NULL);
		viewerMode = VIEWER_MODE_CONVERT;
	}
	if(sender == convertButton[1]){
		sendChildNotifyMessage(NOTIFY_VIEWER_MODE_NORMAL, NULL);
		viewerMode = VIEWER_MODE_NORMAL;
	}
}
//--------------------------------
void ViewerTop::show(BOOL enable, ms::Uint32 _showTime){
	ASSERT(instance);
	instance->showTime = _showTime;
	instance->showTimer = 0;
	if(enable){
		if(instance->state != STATE_SHOW && instance->state != STATE_IN){
			instance->state = STATE_IN_INIT;
		}
		{
			for(int i = 0; i < ARRAYSIZE(instance->convertButton); i++){
				instance->convertButton[i]->setVisible(FALSE);
			}
			instance->viewerMode = Scene::getViewer()->getViewerMode();
			instance->viewerModePrev = instance->viewerMode;
			ASSERT(instance->viewerMode >= (VIEWER_MODE)0 && instance->viewerMode < (VIEWER_MODE)ARRAYSIZE(instance->convertButton));
			instance->convertButton[instance->viewerMode]->setVisible(TRUE);
		}
		instance->drawFlag = TRUE;
	}else{
		if(instance->state != STATE_HIDE && instance->state != STATE_OUT){
			instance->state = STATE_OUT;
		}
	}
}
//--------------------------------
BOOL ViewerTop::getShow(){
	ASSERT(instance);
	return (instance->state != STATE_HIDE);
}
//--------------------------------
void ViewerTop::setupSprite(){
	ms::Vector2n screenSize = Scene::getInstance()->getScreenSize();
	if(state != STATE_HIDE &&
	   top+backSprite->getSize().y >= 0)
	{
		backSprite->setVisible(TRUE);
		backSprite->setPos(ms::Vector3fMake(-backSprite->getSize().x/2.0f, top-(screenSize.y/2.0f), 0.0f));
		{
			ms::GLTexture* textureTable[] ={
				Texture::getStatic(Texture::STATIC_viewer_top_button_area),
				Texture::getStatic(Texture::STATIC_viewer_top_button_move),
				Texture::getStatic(Texture::STATIC_viewer_top_button_note),
				Texture::getStatic(Texture::STATIC_viewer_top_button_twitter),
				Texture::getStatic(Texture::STATIC_viewer_top_button_books),
			};
			ms::Vector3f posTable[] = {
				ms::Vector3fMake((ms::GLScene::SCREEN_SIZE_W/((float)BUTTON_W_COUNT+1.0f)*1.0f)-(ms::GLScene::SCREEN_SIZE_W*0.5f), -ms::GLScene::SCREEN_SIZE_H*0.5f+BUTTON_POS_Y, 0.0f),
				ms::Vector3fMake((ms::GLScene::SCREEN_SIZE_W/((float)BUTTON_W_COUNT+1.0f)*2.0f)-(ms::GLScene::SCREEN_SIZE_W*0.5f), -ms::GLScene::SCREEN_SIZE_H*0.5f+BUTTON_POS_Y, 0.0f),
				ms::Vector3fMake((ms::GLScene::SCREEN_SIZE_W/((float)BUTTON_W_COUNT+1.0f)*3.0f)-(ms::GLScene::SCREEN_SIZE_W*0.5f), -ms::GLScene::SCREEN_SIZE_H*0.5f+BUTTON_POS_Y, 0.0f),
				ms::Vector3fMake((ms::GLScene::SCREEN_SIZE_W/((float)BUTTON_W_COUNT+1.0f)*4.0f)-(ms::GLScene::SCREEN_SIZE_W*0.5f), -ms::GLScene::SCREEN_SIZE_H*0.5f+BUTTON_POS_Y, 0.0f),
				ms::Vector3fMake((ms::GLScene::SCREEN_SIZE_W/((float)BUTTON_W_COUNT+1.0f)*5.0f)-(ms::GLScene::SCREEN_SIZE_W*0.5f), -ms::GLScene::SCREEN_SIZE_H*0.5f+BUTTON_POS_Y, 0.0f),
			};
			ms::Vector2f aeraSize = ms::Vector2fMake(ms::GLScene::SCREEN_SIZE_W/(float)BUTTON_W_COUNT, 50.0f);
			ASSERT(ARRAYSIZE(textureTable) == ARRAYSIZE(button));
			ASSERT(ARRAYSIZE(posTable) == ARRAYSIZE(button));
			for(int i = 0; i < ARRAYSIZE(button); i++){
				ms::Vector2f imageSize = textureTable[i]->getImageSize();
				ms::Vector3f pos = posTable[i];
				pos.x -= imageSize.x*0.5f;
				pos.y -= imageSize.y*0.5f-top;
				button[i]->setPos(pos);
				CGRect reactionRect = CGRectMake(posTable[i].x-aeraSize.x*0.5f+(ms::GLScene::SCREEN_SIZE_W*0.5f), posTable[i].y-aeraSize.y*0.5f+(ms::GLScene::SCREEN_SIZE_H*0.5f), aeraSize.x, aeraSize.y);
				button[i]->setReactionRect(reactionRect);
			}
		}
		// CONVERT ボタン
		{
			ms::GLTexture* textureTable[] ={
				Texture::getStatic(Texture::STATIC_viewer_top_convert_off),
				Texture::getStatic(Texture::STATIC_viewer_top_convert_on),
			};
			ms::Vector3f posTable[] = {
				ms::Vector3fMake((ms::GLScene::SCREEN_SIZE_W/((float)BUTTON_W_COUNT+1.0f)*1.0f)-(ms::GLScene::SCREEN_SIZE_W*0.5f), -ms::GLScene::SCREEN_SIZE_H*0.5f+BUTTON_POS_Y+50.0f, 0.0f),
				ms::Vector3fMake((ms::GLScene::SCREEN_SIZE_W/((float)BUTTON_W_COUNT+1.0f)*1.0f)-(ms::GLScene::SCREEN_SIZE_W*0.5f), -ms::GLScene::SCREEN_SIZE_H*0.5f+BUTTON_POS_Y+50.0f, 0.0f),
			};
			ASSERT(ARRAYSIZE(textureTable) == ARRAYSIZE(convertButton));
			ms::Vector2f aeraSize = ms::Vector2fMake(ms::GLScene::SCREEN_SIZE_W/(float)BUTTON_W_COUNT, 50.0f);
			for(int i = 0; i < ARRAYSIZE(convertButton); i++){
				ms::Vector2f imageSize = textureTable[i]->getImageSize();
				ms::Vector3f pos = posTable[i];
				pos.x -= imageSize.x*0.5f;
				pos.y -= imageSize.y*0.5f-top;
				convertButton[i]->setPos(pos);
				CGRect reactionRect = CGRectMake(posTable[i].x-aeraSize.x*0.5f+(ms::GLScene::SCREEN_SIZE_W*0.5f), posTable[i].y-aeraSize.y*0.5f+(ms::GLScene::SCREEN_SIZE_H*0.5f), aeraSize.x, aeraSize.y);
				convertButton[i]->setReactionRect(reactionRect);
			}
		}
	}else{
		backSprite->setVisible(FALSE);
	}
}
