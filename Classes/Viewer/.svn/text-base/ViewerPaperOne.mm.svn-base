#import "ViewerPaperOne.h"
#import "MyAppDelegate.h"
#import "BookUtil.h"
#import "Scene.h"

//--------------------------------
#define OUTLINE_SPACE_TOP		(8.0f)
#define OUTLINE_SPACE_BOTTOM	(8.0f)
#define SPACE_LEFT				(8.0f)
#define SPACE_RIGHT				(8.0f)
#define SPACE_TOP				(16.0f)
#define SPACE_BOTTOM			(16.0f)
#define DEBUG_OUT_COLOR			(ms::Color4fMake(0.0f, 0.0f, 1.0f, 1.0f))
#define DEBUG_LINE_LEFT_COLOR	(ms::Color4fMake(1.0f, 0.0f, 0.0f, 1.0f))
#define DEBUG_LINE_RIGHT_COLOR	(ms::Color4fMake(0.0f, 1.0f, 0.0f, 1.0f))
#define DEBUG_LINE_HIT_COLOR	(ms::Color4fMake(0.0f, 0.0f, 0.0f, 0.5f))
#define DEBUG_LINE_WORD_COLOR	(ms::Color4fMake(0.0f, 0.0f, 0.0f, 0.2f))
#define DEBUG_LINE_WORD_MIDDLE_COLOR	(ms::Color4fMake(0.0f, 1.0f, 0.0f, 1.0f))
#define DEBUG_RL_COLOR			(ms::Color4fMake(1.0f, 0.0f, 0.0f, 1.0f))
#define RL_MIDDLE_ERROR_MIN_RATE	(0.08f)
#define LINE_NEED_SPACE_MIN_RATE	(0.003f)

#ifdef DEBUG
//#define PRINT_THIN_OUT_VALUE
//#define DENSITY_BIT
#endif

//--------------------------------
ViewerPaperOne::ViewerPaperOne():
state((STATE)0),
mode((VIEWER_MODE)0),
texture(NULL),
normalSprite(NULL),
calcedLine(FALSE),
showArea(ms::RectMake(0.0f, 0.0f, 0.0f, 0.0f)),
filePath(NULL),
lineBackSprite(NULL),
lineSpriteCount(0),
debug(false),
debugLineHitCount(NULL),
debugLineHitCountSprite(NULL)
{
	filePath = @"";
	bzero(&lines, sizeof(lines));
	bzero(lineSprite, sizeof(lineSprite));
	
#ifdef CONVERT_DEBUG
	ms::Uint32 textureMaxSize = ms::GLTexture::getTextureMaxSize();
	ASSERT(!debugLineHitCount);
	debugLineHitCount = (int*)malloc(sizeof(int)*textureMaxSize);
	ASSERT(debugLineHitCount);
	bzero(debugLineHitCount, sizeof(int)*textureMaxSize);
	
	bzero(debugOutSprite, sizeof(debugOutSprite));
	bzero(debugLineLeftSprite, sizeof(debugLineLeftSprite));
	bzero(debugLineRightSprite, sizeof(debugLineRightSprite));
	bzero(debugWordSprite, sizeof(debugWordSprite));
	bzero(debugRL, sizeof(debugRL));

	//bzero(debugLineHitCountSprite, sizeof(debugLineHitCountSprite));
	ASSERT(!debugLineHitCountSprite);
	debugLineHitCountSprite = (ms::GLSprite**)malloc(sizeof(ms::GLSprite*)*textureMaxSize);
	ASSERT(debugLineHitCountSprite);
	bzero(debugLineHitCountSprite, sizeof(ms::GLSprite*)*textureMaxSize);
#endif
}
//--------------------------------
ViewerPaperOne::~ViewerPaperOne(){
	MS_SAFE_DELETE(texture);
	MS_SAFE_DELETE(normalSprite);
	MS_SAFE_DELETE(lineBackSprite);
	for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
		MS_SAFE_DELETE(lineSprite[i]);
	}
	if(filePath){
		[filePath release];
	}
#ifdef CONVERT_DEBUG
	MS_SAFE_FREE(debugLineHitCount);
	for(int i = 0; i < ARRAYSIZE(debugOutSprite); i++){
		MS_SAFE_DELETE(debugOutSprite[i]);
	}
	for(int i = 0; i < ARRAYSIZE(debugLineLeftSprite); i++){
		MS_SAFE_DELETE(debugLineLeftSprite[i]);
	}
	for(int i = 0; i < ARRAYSIZE(debugLineRightSprite); i++){
		MS_SAFE_DELETE(debugLineRightSprite[i]);
	}
	for(int i = 0; i < ARRAYSIZE(debugWordSprite); i++){
		MS_SAFE_DELETE(debugWordSprite[i]);
	}
	for(int i = 0; i < ARRAYSIZE(debugRL); i++){
		MS_SAFE_DELETE(debugRL[i]);
	}
	for(int i = 0; i < ARRAYSIZE(debugLineHitCountSprite); i++){
		MS_SAFE_DELETE(debugLineHitCountSprite[i]);
	}
	MS_SAFE_FREE(debugLineHitCountSprite);
