#import "Note.h"
#import "MyAppDelegate.h"
#import "AppData.h"

//********************************
@implementation NoteData

@synthesize pageNo;
@synthesize icon;
@synthesize text;

//--------------------------------
static NSInteger comparePageNo(id item1, id item2, void *context){
	NSInteger pageNo1 = ((NoteData*)item1).pageNo;
	NSInteger pageNo2 = ((NoteData*)item2).pageNo;
	if(pageNo1 > pageNo2){
		return NSOrderedDescending;
	}else if(pageNo1 < pageNo2){
		return NSOrderedAscending;
	}else{
		NSInteger icon1 = ((NoteData*)item1).icon;
		NSInteger icon2 = ((NoteData*)item2).icon;
		if(icon1 > icon2){
			return NSOrderedDescending;
		}else if(icon1 < icon2){
			return NSOrderedAscending;
		}else{
			NSString* memo1 = ((NoteData*)item1).text;
			NSString* memo2 = ((NoteData*)item2).text;
			NSComparisonResult comp = [memo1 compare:memo2];
			if(comp == NSOrderedDescending){
				return NSOrderedDescending;
			}else if(comp == NSOrderedAscending){
				return NSOrderedAscending;
			}else{
				return NSOrderedSame;
			}
		}
	}
}
//--------------------------------
static NSInteger compareIcon(id item1, id item2, void *context){
	NSInteger icon1 = ((NoteData*)item1).icon;
	NSInteger icon2 = ((NoteData*)item2).icon;
	if(icon1 > icon2){
		return NSOrderedDescending;
	}else if(icon1 < icon2){
		return NSOrderedAscending;
	}else{
		NSInteger pageNo1 = ((NoteData*)item1).pageNo;
		NSInteger pageNo2 = ((NoteData*)item2).pageNo;
		if(pageNo1 > pageNo2){
			return NSOrderedDescending;
		}else if(pageNo1 < pageNo2){
			return NSOrderedAscending;
		}else{
			NSString* memo1 = ((NoteData*)item1).text;
			NSString* memo2 = ((NoteData*)item2).text;
			NSComparisonResult comp = [memo1 compare:memo2];
			if(comp == NSOrderedDescending){
				return NSOrderedDescending;
			}else if(comp == NSOrderedAscending){
				return NSOrderedAscending;
			}else{
				return NSOrderedSame;
			}
		}
	}
}
//--------------------------------
static NSInteger compareMemo(id item1, id item2, void *context){
	NSString* memo1 = ((NoteData*)item1).text;
	NSString* memo2 = ((NoteData*)item2).text;
	NSComparisonResult comp = [memo1 compare:memo2];
	if(comp == NSOrderedDescending){
		return NSOrderedDescending;
	}else if(comp == NSOrderedAscending){
		return NSOrderedAscending;
	}else{
		NSInteger icon1 = ((NoteData*)item1).icon;
		NSInteger icon2 = ((NoteData*)item2).icon;
		if(icon1 > icon2){
			return NSOrderedDescending;
		}else if(icon1 < icon2){
			return NSOrderedAscending;
		}else{
			NSInteger pageNo1 = ((NoteData*)item1).pageNo;
			NSInteger pageNo2 = ((NoteData*)item2).pageNo;
			if(pageNo1 > pageNo2){
				return NSOrderedDescending;
			}else if(pageNo1 < pageNo2){
				return NSOrderedAscending;
			}else{
				return NSOrderedSame;
			}
		}
	}
}
//--------------------------------
+(NSArray*)sortPageNo:(NSArray*)datas{
	return [datas sortedArrayUsingFunction:comparePageNo context:NULL];
}
//--------------------------------
+(NSArray*)sortIcon:(NSArray*)datas{
	return [datas sortedArrayUsingFunction:compareIcon context:NULL];
}
//--------------------------------
+(NSArray*)sortMemo:(NSArray*)datas{
	return [datas sortedArrayUsingFunction:compareMemo context:NULL];
}
//--------------------------------
-(void)dealloc{
	[text release];
	[super dealloc];
}

