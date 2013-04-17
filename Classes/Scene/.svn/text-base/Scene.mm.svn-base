#import "Scene.h"
#import "MyAppDelegate.h"
#import "Scene.h"
#import "AppType.h"

//--------------------------------
Scene* Scene::instance = NULL;

//--------------------------------
Scene::Scene():
state((STATE)0),
camera(NULL),
debugString(NULL),
fade(NULL),
texture(NULL),
viewer(NULL),
config(NULL)
{
	ASSERT(!instance);
	instance = this;
	cameraNotifyNode.init(this);
}
//--------------------------------
Scene::~Scene(){
	camera->removeChildNotifyMessage(cameraNotifyNode);
	MS_SAFE_DELETE(camera);
	MS_SAFE_DELETE(debugString);
	MS_SAFE_DELETE(fade);
	MS_SAFE_DELETE(texture);
	MS_SAFE_DELETE(viewer);
	MS_SAFE_DELETE(config);
	ASSERT(instance);
	instance = NULL;
}
//--------------------------------
void Scene::init(){
	if([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0) {
		setContentScale(2.0f);
	}

	ms::Vector2n screenSize = getScreenSize();
	CGRect frame = CGRectMake(0.0f, 0.0f, screenSize.x, screenSize.y);
	ms::GLScene::init(frame);

	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_TEXTURE_2D);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);		
	glAlphaFunc(GL_GREATER, 0.0);
	
	{
		Texture* object = new Texture;
		ASSERT(object);
		object->init();		
		ASSERT(!texture);
		texture = object;
	}
	{
		ms::GLCamera* object = new ms::GLCamera;
		ASSERT(object);
		object->init();
		object->setScene(Scene::getInstance());
		object->addChildNotifyMessage(cameraNotifyNode);
		ASSERT(!camera);
		camera = object;
	}
	{
		SceneDebugString* object = new SceneDebugString;
		ASSERT(object);
		object->init();		
		ASSERT(!debugString);
		debugString = object;
	}
	{
		SceneFade* object = new SceneFade;
		ASSERT(object);
		object->init();		
		object->start(0, 1.0f, 1.0f, SceneFade::TEXTURE_NONE);
		ASSERT(!fade);
		fade = object;
	}
	{
		Viewer* object = new Viewer;
		ASSERT(object);
		object->init();		
		ASSERT(!viewer);
		viewer = object;
		
//		viewer->start();
	}
	{
		Config* object = new Config;
		ASSERT(object);
		object->init();		
		ASSERT(!config);
		config = object;
		
//		config->start();
	}
}
//--------------------------------
void Scene::onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther){
	if(sender == camera){
		if(massageCode == ms::GLCamera::NOTIFY_CHANGE_UP_DIR){
			ms::GLCamera::NOTIFY_CHANGE_UP_DIR_INFO* info = (ms::GLCamera::NOTIFY_CHANGE_UP_DIR_INFO*)messageOther;
			switch(info->upDir){
				case ms::GLCamera::UP_DIR_UP:
				case ms::GLCamera::UP_DIR_DOWN:
					setScreenType(SCREEN_TYPE_VERTICALITY);
					break;
				case ms::GLCamera::UP_DIR_LEFT:
				case ms::GLCamera::UP_DIR_RIGHT:
					setScreenType(SCREEN_TYPE_HORIZONTALLY);
					break;
			}
		}
	}
}
//--------------------------------
BOOL Scene::update(ms::Uint32 elapsedTime){
//	BOOL isDraw = ms::GLScene::update(elapsedTime);
	BOOL isDraw = FALSE;
	if(debugString->update(elapsedTime)){
		isDraw = TRUE;
	}
	if(fade->update(elapsedTime)){
		isDraw = TRUE;
	}
	if(texture->update(elapsedTime)){
		isDraw = TRUE;
	}
	if(viewer->update(elapsedTime)){
		isDraw = TRUE;
	}
	if(config->update(elapsedTime)){
		isDraw = TRUE;
	}
	return isDraw;
}
//--------------------------------
void Scene::draw(){
	ms::Vector2n screenSize = Scene::getInstance()->getScreenSize();
	EAGLContext* context = getContext();
    [EAGLContext setCurrentContext:context];
    
	GLuint viewFramebuffer = getViewFramebuffer();
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	float contentScale = getContentScale();
    glViewport(0, 0, ms::GLScene::SCREEN_SIZE_W*contentScale, ms::GLScene::SCREEN_SIZE_H*contentScale);
	
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	
	viewer->draw();
	config->draw();
	
	{
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrthof((-ms::GLScene::SCREEN_SIZE_W)/2.0f, (ms::GLScene::SCREEN_SIZE_W)/2.0f, (ms::GLScene::SCREEN_SIZE_H)/2.0f, (-ms::GLScene::SCREEN_SIZE_H)/2.0f, -10000.0f, 10000.0f);
		
		ms::Matrixf mat = *Scene::getCamera()->getMatrix();
		mat.m[3][0] = 0.0f;
		mat.m[3][1] = 0.0f;
		mat.m[3][2] = 0.0f;
		glMultMatrixf((float*)&mat);

		viewer->draw2D();
		config->draw2D();
	}
	{
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrthof(0.0f, ms::GLScene::SCREEN_SIZE_W, ms::GLScene::SCREEN_SIZE_H, 0.0f, -1.0f, 1.0f);
		
		fade->draw();
		debugString->draw();
		viewer->drawTop();
	}
	
	GLuint viewRenderbuffer = getViewRenderbuffer();
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}
//--------------------------------
void Scene::touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	UIView* view = Scene::getInstance()->getView();
	NSArray* allTouches = [touches allObjects];
	ms::Uint32 _touchCount = [allTouches count];
	ms::Vector2f _touchPos[ms::GLScene::TOUCH_MAX];
	ms::Vector2n screenSize = getScreenSize();
	bzero(_touchPos, sizeof(_touchPos));
	for(int i = 0; i < _touchCount; i++){
		UITouch *touch = [allTouches objectAtIndex:i];
		CGPoint _pos = [touch locationInView:view];
		_touchPos[i] = ms::Vector2fMake(_pos.x, _pos.y);
	}	
	BOOL exec = FALSE;
	if(!exec){
		viewer->touchesBegan(_touchPos, _touchCount, touches, event);
		config->touchesBegan(_touchPos, _touchCount, touches, event);
	}
}
//--------------------------------
void Scene::touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	UIView* view = Scene::getInstance()->getView();
	NSArray* allTouches = [touches allObjects];
	ms::Uint32 _touchCount = [allTouches count];
	ms::Vector2f _touchPos[ms::GLScene::TOUCH_MAX];
	ms::Vector2n screenSize = getScreenSize();
	bzero(_touchPos, sizeof(_touchPos));
	for(int i = 0; i < _touchCount; i++){
		UITouch *touch = [allTouches objectAtIndex:i];
		CGPoint _pos = [touch locationInView:view];
		_touchPos[i] = ms::Vector2fMake(_pos.x, _pos.y);
	}	
	viewer->touchesMoved(_touchPos, _touchCount, touches, event);
	config->touchesMoved(_touchPos, _touchCount, touches, event);
}
//--------------------------------
void Scene::touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	UIView* view = Scene::getInstance()->getView();
	NSArray* allTouches = [touches allObjects];
	ms::Uint32 _touchCount = [allTouches count];
	ms::Vector2f _touchPos[ms::GLScene::TOUCH_MAX];
	ms::Vector2n screenSize = getScreenSize();
	bzero(_touchPos, sizeof(_touchPos));
	for(int i = 0; i < _touchCount; i++){
		UITouch *touch = [allTouches objectAtIndex:i];
		CGPoint _pos = [touch locationInView:view];
		_touchPos[i] = ms::Vector2fMake(_pos.x, _pos.y);
	}	
	viewer->touchesEnded(_touchPos, _touchCount, touches, event);
	config->touchesEnded(_touchPos, _touchCount, touches, event);
}
//--------------------------------
void Scene::touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event){
	UIView* view = Scene::getInstance()->getView();
	NSArray* allTouches = [touches allObjects];
	ms::Uint32 _touchCount = [allTouches count];
	ms::Vector2f _touchPos[ms::GLScene::TOUCH_MAX];
	ms::Vector2n screenSize = getScreenSize();
	bzero(_touchPos, sizeof(_touchPos));
	for(int i = 0; i < _touchCount; i++){
		UITouch *touch = [allTouches objectAtIndex:i];
		CGPoint _pos = [touch locationInView:view];
		_touchPos[i] = ms::Vector2fMake(_pos.x, _pos.y);
	}	
	viewer->touchesCancelled(_touchPos, _touchCount, touches, event);
	config->touchesCancelled(_touchPos, _touchCount, touches, event);
}
