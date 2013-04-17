#import "ViewerMove.h"
#import "Texture.h"
#import "Scene.h"
#import "SceneDebugString.h"

#define COLOR_MIN				(ms::Color4fMake(1.0f, 1.0f, 1.0f, 0.0f))
#define COLOR_MAX				(ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f))
#define FADEIN_TIME				(500)
#define FADEOUT_TIME			(500)
#define PAGE_SLASH_W			(16.0f)
#define PAGE_SLASH_H			(16.0f)
#define PAGE_SLASH_POS_X		(ms::GLScene::SCREEN_SIZE_W*0.5f-PAGE_SLASH_W*0.5f)
#define PAGE_SLASH_POS_Y		(ms::GLScene::SCREEN_SIZE_H*0.5f-PAGE_SLASH_H-19.0f)
#define PAGE_TOTAL_POS_X		(ms::GLScene::SCREEN_SIZE_W*0.5f+4.0f)
#define PAGE_TOTAL_POS_Y		(ms::GLScene::SCREEN_SIZE_H*0.5f-PAGE_SLASH_H-20.0f)
#define PAGE_NO_W				(10.0f)
#define PAGE_NO_POS_X			(ms::GLScene::SCREEN_SIZE_W*0.5f-40.0f)
#define PAGE_NO_POS_Y			(ms::GLScene::SCREEN_SIZE_H*0.5f-PAGE_SLASH_H-20.0f)
#define KNOB_SIZE_W				(200.0f)
#define KNOB_POS_Y				(ms::GLScene::SCREEN_SIZE_H*0.5f)
#define MOVE_ALPHA				(0.8f)