@end

//********************************
@implementation NoteTableViewCell

//--------------------------------
@synthesize pageNoLabel;
@synthesize iconView;
@synthesize textLabel;
@synthesize touchPageNo;

//--------------------------------
#define LEFT			(8.0f)
#define CELL_HEIGHT		(43.0f)
#define PAGE_NO_W		(32.0f)
#define ICON_Y			(4.0f)
#define ICON_W			(42.0f)
#define TEXT_W			(320.0f-LEFT-PAGE_NO_W-ICON_W-40.0f)
#define TEXT_FONT_SIZE	(14)

//--------------------------------
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		float posX = LEFT;
		{
			CGRect rect = CGRectMake(posX, 0.0f, PAGE_NO_W, CELL_HEIGHT);
			posX += PAGE_NO_W;
			UILabel* object = [[UILabel alloc] initWithFrame:rect];
			object.textAlignment = UITextAlignmentCenter;
			[self addSubview:object];
			self.pageNoLabel = object;
			[object release];
		}
		// Icon
		{
			CGRect rect = CGRectMake(posX, ICON_Y, 0.0f, 0.0f);
			posX += ICON_W;
			UIImageView* object = [[UIImageView alloc] init];
			object.frame = rect;
			[self addSubview:object];
			self.iconView = object;
			[object release];
		}
		// Text
		{
			CGRect rect = CGRectMake(posX, 0.0f, TEXT_W, CELL_HEIGHT);
			UILabel* view = [[UILabel alloc] initWithFrame:rect];
			rect = CGRectMake(0.0f, 0.0f, TEXT_W, CELL_HEIGHT);
			UILabel* label = [[UILabel alloc] initWithFrame:rect];
			[view addSubview:label];
			[self addSubview:view];
			self.textLabel = label;
			[label release];
			[view release];
		}
	}
	return self;
}

-(void)dealloc{
	[pageNoLabel release];
	[iconView release];
	[textLabel release];
	[super dealloc];
}

//--------------------------------
-(void)setPageNo:(NSInteger)pageNo{
	if(pageNo > 0){
		pageNoLabel.text = [NSString stringWithFormat:@"%03d", pageNo];
	}else{
		pageNoLabel.text = @"---";
	}
}

//--------------------------------
-(void)setIconImage:(UIImage*)iconImage{
//	UIImage* image = icon[item.icon];
	CGRect frame = iconView.frame;
	frame.size.width = iconImage.size.width;
	frame.size.height = iconImage.size.height;
	iconView.frame = frame;
	iconView.image = iconImage;
}

//--------------------------------
-(void)setTextString:(NSString*)textString{
	textLabel.text = textString;
}

//--------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];

	NSArray* allTouches = [touches allObjects];
	UITouch* touch = nil;
	touchPageNo = FALSE;
	for(touch in allTouches){
		CGPoint pos = [touch locationInView:self];
		if(pos.x < (LEFT+PAGE_NO_W)){
			touchPageNo = TRUE;
			break;
		}
	}	
}

//--------------------------------
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
	if(highlighted){
		pageNoLabel.textColor = [UIColor whiteColor];
		textLabel.textColor = [UIColor whiteColor];
	}
}
//--------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
	if(!selected){
		pageNoLabel.textColor = [UIColor blackColor];
		textLabel.textColor = [UIColor blackColor];
	}
}

@end

//********************************
@implementation NoteTableView

//--------------------------------
@synthesize data;
@synthesize movePageCellIndexPath;

//--------------------------------
static NSString* iconText[] = {
	@"男性",
	@"女性",
	@"動物",
	@"メモ",
};

