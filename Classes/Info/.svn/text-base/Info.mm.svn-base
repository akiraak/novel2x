#import "Info.h"
#import "MyAppDelegate.h"

@implementation InfoView

@synthesize infoView;

- (id)init
{
	self = [super init];
	if (self)
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"取り扱い説明書", @"");
/*		UIBarButtonItem *backItem = [[UIBarButtonItem alloc]
									 initWithTitle:NSLocalizedString(@"戻る", @"")
									 style:UIBarButtonItemStylePlain
									 target:self
									 action:@selector(end)];
		self.navigationItem.leftBarButtonItem = backItem;
		[backItem release];
*/	}
	return self;
}

-(void)end{
	[getMyAppDelegateInstance() returnInfo];
}

- (void)dealloc
{
	[infoView release];
	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	NSLog(@"responding to autorotation query");
	//    return YES;
//	return YES;
	return NO;
}


- (void)loadView
{	
	// create and configure the table view
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	frame.size.height -= BANNER_H;

	UIView *base = [[UIView alloc] initWithFrame:frame];
	base.autoresizesSubviews = YES;
	base.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view = base;
	[base release];
	
/*	UIImage *image = [UIImage imageNamed:@"53_yakusima.jpg"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:imageView];
*/
	
	UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
	webView.delegate = self;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	webView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
	webView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	webView.opaque = NO;
	//[(UIScrollView*)[webView.subviews objectAtIndex:0] setAllowsRubberBanding:NO];
	self.infoView = webView;
	[webView release];
	[self.view addSubview:self.infoView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.infoView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"html"]isDirectory:NO]]];
//	NSLog(@"loading: %@", [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]);
}

- (void)viewDidAppear:(BOOL)animated{
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	frame.size.height -= BANNER_H;
	self.view.frame = frame;
	self.infoView.frame = frame;
}


#pragma mark UIWebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeOther)
		return YES;
	[[UIApplication sharedApplication] openURL:[request URL]];
	return NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//	NSLog(@"webview error: %@", error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//	NSLog(@"webview load finish");
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//	NSLog(@"webview load start");
}

@end

@implementation Info

@synthesize navigationController;
@synthesize addView;

-(id)init{
	if(self = [super init]){
		InfoView* aInfo = [[InfoView alloc] init];
		UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:aInfo];
		self.navigationController = aNavigationController;
		[aNavigationController release];
		self.addView = aInfo;
		[aInfo release];
	}
	return self;
}

-(UIView*)view{
	return [self.navigationController view];
}

-(void)dealloc{
	[navigationController release];
	[addView release];
	[super dealloc];
}

@end