//--------------------------------
ViewerMove::ViewerMove():
state((STATE)0),
barBodySprite(NULL),
barKnobSprite(NULL),
pageSlashSprite(NULL),
pageTotalSprite(NULL),
pageNoSprite(NULL),
timer(0),
pageCount(0),
pageIndex(0),
drawFlag(FALSE),
top(NULL)
{
	topNotifyNode.init(this);
}
//--------------------------------
ViewerMove::~ViewerMove(){
	top->removeChildNotifyMessage(topNotifyNode);
	MS_SAFE_DELETE(barBodySprite);
	MS_SAFE_DELETE(barKnobSprite);
	MS_SAFE_DELETE(pageSlashSprite);
	MS_SAFE_DELETE(pageTotalSprite);
	MS_SAFE_DELETE(pageNoSprite);
	MS_SAFE_DELETE(top);
}
//--------------------------------
void ViewerMove::init(){
	ms::Object::init();
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_viewer_move_bar_body);
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(TRUE);
		object->setTexture(texture);
		object->alignParamToTexture();
		ms::Vector2f imageSize = texture->getImageSize();
		object->setPos(ms::Vector3fMake(ms::GLScene::SCREEN_SIZE_W*0.5f-imageSize.x*0.5f, ms::GLScene::SCREEN_SIZE_H*0.5f-imageSize.y*0.5f, 0.0f));
		ASSERT(!barBodySprite);
		barBodySprite = object;
	}
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_viewer_move_bar_knob);
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(FALSE);
		object->setTexture(texture);
		object->alignParamToTexture();
		ms::Vector2f imageSize = texture->getImageSize();
		ASSERT(!barKnobSprite);
		barKnobSprite = object;
	}
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_page_no_font);
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(FALSE);
		object->setTexture(texture);
		object->setColor(ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f));
		object->setSize(ms::Vector2fMake(PAGE_SLASH_W, PAGE_SLASH_H));
		object->setUV(ms::UVMake(2.0f/4.0f, 2.0f/4.0f, 3.0f/4.0f, 3.0f/4.0f));
		object->setPos(ms::Vector3fMake(PAGE_SLASH_POS_X, PAGE_SLASH_POS_Y, 0.0f));
		ASSERT(!pageSlashSprite);
		pageSlashSprite = object;
	}
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_page_no_font);
		ms::Vector2f textureSize = texture->getTextureSize();
		ms::GLKeyedSprite::KEY_INFO keyInfo[]={
			{ '0', ms::UVMake(16.0f * 0.0f / textureSize.x, 16.0f * 0.0f / textureSize.y, 16.0f *  1.0f / textureSize.x, 16.0f * 1.0f / textureSize.y), },
			{ '1', ms::UVMake(16.0f * 1.0f / textureSize.x, 16.0f * 0.0f / textureSize.y, 16.0f *  2.0f / textureSize.x, 16.0f * 1.0f / textureSize.y), },
			{ '2', ms::UVMake(16.0f * 2.0f / textureSize.x, 16.0f * 0.0f / textureSize.y, 16.0f *  3.0f / textureSize.x, 16.0f * 1.0f / textureSize.y), },
			{ '3', ms::UVMake(16.0f * 3.0f / textureSize.x, 16.0f * 0.0f / textureSize.y, 16.0f *  4.0f / textureSize.x, 16.0f * 1.0f / textureSize.y), },
			{ '4', ms::UVMake(16.0f * 0.0f / textureSize.x, 16.0f * 1.0f / textureSize.y, 16.0f *  1.0f / textureSize.x, 16.0f * 2.0f / textureSize.y), },
			{ '5', ms::UVMake(16.0f * 1.0f / textureSize.x, 16.0f * 1.0f / textureSize.y, 16.0f *  2.0f / textureSize.x, 16.0f * 2.0f / textureSize.y), },
			{ '6', ms::UVMake(16.0f * 2.0f / textureSize.x, 16.0f * 1.0f / textureSize.y, 16.0f *  3.0f / textureSize.x, 16.0f * 2.0f / textureSize.y), },
			{ '7', ms::UVMake(16.0f * 3.0f / textureSize.x, 16.0f * 1.0f / textureSize.y, 16.0f *  4.0f / textureSize.x, 16.0f * 2.0f / textureSize.y), },
			{ '8', ms::UVMake(16.0f * 0.0f / textureSize.x, 16.0f * 2.0f / textureSize.y, 16.0f *  1.0f / textureSize.x, 16.0f * 3.0f / textureSize.y), },
			{ '9', ms::UVMake(16.0f * 1.0f / textureSize.x, 16.0f * 2.0f / textureSize.y, 16.0f *  2.0f / textureSize.x, 16.0f * 3.0f / textureSize.y), },
		};
		{
			ms::GLKeyedSprite* object = new ms::GLKeyedSprite;
			ASSERT(object);
			object->init(ARRAYSIZE(keyInfo), 3);
			object->setVisible(FALSE);
			object->setColor(COLOR_MIN);			
			object->setTexture(texture);
			for(int i = 0; i < ARRAYSIZE(keyInfo); i++){
				object->setKeyInfo(i, keyInfo[i]);
			}
			object->setGapPos(ms::Vector2fMake(-6.0f, 0.0f));
			object->setPos(ms::Vector3fMake(PAGE_TOTAL_POS_X, PAGE_TOTAL_POS_Y, 0.0f));
			ASSERT(!pageTotalSprite);
			pageTotalSprite = object;
		}
		{
			ms::GLKeyedSprite* object = new ms::GLKeyedSprite;
			ASSERT(object);
			object->init(ARRAYSIZE(keyInfo), 3);
			object->setVisible(FALSE);
			object->setColor(COLOR_MIN);			
			object->setTexture(texture);
			for(int i = 0; i < ARRAYSIZE(keyInfo); i++){
				object->setKeyInfo(i, keyInfo[i]);
			}
			object->setGapPos(ms::Vector2fMake(-6.0f, 0.0f));
			ASSERT(!pageNoSprite);
			pageNoSprite = object;
		}
	}
	{
		ViewerMoveTop* object = new ViewerMoveTop;
		ASSERT(object);
		object->init();
		object->addChildNotifyMessage(topNotifyNode);
		ASSERT(!top);
		top = object;
	}
}
//--------------------------------
BOOL ViewerMove::update(ms::Uint32 elapsedTime){
	BOOL isDraw = drawFlag;
	if(top->update(elapsedTime)){
		isDraw = TRUE;
	}
	switch(state){
		case STATE_DISABLE:
			break;
		case STATE_FADEIN_INIT:
			barBodySprite->setVisible(TRUE);
			barKnobSprite->setVisible(TRUE);
			pageSlashSprite->setVisible(TRUE);
			pageTotalSprite->setVisible(TRUE);
			pageNoSprite->setVisible(TRUE);
			timer = 0;
			top->show(TRUE, 0);
			state = STATE_FADEIN;
			//break;
		case STATE_FADEIN:
		{
			timer += elapsedTime;
			if(timer >= FADEIN_TIME){
				timer = FADEIN_TIME;
				state = STATE_IDLE;
			}
			{
				ms::Color4f color = COLOR_MAX;
				color.a = COLOR_MAX.a * timer / FADEIN_TIME;
				barBodySprite->setColor(color);
				barKnobSprite->setColor(color);
				pageSlashSprite->setColor(color);
				pageTotalSprite->setColor(color);
				pageNoSprite->setColor(color);
			}
			isDraw = TRUE;
			break;
		}
		case STATE_IDLE:
			break;
		case STATE_MOVE_FADEOUT_INIT:
			top->show(FALSE, 0);
			Scene::getFade()->start(FADEOUT_TIME, MOVE_ALPHA, 1.0f, SceneFade::TEXTURE_NONE);
			timer = 0.0f;
			state = STATE_MOVE_FADEOUT;
			//break;
		case STATE_MOVE_FADEOUT:
		{
			timer += elapsedTime;
			if(timer >= FADEOUT_TIME){
				timer = FADEOUT_TIME;
				sendChildNotifyMessage(ViewerMoveTop::NOTIFY_OK, NULL);
				state = STATE_DISABLE;
			}
			{
				ms::Color4f color = COLOR_MAX;
				color.a = 1.0f - (COLOR_MAX.a * timer / FADEOUT_TIME);
				barBodySprite->setColor(color);
				barKnobSprite->setColor(color);
				pageSlashSprite->setColor(color);
				pageTotalSprite->setColor(color);
				pageNoSprite->setColor(color);
			}
			isDraw = TRUE;
			break;
		}
		case STATE_CANCEL_FADEIN_INIT:
			top->show(FALSE, 0);
			timer = 0;
			state = STATE_CANCEL_FADEIN;
			//break;
		case STATE_CANCEL_FADEIN:
		{
			timer += elapsedTime;
			if(timer >= FADEIN_TIME){
				timer = FADEIN_TIME;
				sendChildNotifyMessage(ViewerMoveTop::NOTIFY_CANCEL, NULL);
				state = STATE_DISABLE;
			}
			{
				ms::Color4f color = COLOR_MAX;
				color.a = 1.0f - (COLOR_MAX.a * timer / FADEIN_TIME);
				barBodySprite->setColor(color);
				barKnobSprite->setColor(color);
				pageSlashSprite->setColor(color);
				pageTotalSprite->setColor(color);
				pageNoSprite->setColor(color);
			}
			isDraw = TRUE;
			break;
		}
	}
	if(isDraw){
		if(pageCount > 0){
			float rate = (float)(pageIndex+1) / (float)pageCount;
			ASSERT(rate >= 0.0f && rate <= 1.0f);
			
			ms::Vector2f imageSize = barKnobSprite->getSize();
			ms::Vector3f pos;
			pos.x = (ms::GLScene::SCREEN_SIZE_W*0.5f+(KNOB_SIZE_W*0.5f))-(KNOB_SIZE_W*rate)-imageSize.x*0.5f;
			pos.y = KNOB_POS_Y-(imageSize.y*0.5f);
			pos.z = 0.0f;
			barKnobSprite->setPos(pos);
			
			setPageNo(pageIndex+1);
		}
	}
	drawFlag = FALSE;
	return isDraw;
}
//--------------------------------
void ViewerMove::draw(){
	if(state != STATE_DISABLE){
		barBodySprite->draw();
		barKnobSprite->draw();
		pageSlashSprite->draw();
		pageTotalSprite->draw();
		pageNoSprite->draw();
		top->draw();
	}
}
//--------------------------------
void ViewerMove::onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther){
	if(state != STATE_DISABLE){
		if(sender == top){
			switch(massageCode){
				case ViewerMoveTop::NOTIFY_CANCEL:
					state = STATE_CANCEL_FADEIN_INIT;
					break;
				case ViewerMoveTop::NOTIFY_OK:
					state = STATE_MOVE_FADEOUT_INIT;
					break;
			}
		}
	}
}
//--------------------------------
void ViewerMove::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
		top->touchesBegan(touchPos, touchCount, touches, event);
		if(touchCount > 0){
			updatePageIndex(touchPos[0]);
		}
	}
}
//--------------------------------
void ViewerMove::touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
		if(touchCount > 0){
			updatePageIndex(touchPos[0]);
		}
	}
}
//--------------------------------
void ViewerMove::touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
	}
}
//--------------------------------
void ViewerMove::touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	touchesEnded(touchPos, touchCount, touches, event);
}
//--------------------------------
void ViewerMove::start(ms::Uint32 _pageCount, ms::Uint32 _pageIndex){
	pageCount = _pageCount;
	pageIndex = _pageIndex;
	{
		char str[256];
		sprintf(str, "%d", _pageCount);
		pageTotalSprite->setRenderKeyWithCString(str);
	}
	setPageNo(_pageIndex+1);
	
	barBodySprite->setVisible(FALSE);
	barKnobSprite->setVisible(FALSE);
	pageSlashSprite->setVisible(FALSE);
	pageTotalSprite->setVisible(FALSE);
	pageNoSprite->setVisible(FALSE);
	state = STATE_FADEIN_INIT;
}
//--------------------------------
void ViewerMove::updatePageIndex(const ms::Vector2f& touchPos){
	ms::Vector2f knobSize = ms::Vector2fMake(KNOB_SIZE_W+16.0f, 40.0f);
	ms::Vector2f knobPos = ms::Vector2fMake(ms::GLScene::SCREEN_SIZE_W*0.5f-knobSize.x*0.5f, ms::GLScene::SCREEN_SIZE_H*0.5f-knobSize.y*0.5f);
	ms::Rect knobRc = ms::RectMake(knobPos.x, knobPos.y, knobSize.x, knobSize.y);
	if(ms::RectHit(knobRc, touchPos)){
		float rate = 0.0f;
		if(touchPos.x < ms::GLScene::SCREEN_SIZE_W*0.5f-KNOB_SIZE_W*0.5f){
			rate = 1.0f;
		}else if(touchPos.x > ms::GLScene::SCREEN_SIZE_W*0.5f+KNOB_SIZE_W*0.5f){
			rate = 0.0f;
		}else{
			rate = 1.0f-((touchPos.x-(ms::GLScene::SCREEN_SIZE_W*0.5f-KNOB_SIZE_W*0.5f))/KNOB_SIZE_W);
		}
		pageIndex = (pageCount-1) * rate;
		drawFlag = TRUE;
	}else if(touchPos.y >= ms::GLScene::SCREEN_SIZE_H*0.5f-16.0f &&
			 touchPos.y <= ms::GLScene::SCREEN_SIZE_H*0.5f+16.0f &&
			 touchPos.x < (ms::GLScene::SCREEN_SIZE_W*0.5f-KNOB_SIZE_W*0.5f-16.0f) &&
			 pageIndex < (pageCount-1))
	{
		pageIndex++;
		drawFlag = TRUE;
	}else if(touchPos.y >= ms::GLScene::SCREEN_SIZE_H*0.5f-16.0f &&
			 touchPos.y <= ms::GLScene::SCREEN_SIZE_H*0.5f+16.0f &&
			 touchPos.x > (ms::GLScene::SCREEN_SIZE_W*0.5f+KNOB_SIZE_W*0.5f+16.0f) &&
			 pageIndex > 0)
	{
		pageIndex--;
		drawFlag = TRUE;
	}
}
//--------------------------------
void ViewerMove::setPageNo(ms::Uint32 no){
	char str[256];
	sprintf(str, "%d", no);
	pageNoSprite->setRenderKeyWithCString(str);
	int i = 0;
	if(no < 10){
		i = 2;
	}else if(no < 100){
		i = 1;
	}
	pageNoSprite->setPos(ms::Vector3fMake(PAGE_NO_POS_X+(PAGE_NO_W*i), PAGE_NO_POS_Y, 0.0f));
}
