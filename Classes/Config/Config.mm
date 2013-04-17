#include <dirent.h>
#import "Config.h"
#import "Scene.h"
#import "Texture.h"
#import "AppData.h"
#import "BookUtil.h"

#define FADEIN_TIME			(500)
#define FADEOUT_TIME		(500)
#define PAPER_SPRITE_POS_Y	(-ms::GLScene::SCREEN_SIZE_H*0.5f+80.0f)
#define PAPER_SPRITE_H		(ms::GLScene::SCREEN_SIZE_H-100.0f)
#define LINE_POY_Y			(54.0f)
#define LINE_IDLE_COLOR		(ms::Color4fMake(0.5f, 0.5f, 0.5f, 0.5f))
#define LINE_ACTIVE_COLOR	(ms::Color4fMake(1.0f, 0.0f, 0.0f, 0.9f))
#define LINE_SIZE			(2.0f)
#define LINE_TOUCH_SIZE		(40.0f)
#define SHOW_AREA_MIN		(0.4f)
#define SHOW_AREA_DARK_COLOR	(ms::Color4fMake(0.0f, 0.0f, 0.0f, 0.5f))
#define END_TOUCH_AREA_H	(40.0f)
#define TOP_TITLE_POS_Y		(14.0f)

//--------------------------------
Config::Config():
state((STATE)0),
paperTexture(NULL),
paperSprite(NULL),
paperSpriteSize(ms::Vector2fMake(0.0f, 0.0f)),
topBackSprite(NULL),
topTitleSprite(NULL),
readButton(NULL),
editLine(LINE_NONE),
drawFlag(FALSE),
dirName(NULL),
showAlert(TRUE)
{
	bzero(lineSprite, sizeof(lineSprite));
	bzero(lineMarkSprite, sizeof(lineMarkSprite));
	bzero(showAreaDarkSprite, sizeof(showAreaDarkSprite));
	bzero(showArea, sizeof(showArea));
	
	readButtonNotifyNode.init(this);
}
//--------------------------------
Config::~Config(){
	readButton->removeChildNotifyMessage(readButtonNotifyNode);

	MS_SAFE_DELETE(paperTexture);
	MS_SAFE_DELETE(paperSprite);
	for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
		MS_SAFE_DELETE(lineSprite[i]);
	}
	for(int i = 0; i < ARRAYSIZE(lineMarkSprite); i++){
		MS_SAFE_DELETE(lineMarkSprite[i]);
	}
	for(int i = 0; i < ARRAYSIZE(showAreaDarkSprite); i++){
		MS_SAFE_DELETE(showAreaDarkSprite[i]);
	}
	MS_SAFE_DELETE(topBackSprite);
	MS_SAFE_DELETE(topTitleSprite);
	MS_SAFE_DELETE(readButton);
	if(dirName){
		[dirName release];
	}
}
//--------------------------------
void Config::init(){
	ms::Object::init();
	{
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(FALSE);
		ASSERT(!paperSprite);
		paperSprite = object;
	}
	{
		ms::Vector2f size[] ={
			ms::Vector2fMake(LINE_SIZE, ms::GLScene::SCREEN_SIZE_H-LINE_POY_Y),
			ms::Vector2fMake(LINE_SIZE, ms::GLScene::SCREEN_SIZE_H-LINE_POY_Y),
			ms::Vector2fMake(ms::GLScene::SCREEN_SIZE_W, LINE_SIZE),
			ms::Vector2fMake(ms::GLScene::SCREEN_SIZE_W, LINE_SIZE),
		};
		for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setVisible(FALSE);
			object->setSize(size[i]);
			object->setColor(LINE_IDLE_COLOR);
			ASSERT(!lineSprite[i]);
			lineSprite[i] = object;
		}
	}
	{
		ms::GLTexture* texture[] ={
			Texture::getStatic(Texture::STATIC_show_area_touch_h),
			Texture::getStatic(Texture::STATIC_show_area_touch_h),
			Texture::getStatic(Texture::STATIC_show_area_touch_v),
			Texture::getStatic(Texture::STATIC_show_area_touch_v),
		};
		for(int i = 0; i < ARRAYSIZE(lineMarkSprite); i++){
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setVisible(FALSE);
			object->setTexture(texture[i]);
			object->alignParamToTexture();
			ASSERT(!lineMarkSprite[i]);
			lineMarkSprite[i] = object;
		}
	}
	{
		for(int i = 0; i < ARRAYSIZE(lineMarkSprite); i++){
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setColor(SHOW_AREA_DARK_COLOR);
			object->setVisible(FALSE);
			ASSERT(!showAreaDarkSprite[i]);
			showAreaDarkSprite[i] = object;
		}
	}
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_viewer_move_top_back);
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(TRUE);
		object->setTexture(texture);
		object->alignParamToTexture();
		object->setPos(ms::Vector3fMake(-ms::GLScene::SCREEN_SIZE_W*0.5f, -ms::GLScene::SCREEN_SIZE_H*0.5f, 0.0f));
		ASSERT(!topBackSprite);
		topBackSprite = object;
	}
	{
		ms::GLTexture* texture = Texture::getStaticString(Texture::STATIC_STRING_ConfigTitle);
		ms::Vector2f imageSize = texture->getImageSize();
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(TRUE);
		object->setTexture(texture);
		object->alignParamToTexture();
		object->setPos(ms::Vector3fMake(-imageSize.x*0.5f, -ms::GLScene::SCREEN_SIZE_H*0.5f+TOP_TITLE_POS_Y, 0.0f));
		ASSERT(!topTitleSprite);
		topTitleSprite = object;
	}
	{
		ms::GLTexture* texture = Texture::getStatic(Texture::STATIC_top_button_read);
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
		ms::Vector3f pos = ms::Vector3fMake(ms::GLScene::SCREEN_SIZE_W*0.5f-imageSize.x, -ms::GLScene::SCREEN_SIZE_H*0.5f+10.0f, 0.0f);
		object->setPos(pos);
		object->setReactionRect(CGRectMake(pos.x+ms::GLScene::SCREEN_SIZE_W*0.5f, pos.y+ms::GLScene::SCREEN_SIZE_H*0.5f, imageSize.x, imageSize.y));
		object->addChildNotifyMessage(readButtonNotifyNode);
		ASSERT(!readButton);
		readButton = object;
	}
}
//--------------------------------
BOOL Config::update(ms::Uint32 elapsedTime){
	BOOL isDraw = drawFlag;
	if(readButton->update(elapsedTime)){
		isDraw = TRUE;
	}
	switch(state){
		case STATE_DISABLE:
			break;
		case STATE_INIT:
		{
			readButton->clean();
			if(paperTexture){
				MS_SAFE_DELETE(paperTexture);
				paperSprite->setTexture(NULL);
			}
			{
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsPath = [paths objectAtIndex:0];
				NSString *dirPathString = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, dirName];
				
				DIR *dp;
				struct dirent *dir;
				NSLog(@"%@", dirPathString);
				const char* dirPath= [dirPathString UTF8String];
				NSLog(@"%s", dirPath);
				ms::Uint32 fileCount = 0;
				char filePath[4096];
				ms::Sint32 pageCount = BookUtil::getPageCountWithBookPath(dirPathString);
				ASSERT(pageCount >= 0);
				fileCount = pageCount;
				if(fileCount > 0){
					if((dp=opendir(dirPath)) != NULL){
						int i = 0;
						while((dir = readdir(dp)) != NULL){
							if(dir->d_type == DT_REG){
								NSString* fileExt = [[NSString stringWithUTF8String:dir->d_name] pathExtension];
								if([fileExt caseInsensitiveCompare:@"jpg"] == NSOrderedSame ||
								   [fileExt caseInsensitiveCompare:@"png"] == NSOrderedSame)
								{
									if(i == fileCount/2){
										sprintf(filePath, "%s/%s", dirPath, dir->d_name);
									}
									i++;
								}
							}
						}
						closedir(dp);
					}
					
					ms::GLTexture* object = new ms::GLTexture;
					ASSERT(object);
					object->initWithFilePathAsync(filePath);
					ASSERT(!paperTexture);
					paperTexture = object;
				}
				paperTexture->startAsyncLoad();
				state = STATE_LOAD_WAIT;
				//break;
			}
		}
		case STATE_LOAD_WAIT:
			if(paperTexture->isLoaded()){
				NSData* data = paperTexture->getFileData();
				UIImage* image = [UIImage imageWithData:data];
				CGSize orgSize = [image size];
				ms::Uint32 textureMaxSize = ms::GLTexture::getTextureMaxSize();
				if(orgSize.width > textureMaxSize ||
				   orgSize.height > textureMaxSize)
				{
					float scaleRate;
					if(orgSize.width > orgSize.height){
						scaleRate = textureMaxSize / orgSize.width;
					}else{
						scaleRate = textureMaxSize / orgSize.height;
					}
					size_t w = orgSize.width * scaleRate;
					size_t h = orgSize.height * scaleRate;
					UIGraphicsBeginImageContext(CGSizeMake(w, h));
					[image drawInRect:CGRectMake(0, 0, w, h)];
					image = UIGraphicsGetImageFromCurrentImageContext();  
					UIGraphicsEndImageContext(); 				
				}
				paperTexture->initWithUIImage(image);
				ms::Vector2f imageSize = paperTexture->getImageSize();
				
				paperSpriteSize.x = imageSize.x * PAPER_SPRITE_H / imageSize.y;
				paperSpriteSize.y = PAPER_SPRITE_H;
				
				paperSprite->setTexture(paperTexture);
				paperSprite->alignParamToTexture();
				paperSprite->setSize(paperSpriteSize);
				
				{
					showArea[LINE_LEFT]		= paperSpriteSize.x * AppData::getBookAreaLeft(dirName);
					showArea[LINE_RIGHT]	= paperSpriteSize.x - (paperSpriteSize.x*(AppData::getBookAreaLeft(dirName)+AppData::getBookAreaWidth(dirName)));
					showArea[LINE_TOP]		= paperSpriteSize.y * AppData::getBookAreaTop(dirName);
					showArea[LINE_BOTTOM]	= paperSpriteSize.y - (paperSpriteSize.y*(AppData::getBookAreaTop(dirName)+AppData::getBookAreaHeight(dirName)));
				}

				setupSprite();
				isDraw = TRUE;
				state = STATE_FADEIN_INIT;
			}
			break;
		case STATE_FADEIN_INIT:
			Scene::getFade()->start(FADEIN_TIME, 1.0f, 0.0f, SceneFade::TEXTURE_NONE);
			state = STATE_FADEIN;
			//break;
		case STATE_FADEIN:
			if(Scene::getFade()->getEnd()){
				state = STATE_VIEW;
			}
			break;
		case STATE_VIEW:
			break;
		case STATE_FADEOUT_INIT:
		{
			Scene::getFade()->start(FADEOUT_TIME, 0.0f, 1.0f, SceneFade::TEXTURE_NONE);
			
			AppData::setBookAreaLeft(dirName, showArea[LINE_LEFT]/paperSpriteSize.x);
			AppData::setBookAreaTop(dirName, showArea[LINE_TOP]/paperSpriteSize.y);
			AppData::setBookAreaWidth(dirName, (paperSpriteSize.x-(showArea[LINE_LEFT]+showArea[LINE_RIGHT]))/paperSpriteSize.x);
			AppData::setBookAreaHeight(dirName, (paperSpriteSize.y-(showArea[LINE_TOP]+showArea[LINE_BOTTOM]))/paperSpriteSize.y);
			state = STATE_FADEOUT;
			//break;
		}
		case STATE_FADEOUT:
			if(Scene::getFade()->getEnd()){
				NSLog(@"%@", dirName);
				Scene::getViewer()->setBookName(dirName);
				Scene::getViewer()->start();
				state = STATE_DISABLE;
			}
			break;
	}
	drawFlag = FALSE;
	return isDraw;
}
//--------------------------------
void Config::draw(){
	if(state != STATE_DISABLE){
	}
}
//--------------------------------
void Config::draw2D(){
	if(state != STATE_DISABLE){
		paperSprite->draw();
		for(int i = 0; i < ARRAYSIZE(lineMarkSprite); i++){
			showAreaDarkSprite[i]->draw();
		}
		for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
			lineSprite[i]->draw();
		}
		for(int i = 0; i < ARRAYSIZE(lineMarkSprite); i++){
			lineMarkSprite[i]->draw();
		}
		topBackSprite->draw();
		readButton->draw();
		topTitleSprite->draw();
	}
}
//--------------------------------
void Config::onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther){
	if(state != STATE_DISABLE){
		if(sender == readButton){
			if(massageCode == ms::GLButton::NOTIFY_PUSH){
				state = STATE_FADEOUT_INIT;
			}
		}
	}
}
//--------------------------------
void Config::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
		readButton->touchesBegan(touchPos, touchCount, touches, event);
		if(touchCount > 0){
			{
				ms::Vector2f imagePos = ms::Vector2fMake(ms::GLScene::SCREEN_SIZE_W*0.5f-paperSpriteSize.x/2.0f,
														 ms::GLScene::SCREEN_SIZE_H*0.5f+PAPER_SPRITE_POS_Y);
				ms::Vector2f imageSize = paperSpriteSize;
				
				// LEFT
				{
					ms::Rect rc = ms::RectMake(imagePos.x-LINE_TOUCH_SIZE*0.5f+showArea[LINE_LEFT],
											   imagePos.y+LINE_TOUCH_SIZE*0.5f,
											   LINE_TOUCH_SIZE,
											   imageSize.y-LINE_TOUCH_SIZE);
					if(ms::RectHit(rc, touchPos[0])){
						editLine = LINE_LEFT;
					}
				}
				// RIGHT
				{
					ms::Rect rc = ms::RectMake(imagePos.x+imageSize.x-LINE_TOUCH_SIZE*0.5f-showArea[LINE_RIGHT],
											   imagePos.y+LINE_TOUCH_SIZE*0.5f,
											   LINE_TOUCH_SIZE,
											   imageSize.y-LINE_TOUCH_SIZE);
					if(ms::RectHit(rc, touchPos[0])){
						editLine = LINE_RIGHT;
					}
				}
				// TOP
				{
					ms::Rect rc = ms::RectMake(imagePos.x+LINE_TOUCH_SIZE*0.5f,
											   imagePos.y-LINE_TOUCH_SIZE*0.5f+showArea[LINE_TOP],
											   imageSize.x-LINE_TOUCH_SIZE,
											   LINE_TOUCH_SIZE);
					if(ms::RectHit(rc, touchPos[0])){
						editLine = LINE_TOP;
					}
				}
				// BOTTOM
				{
					ms::Rect rc = ms::RectMake(imagePos.x+LINE_TOUCH_SIZE*0.5f,
											   imagePos.y+imageSize.y-LINE_TOUCH_SIZE*0.5f-showArea[LINE_BOTTOM],
											   imageSize.x-LINE_TOUCH_SIZE,
											   LINE_TOUCH_SIZE);
					if(ms::RectHit(rc, touchPos[0])){
						editLine = LINE_BOTTOM;
					}
				}
				touchPosPrev = touchPos[0];
				if(editLine >= (LINE)0 && editLine < LINE_COUNT){
					lineSprite[editLine]->setColor(LINE_ACTIVE_COLOR);
				}
				setupSprite();
				drawFlag = TRUE;
			}
		}
	}
}
//--------------------------------
void Config::touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
		if(touchCount > 0){
			switch(editLine){
				case LINE_LEFT:
					showArea[editLine] = touchPos[0].x-((ms::GLScene::SCREEN_SIZE_W-paperSpriteSize.x)/2.0f);
					if(showArea[editLine] > (paperSpriteSize.x*SHOW_AREA_MIN)){
						showArea[editLine] = (paperSpriteSize.x*SHOW_AREA_MIN);
					}
					break;
				case LINE_RIGHT:
					showArea[editLine] = ms::GLScene::SCREEN_SIZE_W-((ms::GLScene::SCREEN_SIZE_W-paperSpriteSize.x)/2.0f)-touchPos[0].x;
					if(showArea[editLine] > (paperSpriteSize.x*SHOW_AREA_MIN)){
						showArea[editLine] = (paperSpriteSize.x*SHOW_AREA_MIN);
					}
					break;
				case LINE_TOP:
					showArea[editLine] = touchPos[0].y-(PAPER_SPRITE_POS_Y+ms::GLScene::SCREEN_SIZE_H*0.5f);
					if(showArea[editLine] > (paperSpriteSize.y*SHOW_AREA_MIN)){
						showArea[editLine] = (paperSpriteSize.y*SHOW_AREA_MIN);
					}
					break;
				case LINE_BOTTOM:
					showArea[editLine] = (PAPER_SPRITE_POS_Y+paperSpriteSize.y+ms::GLScene::SCREEN_SIZE_H*0.5f)-touchPos[0].y;
					if(showArea[editLine] > (paperSpriteSize.y*SHOW_AREA_MIN)){
						showArea[editLine] = (paperSpriteSize.y*SHOW_AREA_MIN);
					}
					break;
			}
			if(showArea[editLine] < 0.0f){
				showArea[editLine] = 0.0f;
			}
			setupSprite();
			drawFlag = TRUE;
			touchPosPrev = touchPos[0];
		}
	}
}
//--------------------------------
void Config::touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
		editLine = LINE_NONE;
		for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
			lineSprite[i]->setColor(LINE_IDLE_COLOR);
		}
		drawFlag = TRUE;
	}
}
//--------------------------------
void Config::touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
	}
}
//--------------------------------
void Config::start(NSString* _dirName){
	NSLog(@"%@",_dirName);
	if(dirName){
		[dirName release];
	}
	dirName = [[NSString stringWithString:_dirName] retain];
	{
//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//		NSString *documentsPath = [paths objectAtIndex:0];
//		dirPath = [[NSString stringWithFormat:@"%@/Books/%@", documentsPath, _dirPath] retain];
//		dirName = [[NSString stringWithString:_dirName] retain];
	}
	state = STATE_INIT;

	if(showAlert){
		UIAlertView* alert = [[UIAlertView alloc]
							  initWithTitle:@"整形モードでの範囲設定"
							  message:@"整形モードを使用する場合は、ページ上下にある「ページ番号」や「章タイトル」などを含めず、本文のみを選択するようにすると綺麗に表示されます。"
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		showAlert = FALSE;
	}
}
//--------------------------------
void Config::setupSprite(){
	{
		paperSprite->setPos(ms::Vector3fMake(-paperSpriteSize.x/2.0f, PAPER_SPRITE_POS_Y, 0.0f));
		paperSprite->setVisible(TRUE);
	}
	{
		ms::Vector3f pos[] ={
			ms::Vector3fMake(-paperSpriteSize.x/2.0f-LINE_SIZE+showArea[LINE_LEFT], -ms::GLScene::SCREEN_SIZE_H*0.5f+LINE_POY_Y, 0.0f),
			ms::Vector3fMake(paperSpriteSize.x/2.0f-showArea[LINE_RIGHT], -ms::GLScene::SCREEN_SIZE_H*0.5f+LINE_POY_Y, 0.0f),
			ms::Vector3fMake(-ms::GLScene::SCREEN_SIZE_W*0.5f, PAPER_SPRITE_POS_Y-LINE_SIZE+showArea[LINE_TOP], 0.0f),
			ms::Vector3fMake(-ms::GLScene::SCREEN_SIZE_W*0.5f, PAPER_SPRITE_POS_Y+paperSpriteSize.y-showArea[LINE_BOTTOM], 0.0f),
		};
		for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
			lineSprite[i]->setPos(pos[i]);
			lineSprite[i]->setVisible(TRUE);
		}
	}
	{
		ms::Vector2f imageSize = lineMarkSprite[0]->getTexture()->getImageSize();
		ms::Vector3f pos[] ={
			ms::Vector3fMake(-paperSpriteSize.x/2.0f-(imageSize.x*0.5f)+showArea[LINE_LEFT], PAPER_SPRITE_POS_Y+(paperSpriteSize.y*0.5f)-(imageSize.y*0.5f), 0.0f),
			ms::Vector3fMake(paperSpriteSize.x/2.0f-(imageSize.x*0.5f)-showArea[LINE_RIGHT], PAPER_SPRITE_POS_Y+(paperSpriteSize.y*0.5f)-(imageSize.y*0.5f), 0.0f),
			ms::Vector3fMake(-(imageSize.x*0.5f), PAPER_SPRITE_POS_Y-(imageSize.y*0.5f)+showArea[LINE_TOP], 0.0f),
			ms::Vector3fMake(-(imageSize.x*0.5f), PAPER_SPRITE_POS_Y+paperSpriteSize.y-(imageSize.y*0.5f)-showArea[LINE_BOTTOM], 0.0f),
		};
		for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
			lineMarkSprite[i]->setPos(pos[i]);
			lineMarkSprite[i]->setVisible(TRUE);
		}
	}
	{
		if(showArea[LINE_LEFT] > 0.0f){
			ms::GLSprite* sprite = showAreaDarkSprite[LINE_LEFT];
			sprite->setVisible(TRUE);
			sprite->setPos(ms::Vector3fMake(-paperSpriteSize.x/2.0f, PAPER_SPRITE_POS_Y, 0.0f));
			sprite->setSize(ms::Vector2fMake(showArea[LINE_LEFT], paperSpriteSize.y));
		}else{
			showAreaDarkSprite[LINE_LEFT]->setVisible(FALSE);
		}
		if(showArea[LINE_RIGHT] > 0.0f){
			ms::GLSprite* sprite = showAreaDarkSprite[LINE_RIGHT];
			sprite->setVisible(TRUE);
			sprite->setPos(ms::Vector3fMake(paperSpriteSize.x/2.0f-showArea[LINE_RIGHT], PAPER_SPRITE_POS_Y, 0.0f));
			sprite->setSize(ms::Vector2fMake(showArea[LINE_RIGHT], paperSpriteSize.y));
		}else{
			showAreaDarkSprite[LINE_RIGHT]->setVisible(FALSE);
		}
		if(showArea[LINE_TOP] > 0.0f){
			ms::GLSprite* sprite = showAreaDarkSprite[LINE_TOP];
			sprite->setVisible(TRUE);
			sprite->setPos(ms::Vector3fMake(-paperSpriteSize.x/2.0f, PAPER_SPRITE_POS_Y, 0.0f));
			sprite->setSize(ms::Vector2fMake(paperSpriteSize.x, showArea[LINE_TOP]));
		}else{
			showAreaDarkSprite[LINE_TOP]->setVisible(FALSE);
		}
		if(showArea[LINE_BOTTOM] > 0.0f){
			ms::GLSprite* sprite = showAreaDarkSprite[LINE_BOTTOM];
			sprite->setVisible(TRUE);
			sprite->setPos(ms::Vector3fMake(-paperSpriteSize.x/2.0f, PAPER_SPRITE_POS_Y+paperSpriteSize.y-showArea[LINE_BOTTOM], 0.0f));
			sprite->setSize(ms::Vector2fMake(paperSpriteSize.x, showArea[LINE_BOTTOM]));
		}else{
			showAreaDarkSprite[LINE_BOTTOM]->setVisible(FALSE);
		}
	}
	{
		char str[512];
		sprintf(str, "%f", showArea[LINE_RIGHT]);
		SceneDebugString::setString(str);
	}
}
