#import "MyAppDelegate.h"
#import "Viewer.h"
#import "Scene.h"
#import "Texture.h"
#import "AppData.h"

#define FADEIN_TIME			(500)
#define FADEOUT_TIME		(500)
#define TOP_TOUCH_TIME		(500)
#define TOP_SHOW_TIME		(3000)
#define MOVE_ALPHA			(0.8f)
#define PUSH_MOVE_TOUCH_H	(Scene::SCREEN_SIZE_H*0.4f)

//--------------------------------
ms::Rect Viewer::touchRect[]={
	ms::RectMake(-Scene::SCREEN_SIZE_W*0.5f,
				 -Scene::SCREEN_SIZE_H*0.5f,
				 Scene::SCREEN_SIZE_W,
				 PUSH_MOVE_TOUCH_H),
	ms::RectMake(-Scene::SCREEN_SIZE_W*0.5f,
				 -Scene::SCREEN_SIZE_H*0.5f+PUSH_MOVE_TOUCH_H,
				 Scene::SCREEN_SIZE_W,
				 Scene::SCREEN_SIZE_H-PUSH_MOVE_TOUCH_H),
};

//--------------------------------
Viewer::Viewer():
state((STATE)0),
camera(NULL),
paper(NULL),
vSlider(NULL),
top(NULL),
move(NULL),
touchFlash(NULL),
pageNo(NULL),
dirName(NULL),
touchBeganPos(ms::Vector2fMake(0.0f, 0.0f)),
touchBeganTime(0),
amazonUrlDelegate(NULL),
alertDelegate(NULL),
drawFlag(FALSE)
{
	bzero(&paperNotifyInfo, sizeof(paperNotifyInfo));
	paperNotifyNode.init(this);
	topNotifyNode.init(this);
	moveNotifyNode.init(this);
}
//--------------------------------
Viewer::~Viewer(){
	paper->removeChildNotifyMessage(paperNotifyNode);
	top->removeChildNotifyMessage(topNotifyNode);
	move->removeChildNotifyMessage(moveNotifyNode);
	MS_SAFE_DELETE(camera);
	MS_SAFE_DELETE(paper);
	MS_SAFE_DELETE(vSlider);
	MS_SAFE_DELETE(top);
	MS_SAFE_DELETE(move);
	MS_SAFE_DELETE(touchFlash);
	if(dirName){
		[dirName release];
	}
	[amazonUrlDelegate release];
	[alertDelegate release];
}
//--------------------------------
void Viewer::init(){
	ms::Object::init();
	{
		ViewerCamera* object = new ViewerCamera;
		ASSERT(object);
		object->init();
		ASSERT(!camera);
		camera = object;
	}
	{
		ViewerPaper* object = new ViewerPaper;
		ASSERT(object);
		ASSERT(!paper);
		paper = object;
		object->addChildNotifyMessage(paperNotifyNode);
		object->init();
	}
	{
		ViewerVSlider* object = new ViewerVSlider;
		ASSERT(object);
		object->init();
		ASSERT(!vSlider);
		vSlider = object;
	}
	{
		ViewerTop* object = new ViewerTop;
		ASSERT(object);
		object->init();
		object->addChildNotifyMessage(topNotifyNode);
		ASSERT(!top);
		top = object;
	}
	{
		ViewerMove* object = new ViewerMove;
		ASSERT(object);
		object->init();
		object->addChildNotifyMessage(moveNotifyNode);
		ASSERT(!move);
		move = object;
	}
	{
		ViewerTouchFlash* object = new ViewerTouchFlash;
		ASSERT(object);
		object->init();
		ASSERT(ARRAYSIZE(touchRect)==ViewerTouchFlash::AREA_COUNT);
		for(int i = 0; i < ViewerTouchFlash::AREA_COUNT; i++){
			object->setRect((ViewerTouchFlash::AREA)i, touchRect[i]);
		}
		ASSERT(!touchFlash);
		touchFlash = object;
	}
	{
		ViewerPageNo* object = new ViewerPageNo;
		ASSERT(object);
		object->init();
		ASSERT(!pageNo);
		pageNo = object;
	}
	{
//		ms::Vector2f viewSize = ms::Vector2fMake();
//		ms::Vector2f viewSize = ms::Vector2fMake();
//		camera->setSize(info->viewSize, info->paperSize);
	}
	{
		ASSERT(!amazonUrlDelegate);
		amazonUrlDelegate = [[[ViewerAmazonURLDelegate alloc] init] retain];
	}
	{
		ASSERT(!alertDelegate);
		alertDelegate = [[[ViewerAlertDelegate alloc] init] retain];
	}
}
//--------------------------------
BOOL Viewer::update(ms::Uint32 elapsedTime){
	BOOL isDraw = drawFlag;
	if(state != STATE_DISABLE){
		if(camera->update(elapsedTime)){
			isDraw = TRUE;
		}
		if(paper->update(elapsedTime)){
			isDraw = TRUE;
		}
		if(vSlider->update(elapsedTime)){
			isDraw = TRUE;
		}
		if(top->update(elapsedTime)){
			isDraw = TRUE;
		}
		if(move->update(elapsedTime)){
			isDraw = TRUE;
		}
		if(touchFlash->update(elapsedTime)){
			isDraw = TRUE;
		}
		if(pageNo->update(elapsedTime)){
			isDraw = TRUE;
		}
	}
	switch(state){
		case STATE_DISABLE:
			break;
		case STATE_INIT:
		{
			ms::Rect showArea = ms::RectMake(Scene::getViewer()->getAreaLeft(),
											 Scene::getViewer()->getAreaTop(),
											 Scene::getViewer()->getAreaWidth(),
											 Scene::getViewer()->getAreaHeight());
			paper->setShowArea(showArea);
			paper->start();
			state = STATE_IDLE;
			//break;
		}
		case STATE_IDLE:
			break;
		case STATE_CHANGE_AREA_INIT:
			top->show(FALSE, 0);
			Scene::getFade()->start(FADEOUT_TIME, 0.0f, 1.0f, SceneFade::TEXTURE_NONE);
			state = STATE_CHANGE_AREA;
			//break;
		case STATE_CHANGE_AREA:
			if(Scene::getFade()->getEnd()){
				state = STATE_DISABLE;
				Scene::getConfig()->start(dirName);
			}
			break;
		case STATE_CHANGE_MOVE_INIT:
			top->show(FALSE, 0);
			Scene::getFade()->start(FADEOUT_TIME, 0.0f, MOVE_ALPHA, SceneFade::TEXTURE_NONE);
			state = STATE_CHANGE_MOVE;
			//break;
		case STATE_CHANGE_MOVE:
			if(Scene::getFade()->getEnd()){
				move->start(paperNotifyInfo.pageCount, paperNotifyInfo.pageIndex);
				paper->pause(TRUE);
				state = STATE_CHANGE_MOVE_WAIT;
			}
			break;
		case STATE_CHANGE_MOVE_WAIT:
			break;
		case STATE_CHANGE_MOVE_CANCEL_INIT:
			Scene::getFade()->start(FADEOUT_TIME, MOVE_ALPHA, 0.0f, SceneFade::TEXTURE_NONE);
			state = STATE_CHANGE_MOVE_CANCEL;
			//break;
		case STATE_CHANGE_MOVE_CANCEL:
			if(Scene::getFade()->getEnd()){
				paper->pause(FALSE);
				state = STATE_IDLE;
			}
			break;
/*		case STATE_CHANGE_MOVE_OK:
		{
			ms::Uint32 pageIndex = move->getPageIndex();
			setPageIndex(pageIndex);
			paper->start();
			state = STATE_IDLE_WAIT;
			break;
		}
*/
		case STATE_CHANGE_NOTE_INIT:
			[getMyAppDelegateInstance() changeSceneNote:dirName pageNo:getPageIndex()+1 pageCount:getPageCount()];
			state = STATE_CHANGE_NOTE;
			//break;
		case STATE_CHANGE_NOTE:
			break;
		case STATE_CHANGE_BOOKS_INIT:
			top->show(FALSE, 0);
			Scene::getFade()->start(FADEOUT_TIME, 0.0f, 1.0f, SceneFade::TEXTURE_NONE);
			[getMyAppDelegateInstance() changeSceneBooks];
			state = STATE_CHANGE_BOOKS;
			//break;
		case STATE_CHANGE_BOOKS:
			if(Scene::getFade()->getEnd()){
				state = STATE_DISABLE;
			}
			break;
		case STATE_CHANGE_TWITTER_INIT:
		{
			[amazonUrlDelegate clean];
			NSString* amazonURL = AppData::getBookAmazonTinyURL(dirName);
			if(amazonURL.length > 0){
				NSLog(@"%d", amazonURL.length);
				state = STATE_CHANGE_TWITTER_SEND;
			}else{
				NSString* amazonCode = AppData::getBookAmazonCode(dirName);
				if(amazonCode.length > 0){
					NSString* url8 = [NSString stringWithFormat:@"http://j.mp/?url=%@%@%@",
									  @"http://www.amazon.co.jp/gp/product/",
									  amazonCode,
									  @"%3fie=UTF8%26linkCode=as2%26tag=akira00-22"];
					NSLog(@"%@", url8);
					NSString *uelEncode = (NSString*)CFURLCreateStringByAddingPercentEscapes(
																							 kCFAllocatorDefault,
																							 (CFStringRef)url8,
																							 NULL,
																							 NULL,
																							 kCFStringEncodingUTF8
																							 ); 
					NSLog(@"%@", uelEncode);
					NSURL* url = [NSURL URLWithString:uelEncode];
					NSMutableURLRequest *theRequest=[NSMutableURLRequest
													 requestWithURL:url
													 cachePolicy:NSURLRequestUseProtocolCachePolicy
													 timeoutInterval:60.0];
					NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:theRequest delegate:amazonUrlDelegate];
					if (theConnection) {
						NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX starting connection");
					} else {
						NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX error connection");
					}
					state = STATE_CHANGE_TWITTER;
				}else{
					UIAlertView* alert = [[UIAlertView alloc]
										  initWithTitle:@"Amazon 情報の設定"
										  message:@"twitter に読書記録を書く場合は、Amazon 情報の設定が必要になります。今すぐ行いますか？"
										  delegate:alertDelegate
										  cancelButtonTitle:@"いいえ"
										  otherButtonTitles:@"はい", nil];
					alertDelegate.bookTitle = dirName;
					[alert show];
					state = STATE_IDLE;
				}
			}
			break;
		}
		case STATE_CHANGE_TWITTER:
		{
			switch([amazonUrlDelegate getState]){
				case AMAZON_URL_DELEGATE_STATE_ERROR:
				{
					UIAlertView* alert = [[UIAlertView alloc]
										  initWithTitle:@"通信エラー"
										  message:@"インターネットに\n接続できませんでした。"
										  delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:@"OK", nil];
					[alert show];
					NSLog(@"ERROR");
					state = STATE_IDLE;
					break;
				}
				case AMAZON_URL_DELEGATE_STATE_END:
				{
					NSString* tinyURL = amazonUrlDelegate.tinyURL;
					AppData::setBookAmazonTinyURL(dirName, tinyURL);
					state = STATE_CHANGE_TWITTER_SEND;
					break;
				}
			}
			break;
		}
		case STATE_CHANGE_TWITTER_SEND:
		{
			NSString* amazonURL = AppData::getBookAmazonTinyURL(dirName);
			int pageIndex = AppData::getBookPageIndex(dirName);
			int pageCount = AppData::getBookPageCount(dirName);
			NSString* url8 = [NSString stringWithFormat:@"%@ : 読書 %@[%d/%d] %@ by 吾輩の小説 http://j.mp/acLgvg #iPhone #wagasyo",
							  @"http://twitter.com/home?status=",
							  dirName,
							  pageIndex+1, pageCount,
							  amazonURL];
			NSString *uelEncode = (NSString*)CFURLCreateStringByAddingPercentEscapes(
																					 kCFAllocatorDefault,
																					 (CFStringRef)url8,
																					 NULL,
																					 NULL,
																					 kCFStringEncodingUTF8
																					 ); 
			NSURL* url = [NSURL URLWithString:uelEncode];
			[[UIApplication sharedApplication] openURL:url];
			state = STATE_IDLE;
			break;
		}
		case STATE_RETURN:
			state = STATE_INIT;
			break;
	}
	drawFlag = FALSE;
	return isDraw;
}
//--------------------------------
void Viewer::draw(){
	if(state != STATE_DISABLE){
		// 透視投影の描画
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		ms::Vector2n screenSize = ms::Vector2nMake(ms::GLScene::SCREEN_SIZE_W, ms::GLScene::SCREEN_SIZE_H);
		glFrustumf((-screenSize.x)/2.0f, (screenSize.x)/2.0f, (screenSize.y)/2.0f, (-screenSize.y)/2.0f, 1000.0f, 10000.0f);
		
		const ms::Matrixf* mat = Scene::getCamera()->getMatrix();
		glMultMatrixf((float*)mat);
		
		paper->draw();
	}
}
//--------------------------------
void Viewer::draw2D(){
	if(state != STATE_DISABLE){
		paper->draw2D();
		touchFlash->draw();
		top->draw();
		pageNo->draw();
	}
}
//--------------------------------
void Viewer::drawTop(){
	if(state != STATE_DISABLE){
		move->draw();
	}
}
//--------------------------------
void Viewer::onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther){
	if(state != STATE_DISABLE){
		if(sender == paper){
/*			if(massageCode == ViewerPaper::NOTIFY_INIT_END){
				state = STATE_FADEIN_INIT;
			}
*/
			if(massageCode == ViewerPaper::NOTIFY_CHANGE_PAGE){
				ViewerPaper::NOTIFY_INFO* info = (ViewerPaper::NOTIFY_INFO*)messageOther;
				pageNo->setPageNo(info->pageIndex+1, info->pageCount);
				pageNo->showPageNo();
				paperNotifyInfo = *info;
			} else if(massageCode == ViewerTop::NOTIFY_BOOKS) {
                state = STATE_CHANGE_BOOKS_INIT;
            }
		}
		if(sender == top){
			switch(massageCode){
				case ViewerTop::NOTIFY_AREA:
					state = STATE_CHANGE_AREA_INIT;
					break;
				case ViewerTop::NOTIFY_MOVE:
					state = STATE_CHANGE_MOVE_INIT;
					break;
				case ViewerTop::NOTIFY_NOTE:
					state = STATE_CHANGE_NOTE_INIT;
					break;
				case ViewerTop::NOTIFY_BOOKS:
					state = STATE_CHANGE_BOOKS_INIT;
					break;
				case ViewerTop::NOTIFY_TWITTER:
#ifdef CONVERT_DEBUG
				{
					static BOOL status = TRUE;
					paper->showDebug(status);
					status = (status)? FALSE: TRUE;
				}
#else
					state = STATE_CHANGE_TWITTER_INIT;
#endif
					break;
				case ViewerTop::NOTIFY_VIEWER_MODE_NORMAL:
					paper->changeViewerMode(VIEWER_MODE_NORMAL);
					break;
				case ViewerTop::NOTIFY_VIEWER_MODE_CONVERT:
					paper->changeViewerMode(VIEWER_MODE_CONVERT);
					break;
			}
		}
		if(sender == move){
			switch(massageCode){
				case ViewerMoveTop::NOTIFY_CANCEL:
					state = STATE_CHANGE_MOVE_CANCEL_INIT;
					break;
				case ViewerMoveTop::NOTIFY_OK:
				{
					ms::Uint32 pageIndex = move->getPageIndex();
					setPageIndex(pageIndex);
					paper->start();
					state = STATE_IDLE;
				}
			}
		}
	}
}
//--------------------------------
void Viewer::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
		camera->touchesBegan(touchPos, touchCount, touches, event);
		paper->touchesBegan(touchPos, touchCount, touches, event);
		vSlider->touchesBegan(touchPos, touchCount, touches, event);
		top->touchesBegan(touchPos, touchCount, touches, event);
		move->touchesBegan(touchPos, touchCount, touches, event);
		
		if(touchCount > 0){
			touchBeganPos = touchPos[0];
			touchBeganTime = ms::getTime();
		}
	}
}
//--------------------------------
void Viewer::touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
		camera->touchesMoved(touchPos, touchCount, touches, event);
		paper->touchesMoved(touchPos, touchCount, touches, event);
		vSlider->touchesMoved(touchPos, touchCount, touches, event);
		move->touchesMoved(touchPos, touchCount, touches, event);
	}
}
//--------------------------------
void Viewer::touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
		if(state == STATE_IDLE){
			ms::Uint32 time = ms::getTime();
			if((time - touchBeganTime) < TOP_TOUCH_TIME &&
			   ABS(touchBeganPos.x-touchPos[0].x) < 32.0f &&
			   ABS(touchBeganPos.y-touchPos[0].y) < 32.0f)
			{
				ms::Vector2f hitPos = ms::Vector2fMake(touchPos[0].x-Scene::SCREEN_SIZE_W*0.5f,
														touchPos[0].y-Scene::SCREEN_SIZE_H*0.5f);
				
				
				if(ms::RectHit(touchRect[ViewerTouchFlash::AREA_MOVE_PAGE], hitPos)){
					paper->touchMoveNext();
					if(top->getShow()){
						top->show(FALSE, 0);
					}
					touchFlash->start(ViewerTouchFlash::AREA_MOVE_PAGE);
				}else if(ms::RectHit(touchRect[ViewerTouchFlash::AREA_TOP], hitPos)){
					if(top->getShow()){
						top->show(FALSE, 0);
					}else{
						top->show(TRUE, TOP_SHOW_TIME);
					}
					pageNo->showPageNo();
					touchFlash->start(ViewerTouchFlash::AREA_TOP);
				}
			}
		}
		camera->touchesEnded(touchPos, touchCount, touches, event);
		paper->touchesEnded(touchPos, touchCount, touches, event);
		vSlider->touchesEnded(touchPos, touchCount, touches, event);
		move->touchesEnded(touchPos, touchCount, touches, event);
	}
}
//--------------------------------
void Viewer::touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	if(state != STATE_DISABLE){
		camera->touchesCancelled(touchPos, touchCount, touches, event);
		paper->touchesCancelled(touchPos, touchCount, touches, event);
		vSlider->touchesCancelled(touchPos, touchCount, touches, event);
		move->touchesCancelled(touchPos, touchCount, touches, event);
	}
}
//--------------------------------
void Viewer::setBookName(NSString* _dirName){
	if(dirName){
		[dirName release];
	}
	dirName = [[NSString stringWithString:_dirName] retain];
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0];
		NSString *dirPathString = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, _dirName];
		paper->setDirPath(dirPathString);
	}
}
//--------------------------------
void Viewer::start(){
	state = STATE_INIT;
}
//--------------------------------
void Viewer::returnOther(){
	state = STATE_IDLE;
	paper->pause(FALSE);
}
//--------------------------------
void Viewer::setDisable(){
	state = STATE_DISABLE;
}
//--------------------------------
ms::Uint32 Viewer::getPageIndex(){
	return AppData::getBookPageIndex(dirName);
}
//--------------------------------
void Viewer::setPageIndex(ms::Uint32 pageIndex){
	AppData::setBookPageIndex(dirName, pageIndex);
}
//--------------------------------
ms::Uint32 Viewer::getPageCount(){
	return AppData::getBookPageCount(dirName);
}
//--------------------------------
void Viewer::setViewerMode(VIEWER_MODE _mode){
	AppData::setBookViewerMode(dirName, _mode);
}
//--------------------------------
VIEWER_MODE Viewer::getViewerMode(){
	return 	AppData::getBookViewerMode(dirName);
}
//--------------------------------
void Viewer::setPosX(float posX){
	AppData::setBookPosX(dirName, posX);
}
//--------------------------------
float Viewer::getPosX(){
	return AppData::getBookPosX(dirName);
}
//--------------------------------
float Viewer::getAreaLeft(){
	return AppData::getBookAreaLeft(dirName);
}
//--------------------------------
float Viewer::getAreaTop(){
	return AppData::getBookAreaTop(dirName);
}
//--------------------------------
float Viewer::getAreaWidth(){
	return AppData::getBookAreaWidth(dirName);
}
//--------------------------------
float Viewer::getAreaHeight(){
	return AppData::getBookAreaHeight(dirName);
}
//--------------------------------
void Viewer::setArea(const ms::Rect& area){
	AppData::setBookAreaLeft(dirName, area.pos.x);
	AppData::setBookAreaTop(dirName, area.pos.y);
	AppData::setBookAreaWidth(dirName, area.size.x);
	AppData::setBookAreaHeight(dirName, area.size.y);
}

