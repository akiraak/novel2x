#import "CalcLine.h"
#import "Scene.h"
#import "Texture.h"
#import "BookUtil.h"

//--------------------------------
#define OUTLINE_SPACE_TOP		(8.0f)
#define OUTLINE_SPACE_BOTTOM	(8.0f)
#define OUTLINE_SPACE_LEFT		(4.0f)
#define OUTLINE_SPACE_RIGHT		(4.0f)
#define SPACE_H					(16.0f)

//--------------------------------
CalcLine::CalcLine():
state((STATE)0),
texture(NULL),
backPaperSprite(NULL),
backSprite(NULL),
lineCount(0),
imageIndex(0)
{
	bzero(outLineSprite, sizeof(outLineSprite));
	bzero(lineDebugSprite, sizeof(lineDebugSprite));
//	bzero(lineInfos, sizeof(lineInfos));
	bzero(lineSprite, sizeof(lineSprite));
	bzero(wordDebugSprite, sizeof(wordDebugSprite));
}
//--------------------------------
CalcLine::~CalcLine(){
	MS_SAFE_DELETE(texture);
	MS_SAFE_DELETE(backPaperSprite);
	MS_SAFE_DELETE(backSprite);
	for(int i = 0; i < ARRAYSIZE(outLineSprite); i++){
		MS_SAFE_DELETE(outLineSprite[i]);
	}
	for(int i = 0; i < ARRAYSIZE(lineDebugSprite); i++){
		MS_SAFE_DELETE(lineDebugSprite[i]);
	}
	for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
		MS_SAFE_DELETE(lineSprite[i]);
	}
	for(int i = 0; i < ARRAYSIZE(wordDebugSprite); i++){
		MS_SAFE_DELETE(wordDebugSprite[i]);
	}
}
//--------------------------------
void CalcLine::init(){
	ms::Object::init();
	{
		ms::GLSprite* object = new ms::GLSprite;
		ASSERT(object);
		object->init();
		object->setVisible(TRUE);
		object->setColor(ms::Color4fMake(1.0f, 250.0f/256.0f, 240.0f/256.0f, 1.0f));
		object->setSize(ms::Vector2fMake(Scene::SCREEN_SIZE_W, Scene::SCREEN_SIZE_H));
		ASSERT(!backPaperSprite);
		backPaperSprite = object;
	}
	{
		ms::Vector2f size[] = {
			ms::Vector2fMake(Scene::SCREEN_SIZE_W, 1),
			ms::Vector2fMake(Scene::SCREEN_SIZE_W, 1),
			ms::Vector2fMake(1, Scene::SCREEN_SIZE_H),
			ms::Vector2fMake(1, Scene::SCREEN_SIZE_H),
		};
		for(int i = 0; i < ARRAYSIZE(outLineSprite); i++){
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setVisible(FALSE);
			object->setColor(ms::Color4fMake(0.0f, 0.0f, 1.0f, 1.0f));
			object->setSize(size[i]);
			ASSERT(!outLineSprite[i]);
			outLineSprite[i] = object;
		}
	}
	{
		for(int i = 0; i < ARRAYSIZE(lineDebugSprite); i++){
			ms::GLSprite* object = new ms::GLSprite;
			ASSERT(object);
			object->init();
			object->setVisible(FALSE);
			object->setColor(ms::Color4fMake(1.0f, 0.0f, 0.0f, 1.0f));
			object->setSize(ms::Vector2fMake(1.0f, Scene::SCREEN_SIZE_H));
			ASSERT(!lineDebugSprite[i]);
			lineDebugSprite[i] = object;
		}
	}
}
//--------------------------------
BOOL CalcLine::update(ms::Uint32 elapsedTime){
	BOOL isDraw = TRUE;
	switch(state){
		case STATE_DISABLE:
			break;
		case STATE_INIT:
		{
			{
				lines.rect = ms::RectMake(0.0f, 0.0f, 0.0f, 0.0f);
				lines.lineCount = 0;
				bzero(lines.line, sizeof(lines.line));
				lines.lineWidthAvg = 0.0f;
				lines.judgeColor = 512;
			}
			ms::Rect showAreas[]={
				ms::RectMake(0.05f, 0.15f, 0.9f, 0.75f),
				ms::RectMake(0.05f, 0.15f, 0.9f, 0.75f),
				ms::RectMake(0.05f, 0.1f, 0.9f, 0.8f),
				ms::RectMake(0.05f, 0.1f, 0.9f, 0.8f),
				ms::RectMake(0.05f, 0.1f, 0.9f, 0.85f),
				ms::RectMake(0.05f, 0.1f, 0.9f, 0.8f),
				ms::RectMake(0.05f, 0.1f, 0.9f, 0.8f),
				ms::RectMake(0.05f, 0.1f, 0.9f, 0.8f),
				ms::RectMake(0.05f, 0.1f, 0.9f, 0.8f),
				ms::RectMake(0.05f, 0.1f, 0.9f, 0.8f),
			};
			NSString* imageFiles[]={
				@"162.jpg",
				@"161.jpg",
				@"hshort_004 0101.jpg",
				@"023.jpg",
				@"033.jpg",
				@"group_01_007.jpg",
				@"group_02_014.jpg",
				@"group_03_068.jpg",
				@"short_01_044.jpg",
				@"short_02_084.jpg",
			};
			UIImage* image = [UIImage imageNamed:imageFiles[imageIndex]];
			BookUtil::resizeTextureFile(image, &image, NULL, FALSE, NULL);
			CGContextRef dstContext;
			ms::Vector2n imageSize;
			ms::Vector2n textureSize;
			void* data = initWithUIImage(image, &dstContext, &imageSize, &textureSize);
			
			ms::Vector2f spriteSize;
			if((Scene::SCREEN_SIZE_W / Scene::SCREEN_SIZE_H) < (imageSize.x / imageSize.y)){
				spriteSize.x = Scene::SCREEN_SIZE_W;
				spriteSize.y = Scene::SCREEN_SIZE_W * imageSize.y / imageSize.x;
			}else{
				spriteSize.x = Scene::SCREEN_SIZE_H * imageSize.x / imageSize.y;
				spriteSize.y = Scene::SCREEN_SIZE_H;
			}

/*			for(int i = 0; i < ARRAYSIZE(wordDebugSprite); i++){
				if(wordDebugSprite[i]){
					wordDebugSprite[i]->setVisible(FALSE);
				}
			}
*/			
			ms::Rect* showArea = &showAreas[imageIndex];
			int top = -1;
//			int left = -1;
			int bottom = -1;
			int right = -1;
			ms::Sint32 judgeColor = lines.judgeColor;
			// 上限下限の取得
			{
				top = getTop((unsigned char*)data, imageSize, textureSize, *showArea, judgeColor);
				bottom = getBottom((unsigned char*)data, imageSize, textureSize, *showArea, judgeColor);
			}
			// 左右の走査
			{
				int searchTop = top;
				int searchBottom = bottom;
				int searchLeft = imageSize.x*showArea->pos.x;
				int searchRight = imageSize.x*(showArea->pos.x+showArea->size.x);
				int hDataSize = 4*textureSize.x;
				//int vDataSize = 4*textureSize.y;
				//int serchDataSize = 4*(searchBottom-searchTop);
				int nextLineDataSize = -(hDataSize*(searchBottom-searchTop)+4);
				int wordSpriteCount = 0;
				
				// 右端の取得
				{
					int needHitCount = (searchBottom-searchTop)*0.015f;
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
					//right += OUTLINE_SPACE_RIGHT;
				}
				// 行を取得
				{
					int lineCount = 0;
					float linePosX[LINE_MAX];
					
					// 行を検出
					{
						enum SEARCH {
							SEARCH_SPACE = 0,
							SEARCH_WORD,
						};
						SEARCH search = SEARCH_SPACE;
						int needHitCount = 1;
						unsigned char* dataWork = ((unsigned char*)data)+(hDataSize*searchTop)+(4*(right-1));
						for(int i = right-1; i >= searchLeft; i--){
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
									if(hitCount == 0){
										linePosX[lineCount] = i;
										lineCount++;
										search = SEARCH_WORD;
									}
									break;
								case SEARCH_WORD:
									if(hitCount >= needHitCount){
										search = SEARCH_SPACE;
									}
									break;
							}
							dataWork += nextLineDataSize;
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
						for(int calcIndex = 0; calcIndex < calcCount; calcIndex++){
							// 幅がかなり大きいものを削除
							{
								float calcThinOutRate = 1.7f;
								//ms::Uint32 valueCount = lineCount-1;
								ms::Uint32 valueCount = 0;
								float srcValue[lineCount];
								for(int j = 0; j < lineCount; j++){
									NSLog(@"%d : %f", j, linePosX[j]);
								}

								{
									int prevLine = 0;
									for(int j = 1; j < lineCount; j++){
										if(spaceType[j] == SPACE_TYPE_NONE){
											srcValue[valueCount] = linePosX[prevLine]-linePosX[j];
											prevLine = j;
											NSLog(@"%d : %f", valueCount, srcValue[valueCount]);
											valueCount++;
										}else if(spaceType[j] == SPACE_TYPE_BIG){
											prevLine = j;
										}
									}
								}
								BOOL calcUseValue[valueCount];
								calcThinOutValue(srcValue, valueCount, calcUseValue, calcThinOutRate, FALSE);
								for(int j = 0; j < valueCount; j++){
									if(calcUseValue[j]){
										NSLog(@"%d : %f : TRUE", j, srcValue[j]);
									}else{
										NSLog(@"%d : %f : FALSE", j, srcValue[j]);
									}
								}

								int index = 0;
								for(int j = 1; j < lineCount; j++){
									if(spaceType[j] == SPACE_TYPE_NONE){
										if(!calcUseValue[index]){
											spaceType[j] = SPACE_TYPE_BIG;
										}
										index++;
									}
								}
								for(int j = 0; j < lineCount; j++){
									NSLog(@"%d : %f : %d", j, linePosX[j], spaceType[j]);
								}

							}
							// 幅が小さいものを削除
							{
								float calcThinOutRate = 0.7f;
								//ms::Uint32 valueCount = lineCount-1;
								ms::Uint32 valueCount = 0;
								float srcValue[lineCount];
/*								for(int j = 0; j < lineCount; j++){
									NSLog(@"%d : %f", j, linePosX[j]);
								}
*/
								{
									int prevLine = 0;
									for(int j = 1; j < lineCount; j++){
										if(spaceType[j] == SPACE_TYPE_NONE){
											srcValue[valueCount] = linePosX[prevLine]-linePosX[j];
											prevLine = j;
											//NSLog(@"%d : %f", valueCount, srcValue[valueCount]);
											valueCount++;
										}else if(spaceType[j] == SPACE_TYPE_BIG){
											prevLine = j;
										}
									}
								}
								BOOL calcUseValue[valueCount];
								calcThinOutValue(srcValue, valueCount, calcUseValue, calcThinOutRate, TRUE);
/*								for(int j = 0; j < valueCount; j++){
									if(calcUseValue[j]){
										NSLog(@"%d : %f : TRUE", j, srcValue[j]);
									}else{
										NSLog(@"%d : %f : FALSE", j, srcValue[j]);
									}
								}
*/
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
/*								for(int j = 0; j < lineCount; j++){
									NSLog(@"%d : %f : %d", j, linePosX[j], spaceType[j]);
								}
*/
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
							lines.rect.size.x = (right-lines.rect.pos.x)/imageSize.x;
							lines.rect.size.x = (bottom-top)/imageSize.y;
							{
								float spaceAvg = 0.0f;
								int prevLine = -1;
								int count = 0;
								for(int i = 0; i < lineCount; i++){
									if(prevLine == -1){
										if(spaceType[i] != SPACE_TYPE_MIN){
											prevLine = i;
										}
									}else{
										if(spaceType[i] == SPACE_TYPE_NONE){
											spaceAvg += linePosX[prevLine]-linePosX[i];
											prevLine = i;
											count++;
										}
									}
								}
								lines.lineWidthAvg = spaceAvg / count;
							}
							{
								int lineIndex = 0;
								for(int i = 0; i < lineCount; i++){
									if(spaceType[i] != SPACE_TYPE_MIN){
										LINE* line = &lines.line[lineIndex];
										line->rect.pos.x = linePosX[i];
										line->rect.pos.y = top;
										if(lineIndex == 0){
											line->rect.size.x = lines.lineWidthAvg;
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
											//LINE* lineInfo = &lines.line[i];
											int wordCount = 0;
											int wordPosY[WORD_COUNT];
											int wordSizeH[WORD_COUNT];
											int lastWordUnderPosY = 0;
											int top = textureSize.y*line->uvUp.v0;
											int searchCount = textureSize.y*(line->uvUp.v1-line->uvUp.v0);
											int lineLeft = textureSize.x*line->uvUp.u0;
											int lineRight = textureSize.x*line->uvUp.u1;
											// 行内の文字を取得
											{
												enum SEARCH{
													SEARCH_WORD = 0,
													SEARCH_SPACE,
												};
												SEARCH search = SEARCH_WORD;
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
															if(hitCount > 0){
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
												}
												{
													if(wordCount > 1){
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
															
															if(wordSpriteCount < ARRAYSIZE(wordDebugSprite)){
																ms::GLSprite* sprite = wordDebugSprite[wordSpriteCount];
																if(!sprite){
																	sprite = new ms::GLSprite;
																	ASSERT(sprite);
																	sprite->init();
																	wordDebugSprite[wordSpriteCount] = sprite;
																}
																ms::Vector3f pos;
																pos.x = spriteSize.x*lineLeft/imageSize.x;
																pos.y = spriteSize.y*(srcValue[j])/imageSize.y;
																pos.z = 0.0f;
																sprite->setPos(pos);
																ms::Vector2f size;
																size.x = (lineRight-lineLeft)*spriteSize.x/imageSize.x;
																size.y = 1.0f;
																sprite->setSize(size);
																sprite->setColor(ms::Color4fMake(1.0f, 0.0f, 0.0f, 1.0f));
																sprite->setVisible(TRUE);
																wordSpriteCount++;
															}
														}
														// 下限の追加
														{
															wordPosY[wordCount] = lastWordUnderPosY;
															wordSizeH[wordCount] = 0.0f;
															wordCount++;

															ms::GLSprite* sprite = wordDebugSprite[wordSpriteCount];
															if(!sprite){
																sprite = new ms::GLSprite;
																ASSERT(sprite);
																sprite->init();
																wordDebugSprite[wordSpriteCount] = sprite;
															}
															ms::Vector3f pos;
															pos.x = spriteSize.x*lineLeft/imageSize.x;
															pos.y = spriteSize.y*(wordPosY[wordCount-1])/imageSize.y;
															pos.z = 0.0f;
															sprite->setPos(pos);
															ms::Vector2f size;
															size.x = (lineRight-lineLeft)*spriteSize.x/imageSize.x;
															size.y = 1.0f;
															sprite->setSize(size);
															sprite->setColor(ms::Color4fMake(1.0f, 0.0f, 0.0f, 1.0f));
															sprite->setVisible(TRUE);
															wordSpriteCount++;
														}
													}
												}
											}
											// 中間を探す
											{
												int lineMiddle = textureSize.y*((line->uvUp.v0+line->uvUp.v1)*0.5f);
												if(wordPosY[0] < lineMiddle){
													BOOL middleExist = FALSE;
													int middleIndex = 0;
													for(int j = 0; j < wordCount-1; j++){
														middleIndex = j;
														if(wordPosY[j] > lineMiddle){
															middleExist = TRUE;
															break;
														}
													}
													if(middleExist){
														line->uvBottom.u0 = line->uvUp.u0;
														if(middleIndex > 0){
															line->uvBottom.v0 = (wordPosY[middleIndex-1]+wordSizeH[middleIndex-1]+wordPosY[middleIndex])*0.5f/textureSize.y;
														}else{
															line->uvBottom.v0 = wordPosY[middleIndex]/textureSize.y;
														}
														if(line->widthBig){
															line->uvBottom.u1 = (line->rect.pos.x+lines.lineWidthAvg)/textureSize.x;
														}else{
															line->uvBottom.u1 = line->uvUp.u1;
														}
														line->uvBottom.v1 = line->uvUp.v1;
														line->uvUp.v1 = line->uvBottom.v0;
													}else{
														line->uvUp.v1 = (line->uvUp.v0+line->uvUp.v1)*0.5f;
														line->uvBottom = ms::UVMake(-1.0f, -1.0f, -1.0f, -1.0f);
													}
												}else{
													// 上半分には何も無い
													line->uvUp.v0 = (float)lineMiddle/(float)textureSize.y;
												}
											}
										}
										lineIndex++;
									}
								}
								lines.lineCount = lineIndex;
							}
							
							for(int i = 0; i < ARRAYSIZE(lineDebugSprite); i++){
								lineDebugSprite[i]->setVisible(FALSE);
							}
							int spriteIndex = 0;
							for(int i = 0; i < lineCount; i++){
								if(spaceType[i] != SPACE_TYPE_MIN){
									if(i < LINE_MAX){
										ms::GLSprite* sprite = lineDebugSprite[spriteIndex];
										ms::Vector3f pos;
										pos.x = spriteSize.x*linePosX[i]/imageSize.x;
										pos.y = 0.0f;
										pos.z = 0.0f;
										sprite->setPos(pos);
										if(spaceType[i] == SPACE_TYPE_NONE){
											sprite->setColor(ms::Color4fMake(1.0f, 0.0f, 0.0f, 1.0f));
										}else{
											sprite->setColor(ms::Color4fMake(1.0f, 1.0f, 0.0f, 1.0f));
										}
										sprite->setVisible(TRUE);
										spriteIndex++;
									}
								}
							}
						}
					}
				}

			}
			// 全体範囲の外枠を描画
			{
				{
					ms::Vector3f pos;
					pos.x = 0.0f;
					pos.y = spriteSize.y*top/imageSize.y;
					pos.z = 0.0f;
					outLineSprite[OUTLINE_TOP]->setPos(pos);
					outLineSprite[OUTLINE_TOP]->setVisible(TRUE);
				}
				{
					ms::Vector3f pos;
					pos.x = 0.0f;
					pos.y = spriteSize.y*bottom/imageSize.y;
					pos.z = 0.0f;
					outLineSprite[OUTLINE_BOTTOM]->setPos(pos);
					outLineSprite[OUTLINE_BOTTOM]->setVisible(TRUE);
				}
/*				{
					ms::Vector3f pos;
					pos.x = spriteSize.x*left/imageSize.x;
					pos.y = 0.0f;
					pos.z = 0.0f;
					outLineSprite[OUTLINE_LEFT]->setPos(pos);
					outLineSprite[OUTLINE_LEFT]->setVisible(TRUE);
				}
*/				{
					ms::Vector3f pos;
					pos.x = spriteSize.x*right/imageSize.x;
					pos.y = 0.0f;
					pos.z = 0.0f;
					outLineSprite[OUTLINE_RIGHT]->setPos(pos);
					outLineSprite[OUTLINE_RIGHT]->setVisible(TRUE);
				}
			}

			MS_SAFE_DELETE(texture);
			texture = new ms::GLTexture;
			texture->initWithData(data,
								  ms::GLTexture::kPixelFormat_RGBA8888,
								  ms::Vector2fMake(textureSize.x, textureSize.y),
								  ms::Vector2fMake(imageSize.x, imageSize.y));
			{
				float scale = 0.0f;
				{
					float vHeightMax = (bottom-top)*0.5f/textureSize.y;
					for(int i = 0; i < lines.lineCount; i++){
						LINE* lineInfo = &lines.line[i];
						if(vHeightMax < (lineInfo->uvUp.v1-lineInfo->uvUp.v0)){
							vHeightMax = (lineInfo->uvUp.v1-lineInfo->uvUp.v0);
						}
						if(lineInfo->uvBottom.u0 != -1.0f &&
						   vHeightMax < (lineInfo->uvBottom.v1-lineInfo->uvBottom.v0))
						{
							vHeightMax = (lineInfo->uvBottom.v1-lineInfo->uvBottom.v0);
						}
					}
					float heightMax = textureSize.y*vHeightMax;
					scale = (Scene::SCREEN_SIZE_H-(SPACE_H*2))/heightMax;
				}
				{
					float posX = Scene::SCREEN_SIZE_W;
					int spriteCount = 0;
					for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
						if(lineSprite[i]){
							MS_SAFE_DELETE(lineSprite[i]);
						}
					}
					for(int i = 0; i < lines.lineCount; i++){
						LINE* line = &lines.line[i];
						{
							ms::GLSprite* object = new ms::GLSprite;
							ASSERT(object);
							object->init();
							object->setVisible(TRUE);
							object->setTexture(texture);
							object->alignParamToTexture();
							object->setColor(ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f));
							ms::Vector2f size;
							ms::UV* uv = &line->uvUp;
							size.x = textureSize.x*(uv->u1-uv->u0)*scale;
							size.y = textureSize.y*(uv->v1-uv->v0)*scale;
							object->setSize(size);
							posX -= size.x;
							ms::Vector3f pos = ms::Vector3fMake(posX, SPACE_H, 0.0f);
							object->setPos(pos);
							object->setUV(*uv);
							ASSERT(!lineSprite[spriteCount]);
							lineSprite[spriteCount] = object;
							spriteCount++;
						}
						if(line->uvBottom.u0 != -1.0f){
							ms::GLSprite* object = new ms::GLSprite;
							ASSERT(object);
							object->init();
							object->setVisible(TRUE);
							object->setTexture(texture);
							object->alignParamToTexture();
							object->setColor(ms::Color4fMake(1.0f, 1.0f, 1.0f, 1.0f));
							ms::Vector2f size;
							ms::UV* uv = &line->uvBottom;
							size.x = textureSize.x*(uv->u1-uv->u0)*scale;
							size.y = textureSize.y*(uv->v1-uv->v0)*scale;
							object->setSize(size);
							posX -= size.x;
							ms::Vector3f pos = ms::Vector3fMake(posX, SPACE_H, 0.0f);
							object->setPos(pos);
							object->setUV(*uv);
							ASSERT(!lineSprite[spriteCount]);
							lineSprite[spriteCount] = object;
							spriteCount++;
						}
					}
				}
			}
			
			CGContextRelease(dstContext);
			free(data);
			
			{
				if(backSprite){
					MS_SAFE_DELETE(backSprite);
				}
				ms::GLSprite* object = new ms::GLSprite;
				ASSERT(object);
				object->init();
				object->setVisible(TRUE);
				object->setTexture(texture);
				object->alignParamToTexture();
				object->setPos(ms::Vector3fMake(0.0f, 0.0f, 0.0f));
				object->setSize(spriteSize);
				ASSERT(!backSprite);
				backSprite = object;
			}
			
			state = STATE_IDLE;
			break;
		}
		case STATE_IDLE:
			if(elapsedTime > 1000){
				elapsedTime = 1000;
			}
			for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
				if(lineSprite[i]){
					ms::GLSprite* sprite = lineSprite[i];
					ms::Vector3f pos = sprite->getPos();
					pos.x += 20.0f * (float)elapsedTime / 1000.0f;
					sprite->setPos(pos);
				}
			}
			break;
	}
	return isDraw;
}
//--------------------------------
void CalcLine::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	imageIndex++;
	state = STATE_INIT;
}
//--------------------------------
void CalcLine::draw(){
	if(state != STATE_DISABLE){
		backPaperSprite->draw();
#if 1
		backSprite->draw();
		for(int i = 0; i < ARRAYSIZE(outLineSprite); i++){
			if(outLineSprite[i]){
				outLineSprite[i]->draw();
			}
		}
		for(int i = 0; i < ARRAYSIZE(lineDebugSprite); i++){
			if(lineDebugSprite[i]){
				lineDebugSprite[i]->draw();
			}
		}
		for(int i = 0; i < ARRAYSIZE(wordDebugSprite); i++){
			if(wordDebugSprite[i]){
				wordDebugSprite[i]->draw();
			}
		}
#else
		for(int i = 0; i < ARRAYSIZE(lineSprite); i++){
			if(lineSprite[i]){
				lineSprite[i]->draw();
			}
		}
#endif
	}
}
//--------------------------------
void CalcLine::start(){
	state = STATE_INIT;
}
//--------------------------------
ms::Uint32 CalcLine::calcThinOutInterval(float* srcValue,
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
void CalcLine::calcThinOutValue(float* srcValue,
									  ms::Uint32 srcValueCount,
									  BOOL* dstUseValueBuffer,
									  float thinOutRate,
									  BOOL thinUnder)
{
	ASSERT(srcValueCount > 0);
	float avgValue = 0.0f;
	for(int i = 0; i < srcValueCount; i++){
		avgValue += srcValue[i];
	}
	avgValue = avgValue / (float)srcValueCount;
	
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
void* CalcLine::initWithUIImage(UIImage* uiImage, CGContextRef* dstContext, ms::Vector2n* dstImageSize, ms::Vector2n* dstTextureSize){
	CGImageRef cgImage = uiImage.CGImage;
	NSUInteger				width;
	NSUInteger				height;
	CGContextRef			context_work = nil;
	void*					data = nil;;
	CGColorSpaceRef			colorSpace;
	BOOL					hasAlpha;
	CGImageAlphaInfo		info;
	ms::GLTexture::PixelFormat	pixelFormat;
	BOOL					sizeToFit = NO;
	
	info = CGImageGetAlphaInfo(cgImage);
	hasAlpha = ((info == kCGImageAlphaPremultipliedLast) || (info == kCGImageAlphaPremultipliedFirst) || (info == kCGImageAlphaLast) || (info == kCGImageAlphaFirst) ? YES : NO);
	if(CGImageGetColorSpace(cgImage)) {
		pixelFormat = ms::GLTexture::kPixelFormat_RGBA8888;
	}else{
		//NOTE: No colorspace means a mask image
		pixelFormat = ms::GLTexture::kPixelFormat_A8;
	}
	ms::Vector2f _imageSize = ms::Vector2fMake(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
	width = _imageSize.x;
	if((width != 1) && (width & (width - 1))) {
		NSUInteger i = 1;
		while((sizeToFit ? 2 * i : i) < width)
			i *= 2;
		width = i;
	}
	height = _imageSize.y;
	if((height != 1) && (height & (height - 1))) {
		NSUInteger i = 1;
		while((sizeToFit ? 2 * i : i) < height)
			i *= 2;
		height = i;
	}
	ASSERT(width <= ms::GLTexture::kMaxTextureSize);
	ASSERT(height <= ms::GLTexture::kMaxTextureSize);
	switch(pixelFormat){
		case ms::GLTexture::kPixelFormat_RGBA8888:
			colorSpace = CGColorSpaceCreateDeviceRGB();
			data = malloc(height * width * 4);
			context_work = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
			CGColorSpaceRelease(colorSpace);
			break;
		case ms::GLTexture::kPixelFormat_A8:
			data = malloc(height * width);
			context_work = CGBitmapContextCreate(data, width, height, 8, width, NULL, kCGImageAlphaOnly);
			break;				
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid pixel format"];
			ASSERT(FALSE);
	}
	CGContextClearRect(context_work, CGRectMake(0, 0, width, height));
	CGContextTranslateCTM(context_work, 0, height - _imageSize.y);
	CGContextDrawImage(context_work, CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage)), cgImage);
//	initWithData(data, pixelFormat, Vector2fMake(width, height), _imageSize);
//	CGContextRelease(context_work);
//	free(data);
	*dstContext = context_work;
	dstImageSize->x = _imageSize.x;
	dstImageSize->y = _imageSize.y;
	dstTextureSize->x = width;
	dstTextureSize->y = height;
	return data;
}
//--------------------------------
ms::Sint32 CalcLine::getTop(unsigned char* _data,
							const ms::Vector2n& _imageSize,
							const ms::Vector2n& _textureSize,
							const ms::Rect& _showArea,
							int _judgeColor)
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
	
	for(int i = searchTop; i < searchBottom; i++){
		int hitCount = 0;
		for(int j = searchLeft; j < searchRight; j++){
			int val = dataWork[0]+dataWork[1]+dataWork[2];
			if(val < _judgeColor){
				hitCount++;
			}
			dataWork += 4;
		}
		if(hitCount >= needHitCount){
			top = i;
			break;
		}
		dataWork += lineDataSize-serchDataSize;
	}
	if(top != -1){
		top -= OUTLINE_SPACE_TOP;
	}
	return top;
}
//--------------------------------
ms::Sint32 CalcLine::getBottom(unsigned char* _data,
							const ms::Vector2n& _imageSize,
							const ms::Vector2n& _textureSize,
							const ms::Rect& _showArea,
							int _judgeColor)
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
	
	for(int i = searchBottom; i > searchTop; i--){
		int hitCount = 0;
		for(int j = searchLeft; j < searchRight; j++){
			int val = dataWork[0]+dataWork[1]+dataWork[2];
			if(val < _judgeColor){
				hitCount++;
			}
			dataWork += 4;
		}
		if(hitCount >= needHitCount){
			bottom = i;
			break;
		}
		dataWork -= lineDataSize+serchDataSize;
	}
	if(bottom != -1){
		bottom += OUTLINE_SPACE_BOTTOM;
	}
	return bottom;
}