//--------------------------------
-(void)initPatam{
	self.rowHeight = CELL_HEIGHT+1.0f;
	{
		NSString* fileName[] ={
			@"note_icon_male.png",
			@"note_icon_female.png",
			@"note_icon_animal.png",
			@"note_icon_memo.png",
		};
		for(int i = 0; i < ARRAYSIZE(icon); i++){
			icon[i] = [UIImage imageNamed:fileName[i]];
			[icon[i] retain];
		}
	}
	sortType = (NOTE_TABLE_SORT)0;
}
//--------------------------------
-(void)cleanup{
	{
		NSString* bookTitle = [Note getInstance].bookTitle;
		NSArray* pageNoArray = AppData::getBookNotePageNo(bookTitle);
		NSArray* iconArray = AppData::getBookNoteIcon(bookTitle);
		NSArray* textArray = AppData::getBookNoteText(bookTitle);
		NSMutableArray* object = nil;
		if(pageNoArray && iconArray && textArray){
			object = [NSMutableArray array];
			int count = [pageNoArray count];
			for(int i = 0; i < count; i++){
				NSNumber* _pageNo = [pageNoArray objectAtIndex:i];
				NSNumber* _icon = [iconArray objectAtIndex:i];
				NSString* _text = [textArray objectAtIndex:i];
				NoteData* item = [[NoteData alloc] init];
				item.pageNo = [_pageNo intValue];
				item.icon = (NOTE_ICON)[_icon intValue];
				item.text = _text;
				[object addObject:item];
			}
		}else{
			object = [NSMutableArray array];
		}
		self.data = object;
	}
//	self.data = [NSMutableArray arrayWithArray:[NoteData sortPageNo:self.data]];
}
//--------------------------------
-(void)saveData{
	NSMutableArray* pageNoArray = [NSMutableArray array];
	NSMutableArray* iconArray = [NSMutableArray array];
	NSMutableArray* textArray = [NSMutableArray array];
	int count = [self.data count];
	for(int i = 0; i < count; i++){
		NoteData* item = [self.data objectAtIndex:i];
		[pageNoArray addObject:[NSNumber numberWithInt:item.pageNo]];
		[iconArray addObject:[NSNumber numberWithInt:item.icon]];
		[textArray addObject:item.text];
	}
	AppData::setBookNote([Note getInstance].bookTitle, pageNoArray, iconArray, textArray);
}
//--------------------------------
-(void)startRemove{
	[self setEditing:YES animated:YES];
}
//--------------------------------
-(void)endRemove{
	[self setEditing:NO animated:YES];
	[self saveData];
}
//--------------------------------
-(UIImage*)getIconImage:(NOTE_ICON)_icon{
	ASSERT(_icon >= (NOTE_ICON)0 && _icon < NOTE_ICON_COUNT);
	return icon[_icon];
}
//--------------------------------
+(NSString*)getIconText:(NOTE_ICON)icon{
	ASSERT(icon >= (NOTE_ICON)0 && icon < NOTE_ICON_COUNT);
	return iconText[icon];
}
//--------------------------------
-(void)addMemo:(int)_pageNo icon:(NOTE_ICON)_icon memo:(NSString*)_memoText{
	NoteData* item = [[NoteData alloc] init];
	item.pageNo = _pageNo;
	item.icon = _icon;
	item.text = _memoText;
	[self.data addObject:item];
	[self sort:sortType];
	[self saveData];
	[self reloadData];
}
//--------------------------------
-(void)editMemo:(int)cellRow pageNo:(int)_pageNo icon:(NOTE_ICON)_icon memo:(NSString*)_memoText{
	NoteData* item = [self.data objectAtIndex:cellRow];
	item.pageNo = _pageNo;
	item.icon = _icon;
	item.text = _memoText;
	[self sort:sortType];
	[self saveData];
	[self reloadData];
}
//--------------------------------
-(void)sort:(NOTE_TABLE_SORT)type{
	sortType = type;
	switch(type){
		case NOTE_TABLE_SORT_PAGE_NO:
			self.data = [NSMutableArray arrayWithArray:[NoteData sortPageNo:self.data]];
			break;
		case NOTE_TABLE_SORT_ICON:
			self.data = [NSMutableArray arrayWithArray:[NoteData sortIcon:self.data]];
			break;
		case NOTE_TABLE_SORT_MEMO:
			self.data = [NSMutableArray arrayWithArray:[NoteData sortMemo:self.data]];
			break;
	}
	[self saveData];
	[self reloadData];
}
//--------------------------------
-(void)dealloc{
	[data release];
	for(int i = 0; i < ARRAYSIZE(icon); i++){
		[icon[i] release];
	}
	[movePageCellIndexPath release];
	[super dealloc];
}