#endif
}
//--------------------------------
void ViewerPaperOne::init(){
	ms::GLRender::init();
	{
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(FALSE);
		ASSERT(!normalSprite);
		normalSprite = object;
	}
	{
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(TRUE);
		object->setColor(ms::Color4fMake(1.0f, 250.0f/256.0f, 240.0f/256.0f, 1.0f));
		ASSERT(!lineBackSprite);
		lineBackSprite = object;
	}
	{
		for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setVisible(FALSE);
			ASSERT(!lineSprite[i]);
			lineSprite[i] = object;
		}
	}
}
//--------------------------------
void ViewerPaperOne::setVisible(BOOL _visible){
	ms::GLRender::setVisible(_visible);
	normalSprite->setVisible(_visible);
	for(int i = 0; i < lineSpriteCount; i++){
		lineSprite[i]->setVisible(_visible);
	}
	lineBackSprite->setVisible(_visible);
}
//--------------------------------
void ViewerPaperOne::setPos(const ms::Vector3f& _pos){
	ms::GLRender::setPos(_pos);
	setupSprite();
}
//--------------------------------
BOOL ViewerPaperOne::update(ms::Uint32 elapsedTime){
	switch(state){
		case STATE_DISABLE:
			break;
		case STATE_INIT:
		{
			calcedLine = FALSE;
			{
				MS_SAFE_DELETE(texture);
				ms::GLTexture* object = new ms::GLTexture;
				ASSERT(object);
				object->setDataRelease(FALSE);
				object->initWithFilePathAsync([filePath UTF8String]);
				object->startAsyncLoad();
				ASSERT(!texture);
				texture = object;
			}
			state = STATE_LOAD_WAIT;
			//break;
		}
		case STATE_LOAD_WAIT:
			if(texture->isLoaded()){
				state = STATE_LOADED;
			}
			break;
		case STATE_LOADED:
			break;
		case STATE_IDLE:
			break;
	}
	return FALSE;
}
//--------------------------------
void ViewerPaperOne::draw(){
	if(debug){
		normalSprite->draw();
#ifdef CONVERT_DEBUG
		for(int i = 0; i < ARRAYSIZE(debugOutSprite); i++){
			if(debugOutSprite[i]){
				debugOutSprite[i]->draw();
			}
		}
		for(int i = 0; i < ARRAYSIZE(debugLineLeftSprite); i++){
			if(debugLineLeftSprite[i]){
				debugLineLeftSprite[i]->draw();
			}else{
				break;
			}
		}
		for(int i = 0; i < ARRAYSIZE(debugLineRightSprite); i++){
			if(debugLineRightSprite[i]){
				debugLineRightSprite[i]->draw();
			}else{
				break;
			}
		}
		for(int i = 0; i < ARRAYSIZE(debugWordSprite); i++){
			if(debugWordSprite[i]){
				debugWordSprite[i]->draw();
			}else{
				break;
			}
		}
		for(int i = 0; i < ARRAYSIZE(debugRL); i++){
			if(debugRL[i]){
				debugRL[i]->draw();
			}else{
				break;
			}
		}
#ifdef DENSITY_BIT
		ms::Uint32 textureMaxSize = ms::GLTexture::getTextureMaxSize();
		for(int i = 0; i < textureMaxSize; i++){
			if(debugLineHitCountSprite[i]){
				debugLineHitCountSprite[i]->draw();
			}
		}
#endif
#endif
	}else{
		if(mode == VIEWER_MODE_NORMAL){
			normalSprite->draw();
		}else{
			lineBackSprite->draw();
			for(int i = 0; i < lineSpriteCount; i++){
				lineSprite[i]->draw();
			}
		}
	}
}
//--------------------------------
void ViewerPaperOne::setFilePath(NSString* _filePath){
	filePath = [[NSString stringWithString:_filePath] retain];
}
//--------------------------------
void ViewerPaperOne::setShowArea(const ms::Rect& _showArea){
	showArea = _showArea;
}
//--------------------------------
ms::Vector2f ViewerPaperOne::getSize(){
	ms::Vector2f size;
	ASSERT(state == STATE_IDLE);
	if(mode == VIEWER_MODE_NORMAL ||
	   debug)
	{
		size = normalSprite->getSize();
	}else{
		size = lineBackSprite->getSize();
	}
	return size;
}
//--------------------------------
void ViewerPaperOne::setMode(VIEWER_MODE _mode){
	mode = _mode;
	if(mode == VIEWER_MODE_CONVERT && state == STATE_IDLE){
		if(!calcedLine){
			char* data = (char*)texture->getData();
			calcLines(data);
			setVisible(getVisible());
		}
	}
}
//--------------------------------
void ViewerPaperOne::reConvert(){
	char* data = (char*)texture->getData();
	calcLines(data);
}
//--------------------------------
void ViewerPaperOne::disable(){
	state = STATE_DISABLE;
}
//--------------------------------
void ViewerPaperOne::startLoad(){
	state = STATE_INIT;
}
//--------------------------------
BOOL ViewerPaperOne::isLoaded(){
	return state == STATE_LOADED;
}
//--------------------------------
BOOL ViewerPaperOne::create(char* dstReplaceFilePath){
	BOOL replace = FALSE;
	// テクスチャ作成
	{
		NSData* data = texture->getFileData();
		UIImage* image = [UIImage imageWithData:data];
		CGSize orgSize = [image size];
		char replaceFilePath8[4096];
		replace = BookUtil::resizeTextureFile(image, &image, texture->getFilePath(), TRUE, (char*)replaceFilePath8);
		if(replace && dstReplaceFilePath){
			strcpy(dstReplaceFilePath, replaceFilePath8);
		}
		texture->initWithUIImage(image);
		ms::Vector2f textureSize = texture->getTextureSize();
		ms::Vector2f imageSize = texture->getImageSize();
		ms::Vector2f imageShowSize = ms::Vector2fMake(imageSize.x*showArea.size.x, imageSize.y*showArea.size.y);
		ms::Vector2f spriteSize;
		if((Scene::SCREEN_SIZE_W / Scene::SCREEN_SIZE_H) < (imageShowSize.x / imageShowSize.y)){
			spriteSize.x = Scene::SCREEN_SIZE_H * imageShowSize.x / imageShowSize.y;
			spriteSize.y = Scene::SCREEN_SIZE_H;
		}else{
			spriteSize.x = Scene::SCREEN_SIZE_W;
			spriteSize.y = Scene::SCREEN_SIZE_W * imageShowSize.y / imageShowSize.x;
		}
		normalSprite->setTexture(texture);
		normalSprite->alignParamToTexture();
		normalSprite->setSize(spriteSize);
	}
	// 解析
	if(mode == VIEWER_MODE_CONVERT){
		char* data = (char*)texture->getData();
		calcLines(data);
	}
	setVisible(getVisible());
	state = STATE_IDLE;
	showDebug(debug);
	return replace;
}
//--------------------------------
void ViewerPaperOne::showDebug(BOOL status){
#ifdef CONVERT_DEBUG
	debug = status;
	if(status && texture){
		if(!calcedLine){
			char* data = (char*)texture->getData();
			calcLines(data);
			setVisible(getVisible());
		}
		// 外枠
		{
			for(int i = 0; i < ARRAYSIZE(debugOutSprite); i++){
				MS_SAFE_DELETE(debugOutSprite[i]);
			}
			// OUTLINE_TOP
			{
				ms::GLSprite* object = new ms::GLSprite;
				object->init();
				object->setColor(DEBUG_OUT_COLOR);
				object->setVisible(TRUE);
				ASSERT(!debugOutSprite[OUTLINE_TOP]);
				debugOutSprite[OUTLINE_TOP] = object;
			}
			// OUTLINE_BOTTOM
			{
				ms::GLSprite* object = new ms::GLSprite;
				object->init();
				object->setColor(DEBUG_OUT_COLOR);
				object->setVisible(TRUE);
				ASSERT(!debugOutSprite[OUTLINE_BOTTOM]);
				debugOutSprite[OUTLINE_BOTTOM] = object;
			}
		}
		// 行
		{
			for(int i = 0; i < ARRAYSIZE(debugLineLeftSprite); i++){
				MS_SAFE_DELETE(debugLineLeftSprite[i]);
			}
			for(int i = 0; i < lines.lineCount; i++){
				ms::GLSprite* object = new ms::GLSprite;
				object->init();
				object->setColor(DEBUG_LINE_LEFT_COLOR);
				object->setVisible(TRUE);
				ASSERT(!debugLineLeftSprite[i]);
				debugLineLeftSprite[i] = object;
			}
			for(int i = 0; i < ARRAYSIZE(debugLineRightSprite); i++){
				MS_SAFE_DELETE(debugLineRightSprite[i]);
			}
			for(int i = 0; i < lines.lineCount; i++){
				ms::GLSprite* object = new ms::GLSprite;
				object->init();
				object->setColor(DEBUG_LINE_RIGHT_COLOR);
				object->setVisible(TRUE);
				ASSERT(!debugLineRightSprite[i]);
				debugLineRightSprite[i] = object;
			}
		}
		// 文字
		{
			for(int i = 0; i < ARRAYSIZE(debugWordSprite); i++){
				MS_SAFE_DELETE(debugWordSprite[i]);
			}
			int index = 0;
			for(int i = 0; i < lines.lineCount; i++){
				LINE* line = &lines.line[i];
				for(int j = 0; j < line->wordCount; j++){
					ms::GLSprite* object = new ms::GLSprite;
					object->init();
					object->setVisible(TRUE);
					ASSERT(!debugWordSprite[index]);
					debugWordSprite[index] = object;
					index++;
				}
			}
		}
		// 改行
		{
			for(int i = 0; i < ARRAYSIZE(debugRL); i++){
				MS_SAFE_DELETE(debugRL[i]);
			}
			for(int i = 0; i < lines.lineCount; i++){
				ms::GLSprite* object = new ms::GLSprite;
				object->init();
				object->setColor(DEBUG_RL_COLOR);
				object->setVisible(TRUE);
				ASSERT(!debugRL[i]);
				debugRL[i] = object;
			}
		}
		// ヒット密度
		{
			ms::Uint32 textureMaxSize = ms::GLTexture::getTextureMaxSize();
			for(int i = 0; i < textureMaxSize; i++){
				MS_SAFE_DELETE(debugLineHitCountSprite[i]);
			}
			for(int i = 0; i < textureMaxSize; i++){
				ms::GLSprite* object = new ms::GLSprite;
				object->init();
				object->setColor(DEBUG_LINE_HIT_COLOR);
				object->setVisible(TRUE);
				ASSERT(!debugLineHitCountSprite[i]);
				debugLineHitCountSprite[i] = object;
			}
		}
	}else{
		for(int i = 0; i < ARRAYSIZE(debugOutSprite); i++){
			if(debugOutSprite[i]){
				debugOutSprite[i]->setVisible(FALSE);
			}
		}
		for(int i = 0; i < ARRAYSIZE(debugLineLeftSprite); i++){
			if(debugLineLeftSprite[i]){
				debugLineLeftSprite[i]->setVisible(FALSE);
			}
		}
		for(int i = 0; i < ARRAYSIZE(debugLineRightSprite); i++){
			if(debugLineRightSprite[i]){
				debugLineRightSprite[i]->setVisible(FALSE);
			}
		}
		for(int i = 0; i < ARRAYSIZE(debugWordSprite); i++){
			if(debugWordSprite[i]){
				debugWordSprite[i]->setVisible(FALSE);
			}
		}
		for(int i = 0; i < ARRAYSIZE(debugRL); i++){
			if(debugRL[i]){
				debugRL[i]->setVisible(FALSE);
			}
		}
		ms::Uint32 textureMaxSize = ms::GLTexture::getTextureMaxSize();
		for(int i = 0; i < textureMaxSize; i++){
			if(debugLineHitCountSprite[i]){
				debugLineHitCountSprite[i]->setVisible(FALSE);
			}
		}
	}
#endif
}
//--------------------------------
void ViewerPaperOne::calcLines(char* data){
	{
		lines.rect = ms::RectMake(0.0f, 0.0f, 0.0f, 0.0f);
		lines.lineCount = 0;
		bzero(lines.line, sizeof(lines.line));
		lines.lineWidthAvg = 0.0f;
		//lines.judgeColor = 512;
		lines.judgeColor = 400;
	}

	ms::Vector2n imageSize = ms::Vector2nMake(texture->getImageSize().x, texture->getImageSize().y);
	ms::Vector2n textureSize = ms::Vector2nMake(texture->getTextureSize().x, texture->getTextureSize().y);
	int top = -1;
	int bottom = -1;
	int right = -1;
	ms::Sint32 judgeColor = lines.judgeColor;
	ms::Color4f backColor = ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);

	// 上限下限の取得
	{
		ms::Color4f topColor;
		ms::Color4f bottomColor;
		top = getTop((unsigned char*)data, imageSize, textureSize, showArea, judgeColor, &topColor);
		bottom = getBottom((unsigned char*)data, imageSize, textureSize, showArea, judgeColor, &bottomColor);
		backColor.r = (topColor.r+bottomColor.r)*0.5f;
		backColor.g = (topColor.g+bottomColor.g)*0.5f;
		backColor.b = (topColor.b+bottomColor.b)*0.5f;
	}
	// 左右の走査
	{
		int searchTop = top;
		int searchBottom = bottom;
		int searchLeft = imageSize.x*showArea.pos.x;
		int searchRight = imageSize.x*(showArea.pos.x+showArea.size.x);
		int hDataSize = 4*textureSize.x;
		int nextLineDataSize = -(hDataSize*(searchBottom-searchTop)+4);
		
		// 右端の取得
		{
			//int needHitCount = (searchBottom-searchTop)*0.015f;
			int needHitCount = 1;
			unsigned char* dataWork = ((unsigned char*)data)+(hDataSize*searchTop)+(4*searchRight);
			for(int i = searchRight; i >= searchLeft; i--){
				int hitCount = 0;
				for(int j = searchTop; j < searchBottom; j++){
					int val = dataWork[0]+dataWork[1]+dataWork[2];
					if(val < judgeColor){
						hitCount++;
					}
					dataWork += hDataSize;
				}
				if(hitCount >= needHitCount){
					right = i;
					break;
				}
				dataWork += nextLineDataSize;
			}
		}
		// 行を取得
		{
			int lineCount = 0;
			float linePosX[LINE_COUNT];
			float lineRightPosX[LINE_COUNT] = {right};
			//int hitCountBuff[ms::GLTexture::kMaxTextureSize];
			//int hitCountBuffCount = 0;
			//int hitCountStart = 0;
//#define UNDER_BUFF (1)
			//int hitCountUnderBuff[UNDER_BUFF];
			//int hitCountUnderBuffCount = 0;

			int spaceStartPosX = -1;
			int spaceCount = 0;
			//int needSpaceMinPixel = (searchRight-searchLeft)*LINE_NEED_SPACE_MIN_RATE;
			int needSpaceMinPixel = 1;
			if(needSpaceMinPixel == 0){
				needSpaceMinPixel = 1;
			}
			
			// 行を検出
			{
				enum SEARCH {
					SEARCH_SPACE = 0,
					SEARCH_WORD,
				};
				SEARCH search = SEARCH_SPACE;
				int needHitCount = 1;
//				unsigned char* dataWork = ((unsigned char*)data)+(hDataSize*searchTop)+(4*(right-1));
				unsigned char* dataWork = ((unsigned char*)data)+(hDataSize*searchTop)+(4*right);
//				for(int i = right-1; i >= searchLeft; i--){
				for(int i = right; i >= searchLeft; i--){
					int hitCount = 0;
					for(int j = searchTop; j < searchBottom; j++){
						int val = dataWork[0]+dataWork[1]+dataWork[2];
						if(val < judgeColor){
							hitCount++;
						}
						dataWork += hDataSize;
					}
					switch(search){
						case SEARCH_SPACE:
						{
							//BOOL hit = FALSE;
							
							if(hitCount == 0){
								if(spaceStartPosX == -1){
									spaceStartPosX = i;
									spaceCount = 1;
								}else{
									spaceCount++;
								}
								if(spaceCount >= needSpaceMinPixel){
									linePosX[lineCount] = spaceStartPosX;
									lineCount++;
									search = SEARCH_WORD;
								}
							}else{
								spaceStartPosX = -1;
							}
							
								/*
							if(hitCount == 0){
								hit = TRUE;
							}else{
								if(hitCountBuffCount > 0){
									float avg = ms::Math::avg(hitCountBuff, hitCountBuffCount);
									if(hitCount <= (int)(avg*0.1f)){
										if(hitCountUnderBuffCount == 0){
											hitCountStart = i;
										}
										hitCountUnderBuff[hitCountUnderBuffCount] = hitCount;
										hitCountUnderBuffCount++;
									}else{
										hitCountBuff[hitCountBuffCount] = hitCount;
										hitCountBuffCount++;
									}
									if(hitCountUnderBuffCount >= UNDER_BUFF){
										int index = 0;
										for(int j = 1; j < UNDER_BUFF; j++){
											if(hitCountUnderBuff[index] > hitCountUnderBuff[j]){
												index = j;
											}
										}
										i = hitCountStart-index;
										hit = TRUE;
									}
								}else{
									hitCountBuff[hitCountBuffCount] = hitCount;
									hitCountBuffCount++;
								}
							}
							if(hit){
								linePosX[lineCount] = i;
								lineCount++;
								//hitCountBuffCount = 0;
								//hitCountUnderBuffCount = 0;
								search = SEARCH_WORD;
							}
*/
							break;
						}
						case SEARCH_WORD:
							if(hitCount >= needHitCount){
								lineRightPosX[lineCount] = i;
								search = SEARCH_SPACE;
							}
							break;
					}
					dataWork += nextLineDataSize;
#ifdef CONVERT_DEBUG
					debugLineHitCount[i] = hitCount;
#endif
				}
				if(search == SEARCH_SPACE){
					linePosX[lineCount] = searchLeft;
					lineCount++;
				}
			}
			// ノイズを削除
			if(lineCount >= 2){
				enum SPACE_TYPE {
					SPACE_TYPE_NONE = 0,
					SPACE_TYPE_BIG,
					SPACE_TYPE_MIN,
				};
				SPACE_TYPE spaceType[lineCount];
				for(int i = 0; i < lineCount; i++){
					spaceType[i] = SPACE_TYPE_NONE;
				}
				int calcCount = lineCount;
				//int calcCount = 1;
				for(int calcIndex = 0; calcIndex < calcCount; calcIndex++){
					// 幅がかなり大きいものを削除
					{
						float calcThinOutRate = 1.7f;
						ms::Uint32 valueCount = 0;
						float srcValue[lineCount];
						{
							int prevLine = 0;
							for(int j = 1; j < lineCount; j++){
								if(spaceType[j] == SPACE_TYPE_NONE){
//									srcValue[valueCount] = linePosX[prevLine]-linePosX[j];
									if(j == 1){
										srcValue[valueCount] = right-linePosX[j];
									}else{
										srcValue[valueCount] = linePosX[prevLine]-linePosX[j];
									}
									prevLine = j;
									valueCount++;
								}else if(spaceType[j] == SPACE_TYPE_BIG){
									prevLine = j;
								}
							}
						}
						BOOL calcUseValue[valueCount];
#ifdef PRINT_THIN_OUT_VALUE
						for(int j = 0; j < valueCount; j++){
							NSLOG(@"srcValue[%d] : %f", j, srcValue[j]);
						}
#endif
						calcThinOutValue(srcValue, valueCount, calcUseValue, calcThinOutRate, FALSE);
#ifdef PRINT_THIN_OUT_VALUE
						for(int j = 0; j < valueCount; j++){
							NSLOG(@"calcUseValue[%d] : %d", j, calcUseValue[j]);
						}
#endif
						int index = 0;
						for(int j = 1; j < lineCount; j++){
							if(spaceType[j] == SPACE_TYPE_NONE){
								if(!calcUseValue[index]){
									spaceType[j] = SPACE_TYPE_BIG;
								}
								index++;
							}
						}
					}
					// 幅が小さいものを削除
					{
						float calcThinOutRate = 0.7f;
						ms::Uint32 valueCount = 0;
						float srcValue[lineCount];
						{
							int prevLine = 0;
							for(int j = 1; j < lineCount; j++){
								if(spaceType[j] == SPACE_TYPE_NONE){
//									srcValue[valueCount] = linePosX[prevLine]-linePosX[j];
									if(j == 1){
										srcValue[valueCount] = right-linePosX[j];
									}else{
										srcValue[valueCount] = linePosX[prevLine]-linePosX[j];
									}
									prevLine = j;
									valueCount++;
								}else if(spaceType[j] == SPACE_TYPE_BIG){
									prevLine = j;
								}
							}
						}
						BOOL calcUseValue[valueCount];
#ifdef PRINT_THIN_OUT_VALUE
						for(int j = 0; j < valueCount; j++){
							NSLOG(@"srcValue[%d] : %f", j, srcValue[j]);
						}
#endif
						calcThinOutValue(srcValue, valueCount, calcUseValue, calcThinOutRate, TRUE);
#ifdef PRINT_THIN_OUT_VALUE
						for(int j = 0; j < valueCount; j++){
							NSLOG(@"calcUseValue[%d] : %d", j, calcUseValue[j]);
						}
#endif
						int index = 0;
						for(int j = 1; j < lineCount; j++){
							if(spaceType[j] == SPACE_TYPE_NONE){
								if(!calcUseValue[index]){
									spaceType[j] = SPACE_TYPE_MIN;
									break;
								}
								index++;
							}
						}
					}
				}
				// １行目のルビを除去
				{
					if(lineCount >= 3 && spaceType[1] != SPACE_TYPE_BIG){
						float spaceAvg = 0.0f;
						int prevLine = 1;
						int count = 0;
						for(int i = 2; i < lineCount; i++){
							if(spaceType[i] == SPACE_TYPE_NONE){
								spaceAvg += linePosX[prevLine]-linePosX[i];
								prevLine = i;
								count++;
							}
						}
						spaceAvg /= count;
						if((right-linePosX[0]) < spaceAvg*0.3f){
							spaceType[0] = SPACE_TYPE_MIN;
						}
					}
				}
				// 情報の設定
				if(lineCount > 0){
					lines.rect.pos.x = linePosX[lineCount-1];
					lines.rect.pos.y = top;
					lines.rect.size.x = right-lines.rect.pos.x;
					lines.rect.size.y = bottom-top;
					{
						float spaceAvg = 0.0f;
						int prevLine = -1;
						int count = 0;
						for(int i = 0; i < lineCount; i++){
							NSLOG(@"%d : type %d", i, spaceType[i]);
							if(prevLine == -1){
								if(spaceType[i] != SPACE_TYPE_MIN){
									prevLine = i;
								}
							}else{
								if(spaceType[i] == SPACE_TYPE_NONE){
									NSLOG(@"add %f", linePosX[prevLine]-linePosX[i]);
									spaceAvg += linePosX[prevLine]-linePosX[i];
									prevLine = i;
									count++;
								}else if(spaceType[i] == SPACE_TYPE_BIG){
									prevLine = i;
								}
							}
						}
						lines.lineWidthAvg = spaceAvg / count;
						NSLOG(@"avg %f : %f / %d", lines.lineWidthAvg, spaceAvg, count);
					}
					{
						int lineIndex = 0;
						for(int i = 0; i < lineCount; i++){
							if(spaceType[i] != SPACE_TYPE_MIN){
								LINE* line = &lines.line[lineIndex];
								line->rect.pos.x = linePosX[i];
								line->rect.pos.y = top;
								line->posRightX = lineRightPosX[i];
								if(lineIndex == 0){
									line->rect.size.x = right-linePosX[i]+SPACE_RIGHT;
								}else{
									LINE* prevLine = &lines.line[lineIndex-1];
									line->rect.size.x = prevLine->rect.pos.x-line->rect.pos.x;
								}
								line->rect.size.y = bottom-top;
								if(spaceType[i] == SPACE_TYPE_BIG){
									line->widthBig = TRUE;
								}
								line->uvUp.u0 = line->rect.pos.x/textureSize.x;
								line->uvUp.v0 = line->rect.pos.y/textureSize.y;
								line->uvUp.u1 = (line->rect.pos.x+line->rect.size.x)/textureSize.x;
								line->uvUp.v1 = (line->rect.pos.y+line->rect.size.y)/textureSize.y;
								line->uvBottom = ms::UVMake(-1.0f, -1.0f, -1.0f, -1.0f);
								
								// 1行のUVを分割
								{
									int wordCount = 0;
									int wordPosY[WORD_COUNT];
									int middleIndex = -1;
									int wordSizeH[WORD_COUNT];
									int lastWordUnderPosY = 0;
									int top = textureSize.y*line->uvUp.v0;
									int searchCount = textureSize.y*(line->uvUp.v1-line->uvUp.v0);
									int lineLeft = textureSize.x*line->uvUp.u0;
									int lineRight = textureSize.x*line->uvUp.u1;
									
#ifdef DEBUG
									bzero(wordPosY, sizeof(wordPosY));
									bzero(wordSizeH, sizeof(wordSizeH));
#endif
									// 行内の文字を取得
									{
										enum SEARCH{
											SEARCH_WORD = 0,
											SEARCH_SPACE,
										};
										SEARCH search = SEARCH_WORD;
										// 文字を取得
										for(int j = 0; j < searchCount; j++){
											unsigned char* dataWork = ((unsigned char*)data)+(textureSize.x*4*(top+j));
											dataWork += 4*lineLeft;
											int hitCount = 0;
											for(int k = 0; k < (lineRight-lineLeft); k++){
												int val = dataWork[0]+dataWork[1]+dataWork[2];
												if(val < judgeColor){
													hitCount++;
												}
												dataWork += 4;
											}
											switch(search){
												case SEARCH_WORD:
													if(hitCount > 1){
														//NSLOG(@"%d : %d", wordCount, wordPosY[wordCount]);
														wordPosY[wordCount] = top+j;
														wordCount++;
														search = SEARCH_SPACE;
													}
													break;
												case SEARCH_SPACE:
													if(hitCount == 0){
														wordSizeH[wordCount-1] = (top+j)-wordPosY[wordCount-1];
														lastWordUnderPosY = top+j;
														search = SEARCH_WORD;
													}
													break;
											}
											if(wordCount >= WORD_COUNT){
												break;
											}
										}
										if(wordCount > 1){
											// 文字として小さすぎる間隔を排除
											{
												ms::Uint32 calcCount = 10;
												float thinOutRate = 0.7f;
												ms::Uint32 calcWordCount = wordCount;
												float srcValue[wordCount];
												float sizeH[wordCount];
												for(int j = 0; j < wordCount; j++){
													srcValue[j] = (float)wordPosY[j];
													sizeH[j] = (float)wordSizeH[j];
												}
												for(int j = 0; j < calcCount; j++){
													BOOL dstUseValue[wordCount];
													int count = calcThinOutInterval(srcValue, calcWordCount, dstUseValue, thinOutRate);;
													ASSERT(count > 1);
													int index = 0;
													for(int k = 0; k < calcWordCount; k++){
														if(dstUseValue[k]){
															srcValue[index] = srcValue[k];
															sizeH[index] = sizeH[k];
															index++;
														}else{
															ASSERT(index>0);
															sizeH[index-1] = (srcValue[k]+sizeH[k])-srcValue[index-1];
														}
													}
													calcWordCount = count;
												}
												wordCount = calcWordCount;
												for(int j = 0; j < calcWordCount; j++){
													wordPosY[j] = srcValue[j];
													wordSizeH[j] = sizeH[j];
												}
											}
											// 下限の追加
											{
												wordPosY[wordCount] = lastWordUnderPosY;
												wordSizeH[wordCount] = 0.0f;
												wordCount++;
											}
										}
									}
									// 行の分割
									{
										int lineMiddle = (top+bottom)/2.0f;
										if(wordPosY[wordCount-1] <= lineMiddle){
											// 下半分は無い
											line->uvUp.v1 = (float)lineMiddle/(float)textureSize.y;
										}else if(wordPosY[0] < lineMiddle){
											// 中間を探す
											middleIndex = 0;
											int middleLen = -1;
											// 中央に一番近い文字間を探す
											for(int j = 0; j < wordCount-1; j++){
												int wordSpacePosY = wordPosY[j];
												if(j > 0){
													wordSpacePosY = (wordPosY[j-1]+wordSizeH[j-1]+wordPosY[j])/2.0f;
												}
												if(middleLen == -1){
													middleLen = ABS(wordSpacePosY-lineMiddle);
													middleIndex = j;
												}else if(middleLen > ABS(wordSpacePosY-lineMiddle)){
													middleLen = ABS(wordSpacePosY-lineMiddle);
													middleIndex = j;
												}
											}
											if(ABS(middleLen) > (bottom-top)*RL_MIDDLE_ERROR_MIN_RATE){
												// 中央から離れすぎている場合は強制で中央にする
												// 下
												line->uvBottom.u0 = line->uvUp.u0;
												line->uvBottom.v0 = (float)lineMiddle/textureSize.y;
												if(line->widthBig){
													line->uvBottom.u1 = (line->rect.pos.x+lines.lineWidthAvg)/textureSize.x;
												}else{
													line->uvBottom.u1 = line->uvUp.u1;
												}
												line->uvBottom.v1 = line->uvUp.v1;
												// 上
												line->uvUp.v1 = line->uvBottom.v0;
											}else{
												line->uvBottom.u0 = line->uvUp.u0;
												if(middleIndex > 0){
													line->uvBottom.v0 = (float)wordPosY[middleIndex]/textureSize.y;
												}else{
													line->uvBottom.v0 = (float)wordPosY[middleIndex]/textureSize.y;
												}
												if(line->widthBig){
													line->uvBottom.u1 = (line->rect.pos.x+lines.lineWidthAvg)/textureSize.x;
												}else{
													if(i == 0){
														// 1行目の下部分は平均幅にする
														line->uvBottom.u1 = (line->rect.pos.x+lines.lineWidthAvg)/textureSize.x;
													}else{
														line->uvBottom.u1 = line->uvUp.u1;
													}
												}
												line->uvBottom.v1 = line->uvUp.v1;
												line->uvUp.v1 = line->uvBottom.v0;
											}
										}else{
											// 上半分は無い
											line->uvUp.v0 = (float)lineMiddle/(float)textureSize.y;
										}
									}
									// 文字情報を保存
									{
										line->wordCount = wordCount;
										bzero(line->wordPosY, sizeof(line->wordPosY));
										for(int j = 0; j < wordCount; j++){
											line->wordPosY[j] = wordPosY[j];
											line->wordSizeH[j] = wordSizeH[j];
										}
										line->middleWordIndex = middleIndex;
									}
								}
								lineIndex++;
							}
						}
						lines.lineCount = lineIndex;
					}
				}
			}
		}
	}
	lineSpriteCount = 0;
	if(lines.lineCount > 0){
		float scale = 0.0f;
		ms::Vector2f textureSize = texture->getTextureSize();
		{
			float vHeightMax = lines.rect.size.y*0.5f/textureSize.y;
			for(int i = 0; i < lines.lineCount; i++){
				LINE* lineInfo = &lines.line[i];
				if(vHeightMax < (lineInfo->uvUp.v1-lineInfo->uvUp.v0)){
					vHeightMax = (lineInfo->uvUp.v1-lineInfo->uvUp.v0);
					NSLOG(@"no:%d heightMax: %f UP", i, vHeightMax);
				}
				if(lineInfo->uvBottom.u0 != -1.0f &&
				   vHeightMax < (lineInfo->uvBottom.v1-lineInfo->uvBottom.v0))
				{
					vHeightMax = (lineInfo->uvBottom.v1-lineInfo->uvBottom.v0);
					NSLOG(@"no:%d heightMax: %f BOTTOM", i, vHeightMax);
				}
			}
			float heightMax = textureSize.y*vHeightMax;
			scale = (Scene::SCREEN_SIZE_H-(SPACE_TOP+SPACE_BOTTOM))/heightMax;
			NSLOG(@"heightMax: %f", heightMax);
			NSLOG(@"scale: %f", scale);
		}
		float width = 0.0f;
		for(int i = 0; i < lines.lineCount; i++){
			LINE* line = &lines.line[i];
			if(lineSpriteCount < LINE_COUNT){
				ms::GLSprite* object = lineSprite[lineSpriteCount];
				object->setTexture(texture);
				ms::Vector2f size;
				ms::UV* uv = &line->uvUp;
				size.x = textureSize.x*(uv->u1-uv->u0)*scale;
				size.y = textureSize.y*(uv->v1-uv->v0)*scale;
				object->setSize(size);
				object->setUV(*uv);
				lineSpriteCount++;
				width += size.x;
			}
			if(lineSpriteCount < LINE_COUNT &&
			   line->uvBottom.u0 != -1.0f)
			{
				ms::GLSprite* object = lineSprite[lineSpriteCount];
				object->setTexture(texture);
				ms::Vector2f size;
				ms::UV* uv = &line->uvBottom;
				size.x = textureSize.x*(uv->u1-uv->u0)*scale;
				size.y = textureSize.y*(uv->v1-uv->v0)*scale;
				object->setSize(size);
				object->setUV(*uv);
				lineSpriteCount++;
				width += size.x;
			}
		}
		// 背景
		{
			ms::Vector2f size = ms::Vector2fMake(width+SPACE_LEFT, Scene::SCREEN_SIZE_H);
			lineBackSprite->setSize(size);
			lineBackSprite->setColor(backColor);
		}
	}else{
		// 背景のみ
		{
			ms::Vector2f size = ms::Vector2fMake(Scene::SCREEN_SIZE_W, Scene::SCREEN_SIZE_H);
			lineBackSprite->setSize(size);
			lineBackSprite->setColor(backColor);
		}
	}
