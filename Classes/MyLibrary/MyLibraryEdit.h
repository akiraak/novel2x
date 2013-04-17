#import <UIKit/UIKit.h>

@interface MyLibraryEditWebViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIView* baseView;
	IBOutlet UIWebView* webView;
	IBOutlet UISegmentedControl* moveButton;
	IBOutlet UITextField* urlText;
	IBOutlet UIActivityIndicatorView* activityIndicatorView;
	NSString* bookTitle;
	NSString* amazonCode;
}

@property (nonatomic, retain) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, retain) NSString* bookTitle;
@property (nonatomic, retain) NSString* amazonCode;

-(void)initParam;
-(void)loadURL:(NSString*)_bookTitle;
-(IBAction)keyboardReturn:(id)sender;
-(IBAction)moveUpdate:(id)sender;

@end

@interface MyLibraryEditView : UIScrollView {
	IBOutlet UILabel*		bookTitleLabel;
	IBOutlet UITextField*	amazonLinkText;
}

//@property (nonatomic, retain) NSURLConnection* connection;

-(void)initParam;
-(void)cleanup:(NSString*)bookTitle;
-(void)setAmazonCode:(NSString*)amazonCode;
-(IBAction)amazonCodeEditing:(id)sender;
-(IBAction)searchAmazon:(id)sender;
-(IBAction)checkAmazonLink:(id)sender;
-(IBAction)keyboardReturn:(id)sender;

@end

@interface MyLibraryEditViewController : UIViewController{
	IBOutlet MyLibraryEditView* addView;
}

-(void)initParam;
-(void)cleanup:(NSString*)bookTitle;
-(void)setAmazonCode:(NSString*)amazonCode;

@end
