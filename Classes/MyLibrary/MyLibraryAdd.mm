#import <AudioToolbox/AudioServices.h>
#import "MyAppDelegate.h"
#import "MyLibraryAdd.h"
#import "AppData.h"
#import "BookUtil.h"
#import "MyLibrary.h"

@implementation MyLibraryAddWebViewController

@synthesize openUrl8;

-(void)dealloc{
	[openUrl8 release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
	self.openUrl8 = AppData::getAddWebURL();
	urlText.text = self.openUrl8;
	if(![self.openUrl8 isEqualToString:ADD_WEB_URL_DEFAULT]){
		[self loadURL:self.openUrl8];
	}
}

-(void)initParam{
	webView.delegate = self;
	{
		CGRect frame = moveButton.frame;
		frame.size.height = 32;
		[moveButton setFrame:frame];
	}
}

-(void)loadURL:(NSString*)url8{
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
	self.openUrl8 = [[request URL] absoluteString];
	NSString* ext = [self.openUrl8 pathExtension];
	if([ext caseInsensitiveCompare:@"zip"] == NSOrderedSame){
		UIAlertView* alert = [[UIAlertView alloc]
							  initWithTitle:@"書籍への追加"
							  message:@"リンク先をzipファイルとして書籍に追加しますか？"
							  delegate:self
							  cancelButtonTitle:@"いいえ"
							  otherButtonTitles:@"はい", nil];
		[alert show];
		return FALSE;
	}else{
		urlText.text = self.openUrl8;
		return TRUE;
	}
}
//--------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 1){
		[getMyLibrary().addView setURL:self.openUrl8];
		[getMyLibrary() pop];
	}
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[activityIndicatorView stopAnimating];
	AppData::setAddWebURL(self.openUrl8);
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
	[self loadURL:urlText.text];
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

@implementation MyLibraryAddView

@synthesize openWebButton;
@synthesize connection;
@synthesize webBookData;
@synthesize unzipedDirName;
@synthesize unzipedDirPath;
@synthesize unzip;
@synthesize unzipTimer;


-(void)initParam{
	[self cleanup];
	urlField.text = AppData::getDownloadURL();
	[self updateBookName];
}

