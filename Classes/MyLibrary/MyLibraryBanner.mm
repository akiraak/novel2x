#import "MyLibraryBanner.h"


@implementation MyLibraryBanner

@synthesize baseView;
@synthesize bannerView;

#define BANNER_URL @"http://rcm-jp.amazon.co.jp/e/cm?t=akira00-22&o=9&p=42&l=ur1&category=papaerbackbooks&banner=0XMK3WWBNXZA5X7D0X82&f=ifr"

-(id)init{
	CGSize bannerSize = CGSizeMake(BANNER_W, BANNER_H);
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	frame.origin.y = frame.size.height - bannerSize.height;
	frame.size.height = bannerSize.height;
	
	if(self = [super initWithFrame:frame]){
		self.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
		//self.backgroundColor = [UIColor blackColor];
		
		{
			frame.origin.x = (frame.size.width*0.5f)-(bannerSize.width*0.5f);
			frame.origin.y = 0.0f;
			frame.size.width = bannerSize.width;
			UIWebView* object = [[UIWebView alloc] initWithFrame:frame];
			object.delegate = self;
			object.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			object.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
			object.opaque = NO;
			self.bannerView = object;
			[object release];
			[self addSubview:self.bannerView];
			
			NSString* url8 = BANNER_URL;
			NSLog(@"%@", url8);
			NSString *uelEncode = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url8, NULL, NULL, kCFStringEncodingUTF8); 
			NSLog(@"%@", uelEncode);
			NSURL* url = [NSURL URLWithString:uelEncode];

			//[self.bannerView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"banner" ofType:@"html"]isDirectory:NO]]];
			[self.bannerView loadRequest:[NSURLRequest requestWithURL:url]];
		}
	}
	return self;
}

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	NSString* url8 = [[request URL] absoluteString];
	if(![url8 isEqualToString:BANNER_URL]){
		NSURL* url = [NSURL URLWithString:url8];
		[[UIApplication sharedApplication] openURL:url];
		return FALSE;
	}
	return TRUE;
}
*/

-(void)dealloc{
	[super dealloc];
}

@end
