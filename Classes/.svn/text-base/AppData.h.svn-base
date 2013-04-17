#import <Foundation/Foundation.h>
#import "MS.h"
#import "AppType.h"

#define DOWNLOAD_URL_DEFAULT	@"http://mybooks.moonshine-project.com/%e4%ba%ba%e9%96%93%e5%a4%b1%e6%a0%bc-%e5%a4%aa%e5%ae%b0%e6%b2%bb.zip"
#define ADD_WEB_URL_DEFAULT		@"http://"

enum VIEWER_MODE {
	VIEWER_MODE_NORMAL = 0,
	VIEWER_MODE_CONVERT,
	
	VIEWER_MODE_COUNT,
};

#define kUserDefaultsExecCount			@"kUserDefaultsExecCount"
#define kUserDefaultsLastScene			@"kUserDefaultsLastScene"
#define kUserDefaultsLastBook			@"kUserDefaultsLastBook"
#define kUserDefaultsDownloadURL		@"kUserDefaultsDownloadURL"
#define kUserDefaultsAddWebURL			@"kUserDefaultsAddWebURL"
#define kUserDefaultsBookAreaLeftHead	@"BookAreaLeft"
#define kUserDefaultsBookAreaTopHead	@"BookAreaTop"
#define kUserDefaultsBookAreaWidthHead	@"BookAreaWidth"
#define kUserDefaultsBookAreaHeightHead	@"BookAreaHeight"
#define kUserDefaultsBookPageCountHead	@"BookPageCount"
#define kUserDefaultsBookPageIndexHead	@"BookPageIndex"
#define kUserDefaultsBookViewerModeHead	@"BookViewerMode"
#define kUserDefaultsBookPosXHead		@"BookPosX"
#define kUserDefaultsBookAmazonCode		@"BookAmazonCode"
#define kUserDefaultsBookAmazonTinyURL	@"BookAmazonTinyURL"
#define kUserDefaultsBookNotePageNo		@"BookNotePageNo"
#define kUserDefaultsBookNoteIcon		@"BookNoteIcon"
#define kUserDefaultsBookNoteText		@"BookNoteText"

class AppData {
public:
	AppData();
	virtual ~AppData();
	void init();
	void removeData();
	
	static void setExecCountValue(int value);
	static int getExecCountValue(){ASSERT(instance);return instance->execCount;}
	
	enum SCENE {
		SCENE_BOOKS_LIST = 0,
		SCENE_BOOK,
	};
	static void setLastScene(SCENE scene);
	static int getLastScene();
	
	static void setLastBook(NSString* bookName);
	static NSString* getLastBook();
	
	static void setDownloadURL(NSString* url);
	static NSString* getDownloadURL();
	
	static void setAddWebURL(NSString* url);
	static NSString* getAddWebURL();
	
	//------------------------------------
	static void setupBook(NSString* bookTitle);

	static void setBookAreaLeft(NSString* bookTitle, float value);
	static float getBookAreaLeft(NSString* bookTitle);
	
	static void setBookAreaTop(NSString* bookTitle, float value);
	static float getBookAreaTop(NSString* bookTitle);
	
	static void setBookAreaWidth(NSString* bookTitle, float value);
	static float getBookAreaWidth(NSString* bookTitle);
	
	static void setBookAreaHeight(NSString* bookTitle, float value);
	static float getBookAreaHeight(NSString* bookTitle);
	
	static void setBookPageCount(NSString* bookTitle, int value);
	static int getBookPageCount(NSString* bookTitle);
	
	static void setBookPageIndex(NSString* bookTitle, int value);
	static int getBookPageIndex(NSString* bookTitle);
	
	static void setBookViewerMode(NSString* bookTitle, VIEWER_MODE _mode);
	static VIEWER_MODE getBookViewerMode(NSString* bookTitle);
	
	static void setBookPosX(NSString* bookTitle, float value);
	static float getBookPosX(NSString* bookTitle);
	
	static void setBookAmazonCode(NSString* bookTitle, NSString* value);
	static NSString* getBookAmazonCode(NSString* bookTitle);
	
	static void setBookAmazonTinyURL(NSString* bookTitle, NSString* value);
	static NSString* getBookAmazonTinyURL(NSString* bookTitle);

	static void setBookNote(NSString* bookTitle, NSArray* pageNo, NSArray* icon, NSArray* text);
	static NSArray* getBookNotePageNo(NSString* bookTitle);
	static NSArray* getBookNoteIcon(NSString* bookTitle);
	static NSArray* getBookNoteText(NSString* bookTitle);
	
private:
	static AppData* instance;
	NSUserDefaults* defaults;
	NSInteger		execCount;
};
