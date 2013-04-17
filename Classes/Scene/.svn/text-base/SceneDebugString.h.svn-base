#import "MS.h"

class SceneDebugString {
public:
	SceneDebugString();
	virtual ~SceneDebugString();
	void init();
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	static void setString(const char* string);
	static ms::GLTexture* getTexture();
private:
	static SceneDebugString* instance;
	ms::GLTexture*		texture;
	ms::GLKeyedSprite*	sprite;
	ms::GLKeyedSprite*	fpsSprite;
	ms::GLSprite*		fpsBarSprite;
	BOOL				drawFlag;
};