-(void)cleanup{
	progView.progress = 0.0f;
	
	infoLabel.text = @"UTF8でURLエンコードされたURLを入力してください";

	[urlField setTextColor:[UIColor blackColor]];
	urlField.enabled = TRUE;
	 
	[openWebButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
	openWebButton.enabled = TRUE;

	[cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
	cancelButton.enabled = FALSE;

	[getWebButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
	getWebButton.enabled = TRUE;

	{
		UIButton *button;
		button = [UIButton buttonWithType:(UIButtonType)100];
		button.frame = CGRectMake(225.0f, 78.0f, 75.0f, 31.0f);
		[button setTitle:[NSString stringWithUTF8String:"WEBを開く"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(openWeb:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
	}
}

-(void)updateBookName{
	NSString* urlItem = [[[[urlField text] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] lastPathComponent] stringByDeletingPathExtension];
	bookLabel.text = [urlItem stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(void)setURL:(NSString*)url8{
	urlField.text = url8;
	[self updateBookName];
	[self cleanup];
	[self webGet:self];
}

-(IBAction)openWeb:(id)sender{
	[getMyLibrary() pushAddWebView];
}

-(IBAction)webGet:(id)sender{
	BOOL error = FALSE;
#ifdef TYPE_FREE
	if([getMyLibraryTable().tableItems count] >= 2){
		error = TRUE;
	}
#endif
	if(error){
		[getMyLibrary() pushAddErrorView];
	}else{
		openWebButton.enabled = FALSE;
		getWebButton.enabled = FALSE;
		cancelButton.enabled = TRUE;
		
		[urlField setTextColor:[UIColor grayColor]];
		urlField.enabled = FALSE;
		
		{
			loadSize = 0;
			loadedSize = 0;
			//		NSString* urlStrgin = [[urlField text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSString* urlStrgin = [urlField text];
			NSLog(@"%@", urlStrgin);
			NSURL* urlWork = [NSURL URLWithString:urlStrgin];
			//		NSString* encodeString = [self stringByURLEncoding:NSUTF8StringEncoding string:[urlField text]];
			//		NSURL* urlWork = [NSURL URLWithString:encodeString];
			NSMutableURLRequest *theRequest=[NSMutableURLRequest
											 requestWithURL:urlWork
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:60.0];
			NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
			self.connection = theConnection;
			if (theConnection) {
				NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX starting connection");
			} else {
				NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX error connection");
			}
			infoLabel.text = [NSString stringWithFormat:@"ダウンロード中"];
		}
	}
}

-(IBAction)canecl:(id)sender{
	[connection cancel];
	[self cleanup];
}

-(IBAction)keyboardReturn:(id)sender{
	[urlField resignFirstResponder];
}	

-(IBAction)urlEditingChanged:(id)sender{
	[self updateBookName];
}	

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX will cache response");
	return cachedResponse;
}

- (void)connection:(NSURLConnection *)_connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did receive response: %@", response);
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did receive response: %d", response.expectedContentLength);
	int statusCode = [((NSHTTPURLResponse *)response) statusCode];
	if(statusCode == 200){
		loadSize = response.expectedContentLength;
		infoLabel.text = [NSString stringWithFormat:@"ダウンロード中 : %.1f / %.1fMB", (float)loadedSize/1000000.0f, (float)loadSize/1000000.0f];
		self.webBookData = [NSMutableData data];
		{
			NSString* filePath;
			{
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString* documentsPath = [paths objectAtIndex:0];
				NSString* fileName = [[[urlField text] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] lastPathComponent];
				filePath = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, fileName];
				NSLog(@"save : %@", filePath);
			}
			// ディレクトリ作成
			{
				NSString* dirPath = [filePath stringByDeletingLastPathComponent];
				[[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
			}
			bookFp = fopen([filePath UTF8String], "wb");
			if(!bookFp){
				[_connection cancel];
				[self cleanup];
				infoLabel.text = @"ダウンロード失敗";
			}
		}
	}else{
		[_connection cancel];
		[self cleanup];
		infoLabel.text = @"ダウンロード失敗";
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did receive data");
	loadedSize += data.length;
	progView.progress = (float)loadedSize/(float)loadSize * 0.5f;
	infoLabel.text = [NSString stringWithFormat:@"ダウンロード中 : %.1f / %.1fMB", (float)loadedSize/1000000.0f, (float)loadSize/1000000.0f];
	//[self.webBookData appendData:data];
	ASSERT(bookFp);
	fwrite(data.bytes, 1, data.length, bookFp);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did finish loading");
	/*if(self.webBookData.length > 0)*/{
		AppData::setDownloadURL(urlField.text);

		{
			ASSERT(bookFp);
			fclose(bookFp);
		}

		NSString* fileName = [[[urlField text] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] lastPathComponent];
		if(![fileName hasSuffix:@".zip"]){
			fileName = [fileName stringByAppendingString:@".zip"];
		}
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *documentsPath;
		{
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			documentsPath = [paths objectAtIndex:0];
			NSLog(@"%@", documentsPath);
		}
/*		{
			NSString *dirPath = [NSString stringWithFormat:@"%@/Books", documentsPath];
			BOOL exist = [fileManager fileExistsAtPath:dirPath];
			if(!exist){
				exist = [fileManager createDirectoryAtPath:dirPath attributes:nil];
			}
		}
*/
/*		{
			NSString* filePath = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, fileName];
			NSLog(@"save : %@", filePath);
			[webBookData writeToFile:filePath atomically:FALSE];
			self.webBookData = [NSData data];
		}
*/
		{
			NSString *unzipDirName = [fileName stringByDeletingPathExtension];
			NSString *unzipDirPath = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, unzipDirName];
			NSLog(@"unzip dir : %@", unzipDirPath);
			BOOL exist = [fileManager fileExistsAtPath:unzipDirPath];
			if(!exist){
				//[fileManager createDirectoryAtPath:unzipDirPath attributes:nil];
				[fileManager createDirectoryAtPath:unzipDirPath withIntermediateDirectories:YES attributes:nil error:nil];
				
				
			}else{
				NSError* error = NULL;
				BOOL remove = [fileManager removeItemAtPath:unzipDirPath error:&error];
				if(remove){
					//[fileManager createDirectoryAtPath:unzipDirPath attributes:nil];
					[fileManager createDirectoryAtPath:unzipDirPath withIntermediateDirectories:YES attributes:nil error:nil];
				}
			}
		}
		{
			self.unzipedDirName = [fileName stringByDeletingPathExtension];
			self.unzipedDirPath = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, unzipedDirName];
		}
		{
			NSString* filePath = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, fileName];
			HetimaUnZipContainer *unzipContainer = [[HetimaUnZipContainer alloc] initWithZipFile:filePath];
			self.unzip = unzipContainer;
			[unzipContainer setListOnlyRealFile:YES];
			unzipedCount = 0;
			self.unzipTimer = [NSTimer scheduledTimerWithTimeInterval:0.000001f target:self selector:@selector(unzipUpdate) userInfo:nil repeats:YES];
			ASSERT(self.unzipTimer);
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX did fail with error %@", error);
	[self.connection release];
	[self.webBookData release];
	[self cleanup];
	infoLabel.text = [NSString stringWithFormat:@"ダウンロード失敗", (float)loadedSize/1000000.0f, (float)loadSize/1000000.0f];
}

- (void)unzipUpdate {
	
	NSEnumerator *contentsEnum = [[self.unzip contents] objectEnumerator];
	NSArray* items = [contentsEnum allObjects];
	int itemCount = [items count];

	infoLabel.text = [NSString stringWithFormat:@"解凍中:%d / %dfiles", unzipedCount, itemCount];
	progView.progress = 0.5f + ((float)unzipedCount/(float)itemCount * 0.5f);

	if(unzipedCount < itemCount){
		HetimaUnZipItem* item = [items objectAtIndex:unzipedCount];
		NSString* itemName = [[item path] lastPathComponent];
		NSString *path = [NSString stringWithFormat:@"%@/%@", unzipedDirPath, itemName];
		NSLog(@"%@", path);
		BOOL result = [item extractTo:path delegate:nil];
		if(!result){
			ASSERT(FALSE);
		}
		unzipedCount++;
		if(unzipedCount == itemCount){
			MyLibraryTable* table = getMyLibraryTable();
			
			{
				// 書籍情報の保存
				AppData::setupBook(unzipedDirName);
				ms::Sint32 pageCount = BookUtil::getPageCountWithBookName(unzipedDirName);
				AppData::setBookPageCount(unzipedDirName, pageCount);
				
				// 書籍一覧画面に書籍を追加
				BOOL exist = FALSE;
				{
					int count = [table.tableItems count];
					for(int i = 0; i < count; i++){
						MyLibraryTableItem* item = [table.tableItems objectAtIndex:i];
						if([item.title isEqualToString:unzipedDirName]){
							exist = TRUE;
						}
					}
				}
				if(!exist){
					MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:unzipedDirName path:unzipedDirPath type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
					NSLog(@"%d", [table.tableItems count]);
					[table.tableItems insertObject:item atIndex:[table.tableItems count]-1];
				}
				[table updateList];
			}
			NSLog(@"unzip complated. size %d bytes.", unzipedSize);
			[self.unzip release];
			// zipファイルの削除
			{
				NSString* fileName = [[[urlField text] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] lastPathComponent];
				if(![fileName hasSuffix:@".zip"]){
					fileName = [fileName stringByAppendingString:@".zip"];
				}
				NSString *documentsPath;
				{
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					documentsPath = [paths objectAtIndex:0];
				}
				{
					NSString* filePath = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, fileName];
					NSFileManager *fileManager = [NSFileManager defaultManager];
					[fileManager removeItemAtPath:filePath error:NULL];
					NSLog(@"remove zip file : %@", filePath);
				}
			}
			[self cleanup];
			infoLabel.text = @"追加完了";
			progView.progress = 1.0f;
			
			[unzipTimer invalidate];
			
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		}
	}
}

-(void)dealloc{
	[openWebButton release];
	[connection release];
	[webBookData release];
	[super dealloc];
}

@end

@implementation MyLibraryAddViewController

-(void)initParam{
	self.title = NSLocalizedString(@"書籍の追加", @"");
	[addView initParam];
}

-(void)cleanup{
}

-(void)setURL:(NSString*)url8{
	[addView setURL:url8];
}

- (void)viewWillAppear:(BOOL)animated{
	[UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
	[UIApplication sharedApplication].idleTimerDisabled = NO;
}
@end

@implementation MyLibraryAddErrorViewController

-(IBAction)pay{
	NSString* url8 = @"http://j.mp/acLgvg";
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

@end