//--------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

//--------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(section == 0){
		return [self.data count];
	}else{
		ASSERT(FALSE);
		return 0;
	}
}

//--------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NoteTableViewCell* cell = (NoteTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"any-cell"];
	if(cell == nil){
		cell = [[[NoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"any-cell"] autorelease];
	}
	
	NoteData* item = [self.data objectAtIndex:indexPath.row];
	[cell setPageNo:item.pageNo];
	[cell setIconImage:icon[item.icon]];
	[cell setTextString:item.text];
	
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

	return cell;
}

//--------------------------------
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

//--------------------------------
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.data removeObjectAtIndex:indexPath.row];
	[self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

//--------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NoteData* item = [self.data objectAtIndex:indexPath.row];
	UIAlertView* alert = [[UIAlertView alloc]
						  initWithTitle:@"ページ表示"
						  message:[NSString stringWithFormat:@"%d ページ目を\n表示しますか？", item.pageNo]
						  delegate:self
						  cancelButtonTitle:@"いいえ"
						  otherButtonTitles:@"はい", nil];
	[alert show];
	self.movePageCellIndexPath = indexPath;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	NoteData* item = [self.data objectAtIndex:indexPath.row];
	[Note pushAddView:indexPath.row pageNo:item.pageNo icon:item.icon memoText:item.text];
}

//--------------------------------
-(IBAction)clearNote:(id)sender{
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[self deselectRowAtIndexPath:self.movePageCellIndexPath animated:NO];
	NoteData* item = [self.data objectAtIndex:self.movePageCellIndexPath.row];
	if(buttonIndex == 1){
		[getMyAppDelegateInstance() changeScenePaperViewFromNote:item.pageNo-1];
	}
}

@end

//********************************
@implementation NoteViewController

@synthesize tableView;