#ifdef CONVERT_DEBUG
	for(int i = 0; i < ARRAYSIZE(debugLineHitCount); i++){
		//NSLOG(@"%d : %d", i, debugLineHitCount[i]);
	}
#endif
	calcedLine = TRUE;
}
//--------------------------------
ms::Uint32 ViewerPaperOne::calcThinOutInterval(float* srcValue,
										 ms::Uint32 srcValueCount,
										 BOOL* dstUseValueBuffer,
										 float thinOutRate)
{
	ASSERT(srcValueCount > 0);
	float avgValue = 0.0f;
	for(int i = 1; i < srcValueCount; i++){
		avgValue += ABS(srcValue[i]-srcValue[i-1]);
	}
	avgValue = avgValue / (float)srcValueCount;
	
	float prevValue = srcValue[0];
	float thinOutValue = avgValue*thinOutRate;
	ms::Uint32 dstCount = 1;
	dstUseValueBuffer[0] = TRUE;
	for(int i = 1; i < srcValueCount; i++){
		if(ABS(srcValue[i]-prevValue)>thinOutValue){
			dstUseValueBuffer[i] = TRUE;
			dstCount++;
			prevValue = srcValue[i];
		}else{
			dstUseValueBuffer[i] = FALSE;
		}
	}
	return dstCount;
}
//--------------------------------
void ViewerPaperOne::calcThinOutValue(float* srcValue,
								ms::Uint32 srcValueCount,
								BOOL* dstUseValueBuffer,
								float thinOutRate,
								BOOL thinUnder)
{
#define GROUP_COUNT	(2)
	ASSERT(srcValueCount > 0);
	BOOL useAvg[srcValueCount];
	float avgValue = 0.0f;
	
	{
		float min = srcValue[0];
		float max = srcValue[0];
		float groupCount[GROUP_COUNT];
		float groupMin[GROUP_COUNT];
		int useGroup;

		for(int i = 1; i < srcValueCount; i++){
			if(min > srcValue[i]){
				min = srcValue[i];
			}
			if(max < srcValue[i]){
				max = srcValue[i];
			}
		}
		for(int i = 0; i < GROUP_COUNT; i++){
			groupMin[i] = min+((max-min)/(float)GROUP_COUNT*i);
		}

		float gap = max-min;
		bzero(groupCount, sizeof(groupCount));
		for(int i = 0; i < srcValueCount; i++){
			int index = ((float)GROUP_COUNT*(srcValue[i]-min)/gap);
			index = (index >= GROUP_COUNT)? GROUP_COUNT-1: index;
			groupCount[index]++;
		}
		useGroup = GROUP_COUNT/2;
		for(int i = 0; i < GROUP_COUNT; i++){
			if(groupCount[useGroup] < groupCount[i]){
				useGroup = i;
			}
		}
		bzero(useAvg, sizeof(useAvg));
		for(int i = 0; i < srcValueCount; i++){
			if(srcValue[i] >= groupMin[useGroup] &&
			   (useGroup >= (GROUP_COUNT-1) || srcValue[i] < groupMin[useGroup+1]))
			{
				useAvg[i] = TRUE;
			}
		}
	}
	{
		int count = 0;
		for(int i = 0; i < srcValueCount; i++){
			if(useAvg[i]){
				avgValue += srcValue[i];
				count++;
			}
		}
		avgValue = avgValue / (float)count;
	}
	
	float thinOutValue = avgValue*thinOutRate;
	if(thinUnder){
		for(int i = 0; i < srcValueCount; i++){
			if(srcValue[i] < thinOutValue){
				dstUseValueBuffer[i] = FALSE;
			}else{
				dstUseValueBuffer[i] = TRUE;
			}
		}
	}else{
		for(int i = 0; i < srcValueCount; i++){
			if(srcValue[i] > thinOutValue){
				dstUseValueBuffer[i] = FALSE;
			}else{
				dstUseValueBuffer[i] = TRUE;
			}
		}
	}
}
//--------------------------------
ms::Sint32 ViewerPaperOne::getTop(unsigned char* _data,
								  const ms::Vector2n& _imageSize,
								  const ms::Vector2n& _textureSize,
								  const ms::Rect& _showArea,
								  int _judgeColor,
								  ms::Color4f* dstAvgColor)
{
	int searchTop = _imageSize.y*_showArea.pos.y;
	int searchBottom = _imageSize.y*(_showArea.pos.y+_showArea.size.y);
	int searchLeft = _imageSize.x*_showArea.pos.x;
	int searchRight = _imageSize.x*(_showArea.pos.x+_showArea.size.x);
	int needHitCount = 1/*(searchRight-searchLeft)*0.015f*/;
	int lineDataSize = _textureSize.x*4;
	int serchDataSize = (searchRight-searchLeft)*4;
	unsigned char* dataWork = ((unsigned char*)_data)+(lineDataSize*searchTop)+(4*searchLeft);
	int top = -1;
	unsigned int avgColorR = 0;
	unsigned int avgColorG = 0;
	unsigned int avgColorB = 0;
	unsigned int avgColorCount = 0;
	
	for(int i = searchTop; i < searchBottom; i++){
		int hitCount = 0;
		for(int j = searchLeft; j < searchRight; j++){
			int val = dataWork[0]+dataWork[1]+dataWork[2];
			if(val < _judgeColor){
				hitCount++;
			}else{
				avgColorR += dataWork[0];
				avgColorG += dataWork[1];
				avgColorB += dataWork[2];
				avgColorCount++;
			}
			dataWork += 4;
		}
		if(hitCount >= needHitCount){
			top = i;
			break;
		}
		dataWork += lineDataSize-serchDataSize;
	}
/*	if(top != -1){
		top -= OUTLINE_SPACE_TOP;
	}
*/
	if(dstAvgColor){
		dstAvgColor->r = ((float)avgColorR/(float)avgColorCount)/255.0f;
		dstAvgColor->g = ((float)avgColorG/(float)avgColorCount)/255.0f;
		dstAvgColor->b = ((float)avgColorB/(float)avgColorCount)/255.0f;
		dstAvgColor->a = 1.0f;
	}
	return top;
}
//--------------------------------
ms::Sint32 ViewerPaperOne::getBottom(unsigned char* _data,
									 const ms::Vector2n& _imageSize,
									 const ms::Vector2n& _textureSize,
									 const ms::Rect& _showArea,
									 int _judgeColor,
									 ms::Color4f* dstAvgColor)
{
	int searchTop = _imageSize.y*_showArea.pos.y;
	int searchBottom = _imageSize.y*(_showArea.pos.y+_showArea.size.y);
	int searchLeft = _imageSize.x*_showArea.pos.x;
	int searchRight = _imageSize.x*(_showArea.pos.x+_showArea.size.x);
	int needHitCount = 1/*(searchRight-searchLeft)*0.015f*/;
	int lineDataSize = _textureSize.x*4;
	int serchDataSize = (searchRight-searchLeft)*4;
	unsigned char* dataWork = ((unsigned char*)_data)+(lineDataSize*searchBottom)+(4*searchLeft);
	int bottom = -1;
	unsigned int avgColorR = 0;
	unsigned int avgColorG = 0;
	unsigned int avgColorB = 0;
	unsigned int avgColorCount = 0;
	
	for(int i = searchBottom; i > searchTop; i--){
		int hitCount = 0;
		for(int j = searchLeft; j < searchRight; j++){
			int val = dataWork[0]+dataWork[1]+dataWork[2];
			if(val < _judgeColor){
				hitCount++;
			}else{
				avgColorR += dataWork[0];
				avgColorG += dataWork[1];
				avgColorB += dataWork[2];
				avgColorCount++;
			}
			dataWork += 4;
		}
		if(hitCount >= needHitCount){
			bottom = i;
			break;
		}
		dataWork -= lineDataSize+serchDataSize;
	}
/*	if(bottom != -1){
		bottom += OUTLINE_SPACE_BOTTOM;
	}
*/
	if(dstAvgColor){
		dstAvgColor->r = ((float)avgColorR/(float)avgColorCount)/255.0f;
		dstAvgColor->g = ((float)avgColorG/(float)avgColorCount)/255.0f;
		dstAvgColor->b = ((float)avgColorB/(float)avgColorCount)/255.0f;
		dstAvgColor->a = 1.0f;
	}
	return bottom;
}
//--------------------------------
void ViewerPaperOne::setupSprite(){
	ms::Vector3f basePos = getPos();
	ms::Vector2f textureSize = texture->getTextureSize();
	ms::Vector2f imageSize = texture->getImageSize();
	{
		ms::UV uv;
		uv.u0 = imageSize.x*showArea.pos.x/textureSize.x;
		uv.v0 = imageSize.y*showArea.pos.y/textureSize.y;
		uv.u1 = imageSize.x*(showArea.pos.x+showArea.size.x)/textureSize.x;
		uv.v1 = imageSize.y*(showArea.pos.y+showArea.size.y)/textureSize.y;
		normalSprite->setUV(uv);
		normalSprite->setPos(basePos);
	}
	lineBackSprite->setPos(basePos);
	if(lineSpriteCount > 0){
		float posX = basePos.x+lineBackSprite->getSize().x;
		//float posX = 0.0f;
		for(int i = 0; i < lineSpriteCount; i++){
			ms::GLSprite* object = lineSprite[i];
			ms::Vector2f size = object->getSize();
			posX -= size.x;
			ms::Vector3f pos = ms::Vector3fMake(posX, basePos.y+SPACE_TOP, 0.0f);
			object->setPos(pos);
		}
	}
	// debug
#ifdef CONVERT_DEBUG
	if(debug){
		float normalSpriteScale = getNormalSpriteScale();
		ms::Vector2f spriteSize = normalSprite->getSize();
		// OUTLINE_TOP
		{
			ms::GLSprite* object = debugOutSprite[OUTLINE_TOP];
			if(object){
				object->setSize(ms::Vector2fMake(spriteSize.x, 1.0f));
				ms::Vector3f pos;
				pos.x = basePos.x;
				pos.y = basePos.y+(lines.rect.pos.y-(imageSize.y*showArea.pos.y))*normalSpriteScale;
				pos.z = 0.0f;
				object->setPos(pos);
			}
		}
		// OUTLINE_BOTTOM
		{
			ms::GLSprite* object = debugOutSprite[OUTLINE_BOTTOM];
			if(object){
				object->setSize(ms::Vector2fMake(spriteSize.x, 1.0f));
				ms::Vector3f pos;
				pos.x = basePos.x;
				pos.y = basePos.y+((lines.rect.pos.y+lines.rect.size.y)-(imageSize.y*showArea.pos.y))*normalSpriteScale;
				pos.z = 0.0f;
				object->setPos(pos);
			}
		}
		// line
		{
			for(int i = 0; i < lines.lineCount; i++){
				LINE* line = &lines.line[i];
				{
					ms::GLSprite* object = debugLineLeftSprite[i];
					if(object){
						object->setSize(ms::Vector2fMake(1.0f, spriteSize.y));
						ms::Vector3f pos;
						pos.x = basePos.x+(line->rect.pos.x-(imageSize.x*showArea.pos.x))*normalSpriteScale;
						pos.y = basePos.y;
						pos.z = 0.0f;
						object->setPos(pos);
					}
				}
				{
					ms::GLSprite* object = debugLineRightSprite[i];
					if(object){
						object->setSize(ms::Vector2fMake(1.0f, spriteSize.y));
						ms::Vector3f pos;
						pos.x = basePos.x+(line->posRightX-(imageSize.x*showArea.pos.x))*normalSpriteScale;
						pos.y = basePos.y;
						pos.z = 0.0f;
						object->setPos(pos);
					}
				}
			}
		}
		// word
		{
			int index = 0;
			for(int i = 0; i < lines.lineCount; i++){
				LINE* line = &lines.line[i];
				for(int j = 0; j < line->wordCount; j++){
					ms::GLSprite* object = debugWordSprite[index];

					ms::Vector3f pos;
					pos.x = basePos.x+(line->rect.pos.x-(imageSize.x*showArea.pos.x))*normalSpriteScale;
					pos.y = basePos.y+(line->wordPosY[j]-(imageSize.y*showArea.pos.y))*normalSpriteScale;
					pos.z = 0.0f;
					object->setPos(pos);
					object->setSize(ms::Vector2fMake(line->rect.size.x*normalSpriteScale, 1.0f));
					if(j == line->middleWordIndex){
						object->setColor(DEBUG_LINE_WORD_MIDDLE_COLOR);
					}else{
						object->setColor(DEBUG_LINE_WORD_COLOR);
					}
					index++;
				}
			}
		}
		// 改行
		{
			for(int i = 0; i < lines.lineCount; i++){
				LINE* line = &lines.line[i];
				ms::GLSprite* object = debugRL[i];
				if(object){
					object->setSize(ms::Vector2fMake(1.0f, spriteSize.y));
					if(line->uvUp.v1 != -1.0f){
						ms::Vector3f pos;
						pos.x = basePos.x+(line->rect.pos.x-(imageSize.x*showArea.pos.x))*normalSpriteScale;
						pos.y = basePos.y+((textureSize.y*line->uvUp.v1)-(imageSize.y*showArea.pos.y))*normalSpriteScale;
						pos.z = 0.0f;
						object->setPos(pos);
					}
					object->setSize(ms::Vector2fMake(line->rect.size.x*normalSpriteScale, 1.0f));
				}
			}
		}
		// ヒット密度
		{
			for(int i = 0; i < imageSize.x; i++){
				ms::GLSprite* object = debugLineHitCountSprite[i];
				if(object){
					if(i >= imageSize.x*showArea.pos.x && i < imageSize.x*(showArea.pos.x+showArea.size.x)){
						ms::Vector3f pos;
						pos.x = basePos.x+(i-(imageSize.x*showArea.pos.x))*normalSpriteScale;
						pos.y = basePos.y;
						pos.z = 0.0f;
						object->setPos(pos);
						ms::Vector2f size;
						size.x = 1.0f;
						size.y = (float)debugLineHitCount[i]/imageSize.y*((float)Scene::SCREEN_SIZE_H*2.0f);
						//NSLOG(@"%f", size.y);
						object->setSize(size);
						object->setVisible(TRUE);
					}else{
						object->setVisible(FALSE);
					}
				}
			}
		}
	}
#endif
}
//--------------------------------
float ViewerPaperOne::getNormalSpriteScale(){
	float scale = 0.0f;
	ms::Vector2f spriteSize = normalSprite->getSize();
	ms::Vector2f imageSize = texture->getImageSize();
	scale = spriteSize.x / (imageSize.x*showArea.size.x);
	return scale;
}