#import "MyLibraryEdit.h"
#import "MyLibrary.h"
#import "AppData.h"

@implementation MyLibraryEditWebViewController

@synthesize activityIndicatorView;
@synthesize bookTitle;
@synthesize amazonCode;

-(void)initParam{
	webView.delegate = self;
	{
		CGRect frame = moveButton.frame;
		frame.size.height = 32;
		[moveButton setFrame:frame];
	}
}

-(void)loadURL:(NSString*)_bookTitle{
	self.bookTitle = _bookTitle;
	NSString* url8 = [NSString stringWithFormat:@"%@%@%@",
					  @"http://www.amazon.co.jp/gp/aw/rd.html?ie=UTF8&m=stripbooks&uid=NULLGWDOCOMO&__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&lc=mqr&at=akira00-22&k=",
					  _bookTitle,
					  @"&url=/gp/aw/s.html"];
					  
	
	NSLog(@"%@", url8);
	NSString *uelEncode = (NSString*)CFURLCreateStringByAddingPercentEscapes(
																			 kCFAllocatorDefault,
																			 (CFStringRef)url8,
																			 NULL,
																			 NULL,
																			 kCFStringEncodingUTF8
																			 ); 
	NSLog(@"%@", uelEncode);
	NSURL* url = [NSURL URLWithString:uelEncode];
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	
	[activityIndicatorView startAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	urlText.text = [[request URL] absoluteString];
	
	{
		BOOL exist = FALSE;
		NSString* query = [[request URL] query];
		NSArray* params = [query componentsSeparatedByString:@"&"];
		NSString* targetParamName = @"a=";
		NSString* param;
		for(param in params){
			NSRange rg;
			rg.location = 0;
			rg.length = targetParamName.length;
			NSString* paramName = [param substringWithRange:rg];
			if([paramName isEqualToString:targetParamName]){
				self.amazonCode = [param substringFromIndex:rg.length];
				NSLog(@"%@", self.amazonCode);
				exist = TRUE;
			}
		}
		if(exist){
			UIBarButtonItem* addButton = [[[UIBarButtonItem alloc]
										   initWithTitle:@"この書籍に決定"
										   style:UIBarButtonItemStyleDone
										   target:self
										   action:@selector(amazonSelected)
										   ] autorelease];
			self.navigationItem.rightBarButtonItem = addButton;
		}else{
			self.navigationItem.rightBarButtonItem = nil;
		}
	}
	
	
	return TRUE;
}

-(void)amazonSelected{
	[getMyLibrary().editView setAmazonCode:self.amazonCode];
	[getMyLibrary() pop];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	UIAlertView* alert = [[UIAlertView alloc]
						  initWithTitle:@"通信エラー"
						  message:@"インターネットに\n接続できませんでした。"
						  delegate:nil
						  cancelButtonTitle:nil
						  otherButtonTitles:@"OK", nil];
	[alert show];

	[activityIndicatorView stopAnimating];
}

-(IBAction)keyboardReturn:(id)sender{
	[urlText resignFirstResponder];
}

-(IBAction)moveUpdate:(id)sender{
	if(moveButton.selectedSegmentIndex == 0){
		if([webView canGoBack]){
			[webView goBack];
		}
	}else{
		if([webView canGoForward]){
			[webView goForward];
		}
	}
	moveButton.selectedSegmentIndex = -1;
}

@end

@implementation MyLibraryEditView

//@synthesize connection;

-(void)initParam{
	[self cleanup:@""];
}

-(void)cleanup:(NSString*)bookTitle{
	bookTitleLabel.text = bookTitle;
	amazonLinkText.text = AppData::getBookAmazonCode(bookTitle);
}

-(void)setAmazonCode:(NSString*)amazonCode{
	amazonLinkText.text = amazonCode;
	AppData::setBookAmazonCode(bookTitleLabel.text, amazonLinkText.text);
	AppData::setBookAmazonTinyURL(bookTitleLabel.text, @"");
}

-(IBAction)amazonCodeEditing:(id)sender{
	AppData::setBookAmazonCode(bookTitleLabel.text, amazonLinkText.text);
	AppData::setBookAmazonTinyURL(bookTitleLabel.text, @"");
}

-(IBAction)searchAmazon:(id)sender{
	[getMyLibrary() pushEditWebView:bookTitleLabel.text];
}

-(IBAction)checkAmazonLink:(id)sender{
	NSString* url8 = [NSString stringWithFormat:@"%@%@", @"http://www.amazon.co.jp/dp/", amazonLinkText.text];
	NSString *uelEncode = (NSString*)CFURLCreateStringByAddingPercentEscapes(  
																			 kCFAllocatorDefault,
																			 (CFStringRef)url8,
																			 NULL,
																			 NULL,
																			 kCFStringEncodingUTF8
																			 ); 
	
	NSURL* url = [NSURL URLWithString:uelEncode];
	[[UIApplication sharedApplication] openURL:url];
}

-(IBAction)keyboardReturn:(id)sender{
	[amazonLinkText resignFirstResponder];
}

-(void)dealloc{
	[super dealloc];
}

@end

@implementation MyLibraryEditViewController

-(void)initParam{
	self.title = NSLocalizedString(@"設定", @"");
	[addView initParam];
}

-(void)cleanup:(NSString*)bookTitle{
	[addView cleanup:bookTitle];
}

-(void)setAmazonCode:(NSString*)amazonCode{
	[addView setAmazonCode:amazonCode];
}

@end
