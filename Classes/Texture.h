#import "MS.h"
#import "AppType.h"

class Texture: public ms::Object{

public:
	Texture();
	virtual ~Texture();
	virtual void init();
	BOOL update(ms::Uint32 elapsedTime);
	enum STATIC {
		STATIC_show_area_touch_v = 0,
		STATIC_show_area_touch_h,
		STATIC_v_slider_top,
		STATIC_v_slider_middle,
		STATIC_v_slider_back_top,
		STATIC_v_slider_back_middle,
		STATIC_page_no_font,
		STATIC_top_button_read,
		STATIC_viewer_top_button_books,
		STATIC_viewer_top_button_area,
		STATIC_viewer_top_button_move,
		STATIC_viewer_top_button_info,
		STATIC_viewer_top_button_twitter,
		STATIC_viewer_top_button_note,
		STATIC_viewer_top_convert_on,
		STATIC_viewer_top_convert_off,
		STATIC_viewer_top_back,
		STATIC_viewer_move_top_back,
		STATIC_viewer_move_bar_body,
		STATIC_viewer_move_bar_knob,
		STATIC_viewer_move_top_button_cancel,
		STATIC_viewer_move_top_button_ok,
		
		STATIC_COUNT,
	};
	enum STATIC_STRING {
		STATIC_STRING_ConfigTitle = 0,
		
		STATIC_STRING_COUNT,
	};
	static ms::GLTexture* getStatic(STATIC _index);
	static ms::GLTexture* getStaticString(STATIC_STRING _index);
private:
	static Texture* instance;
	static const char* staticFileName[];
	enum STATE {
		STATE_HIDE = 0,
	};
	STATE			state;
	ms::GLTexture*	staticTexture[STATIC_COUNT];
	ms::GLTexture**	staticStringexture;

	struct STATIC_STRING_INFO {
		ms::Vector2f	size;
		UITextAlignment	textAlignment;
		NSString*		localizeString;
		NSString*		fontName;
		ms::Sint32		fontSize;
	};
	static STATIC_STRING_INFO staticStringTable[];
};



