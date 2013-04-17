#import "MS.h"
#import "AppData.h"

class ViewerPaperOne: public ms::GLRender {
public:
	ViewerPaperOne();
	virtual ~ViewerPaperOne();
	virtual void init();
	virtual void setVisible(BOOL _visible);
	virtual void setPos(const ms::Vector3f& _pos);
	BOOL update(ms::Uint32 elapsedTime);
	void draw();
	void disable();
	BOOL getDisable(){return state == STATE_DISABLE;}
	void startLoad();
	BOOL isLoaded();
	BOOL create(char* dstReplaceFilePath);
	void setFilePath(NSString* _filePath);
	void setShowArea(const ms::Rect& _showArea);
	ms::Vector2f getSize();
	void setMode(VIEWER_MODE _mode);
	enum{
		LINE_COUNT = 60,
		WORD_COUNT = 100,
	};
	void reConvert();
	void showDebug(BOOL status);
private:
	enum STATE {
		STATE_DISABLE,
		STATE_INIT,
		STATE_LOAD_WAIT,
		STATE_LOADED,
		STATE_IDLE,
	};
	STATE			state;
	VIEWER_MODE		mode;
	ms::GLTexture*	texture;
	ms::GLSprite*	normalSprite;
	ms::Rect		showArea;
	float			normalSpriteScale;
	NSString*		filePath;
	BOOL			calcedLine;
	BOOL			debug;
	
	struct LINE {
		ms::Rect rect;
		float	posRightX;
		BOOL	widthBig;
		ms::UV	uvUp;
		ms::UV	uvBottom;
		int		wordCount;
		float	wordPosY[WORD_COUNT];
		float	wordSizeH[WORD_COUNT];
		int		middleWordIndex;
	};
	struct LINES {
		ms::Rect	rect;
		ms::Uint32	lineCount;
		LINE		line[LINE_COUNT];
		float		lineWidthAvg;
		ms::Sint32	judgeColor;
	};
	LINES lines;
	ms::GLSprite*	lineBackSprite;
	int				lineSpriteCount;
	ms::GLSprite*	lineSprite[LINE_COUNT];

	void calcLines(char* data);
	ms::Uint32 calcThinOutInterval(float* srcValue, ms::Uint32 srcValueCount, BOOL* dstUseValueBuffer, float thinOutRate);
	void calcThinOutValue(float* srcValue, ms::Uint32 srcValueCount, BOOL* dstUseValueBuffer, float thinOutRate, BOOL thinUnder);
	static ms::Sint32 getTop(unsigned char* _data, const ms::Vector2n& _imageSize, const ms::Vector2n& _textureSize, const ms::Rect& _showArea, int _judgeColor, ms::Color4f* dstAvgColor);
	static ms::Sint32 getBottom(unsigned char* _data, const ms::Vector2n& _imageSize, const ms::Vector2n& _textureSize, const ms::Rect& _showArea, int _judgeColor, ms::Color4f* dstAvgColor);
	void setupSprite();
	float getNormalSpriteScale();
	
	enum{
		OUTLINE_TOP = 0,
		OUTLINE_BOTTOM,
		
		OUTLINE_COUNT,
	};
	enum{
		WORD_SPRITE_COUNT = ViewerPaperOne::LINE_COUNT*ViewerPaperOne::WORD_COUNT,
	};
//#ifdef CONVERT_DEBUG
#if 1
	int *debugLineHitCount;
	ms::GLSprite*	debugOutSprite[OUTLINE_COUNT];
	ms::GLSprite*	debugLineLeftSprite[LINE_COUNT];
	ms::GLSprite*	debugLineRightSprite[LINE_COUNT];
	ms::GLSprite*	debugWordSprite[WORD_SPRITE_COUNT];
	ms::GLSprite*	debugRL[LINE_COUNT];
	ms::GLSprite**	debugLineHitCountSprite;
#endif
};