#import <UIKit/UIKit.h>
#import "AppData.h"
#import "Scene.h"
#import "MyLibrary.h"
#import "info.h"
#import "Note.h"
#import "FreeAd.h"

#ifdef DEBUG
#define CONVERT_DEBUG
#endif
//#define SHOW_MEMORY_WARNING

@interface MyView : UIView{
}
@end

@interface MyViewController : UIViewController{
}
@end

@interface MyAppDelegate : NSObject <UIApplicationDelegate, HetimaUnZipItemDelegate> {
    UIWindow*			window;
	AppData*			appData;
	Scene*				scene;
	MyLibrary*			myLibrary;
	Info*				info;
	Note*				note;
	FreeAd*				freeAd;
	NSString*			editBookTitle;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NSString* editBookTitle;

-(void)start;
-(void)changeSceneConfig:(NSString*)dirName;
-(void)changeScenePaperView:(NSString*)dirName;
-(void)changeScenePaperViewFromNote:(ms::Sint32)movePageIndex;
-(void)changeSceneBooks;
-(void)changeSceneBooksEdit:(NSString*)editBookTitile;
-(void)changeSceneInfoFromBooks;
-(void)changeSceneNote:(NSString*)dirName pageNo:(int)pageNo pageCount:(int)pageCount;
-(void)returnInfo;

-(Scene*)getScene;
-(MyLibrary*)getMyLibrary;
-(Info*)getInfo;
-(Note*)getNote;
-(FreeAd*)getFreeAd;

@end

MyAppDelegate* getMyAppDelegateInstance();
