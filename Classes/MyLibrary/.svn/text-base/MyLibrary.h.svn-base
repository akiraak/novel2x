#import <UIKit/UIKit.h>
#import "HetimaUnZip.h"
#import "MyLibraryAdd.h"
#import "MyLibraryEdit.h"
#import "MyLibraryBanner.h"
#import "MyLibraryUnzip.h"

enum MYLIBRARY_TABLEITEM_TYPE{
	MYLIBRARY_TABLEITEM_TYPE_BOOK = 0,
	MYLIBRARY_TABLEITEM_TYPE_ZIP,
	MYLIBRARY_TABLEITEM_TYPE_MANUAL,
};

@interface MyLibraryTableItem : NSObject {
	NSString* title;
	NSString* path;
	MYLIBRARY_TABLEITEM_TYPE type;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* path;
//@property (nonatomic, retain) MYLIBRARY_TABLEITEM_TYPE type;

-(id)initWithTitle:(NSString*)_title path:(NSString*)_path type:(MYLIBRARY_TABLEITEM_TYPE)_type;

-(MYLIBRARY_TABLEITEM_TYPE)getType;

@end

@interface MyLibraryTable : UITableViewController <UIAlertViewDelegate, HetimaUnZipItemDelegate>{
	NSMutableArray*	tableItems;
	NSTimer* searchZipTimer;
}

@property (nonatomic, retain) NSMutableArray* tableItems;
@property (nonatomic, retain) NSTimer* searchZipTimer;

-(void)removeItemWithTitle:(NSString*)title;
-(void)updateList;

@end

@interface MyLibrary : NSObject{
	UIView* baseView;
	UINavigationController*	navigationController;
	MyLibraryBanner* bannerView;
	MyLibraryAddViewController* addView;
	MyLibraryAddWebViewController* addWebView;
	MyLibraryAddErrorViewController* addErrorView;
	MyLibraryEditViewController* editView;
	MyLibraryEditWebViewController* editWebView;
	MyLibraryUnzipViewController* unzipView;
}

@property (nonatomic, retain) UIView* baseView;
@property (nonatomic, retain) MyLibraryBanner* bannerView;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) MyLibraryAddViewController* addView;
@property (nonatomic, retain) MyLibraryAddWebViewController* addWebView;
@property (nonatomic, retain) MyLibraryAddErrorViewController* addErrorView;
@property (nonatomic, retain) MyLibraryEditViewController* editView;
@property (nonatomic, retain) MyLibraryEditWebViewController* editWebView;
@property (nonatomic, retain) MyLibraryUnzipViewController* unzipView;

-(void)showPaidUpdate;
-(UIView*)view;
-(void)pushAddView;
-(void)pushAddWebView;
-(void)pushAddErrorView;
-(void)pushEditView:(NSString*)bookTitle;
-(void)pushEditWebView:(NSString*)bookTitle;
-(void)pushUnzipView:(NSString*)filePath;
-(void)pop;

@end

MyLibrary* getMyLibrary();
MyLibraryTable* getMyLibraryTable();