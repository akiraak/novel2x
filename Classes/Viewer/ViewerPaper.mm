#include <dirent.h>
#import "ViewerPaper.h"
#import "Texture.h"
#import "SceneDebugString.h"
#import "AppData.h"
#import "Scene.h"
#import "BookUtil.h"
#import "MyLibrary.h"

#define FADE_IN_TIME		(300)
#define FADE_OUT_TIME		(300)
#define SCROLL_V_MIN		(40.0f)
#define SCROLL_V_RATE		(0.1f)
#define SCROLL_H_RATE		(2.0f)
#define VIEW_SIZE_W			(ms::GLScene::SCREEN_SIZE_W*0.5f)
#define VIEW_SIZE_H			(ms::GLScene::SCREEN_SIZE_H*0.9f)
#define MOVE_AREA_H			(40.0f)
#define BORDER_INTERVAL_W	(32.0f)
#define ZOOM_MIN			(0.5f)
#define ZOOM_MAX			(3.0f)
#define MENU_AREA_H			(40.0f)
#define RETURN_SPEED		(600.0f)
#define RETURN_START_MARGIN	(60.0f)
#define PAPER_SPACE			(8.0f)
#define PAGE_CHAGE_SPEED	(600.0f)
#define TOUCH_MOVE_SPEED	(600.0f)
#define PAGE_SIDE_SPACE		(32.0f)
#define TOUCH_MOVE_NEXT_SIZE	(0.8f)

