#import "ViewerPageNo.h"
//#import "Scene.h"
#import "Texture.h"

#define PAGE_BACK_SIZE_W		(84.0f)
#define PAGE_BACK_SIZE_H		(20.0f)
#define PAGE_BACK_COLOR			(ms::Color4fMake(0.0f, 0.0f, 0.0f, 0.8f))
#define PAGE_SHOW_TIME			(1000)
#define PAGE_FADEOUT_TIME		(1000)
#define PAGE_SLASH_W			(16.0f)
#define PAGE_SLASH_H			(16.0f)
#define PAGE_SLASH_POS_X		(-PAGE_SLASH_W*0.5f)
#define PAGE_SLASH_POS_Y		(ms::GLScene::SCREEN_SIZE_H*0.5f-PAGE_SLASH_H-1.0f)
#define PAGE_TOTAL_POS_X		(4.0f)
#define PAGE_TOTAL_POS_Y		(ms::GLScene::SCREEN_SIZE_H*0.5f-PAGE_SLASH_H-2.0f)
#define PAGE_NO_W				(10.0f)
#define PAGE_NO_POS_X			(-40.0f)
#define PAGE_NO_POS_Y			(ms::GLScene::SCREEN_SIZE_H*0.5f-PAGE_SLASH_H-2.0f)

//--------------------------------
ViewerPageNo::ViewerPageNo():
pageBackSprite(NULL),
pageSlashSprite(NULL),
pageTotalSprite(NULL),
pageNoSprite(NULL),
state((STATE)0),
timer(0)
{
}
//--------------------------------
ViewerPageNo::~ViewerPageNo(){
	MS_SAFE_DELETE(pageBackSprite);
	MS_SAFE_DELETE(pageSlashSprite);
	MS_SAFE_DELETE(pageTotalSprite);
	MS_SAFE_DELETE(pageNoSprite);
}
//--------------------------------
void ViewerPageNo::init(){
	ms::Object::init();
	{
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(FALSE);
		object->setSize(ms::Vector2fMake(PAGE_BACK_SIZE_W, PAGE_BACK_SIZE_H));
		object->setColor(PAGE_BACK_COLOR);
		object->setPos(ms::Vector3fMake(-PAGE_BACK_SIZE_W*0.5f, ms::GLScene::SCREEN_SIZE_H*0.5f-PAGE_BACK_SIZE_H, 0.0f));
		ASSERT(!pageBackSprite);
		pageBackSprite = object;
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
			object->setColor(ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f));			
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
			object->setColor(ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f));			
			object->setTexture(texture);
			for(int i = 0; i < ARRAYSIZE(keyInfo); i++){
				object->setKeyInfo(i, keyInfo[i]);
			}
			object->setGapPos(ms::Vector2fMake(-6.0f, 0.0f));
			ASSERT(!pageNoSprite);
			pageNoSprite = object;
		}
	}
}
//--------------------------------
BOOL ViewerPageNo::update(ms::Uint32 elapsedTime){
	BOOL isDraw = FALSE;

	switch(state){
		case STATE_HIDE:
			break;
		case STATE_SHOW_INIT:
			timer = 0;
			pageBackSprite->setColor(PAGE_BACK_COLOR);
			pageBackSprite->setVisible(TRUE);
			pageSlashSprite->setColor(ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f));
			pageSlashSprite->setVisible(TRUE);
			pageTotalSprite->setColor(ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f));
			pageTotalSprite->setVisible(TRUE);
			pageNoSprite->setColor(ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f));
			pageNoSprite->setVisible(TRUE);
			state = STATE_SHOW;
			isDraw = TRUE;
			//break;
		case STATE_SHOW:
			timer += elapsedTime;
			if(timer > PAGE_SHOW_TIME){
				state = STATE_FADEOUT_INIT;
			}
			break;
		case STATE_FADEOUT_INIT:
			timer = 0;
			state = STATE_FADEOUT;
			//break;
		case STATE_FADEOUT:
		{
			timer += elapsedTime;
			if(timer > PAGE_FADEOUT_TIME){
				state = STATE_HIDE;
				pageBackSprite->setVisible(FALSE);
				pageSlashSprite->setVisible(FALSE);
				pageTotalSprite->setVisible(FALSE);
				pageNoSprite->setVisible(FALSE);
			}
			{
				ms::Color4f color = PAGE_BACK_COLOR;
				color.a = color.a - (color.a * timer / PAGE_FADEOUT_TIME);
				pageBackSprite->setColor(color);
			}
			{
				ms::Color4f color = ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);
				color.a = color.a - (color.a * timer / PAGE_FADEOUT_TIME);
				pageSlashSprite->setColor(color);
				pageTotalSprite->setColor(color);
				pageNoSprite->setColor(color);
			}
			isDraw = TRUE;
			break;
		}
	}
	
	return isDraw;
}
//--------------------------------
void ViewerPageNo::draw(){
	pageBackSprite->draw();
	pageSlashSprite->draw();
	pageTotalSprite->draw();
	pageNoSprite->draw();
}
//--------------------------------
void ViewerPageNo::showPageNo(){
	state = STATE_SHOW_INIT;
}
//--------------------------------
void ViewerPageNo::setPageNo(int pageNo, int total){
	{
		char str[256];
		sprintf(str, "%d", total);
		pageTotalSprite->setRenderKeyWithCString(str);
	}
	{
		char str[256];
		sprintf(str, "%d", pageNo);
		pageNoSprite->setRenderKeyWithCString(str);
		int i = 0;
		if(pageNo+1 < 10){
			i = 2;
		}else if(pageNo < 100){
			i = 1;
		}
		pageNoSprite->setPos(ms::Vector3fMake(PAGE_NO_POS_X+(PAGE_NO_W*i), PAGE_NO_POS_Y, 0.0f));
	}
}
