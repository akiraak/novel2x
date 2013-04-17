#import "MS.h"
#import "ViewerPaperOne.h"

class ViewerPaperConvert: public ms::Object {
public:
	ViewerPaperConvert();
	virtual ~ViewerPaperConvert();
	virtual void init();
	void set();
private:
	enum STATE {
		STATE_DISABLE,
		STATE_INIT,
		STATE_IDLE,
	};
	STATE state;
	enum{
		OUTLINE_TOP = 0,
		OUTLINE_BOTTOM,
		OUTLINE_LEFT,
		OUTLINE_RIGHT,
		
		OUTLINE_COUNT,
	};
	enum{
		WORD_SPRITE_COUNT = ViewerPaperOne::LINE_COUNT*ViewerPaperOne::WORD_COUNT,
	};
	ms::GLSprite*	outSprite[OUTLINE_COUNT];	
	ms::GLSprite*	lineSprite[LINE_MAX];
	ms::GLSprite*	wordSprite[WORD_SPRITE_COUNT];
};
