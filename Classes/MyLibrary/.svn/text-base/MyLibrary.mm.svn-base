#include <dirent.h>
#import "MyLibrary.h"
#import "MyAppDelegate.h"
#import "AppData.h"
#import "BookUtil.h"

static MyLibrary* instanceMyLibrary = NULL;
MyLibrary* getMyLibrary(){
	return instanceMyLibrary;
}

static MyLibraryTable* instanceMyLibraryTable = NULL;
MyLibraryTable* getMyLibraryTable(){
	return instanceMyLibraryTable;
}

@interface UIAlertView (Extended)
- (UITextField*)addTextFieldWithValue:(NSString*)value label:(NSString*)label;
- (UITextField*)textFieldAtIndex:(NSUInteger)index;
- (NSUInteger)textFieldCount;
- (UITextField*)textField;
@end

@implementation MyLibraryTableItem

@synthesize title;
@synthesize path;

//-(id)initWithTitle:(NSString*)_title path:(NSString*)_path{
-(id)initWithTitle:(NSString*)_title path:(NSString*)_path type:(MYLIBRARY_TABLEITEM_TYPE)_type{
	if(self = [super init]){
		self.title = _title;
		self.path = _path;
		type = _type;
	}
	return self;
}

-(MYLIBRARY_TABLEITEM_TYPE)getType{
	return type;
}

@end

@implementation MyLibraryTable

@synthesize tableItems;
@synthesize searchZipTimer;

-(id)init{
	if(self = [super init]){
		self.title = @"書籍";
		UIBarButtonItem* removeButton = [[[UIBarButtonItem alloc]
									   initWithTitle:@"削除"
									   style:UIBarButtonItemStylePlain
									   target:self
									   action:@selector(remove)
									   ] autorelease];
		self.navigationItem.leftBarButtonItem = removeButton;
		UIBarButtonItem* addButton = [[[UIBarButtonItem alloc]
									   initWithTitle:@"追加"
									   style:UIBarButtonItemStylePlain
									   target:self
									   action:@selector(add)
									   ] autorelease];
		self.navigationItem.rightBarButtonItem = addButton;
		
		{
			NSMutableArray* items = [[NSMutableArray array] retain];
			
			NSString *documentsPath;
			{
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				documentsPath = [paths objectAtIndex:0];
				NSLog(@"%@", documentsPath);
			}
#if 0
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"1Q84 BOOK 1[1/554]" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
				[items addObject:item];
			}
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"1Q84 BOOK 2[1/501]" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
				[items addObject:item];
			}
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"告白[1/268]" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
				[items addObject:item];
			}
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"悼む人[1/464]" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
				[items addObject:item];
			}
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"猫を抱いて象と泳ぐ[1/366]" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
				[items addObject:item];
			}
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"獣の奏者1[1/351]" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
				[items addObject:item];
			}
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"涼宮ハルヒの憂鬱(1)[1/286]" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
				[items addObject:item];
			}
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"アイの物語[1/584]" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
				[items addObject:item];
			}
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"ファウンデーション〈1〉[1/355]" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
				[items addObject:item];
			}
#endif
			// zipファイル一覧
			{
				NSLOG(@"zipファイル一覧");
				NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:nil];
				for(NSString* content in contents){
					NSString* ext = [content pathExtension];
					if([ext isEqualToString:@"zip"]){
						NSString* title = [NSString stringWithFormat:@"ZIP:%@", content];
						NSString* path = [NSString stringWithFormat:@"%@/%@", documentsPath, content];
						MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:title path:path type:MYLIBRARY_TABLEITEM_TYPE_ZIP];
						[items addObject:item];
						NSLOG(@"zip file : %@", content);
					}
				}
			}
			// 書籍一覧
			{
				DIR *dp;
				struct dirent *dir;
				NSString *dirPathString = [NSString stringWithFormat:@"%@/Books", documentsPath];
				NSLog(@"%@", dirPathString);
				const char* dirPath= [dirPathString UTF8String];
				if((dp=opendir(dirPath)) != NULL){
					// カレントディレクトリのファイル一覧を表示
					while((dir = readdir(dp)) != NULL){
						if(dir->d_type == DT_DIR){
							if(strcmp(dir->d_name, ".") != 0 &&
							   strcmp(dir->d_name, "..") != 0)
							{
								NSString* dirName = [NSString stringWithUTF8String:dir->d_name];
								NSString* dirPath = [NSString stringWithFormat:@"%@/%@", dirPathString, dirName];
								NSLog(@"%@", dirName);
								MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:dirName path:dirPath type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
								[items addObject:item];
								AppData::setupBook(dirName);
							}
						}else{
							NSString* path = [NSString stringWithUTF8String:dir->d_name];
							NSLog(@"not dir : %@", path);
						}
					}
					closedir(dp);
				}
			}
			{
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:@"取り扱い説明書" path:@"" type:MYLIBRARY_TABLEITEM_TYPE_MANUAL];
				[items addObject:item];
			}
			self.tableItems = items;
			[items release];
		}
	}
	return self;
}

