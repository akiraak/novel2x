#import "Texture.h"
#import "Scene.h"

#define PICTURE_TITLE_SIZE_W	(480)
#define PICTURE_TITLE_SIZE_H	(32)
#define PICTURE_TITLE_FONT_NAME	@"HiraKakuProN-W6"
#define PICTURE_TITLE_FONT_SIZE	(20)

//--------------------------------
Texture* Texture::instance = NULL;

const char* Texture::staticFileName[]={
	"show_area_touch_v.png",
	"show_area_touch_h.png",
	"v_slider_top.png",
	"v_slider_middle.png",
	"v_slider_back_top.png",
	"v_slider_back_middle.png",
	"page_no_font.png",
	"top_button_read.png",
	"viewer_top_button_books.png",
	"viewer_top_button_area.png",
	"viewer_top_button_move.png",
	"viewer_top_button_info.png",
	"viewer_top_button_twitter.png",
	"viewer_top_button_note.png",
	"viewer_top_convert_on.png",
	"viewer_top_convert_off.png",
	"viewer_top_back.png",
	"viewer_move_top_back.png",
	"viewer_move_bar_body.png",
	"viewer_move_bar_knob.png",
	"viewer_move_top_button_cancel.png",
	"viewer_move_top_button_ok.png",
};

Texture::STATIC_STRING_INFO Texture::staticStringTable[]={
	{
		ms::Vector2fMake(128.0f, 32.0f),
		UITextAlignmentCenter,
		@"Texture ConfigTitle",
		@"HiraKakuProN-W6",
		16,
	},
};

//--------------------------------
Texture::Texture():
state((STATE)0),
staticStringexture(NULL)
{
	ASSERT(!instance);
	instance = this;
	memset(staticTexture, 0, sizeof(staticTexture));
}
//--------------------------------
Texture::~Texture(){
	for(int i = 0; i < ARRAYSIZE(staticTexture); i++){
		MS_SAFE_DELETE(staticTexture[i]);
	}
	for(int i = 0; i < ARRAYSIZE(staticStringTable); i++){
		MS_SAFE_DELETE(staticStringexture[i]);
	}
	MS_SAFE_FREE(staticStringexture);
	ASSERT(instance);
	instance = NULL;
}
//--------------------------------
void Texture::init(){
	ms::Object::init();
	{
		ASSERT(ARRAYSIZE(staticFileName) == ARRAYSIZE(staticTexture));
		for(int i = 0; i < ARRAYSIZE(staticTexture); i++){
			ms::GLTexture* object = new ms::GLTexture;
			ASSERT(object);
			object->initWithFilePath(staticFileName[i]);
			ASSERT(!staticTexture[i]);
			staticTexture[i] = object;
		}
	}
	{
		ASSERT(!staticStringexture);
		ms::Sint32 mallocSize = sizeof(ms::GLTexture*)*ARRAYSIZE(staticStringTable);
		staticStringexture = (ms::GLTexture**)malloc(mallocSize);
		ASSERT(staticStringexture);
		memset(staticStringexture, 0, mallocSize);
		for(int i = 0; i < ARRAYSIZE(staticStringTable); i++){
			ms::GLTexture* object = new ms::GLTexture;
			STATIC_STRING_INFO* stringInfo = &staticStringTable[i];
			ASSERT(object);
			NSString* string = NSLocalizedString(stringInfo->localizeString, @"");
			object->initWithString(string, stringInfo->size, stringInfo->textAlignment, stringInfo->fontName, stringInfo->fontSize);

			ASSERT(!staticStringexture[i]);
			staticStringexture[i] = object;
		}
	}
}
//--------------------------------
BOOL Texture::update(ms::Uint32 elapsedTime){
	BOOL isDraw = FALSE;
	return isDraw;
}
//--------------------------------
ms::GLTexture* Texture::getStatic(STATIC _index){
	ASSERT(_index >= (STATIC)0 && _index < STATIC_COUNT);
	ASSERT(instance);
	return instance->staticTexture[_index];
}
//--------------------------------
ms::GLTexture* Texture::getStaticString(STATIC_STRING _index){
	ASSERT(_index >= (STATIC_STRING)0 && _index < STATIC_STRING_COUNT);
	ASSERT(instance);
	return instance->staticStringexture[_index];
}
