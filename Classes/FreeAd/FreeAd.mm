#import "FreeAd.h"
#import "MyAppDelegate.h"

@implementation FreeAdViewController

@synthesize webView;

- (id)init
{
	self = [super init];
	if (self)
	{
		self.title = NSLocalizedString(@"無料版 広告", @"");
		UIBarButtonItem *button = [[UIBarButtonItem alloc]
									 initWithTitle:NSLocalizedString(@"次へ", @"")
									 style:UIBarButtonItemStylePlain
									 target:self
									 action:@selector(end)];
		self.navigationItem.rightBarButtonItem = button;
		[button release];
	}
	return self;
}

-(void)end{
	[getMyAppDelegateInstance() start];
}

- (void)dealloc
{
	[webView release];
	
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
	{
		UIWebView *view = [[UIWebView alloc] initWithFrame:self.view.frame];
		view.delegate = self;
		view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
		view.opaque = NO;
		self.webView = view;
		[view release];
		[self.view addSubview:self.webView];
	}
}

- (void)viewWillAppear:(BOOL)animated{
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"free_ad" ofType:@"html"]isDirectory:NO]]];
}

- (void)viewDidAppear:(BOOL)animated{
}

#pragma mark UIWebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeOther)
		return YES;
	[[UIApplication sharedApplication] openURL:[request URL]];
	return NO;
}

@end

@implementation FreeAd

@synthesize navigationController;

-(id)init{
	if(self = [super init]){
		FreeAdViewController* viewController = [[FreeAdViewController alloc] init];
		UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
		aNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
		self.navigationController = aNavigationController;
		[aNavigationController release];
	}
	return self;
}

-(UIView*)view{
	return [self.navigationController view];
}

-(void)dealloc{
	[navigationController release];
	[super dealloc];
}

@end