- (void)viewDidAppear:(BOOL)animated{
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
//	frame.origin.y = 44.0f;
	frame.size.height -= BANNER_H/*+44.0f*/;
	self.tableView.frame = frame;
	self.tableView.bounds = frame;
	[self.tableView setContentOffset:CGPointMake(0.0f, -44.0f) animated:NO];
	
	
	// zipファイル検索のタイマー作成
	self.searchZipTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(searchZipUpdate) userInfo:nil repeats:YES];
	ASSERT(searchZipTimer);
}

- (void)viewDidDisappear:(BOOL)animated{
	[searchZipTimer invalidate];
}

-(void)searchZipUpdate{
	// zipファイル取得
	//NSLOG(@"zipファイル一覧");
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:nil];
	BOOL add = FALSE;
	for(NSString* content in contents){
		NSString* ext = [content pathExtension];
		if([ext isEqualToString:@"zip"]){
			BOOL exist = FALSE;
			NSString* title = [NSString stringWithFormat:@"ZIP:%@", content];
			for(MyLibraryTableItem* item in tableItems){
				if([item.title isEqualToString:title]){
					exist = TRUE;
					break;
				}
			}
			if(!exist){
				NSString* path = [NSString stringWithFormat:@"%@/%@", documentsPath, content];
				MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:title path:path type:MYLIBRARY_TABLEITEM_TYPE_ZIP];
				[tableItems insertObject:item atIndex:0];
				add = TRUE;
				NSLOG(@"zip file : %@", content);
			}
		}
	}
	if(add){
		[self updateList];
	}
}
	
-(void)add{
#ifdef TYPE_FREE
	if([self.tableItems count] < 2){
		[getMyLibrary() pushAddView];
	}else{
		[getMyLibrary() pushAddErrorView];
	}
#elif defined(TYPE_PAY)
	[getMyLibrary() pushAddView];
#else
	#error
#endif
}

-(void)remove{
	UIBarButtonItem* removeButton = [[[UIBarButtonItem alloc]
									  initWithTitle:@"完了"
									  style:UIBarButtonItemStylePlain
									  target:self
									  action:@selector(removeDone)
									  ] autorelease];
	self.navigationItem.leftBarButtonItem = removeButton;
	self.navigationItem.rightBarButtonItem = nil;

	[self.tableView setEditing:YES animated:YES];
}

