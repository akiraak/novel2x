#import "MS.h"

//--------------------------------
#define OUTLINE_SPACE_TOP		(8.0f)
#define OUTLINE_SPACE_BOTTOM	(8.0f)
#define OUTLINE_SPACE_LEFT		(4.0f)
#define OUTLINE_SPACE_RIGHT		(4.0f)
#define SPACE_H					(16.0f)

class CalcLine: public ms::Object{

public:
	CalcLine();
	virtual ~CalcLine();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	virtual void touchesBegan(const ms::Vector2f* touchPos, ms::Uint32 touchCount, NSSet* touches, UIEvent* event);
	void draw();
	void start();
private:
	enum STATE {
		STATE_DISABLE = 0,
		STATE_INIT,
		STATE_IDLE,
	};
	STATE				state;
	enum{
		OUTLINE_TOP = 0,
		OUTLINE_BOTTOM,
		OUTLINE_LEFT,
		OUTLINE_RIGHT,
		
		OUTLINE_COUNT,
	};
	enum{
		LINE_COUNT = 100,
		WORD_COUNT = 300,
		DEBUG_WORD_SPRITE_COUNT = LINE_COUNT*WORD_COUNT*2,
	};
	ms::GLTexture*	texture;
	ms::GLSprite*	backPaperSprite;	
	ms::GLSprite*	backSprite;	
	ms::GLSprite*	outLineSprite[OUTLINE_COUNT];	
	ms::GLSprite*	lineDebugSprite[LINE_MAX];
	ms::GLSprite*	wordDebugSprite[DEBUG_WORD_SPRITE_COUNT];
	
	struct LINE {
		ms::Rect rect;
		BOOL	widthBig;
		ms::UV	uvUp;
		ms::UV	uvBottom;
	};
	struct LINES {
		ms::Rect	rect;
		ms::Uint32	lineCount;
		LINE		line[LINE_COUNT];
		float		lineWidthAvg;
		ms::Sint32	judgeColor;
	};
	LINES lines;
//	LINE_INFO lineInfos[LINE_COUNT];
	ms::Uint32 lineCount;
	ms::GLSprite* lineSprite[LINE_COUNT];
	int imageIndex;
	
	ms::Uint32 calcThinOutInterval(float* srcValue, ms::Uint32 srcValueCount, BOOL* dstUseValueBuffer, float thinOutRate);
	void calcThinOutValue(float* srcValue, ms::Uint32 srcValueCount, BOOL* dstUseValueBuffer, float thinOutRate, BOOL thinUnder);
	void* initWithUIImage(UIImage* uiImage, CGContextRef* dstContext, ms::Vector2n* dstImageSize, ms::Vector2n* dstTextureSize);
	static ms::Sint32 getTop(unsigned char* _data, const ms::Vector2n& _imageSize, const ms::Vector2n& _textureSize, const ms::Rect& _showArea, int _judgeColor);
	static ms::Sint32 getBottom(unsigned char* _data, const ms::Vector2n& _imageSize, const ms::Vector2n& _textureSize, const ms::Rect& _showArea, int _judgeColor);
};
