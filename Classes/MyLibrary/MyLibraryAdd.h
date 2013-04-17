#import <UIKit/UIKit.h>
#import "HetimaUnZip.h"

@interface MyLibraryAddWebViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIView* baseView;
	IBOutlet UIWebView* webView;
	IBOutlet UISegmentedControl* moveButton;
	IBOutlet UITextField* urlText;
	IBOutlet UIActivityIndicatorView* activityIndicatorView;
	NSString* openUrl8;
}

@property (nonatomic, retain) NSString* openUrl8;

-(void)initParam;
-(void)loadURL:(NSString*)url8;
-(IBAction)keyboardReturn:(id)sender;
-(IBAction)moveUpdate:(id)sender;

@end

@interface MyLibraryAddView : UIView {
	IBOutlet UILabel* bookLabel;
	IBOutlet UITextField* urlField;
	IBOutlet UILabel* infoLabel;
	IBOutlet UIProgressView* progView;
	//IBOutlet UIButton* openWebButton;
	UIButton* openWebButton;
	IBOutlet UIButton* getWebButton;
	IBOutlet UIButton* cancelButton;

	NSURLConnection*	connection;
	NSInteger			loadSize;
	NSInteger			loadedSize;
	NSMutableData*		webBookData;
	FILE*				bookFp;
	NSInteger			unzipSize;
	NSInteger			unzipedSize;
	NSInteger			unzipedCount;
	NSString*			unzipedDirName;
	NSString*			unzipedDirPath;
	HetimaUnZipContainer*	unzip;
	NSTimer*				unzipTimer;
}

@property (nonatomic, retain) UIButton* openWebButton;
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, retain) NSMutableData* webBookData;
@property (nonatomic, retain) NSString* unzipedDirName;
@property (nonatomic, retain) NSString* unzipedDirPath;
@property (nonatomic, retain) HetimaUnZipContainer* unzip;
@property (nonatomic, retain) NSTimer* unzipTimer;

-(void)initParam;
-(void)cleanup;
-(void)updateBookName;
-(void)setURL:(NSString*)url8;
-(IBAction)openWeb:(id)sender;
-(IBAction)webGet:(id)sender;
-(IBAction)canecl:(id)sender;
-(IBAction)keyboardReturn:(id)sender;
-(IBAction)urlEditingChanged:(id)sender;

@end

@interface MyLibraryAddViewController : UIViewController{
	IBOutlet MyLibraryAddView* addView;
}

-(void)initParam;
-(void)cleanup;
-(void)setURL:(NSString*)url8;

@end

@interface MyLibraryAddErrorViewController : UIViewController{
}

-(IBAction)pay;

@end
