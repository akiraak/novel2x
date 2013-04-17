#import "MS.h"

class SceneFade {
public:
	SceneFade();
	virtual ~SceneFade();
	virtual void init();
	virtual BOOL update(ms::Uint32 elapsedTime);
	virtual void draw();

	enum TEXTURE {
		TEXTURE_NONE = 0,

		TEXTURE_COUNT,
	};
	void start(ms::Uint32 _fadeTime, float _alphaStart, float _alphaEnd, TEXTURE _texture);
	BOOL getEnd(){return (state == STATE_IDLE);}
	float getAlpha(){return alpha;}
private:
	enum STATE {
		STATE_IDLE,
		STATE_FADE_INIT,
		STATE_FADE,
	};
	STATE			state;
	TEXTURE			texture;
	ms::GLSprite*	sprite;
	ms::Uint32		timer;
	ms::Uint32		fadeTime;
	float			alphaStart;
	float			alphaEnd;
	float			alpha;
	BOOL			drawFlag;
};
