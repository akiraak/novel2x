#import <UIKit/UIKit.h>

//********************************
enum NOTE_ADD_PICKER {
	NOTE_ADD_PICKER_PAGE_NO = 0,
	NOTE_ADD_PICKER_ICON,
};

@interface NoteAddViewController : UIViewController <UITextViewDelegate, UIPickerViewDelegate>{
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIView* hideView;
	IBOutlet UIButton* pageNoButton;
	IBOutlet UIButton* iconImageButton;
	IBOutlet UITextView* memoTextView;
	IBOutlet UIButton* memoClearButton;
	IBOutlet UIButton* memoEndButton;
	IBOutlet UIView* pickerAllView;
	IBOutlet UIPickerView* pickerView;

	int cellRow;
	int nowPageNo;
	int pageNo;
	int pageCount;
	int icon;
	NOTE_ADD_PICKER pickerType;
}

@property (nonatomic, retain) UIPickerView* pickerView;

-(void)initAdd:(int)_pageNo pageCount:(int)_pageCount;
-(void)initEdit:(int)_cellRow pageNo:(int)_pageNo pageCount:(int)_pageCount icon:(int)_icon memoTex:(NSString*)_memoText;	
-(void)showMemoButton:(BOOL)show;
-(void)setPageNo:(int)_pageNo;
-(void)setIcon:(int)_icon;

-(IBAction)pageNoEdit:(id)sender;
-(IBAction)iconEdit:(id)sender;
-(IBAction)pickerEnd:(id)sender;
-(IBAction)memoClear:(id)sender;
-(IBAction)memoEnd:(id)sender;

@end