//--------------------------------
ViewerPaper::ViewerPaper():
state((STATE)0),
viewerMode((VIEWER_MODE)0),
fastInit(FALSE),
updateTexture(NULL),
showArea(ms::RectMake(0.1f, 0.12f, 0.85f, 0.77f)),
drawFlag(FALSE),
zoom(1.0f),
touchStart(FALSE),
touchStartPos(ms::Vector2fMake(0.0f, 0.0f)),
posBase(ms::Vector2fMake(0.0f, 0.0f)),
addPos(ms::Vector2fMake(0.0f, 0.0f)),
changeEndPos(0.0f),
updateSprite((SPRITE)0),
fileCount(0),
fileBasePath(NULL),
fileNameArray(NULL),
pageIndex(0),
isCheckPageLoad(FALSE),
touchMoveDark(NULL)
{
	bzero(texture, sizeof(texture));
	bzero(sprite, sizeof(sprite));
	bzero(paperOne, sizeof(paperOne));
}
//--------------------------------
ViewerPaper::~ViewerPaper(){
	for(int i = 0; i < ARRAYSIZE(texture); i++){
		MS_SAFE_DELETE(texture[i]);
	}
	for(int i = 0; i < ARRAYSIZE(sprite); i++){
		MS_SAFE_DELETE(sprite[i]);
	}
	MS_SAFE_DELETE(updateTexture);
	
	if(fileNameArray){
		for(int i = 0; i < ARRAYSIZE(fileNameArray); i++){
			MS_SAFE_FREE(fileNameArray[i]);
		}
		MS_SAFE_FREE(fileNameArray);
	}

	[fileBasePath release];
	for(int i = 0; i < ARRAYSIZE(paperOne); i++){
		MS_SAFE_DELETE(paperOne[i]);
	}
	MS_SAFE_DELETE(touchMoveDark);
}
//--------------------------------
void ViewerPaper::init(){
	ms::Object::init();
	for(int i = 0; i < ARRAYSIZE(sprite); i++){
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(FALSE);
		object->setPos(ms::Vector3fMake(0.0f, -ms::GLScene::SCREEN_SIZE_H/2.0f, 0.0f));
		object->setSize(ms::Vector2fMake(VIEW_SIZE_W, VIEW_SIZE_H));
		ASSERT(!sprite[i]);
		sprite[i] = object;
	}
	for(int i = 0; i < ARRAYSIZE(paperOne); i++){
		ViewerPaperOne* object = new ViewerPaperOne;
		object->init();
		object->setVisible(FALSE);
		ASSERT(!paperOne[i]);
		paperOne[i] = object;
	}
	{
		ViewerTouchMoveDark* object = new ViewerTouchMoveDark;
		object->init();
		ASSERT(!touchMoveDark);
		touchMoveDark = object;
	}
	Scene::getFade()->start(0, 1.0f, 1.0f, SceneFade::TEXTURE_NONE);
}
//--------------------------------
BOOL ViewerPaper::update(ms::Uint32 elapsedTime){
	BOOL isDraw = drawFlag;
	drawFlag = FALSE;
	
	for(int i = 0; i < ARRAYSIZE(paperOne); i++){
		if(paperOne[i]->update(elapsedTime)){
			isDraw = TRUE;
		}
	}
	if(touchMoveDark->update(elapsedTime)){
		isDraw = TRUE;
	}
	switch(state){
		case STATE_DISABLE:
			break;
		case STATE_INIT:
		{
			{
				viewerMode = Scene::getViewer()->getViewerMode();
			}
			{
				ms::Sint32 count = Scene::getViewer()->getPageCount();
				ms::Sint32 page = Scene::getViewer()->getPageIndex();
				//ms::Sint32 page = 100;
				if(page < 0){
					page = 0;
				}
				if(count > 0 && page >= count){
					page = count-1;
				}
                if(count == 0){
                    state = STATE_IDLE;
                    sendChildNotifyMessage(ViewerTop::NOTIFY_BOOKS, NULL);
                    break;
                }
				pageIndex = page;
				Scene::getViewer()->setPageIndex(pageIndex);
			}
			for(int i = 0; i < ARRAYSIZE(paperOne); i++){
				paperOne[i]->setVisible(FALSE);
			}
			{
				NSString* fileName = BookUtil::getFilePathWithIndex(fileBasePath, pageIndex);
				NSString* filePath = [NSString stringWithFormat:@"%@/%@", fileBasePath, fileName];
				ViewerPaperOne* sprite = paperOne[SPRITE_NOW];
				NSLog(@"%@", filePath);
				sprite->setFilePath(filePath);
				sprite->setShowArea(showArea);
				//sprite->setMode(ViewerPaperOne::MODE_CONVERT);
				sprite->setMode(viewerMode);
				sprite->startLoad();
				state = STATE_FIRST_WAIT;
				//break;
			}
			//break;
		}
		case STATE_FIRST_WAIT:
		{
			if(paperOne[SPRITE_NOW]->isLoaded()){
				{
					ViewerPaperOne* sprite = paperOne[SPRITE_NOW];
					sprite->create(NULL);
					ms::Vector2f size = sprite->getSize();
					ms::Vector3f pos = ms::Vector3fMake(-size.x+Scene::SCREEN_SIZE_W*0.5f, -Scene::SCREEN_SIZE_H*0.5f, 0.0f);
					float posX = Scene::getViewer()->getPosX();
					if(ABS(posX) < 5000.0f){
						pos.x = posX;
					}
					sprite->setPos(pos);
					sprite->setVisible(TRUE);
					Scene::getViewer()->setPosX(pos.x);
				}
				// ファイル名の取得
				{
					DIR *dp;
					struct dirent *dir;
					NSLog(@"%@", fileBasePath);
					const char* dirPath= [fileBasePath UTF8String];
					NSLog(@"%s", dirPath);
					fileCount = 0;
					ms::Sint32 pageCount = BookUtil::getPageCountWithBookPath(fileBasePath);
					ASSERT(pageCount >= 0);
					fileCount = pageCount;
					if(fileCount > 0){
						if(fileNameArray){
							for(int i = 0; i < ARRAYSIZE(fileNameArray); i++){
								MS_SAFE_FREE(fileNameArray[i]);
							}
						}
						MS_SAFE_FREE(fileNameArray);
						ASSERT(!fileNameArray);
						fileNameArray = (char**)malloc(sizeof(char*)*fileCount);
						bzero(fileNameArray, sizeof(fileNameArray));
						if((dp=opendir(dirPath)) != NULL){
							int i = 0;
							while((dir = readdir(dp)) != NULL){
								if(dir->d_type == DT_REG){
									NSString* fileExt = [[NSString stringWithUTF8String:dir->d_name] pathExtension];
									if([fileExt caseInsensitiveCompare:@"jpg"] == NSOrderedSame ||
									   [fileExt caseInsensitiveCompare:@"png"] == NSOrderedSame)
									{
										ASSERT(strlen(dir->d_name) < (FILE_NAME_MAX-1));
										fileNameArray[i] = (char*)malloc(sizeof(char*)*FILE_NAME_MAX);
										strcpy(fileNameArray[i], dir->d_name);
										i++;
									}
								}
							}
							closedir(dp);
						}
					}
					NSString* bookName = [fileBasePath lastPathComponent];
					AppData::setBookPageCount(bookName, pageCount);
				}
				// 前
				{
					ViewerPaperOne* sprite = paperOne[SPRITE_PREV];
					if(pageIndex > 0){
						NSString* fileName = BookUtil::getFilePathWithIndex(fileBasePath, pageIndex-1);
						NSString* filePath = [NSString stringWithFormat:@"%@/%@", fileBasePath, fileName];
						NSLog(@"%@", filePath);
						sprite->setFilePath(filePath);
						sprite->setShowArea(showArea);
						//sprite->setMode(ViewerPaperOne::MODE_CONVERT);
						sprite->setMode(viewerMode);
						sprite->startLoad();
					}else{
						sprite->disable();
					}
				}
				// 次
				{
					ViewerPaperOne* sprite = paperOne[SPRITE_NEXT];
					if(pageIndex < fileCount-1){
						NSString* fileName = BookUtil::getFilePathWithIndex(fileBasePath, pageIndex+1);
						NSString* filePath = [NSString stringWithFormat:@"%@/%@", fileBasePath, fileName];
						NSLog(@"%@", filePath);
						sprite->setFilePath(filePath);
						sprite->setShowArea(showArea);
						//sprite->setMode(ViewerPaperOne::MODE_CONVERT);
						sprite->setMode(viewerMode);
						sprite->startLoad();
					}else{
						sprite->disable();
					}
				}
				state = STATE_FADE_IN_INIT;
			}
			break;
		}
		case STATE_FADE_IN_INIT:
			Scene::getFade()->start(FADE_IN_TIME, 1.0f, 0.0f, SceneFade::TEXTURE_NONE);
			state = STATE_FADE_IN;
			break;
		case STATE_FADE_IN:
			if(Scene::getFade()->getEnd()){
				state = STATE_OTHER_WAIT;
			}
			break;
		case STATE_OTHER_WAIT:
		{
			if((paperOne[SPRITE_PREV]->getDisable() || paperOne[SPRITE_PREV]->isLoaded()) &&
			   (paperOne[SPRITE_NEXT]->getDisable() || paperOne[SPRITE_NEXT]->isLoaded()))
			{
				// 前
				{
					ViewerPaperOne* sprite = paperOne[SPRITE_PREV];
					if(!sprite->getDisable()){
						char replaceFilePath[4096];
						BOOL replace = sprite->create((char*)replaceFilePath);
						if(replace){
							NSString* replaceFileName = [[NSString stringWithUTF8String:replaceFilePath] lastPathComponent];
							strcpy(fileNameArray[pageIndex-1], [replaceFileName UTF8String]);
						}
						sprite->setVisible(TRUE);
					}
				}
				// 次
				{
					ViewerPaperOne* sprite = paperOne[SPRITE_NEXT];
					if(!sprite->getDisable()){
						char replaceFilePath[4096];
						BOOL replace = sprite->create((char*)replaceFilePath);
						if(replace){
							NSString* replaceFileName = [[NSString stringWithUTF8String:replaceFilePath] lastPathComponent];
							strcpy(fileNameArray[pageIndex+1], [replaceFileName UTF8String]);
						}
						sprite->setVisible(TRUE);
					}
				}
				sendPageChange();
				isDraw = TRUE;
				state = STATE_IDLE;
			}
			break;
		}
		case STATE_IDLE:
			break;
		case STATE_TOUCH_MOVE_INIT:
			state = STATE_TOUCH_MOVE;
			//break;
		case STATE_TOUCH_MOVE:
		{
			BOOL end = FALSE;
			ViewerPaperOne* spriteNow = paperOne[SPRITE_NOW];
			ASSERT(spriteNow && spriteNow->getVisible());
			ms::Vector3f posNow = spriteNow->getPos();
			addPos = ms::Vector2fMake(moveSpeed*elapsedTime/1000.0f, 0.0f);
			ASSERT(moveSpeed > 0.0f);
			if((posNow.x+addPos.x) >= moveEndPos){
				addPos.x = moveEndPos-posNow.x;
				end = TRUE;
			}
			moveDarkPosRight += addPos.x;
			touchMoveDark->setPosRight(moveDarkPosRight);
			if(end){
				//isCheckPageLoad = TRUE;
				touchMoveDark->hide();
				state = STATE_TOUCH_MOVE_DARK_HIDE_WAIT;
			}
			isDraw = TRUE;
			break;
		}
		case STATE_TOUCH_MOVE_DARK_HIDE_WAIT:
			if(touchMoveDark->getHide()){
				isCheckPageLoad = TRUE;
				state = STATE_IDLE;
			}
			break;
		case STATE_PAGE_LOAD_PREV_INIT:
		{
			ASSERT(pageIndex > 0);
			pageIndex--;
			ViewerPaperOne* changePaperOne = paperOne[SPRITE_NEXT];
			paperOne[SPRITE_NEXT] = paperOne[SPRITE_NOW];
			paperOne[SPRITE_NOW] = paperOne[SPRITE_PREV];
			paperOne[SPRITE_PREV] = changePaperOne;
			{
				ViewerPaperOne* sprite = paperOne[SPRITE_NOW];
				ms::Vector3f pos = sprite->getPos();
				pos.x = pageLoadCenterPosX;
				sprite->setPos(pos);
			}
			changePaperOne->setVisible(FALSE);
			if(pageIndex > 0){
				NSString* fileName = BookUtil::getFilePathWithIndex(fileBasePath, pageIndex-1);
				NSString* filePath = [NSString stringWithFormat:@"%@/%@", fileBasePath, fileName];
				NSLog(@"%@", filePath);
				changePaperOne->setFilePath(filePath);
				changePaperOne->setShowArea(showArea);
				//changePaperOne->setMode(ViewerPaperOne::MODE_CONVERT);
				changePaperOne->setMode(viewerMode);
				changePaperOne->startLoad();
				state = STATE_PAGE_LOAD_PREV;
			}else{
				changePaperOne->disable();
				Scene::getViewer()->setPageIndex(pageIndex);
				sendPageChange();
				state = STATE_IDLE;
			}
			isDraw = TRUE;
			break;
		}
		case STATE_PAGE_LOAD_PREV:
		{
			ViewerPaperOne* sprite = paperOne[SPRITE_PREV];
			if(sprite->isLoaded()){
				char replaceFilePath[4096];
				BOOL replace = sprite->create((char*)replaceFilePath);
				if(replace){
					NSString* replaceFileName = [[NSString stringWithUTF8String:replaceFilePath] lastPathComponent];
					strcpy(fileNameArray[pageIndex-1], [replaceFileName UTF8String]);
				}
				sprite->setVisible(TRUE);
				Scene::getViewer()->setPageIndex(pageIndex);
				sendPageChange();
				isDraw = TRUE;
				state = STATE_IDLE;
			}
			break;
		}
		case STATE_PAGE_LOAD_NEXT_INIT:
		{
			ASSERT(pageIndex < fileCount-1);
			pageIndex++;
			ViewerPaperOne* changePaperOne = paperOne[SPRITE_PREV];
			paperOne[SPRITE_PREV] = paperOne[SPRITE_NOW];
			paperOne[SPRITE_NOW] = paperOne[SPRITE_NEXT];
			paperOne[SPRITE_NEXT] = changePaperOne;
			{
				ViewerPaperOne* sprite = paperOne[SPRITE_NOW];
				ms::Vector3f pos = sprite->getPos();
				pos.x = pageLoadCenterPosX;
				sprite->setPos(pos);
			}
			changePaperOne->setVisible(FALSE);
			if(pageIndex < fileCount-1){
				NSString* fileName = BookUtil::getFilePathWithIndex(fileBasePath, pageIndex+1);
				NSString* filePath = [NSString stringWithFormat:@"%@/%@", fileBasePath, fileName];
				NSLog(@"%@", filePath);
				changePaperOne->setFilePath(filePath);
				changePaperOne->setShowArea(showArea);
				//changePaperOne->setMode(ViewerPaperOne::MODE_CONVERT);
				changePaperOne->setMode(viewerMode);
				changePaperOne->startLoad();
				state = STATE_PAGE_LOAD_NEXT;
			}else{
				changePaperOne->disable();
				Scene::getViewer()->setPageIndex(pageIndex);
				sendPageChange();
				state = STATE_IDLE;
			}
			isDraw = TRUE;
			break;
		}
		case STATE_PAGE_LOAD_NEXT:
		{
			ViewerPaperOne* sprite = paperOne[SPRITE_NEXT];
			if(sprite->isLoaded()){
				char replaceFilePath[4096];
				BOOL replace = sprite->create((char*)replaceFilePath);
				if(replace){
					NSString* replaceFileName = [[NSString stringWithUTF8String:replaceFilePath] lastPathComponent];
					strcpy(fileNameArray[pageIndex+1], [replaceFileName UTF8String]);
				}
				sprite->setVisible(TRUE);
				Scene::getViewer()->setPageIndex(pageIndex);
				sendPageChange();
				isDraw = TRUE;
				state = STATE_IDLE;
			}
			break;
		}
		case STATE_CHANGE_VIEWER_MODE_INIT:
			Scene::getFade()->start(FADE_OUT_TIME, 0.0f, 1.0f, SceneFade::TEXTURE_NONE);
			state = STATE_CHANGE_VIEWER_MODE_FADEOUT_WAIT;
			//break;
		case STATE_CHANGE_VIEWER_MODE_FADEOUT_WAIT:
			if(Scene::getFade()->getEnd()){
				for(int i = 0; i < ARRAYSIZE(paperOne); i++){
					paperOne[i]->setMode(viewerMode);
				}
				{
					ViewerPaperOne* sprite = paperOne[SPRITE_NOW];
					ms::Vector2f size = sprite->getSize();
					sprite->setShowArea(showArea);
					sprite->reConvert();
					sprite->setPos(ms::Vector3fMake(-size.x+Scene::SCREEN_SIZE_W*0.5f, -Scene::SCREEN_SIZE_H*0.5f, 0.0f));
					sprite->setVisible(TRUE);
				}
				isDraw = TRUE;
				Scene::getFade()->start(FADE_IN_TIME, 1.0f, 0.0f, SceneFade::TEXTURE_NONE);
				state = STATE_CHANGE_VIEWER_MODE_FADEIN_WAIT;
			}
			break;
		case STATE_CHANGE_VIEWER_MODE_FADEIN_WAIT:
			if(Scene::getFade()->getEnd()){
				ViewerPaperOne* sprite = paperOne[SPRITE_NOW];
				ms::Vector3f pos = sprite->getPos();
				Scene::getViewer()->setPosX(pos.x);
				
				Scene::getViewer()->setViewerMode(viewerMode);
				state = STATE_IDLE;
			}
			break;
		case STATE_CONVERT_DEBUG_INIT:
			//break;
		case STATE_CONVERT_DEBUG_FADEOUT_WAIT:
			break;
		case STATE_CONVERT_DEBUG:
			break;
		case STATE_CONVERT_DEBUG_FADEIN_WAIT:
			break;
		case STATE_PAUSE:
			break;
	}
	if(isDraw){
		setupSprite();
		if(isCheckPageLoad){
			checkPageLoad();
			isCheckPageLoad = FALSE;
		}
	}
	return isDraw;
}
//--------------------------------
void ViewerPaper::draw(){
}
//--------------------------------
void ViewerPaper::draw2D(){
	for(int i = 0; i < ARRAYSIZE(paperOne); i++){
		paperOne[i]->draw();
	}
	touchMoveDark->draw();
}
//--------------------------------
void ViewerPaper::setupSprite(){
	// 紙
	{
		ViewerPaperOne* spriteNow = paperOne[SPRITE_NOW];
		ASSERT(spriteNow);
		if(spriteNow && spriteNow->getVisible()){
			ms::Vector2f sizeNow = spriteNow->getSize();
			ms::Vector3f posNow = spriteNow->getPos();
			posNow.x = posNow.x+addPos.x;
			posNow.y = posNow.y+addPos.y;
			posNow.z = 0.0f;
			
			// ページ端の移動判定
			{
				// 右端
				if(pageIndex == 0 &&
				   (posNow.x+sizeNow.x) < Scene::SCREEN_SIZE_W*0.5f-PAGE_SIDE_SPACE)
				{
					posNow.x = Scene::SCREEN_SIZE_W*0.5f-(sizeNow.x+PAGE_SIDE_SPACE);
				}
				// 左端
				if(pageIndex == fileCount-1 &&
				   posNow.x > -Scene::SCREEN_SIZE_W*0.5f+PAGE_SIDE_SPACE)
				{
					posNow.x = -Scene::SCREEN_SIZE_W*0.5f+PAGE_SIDE_SPACE;
				}
			}
			
			// 今
			{
				spriteNow->setPos(posNow);
			}
			// 前
			{
				ViewerPaperOne* sprite = paperOne[SPRITE_PREV];
				if(sprite && !sprite->getDisable() && sprite->getVisible()){
					ms::Vector2f size = sprite->getSize();
					ms::Vector3f pos;
					pos.x = posNow.x+sizeNow.x+PAPER_SPACE;
					pos.y = -Scene::SCREEN_SIZE_H*0.5f;
					pos.z = 0.0f;
					sprite->setPos(pos);
				}
			}
			// 次
			{
				ViewerPaperOne* sprite = paperOne[SPRITE_NEXT];
				if(sprite && !sprite->getDisable() && sprite->getVisible()){
					ms::Vector2f size = sprite->getSize();
					ms::Vector3f pos;
					pos.x = posNow.x-size.x-PAPER_SPACE;
					pos.y = -Scene::SCREEN_SIZE_H*0.5f;
					pos.z = 0.0f;
					sprite->setPos(pos);
				}
			}
		}
	}
	addPos = ms::Vector2fMake(0.0f, 0.0f);
}
//--------------------------------
void ViewerPaper::checkPageLoad(){
	ViewerPaperOne* spriteNow = paperOne[SPRITE_NOW];
	ASSERT(spriteNow);
	if(spriteNow && spriteNow->getVisible()){
		ms::Vector2f sizeNow = spriteNow->getSize();
		ms::Vector3f posNow = spriteNow->getPos();
		if(pageIndex > 0 &&
		   ((posNow.x+sizeNow.x)+(PAPER_SPACE*0.5f)) < 0.0f)
		{
			pageLoadCenterPosX = paperOne[SPRITE_PREV]->getPos().x;
			state = STATE_PAGE_LOAD_PREV_INIT;
		}
		if(pageIndex < (fileCount-1) &&
		   (posNow.x-(PAPER_SPACE*0.5f)) > 0.0f)
		{
			pageLoadCenterPosX = paperOne[SPRITE_NEXT]->getPos().x;
			state = STATE_PAGE_LOAD_NEXT_INIT;
		}
		Scene::getViewer()->setPosX(posNow.x);
	}
}
//--------------------------------
void ViewerPaper::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state == STATE_IDLE){
		if(touchCount > 0){
			//touchStartPos = touchPos[0];
			//touchPosPrev = touchPos[0];
			//drawFlag = TRUE;
			touchStart = FALSE;
		}
	}
}
//--------------------------------
void ViewerPaper::touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state == STATE_IDLE){
		if(touchCount > 0){
			if(touchStart){
				if(viewerMode == VIEWER_MODE_NORMAL &&
				   ABS(touchPos[0].x-touchStartPos.x) < ABS(touchPos[0].y-touchStartPos.y) &&
				   ABS(touchPos[0].y-touchStartPos.y) >= SCROLL_V_MIN)
				{
					float y = -(touchPos[0].y-touchPosPrev.y)/ms::GLScene::SCREEN_SIZE_H * SCROLL_V_RATE;
					showArea.pos.y += y;
					if(showArea.pos.y < 0.0f){
						showArea.pos.y = 0.0f;
					}
					if(showArea.pos.y+showArea.size.y > 1.0f){
						showArea.pos.y = 1.0f - showArea.size.y;
					}
					for(int i = 0; i < ARRAYSIZE(paperOne); i++){
						paperOne[i]->setShowArea(showArea);
					}
					Scene::getViewer()->setArea(showArea);
				}else{
					ms::Vector2f gapPos = ms::Vector2fMake(touchPos[0].x-touchPosPrev.x, touchPos[0].y-touchPosPrev.y);
					posBase.x += gapPos.x * SCROLL_H_RATE;
					addPos = ms::Vector2fMake(gapPos.x * SCROLL_H_RATE, 0.0f);
				}
				touchPosPrev = touchPos[0];
				drawFlag = TRUE;
			}else{
				touchStartPos = touchPos[0];
				touchPosPrev = touchPos[0];
				touchStart = TRUE;
			}
		}
	}
}
//--------------------------------
void ViewerPaper::touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state == STATE_IDLE){
		drawFlag = TRUE;
		isCheckPageLoad = TRUE;

/*		{
			ms::Vector2f imageSize = sprite[SPRITE_NOW]->getSize();
			if(imageSize.x > ms::GLScene::SCREEN_SIZE_W){
				// 現在のページ幅が画面よりも大きい場合
				if(pageIndex < (fileCount-1) &&
				   posBase.x > ((imageSize.x*0.5f)-(ms::GLScene::SCREEN_SIZE_W*0.5f)+RETURN_START_MARGIN))
				{
					// 左ページに移動
					pageIndex++;
					Scene::getViewer()->setPageIndex(pageIndex);
					moveSpeed = PAGE_CHAGE_SPEED;
					changeEndPos = -((sprite[SPRITE_NOW]->getSize().x*0.5f)-(ms::GLScene::SCREEN_SIZE_W*0.5f));
					changeEndPos += sprite[SPRITE_NEXT]->getSize().x+PAPER_SPACE;
					state = STATE_PAGE_CHANGE_INIT;
				}else if(posBase.x > ((imageSize.x*0.5f)-(ms::GLScene::SCREEN_SIZE_W*0.5f))){
					// 右へ戻る
					moveSpeed = -RETURN_SPEED;
					//					if(posBase.x <= ((imageSize.x*0.5f)-(ms::GLScene::SCREEN_SIZE_W*0.5f))){
					changeEndPos = -((sprite[SPRITE_NOW]->getSize().x*0.5f)-(ms::GLScene::SCREEN_SIZE_W*0.5f));
					state = STATE_PAGE_RETURN_INIT;
				}else if(pageIndex > 0 &&
						 posBase.x < -((imageSize.x*0.5f)-(ms::GLScene::SCREEN_SIZE_W*0.5f)+RETURN_START_MARGIN))
				{
					// 右ページに移動
					pageIndex--;
					Scene::getViewer()->setPageIndex(pageIndex);
					moveSpeed = -PAGE_CHAGE_SPEED;
					changeEndPos = -((sprite[SPRITE_NOW]->getSize().x*0.5f)-(ms::GLScene::SCREEN_SIZE_W*0.5f));
					changeEndPos -= ms::GLScene::SCREEN_SIZE_W+PAPER_SPACE;
					state = STATE_PAGE_CHANGE_INIT;
				}else{
					// 左へ戻る
					moveSpeed = RETURN_SPEED;
					state = STATE_PAGE_RETURN_INIT;
				}
			}else{
				// 現在のページ幅が画面よりも小さい場合
				if(pageIndex < (fileCount-1) &&
				   posBase.x >= RETURN_START_MARGIN)
				{
					// 左ページに移動
					pageIndex++;
					Scene::getViewer()->setPageIndex(pageIndex);
					moveSpeed = PAGE_CHAGE_SPEED;
					changeEndPos = sprite[SPRITE_NEXT]->getSize().x+PAPER_SPACE;
					state = STATE_PAGE_CHANGE_INIT;
				}else if(posBase.x > 0.0f){
					moveSpeed = -RETURN_SPEED;
					state = STATE_PAGE_RETURN_INIT;
				}else if(pageIndex > 0 &&
						 posBase.x <= -RETURN_START_MARGIN)
				{
					// 右ページに移動
					pageIndex--;
					Scene::getViewer()->setPageIndex(pageIndex);
					moveSpeed = -PAGE_CHAGE_SPEED;
					changeEndPos = -(sprite[SPRITE_PREV]->getSize().x+PAPER_SPACE);
					state = STATE_PAGE_CHANGE_INIT;
				}else{
					moveSpeed = RETURN_SPEED;
					state = STATE_PAGE_RETURN_INIT;
				}
			}
		}
*/
	}
}
//--------------------------------
void ViewerPaper::touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
 	if(state == STATE_IDLE){
		touchesEnded(touchPos, touchCount, touches, event);
	}
}
//--------------------------------
void ViewerPaper::setShowArea(const ms::Rect& _showArea){
	showArea = _showArea;
}
//--------------------------------
void ViewerPaper::setDirPath(NSString* dirPath){
	fileBasePath = [NSString stringWithString:dirPath];
	[fileBasePath retain];
}
//--------------------------------
void ViewerPaper::changeViewerMode(VIEWER_MODE _mode){
	if(viewerMode != _mode){
		state = STATE_CHANGE_VIEWER_MODE_INIT;
		viewerMode = _mode;
	}
}
//--------------------------------
void ViewerPaper::start(){
	state = STATE_INIT;
}		
//--------------------------------
void ViewerPaper::pause(BOOL status){
	if(status){
		state = STATE_PAUSE;
	}else{
		state = STATE_IDLE;
	}
}
//--------------------------------
void ViewerPaper::touchMoveNext(){
	if(state == STATE_IDLE){
		ViewerPaperOne* spriteNow = paperOne[SPRITE_NOW];
		ASSERT(spriteNow);
		if(spriteNow && spriteNow->getVisible()){
			ms::Vector3f posNow = spriteNow->getPos();
			moveSpeed = TOUCH_MOVE_SPEED;
			moveEndPos = posNow.x+(Scene::SCREEN_SIZE_W*TOUCH_MOVE_NEXT_SIZE);
			moveDarkPosRight = -Scene::SCREEN_SIZE_W*0.5f;
			state = STATE_TOUCH_MOVE_INIT;
		}
	}
}
//--------------------------------
void ViewerPaper::showDebug(BOOL status){
	for(int i = 0; i < ARRAYSIZE(paperOne); i++){
		if(paperOne[i]){
			paperOne[i]->showDebug(status);
		}
	}
}
//--------------------------------
void ViewerPaper::sendPageChange(){
	NOTIFY_INFO notifyInfo;
	bzero(&notifyInfo, sizeof(notifyInfo));
	notifyInfo.pageCount = fileCount;
	notifyInfo.pageIndex = pageIndex;
	sendChildNotifyMessage(NOTIFY_CHANGE_PAGE, &notifyInfo);
}