//--------------------------------
@implementation ViewerAmazonURLDelegate

@synthesize webBookData;
@synthesize tinyURL;

-(id)init{
	if(self = [super init]){
	}
	return self;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX will cache response");
	return cachedResponse;
}

- (void)connection:(NSURLConnection *)_connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did receive response: %@", response);
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did receive response: %d", response.expectedContentLength);
	int statusCode = [((NSHTTPURLResponse *)response) statusCode];
	if(statusCode == 200){
		self.webBookData = [NSMutableData data];
	}else{
		state = AMAZON_URL_DELEGATE_STATE_ERROR;
		[_connection cancel];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did receive data");
	[self.webBookData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did finish loading");
	if(self.webBookData.length > 0){
		BOOL error = FALSE;
		NSString* html = [[NSString alloc] initWithData:self.webBookData encoding:NSUTF8StringEncoding];
		NSLog(@"%@", html);
		NSRange rg = [html rangeOfString:@"id=\"short_url\">" options:NSCaseInsensitiveSearch];
		self.tinyURL = @"";
		if(rg.location != NSNotFound){
			NSRange subRg;
			subRg.length = html.length - (rg.location+rg.length+1);
			subRg.location = rg.location+rg.length;
			html = [html substringWithRange:subRg];
			rg = [html rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
			if(rg.location != NSNotFound){
				subRg.length = rg.location;
				subRg.location = 0;
				html = [html substringWithRange:subRg];
				self.tinyURL = html;
				state = AMAZON_URL_DELEGATE_STATE_END;
			}else{
				error = TRUE;
			}
		}else{
			error = TRUE;
		}
		if(error){
			state = AMAZON_URL_DELEGATE_STATE_ERROR;
		}
		self.webBookData = [NSMutableData data];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did fail with error %@", error);
	state = AMAZON_URL_DELEGATE_STATE_ERROR;
}

-(void)clean{
	state = AMAZON_URL_DELEGATE_STATE_IDLE;
}

-(AMAZON_URL_DELEGATE_STATE)getState{
	return state;
}

-(void)dealloc{
	[super dealloc];
}

@end

//--------------------------------
@implementation ViewerAlertDelegate

@synthesize bookTitle;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 1){
		[getMyAppDelegateInstance() changeSceneBooksEdit:self.bookTitle];
		Scene::getFade()->start(FADEOUT_TIME, 0.0f, 1.0f, SceneFade::TEXTURE_NONE);
	}
}

-(void)dealloc{
	[bookTitle release];
	[super dealloc];	
}

@end