-(void)removeDone{
	[self.tableView setEditing:NO animated:YES];

	UIBarButtonItem* removeButton = [[[UIBarButtonItem alloc]
									  initWithTitle:@"削除"
									  style:UIBarButtonItemStylePlain
									  target:self
									  action:@selector(remove)
									  ] autorelease];
	self.navigationItem.leftBarButtonItem = removeButton;
	UIBarButtonItem* addButton = [[[UIBarButtonItem alloc]
								   initWithTitle:@"追加"
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(add)
								   ] autorelease];
	self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark UITableViewDataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSLog(@"%d", [self.tableItems count]);
	return [self.tableItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"any-cell"];
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"any-cell"] autorelease];
	}
	NSString* title = [[self.tableItems objectAtIndex:[indexPath row]] title];
	MYLIBRARY_TABLEITEM_TYPE type = [[self.tableItems objectAtIndex:[indexPath row]] getType];
	NSString* text = nil;
	switch(type){
		case MYLIBRARY_TABLEITEM_TYPE_BOOK:
		{
			int pageCount = AppData::getBookPageCount(title);
			int pageNo = AppData::getBookPageIndex(title)+1;
			text = [NSString stringWithFormat:@"%@ [%d/%d]", title, pageNo, pageCount];
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
		}
		case MYLIBRARY_TABLEITEM_TYPE_ZIP:
		case MYLIBRARY_TABLEITEM_TYPE_MANUAL:
			text = title;
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
	}
	[cell.textLabel setText:text];
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style;
	MYLIBRARY_TABLEITEM_TYPE type = [[self.tableItems objectAtIndex:[indexPath row]] getType];
	switch(type){
		case MYLIBRARY_TABLEITEM_TYPE_BOOK:
		case MYLIBRARY_TABLEITEM_TYPE_ZIP:
			style = UITableViewCellEditingStyleDelete;
			break;
		case MYLIBRARY_TABLEITEM_TYPE_MANUAL:
			style = UITableViewCellEditingStyleNone;
			break;
	}
	return style;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	MyLibraryTableItem* item = [tableItems objectAtIndex:indexPath.row];
	switch([item getType]){
		case MYLIBRARY_TABLEITEM_TYPE_BOOK:
			BookUtil::remove(item.title);
			[tableItems removeObjectAtIndex:indexPath.row];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
			break;
		case MYLIBRARY_TABLEITEM_TYPE_ZIP:
		{
			// zipファイル削除
			[[NSFileManager defaultManager] removeItemAtPath:item.path error:nil];
			[tableItems removeObjectAtIndex:indexPath.row];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
			break;
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	MyLibraryTableItem* item = [tableItems objectAtIndex:indexPath.row];
	MYLIBRARY_TABLEITEM_TYPE type = [[self.tableItems objectAtIndex:[indexPath row]] getType];
	switch(type){
		case MYLIBRARY_TABLEITEM_TYPE_BOOK:
			NSLog(@"%@", [[tableItems objectAtIndex:[indexPath row]] title]);
			[getMyAppDelegateInstance() changeSceneConfig:[[tableItems objectAtIndex:[indexPath row]] title]];
			break;
		case MYLIBRARY_TABLEITEM_TYPE_ZIP:
		{
			NSLOG(@"ZIP解凍");
/*			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsPath = [paths objectAtIndex:0];
			NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPath, [item title]];
*/
			NSString *filePath = [item path];
			NSLOG(@"filePath: %@", filePath);
			[getMyLibrary() pushUnzipView:filePath];
			break;
		}
		case MYLIBRARY_TABLEITEM_TYPE_MANUAL:
			[getMyAppDelegateInstance() changeSceneInfoFromBooks];
			break;
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	NSString* bookTitle = [[self.tableItems objectAtIndex:indexPath.row] title];
	[getMyLibrary() pushEditView:bookTitle];
}

#pragma mark Contoroller's loadView Methods

- (void)loadView{
	[super loadView];
}

-(void)removeItemWithTitle:(NSString*)title{
	for(int i = 0; i < tableItems.count; i++){
		MyLibraryTableItem* item = [tableItems objectAtIndex:i];
		if([item.title isEqualToString:title]){
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
			[tableItems removeObjectAtIndex:indexPath.row];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
			break;
		}
	}
}

-(void)updateList{
	[self.tableView reloadData];
}

-(void)dealloc{
	[tableItems release];
	[searchZipTimer release];
	[super dealloc];
}

@end

@implementation MyLibrary

@synthesize baseView;
@synthesize bannerView;
@synthesize navigationController;
@synthesize addView;
@synthesize addWebView;
@synthesize addErrorView;
@synthesize editWebView;
@synthesize editView;
@synthesize unzipView;

-(id)init{
	if(self = [super init]){
		instanceMyLibrary = self;
		
		{
			UIView* object = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
			object.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			self.baseView = object;
		}
		{
			MyLibraryBanner* object = [[MyLibraryBanner alloc] init];
			self.bannerView = object;
			[object release];
		}
		
		MyLibraryTable* aTable = [[MyLibraryTable alloc] init];
		instanceMyLibraryTable = aTable;
		UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:aTable];
		aNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
		self.navigationController = aNavigationController;
		[aNavigationController release];
		[aTable release];

		{
			NSArray* niblets = [[NSBundle mainBundle] loadNibNamed:@"MyLibraryAdd" owner:self options:NULL];
			for(id object in niblets){
				if([object isKindOfClass:[UIViewController class]]){
					self.addView = object;
					[self.addView initParam];
				}
			}
		}
		{
			NSArray* niblets = [[NSBundle mainBundle] loadNibNamed:@"MyLibraryAddWeb" owner:self options:NULL];
			for(id object in niblets){
				if([object isKindOfClass:[UIViewController class]]){
					self.addWebView = object;
					[self.addWebView initParam];
				}
			}
		}
		{
			NSArray* niblets = [[NSBundle mainBundle] loadNibNamed:@"MyLibraryAddError" owner:self options:NULL];
			for(id object in niblets){
				if([object isKindOfClass:[UIViewController class]]){
					self.addErrorView = object;
				}
			}
		}
		{
			NSArray* niblets = [[NSBundle mainBundle] loadNibNamed:@"MyLibraryEdit" owner:self options:NULL];
			for(id object in niblets){
				if([object isKindOfClass:[UIViewController class]]){
					self.editView = object;
					[self.editView initParam];
				}
			}
		}
		{
			NSArray* niblets = [[NSBundle mainBundle] loadNibNamed:@"MyLibraryEditWeb" owner:self options:NULL];
			for(id object in niblets){
				if([object isKindOfClass:[UIViewController class]]){
					self.editWebView = object;
					[self.editWebView initParam];
				}
			}
		}
		{
			NSArray* niblets = [[NSBundle mainBundle] loadNibNamed:@"MyLibraryUnzip" owner:self options:NULL];
			for(id object in niblets){
				if([object isKindOfClass:[UIViewController class]]){
					self.unzipView = object;
					[self.unzipView initParam];
				}
			}
		}
		[self.baseView addSubview:[self.navigationController view]];
		[self.baseView addSubview:self.bannerView];
	}
	return self;
}

-(void)showPaidUpdate{
	UIAlertView* alert = [[UIAlertView alloc]
						  initWithTitle:@"今だけ無料"
						  message:@"機能強化版を開発中のため、現在の有料版を無料でご提供中です。"
						  delegate:self
						  cancelButtonTitle:@"有料版を使う"
						  otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 0){
		NSString* url8 = [NSString stringWithFormat:@"http://itunes.apple.com/jp/app/id351820519?mt=8"];
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
}

-(UIView*)view{
//	return [self.navigationController view];
	return self.baseView;
}

#define kShowMapAnimationId @"kShowMapAnimationId"
#define kHideMapAnimationId @"kHideMapAnimationId"
#define kMapAnimationDuration 0.6f

-(void)pushAddView{
	[navigationController pushViewController:self.addView animated:YES];
}

-(void)pushAddWebView{
	[navigationController pushViewController:self.addWebView animated:YES];
}

-(void)pushAddErrorView{
	[navigationController pushViewController:self.addErrorView animated:YES];
}

-(void)pushEditView:(NSString*)bookTitle{
	[editView cleanup:bookTitle];
	[navigationController pushViewController:self.editView animated:YES];
}

-(void)pushEditWebView:(NSString*)bookTitle{
	[navigationController pushViewController:self.editWebView animated:YES];
	[self.editWebView loadURL:bookTitle];
}

-(void)pushUnzipView:(NSString*)filePath{
	[self.unzipView cleanup:filePath];
	[navigationController pushViewController:self.unzipView animated:YES];
}

-(void)pop{
	[navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
	[bannerView release];
	[navigationController release];
	[addView release];
	[addWebView release];
	[addErrorView release];
	[editWebView release];
	[unzipView release];
	[editView release];
	[super dealloc];
}

@end
