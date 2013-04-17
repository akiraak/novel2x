#import <UIKit/UIKit.h>
#import "NoteAdd.h"

enum NOTE_ICON {
	NOTE_ICON_MALE = 0,
	NOTE_ICON_FEMALE,
	NOTE_ICON_ANIMAL,
	NOTE_ICON_MEMO,
	
	NOTE_ICON_COUNT,
};

@interface NoteData : NSObject {
	NSInteger	pageNo;
	NOTE_ICON	icon;
	NSString*	text;
}

@property (readwrite) NSInteger pageNo;
@property (readwrite) NOTE_ICON icon;
@property (nonatomic, retain) NSString* text;

+(NSArray*)sortPageNo:(NSArray*)datas;
+(NSArray*)sortIcon:(NSArray*)datas;

@end

@interface NoteTableViewCell : UITableViewCell{
	UILabel* pageNoLabel;
	UIImageView* iconView;
	UILabel* textLabel;
	BOOL touchPageNo;
}

@property (nonatomic, retain) UILabel* pageNoLabel;
@property (nonatomic, retain) UIImageView* iconView;
@property (nonatomic, retain) UILabel* textLabel;
@property (readonly) BOOL touchPageNo;

-(void)setPageNo:(NSInteger)pageNo;
-(void)setIconImage:(UIImage*)iconImage;
-(void)setTextString:(NSString*)textString;

@end

enum NOTE_TABLE_SORT {
	NOTE_TABLE_SORT_PAGE_NO = 0,
	NOTE_TABLE_SORT_ICON,
	NOTE_TABLE_SORT_MEMO,
	
	NOTE_TABLE_SORT_COUNT,
};

@interface NoteTableView : UITableView <UITableViewDelegate, UITableViewDataSource>{
	NSMutableArray* data;
	UIImage* icon[NOTE_ICON_COUNT];
	NSIndexPath* movePageCellIndexPath;
	
	NOTE_TABLE_SORT sortType;
}

@property (nonatomic, retain) NSMutableArray* data;
@property (nonatomic, retain) NSIndexPath* movePageCellIndexPath;

-(void)initPatam;
-(void)cleanup;
-(void)saveData;
-(void)startRemove;
-(void)endRemove;
-(UIImage*)getIconImage:(NOTE_ICON)icon;
+(NSString*)getIconText:(NOTE_ICON)icon;
-(void)addMemo:(int)_pageNo icon:(NOTE_ICON)_icon memo:(NSString*)_memoText;
-(void)editMemo:(int)cellRow pageNo:(int)_pageNo icon:(NOTE_ICON)_icon memo:(NSString*)_memoText;
-(void)sort:(NOTE_TABLE_SORT)type;

@end

@interface NoteViewController : UIViewController <UITextViewDelegate>{
	IBOutlet NoteTableView* tableView;
	IBOutlet UIBarButtonItem* addButton;
	IBOutlet UIBarButtonItem* removeButton;
	IBOutlet UIBarButtonItem* sendMailButton;
	IBOutlet UISegmentedControl* sortButton;
	
	NOTE_TABLE_SORT sortType;
}

@property (readonly) NoteTableView* tableView;

-(void)cleanup;
-(void)reSort;

-(IBAction)addMemo:(id)sender;
-(IBAction)removeMemo:(id)sender;
-(IBAction)sendMailMemo:(id)sender;
-(IBAction)sort:(id)sender;

@end

@interface Note : NSObject{
	UINavigationController* navi;
	NoteViewController* viewCtrl;
	NoteAddViewController* addViewCtrl;

	NSString* bookTitle;
	int pageNo;
	int pageCount;
}

@property (nonatomic, retain) UINavigationController* navi;
@property (nonatomic, retain) NoteViewController* viewCtrl;
@property (nonatomic, retain) NoteAddViewController* addViewCtrl;
@property (nonatomic, retain) NSString* bookTitle;
@property (readonly) int pageNo;
@property (readonly) int pageCount;

-(void)cleanup:(NSString*)_dirName pageNo:(int)_pageNo pageCount:(int)_pageCount;
-(UIView*)view;
+(void)pushAddView;
+(void)pushAddView:(int)_cellRow pageNo:(int)_pageNo icon:(NOTE_ICON)_icon memoText:(NSString*)_memoText;
+(Note*)getInstance;

@end
