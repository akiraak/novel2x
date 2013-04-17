#import "MS.h"
#import "SceneDebugString.h"
#import "SceneFade.h"
#import "Texture.h"
#import "Viewer.h"
#import "Config.h"

class Scene : public ms::GLScene {
public:
	Scene();
	virtual ~Scene();
	virtual void init();
	virtual void onChildNotifyMessage(ms::Object* sender, ms::Uint32 massageCode, void* messageOther);
	virtual BOOL update(ms::Uint32 elapsedTime);
	virtual void draw();
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesMoved(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesEnded(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	virtual void touchesCancelled(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	static Scene* getInstance(){ASSERT(instance); return instance;}
	static SceneFade* getFade(){ASSERT(instance);ASSERT(instance->fade); return instance->fade;}
	static ms::GLCamera* getCamera(){ASSERT(instance);ASSERT(instance->camera); return instance->camera;}
	static Viewer* getViewer(){ASSERT(instance);ASSERT(instance->viewer);return instance->viewer;}
	static Config* getConfig(){ASSERT(instance);ASSERT(instance->config);return instance->config;}
private:
	static Scene* instance;
	enum STATE {
		STATE_INIT = 0,
		STATE_AUTO_INIT,
		STATE_AUTO,
		STATE_AUTO_RAND_INIT,
		STATE_AUTO_RAND,
		STATE_MANUAL_INIT,
		STATE_MANUAL,
	};
	STATE				state;
	ms::GLCamera*		camera;
	SceneDebugString*	debugString;
	SceneFade*			fade;
	Texture*			texture;
	NotifyNode			cameraNotifyNode;
	Viewer*				viewer;
	Config*				config;
};