//--------------------------------
-(void)viewDidLoad{
	self.title = @"メモ / しおり";
	{
		UIBarButtonItem* button = [[[UIBarButtonItem alloc]
									initWithTitle:@"戻る"
									style:UIBarButtonItemStylePlain
									target:self
									action:@selector(returnPaper)
									] autorelease];
		self.navigationItem.leftBarButtonItem = button;
	}
	sortType = NOTE_TABLE_SORT_PAGE_NO;
	sortButton.selectedSegmentIndex = 0;

	tableView.delegate = tableView;
	tableView.dataSource = tableView;
	[tableView initPatam];
}
//--------------------------------
- (void)viewWillAppear:(BOOL)animated{
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	frame.origin.y += 44.0f;
	frame.size.height -= 44.0f * 2.0f;
	self.tableView.frame = frame;
}
//--------------------------------
-(void)returnPaper{
	[tableView saveData];
	[getMyAppDelegateInstance() changeScenePaperViewFromNote:-1];
}
//--------------------------------
-(void)cleanup{
	[tableView cleanup];
	[self reSort];
}
//--------------------------------
-(void)reSort{
	[tableView sort:sortType];
}
//--------------------------------
-(IBAction)addMemo:(id)sender{
	[Note pushAddView];
}
//--------------------------------
-(IBAction)removeMemo:(id)sender{
	if(!self.tableView.editing){
		UIBarButtonItem* button = [[[UIBarButtonItem alloc]
									initWithTitle:@"完了"
									style:UIBarButtonItemStyleDone
									target:self
									action:@selector(removeMemoDone)
									] autorelease];
		self.navigationItem.rightBarButtonItem = button;
		[self.tableView startRemove];
	}
}
//--------------------------------
-(void)removeMemoDone{
	[self.tableView endRemove];
	self.navigationItem.rightBarButtonItem = nil;
}
//--------------------------------
-(IBAction)sendMailMemo:(id)sender{
	NSMutableString* body = [NSMutableString string];
	NoteData* item = nil;
	[body appendString:@"--------\n"];
	for(item in tableView.data){
		[body appendFormat:@"p.%03d %@\n", item.pageNo, [NoteTableView getIconText:(NOTE_ICON)item.icon]];
		[body appendString:item.text];
		[body appendString:@"\n--------\n"];
	}
	NSLog(@"%@", body);
	NSString* url8 = [NSString stringWithFormat:@"mailto:?Subject=読書メモ-%@&body=%@",
					  [Note getInstance].bookTitle,
					  body];
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
//--------------------------------
-(IBAction)sort:(id)sender{
	sortType = (NOTE_TABLE_SORT)sortButton.selectedSegmentIndex;
	ASSERT(sortType >= 0 && sortType < NOTE_TABLE_SORT_COUNT);
	[tableView sort:sortType];
}

@end

//********************************
@implementation Note

//--------------------------------
@synthesize navi;
@synthesize viewCtrl;
@synthesize addViewCtrl;
@synthesize bookTitle;
@synthesize pageNo;
@synthesize pageCount;

//--------------------------------
static Note* noteInstance = nil;

//--------------------------------
-(id)init{
	if(self = [super init]){
		{
			NSArray* niblets = [[NSBundle mainBundle] loadNibNamed:@"Note" owner:self options:NULL];
			for(id object in niblets){
				if([object isKindOfClass:[NoteViewController class]]){
					NoteViewController* viewController = object;
					self.viewCtrl = viewController;
/*					viewController.tableView.delegate = viewController.tableView;
					viewController.tableView.dataSource = viewController.tableView;
					[viewController.tableView initPatam];
*/
				}
				if([object isKindOfClass:[NoteAddViewController class]]){
					NoteAddViewController* viewController = object;
					self.addViewCtrl = viewController;
				}
			}
		}
		{
			UINavigationController *object = [[UINavigationController alloc] initWithRootViewController:self.viewCtrl];
			self.navi = object;
			[object release];

//			object.navigationBar.barStyle = UIBarStyleBlackTranslucent;
			self.navi.navigationBar.barStyle = UIBarStyleBlackTranslucent;
		}
		noteInstance = self;
	}
	return self;
}
//--------------------------------
-(void)dealloc{
	[navi release];
	[viewCtrl release];
	[addViewCtrl release];
	[bookTitle release];
	[super dealloc];
}
//--------------------------------
-(void)cleanup:(NSString*)_dirName pageNo:(int)_pageNo pageCount:(int)_pageCount{
	self.bookTitle = [NSString stringWithString:_dirName];
	pageNo = _pageNo;
	pageCount = _pageCount;
	[viewCtrl cleanup];
}
//--------------------------------
-(UIView*)view{
	return navi.view;
}
//--------------------------------
+(void)pushAddView{
	[noteInstance.addViewCtrl initAdd:noteInstance.pageNo pageCount:noteInstance.pageCount];
	[noteInstance.navi pushViewController:noteInstance.addViewCtrl animated:YES];
}
//--------------------------------
+(void)pushAddView:(int)_cellRow pageNo:(int)_pageNo icon:(NOTE_ICON)_icon memoText:(NSString*)_memoText{
	[noteInstance.addViewCtrl initEdit:_cellRow pageNo:_pageNo pageCount:noteInstance.pageCount icon:_icon memoTex:_memoText];
	[noteInstance.navi pushViewController:noteInstance.addViewCtrl animated:YES];
}
//--------------------------------
+(Note*)getInstance{
	return noteInstance;
}

@end
