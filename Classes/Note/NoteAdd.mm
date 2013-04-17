#import "NoteAdd.h"
#import "Note.h"
#import "MS.h"

//********************************
@implementation NoteAddViewController

//--------------------------------
@synthesize pickerView;

//--------------------------------
#define UPED_Y			(140.0f)
#define UPED_H			(180.0f)
#define DEFAULT_H		(273.0f)
#define PICKER_ALL_H	(249.0f)

//--------------------------------
-(void)dealloc{
	[pickerView release];
	[super dealloc];
}
//--------------------------------
- (void)viewDidLoad{
}
//--------------------------------
- (void)viewWillAppear:(BOOL)animated{
	[self showMemoButton:FALSE];
	hideView.hidden = FALSE;
	pickerAllView.hidden = TRUE;
}
//--------------------------------
-(void)viewWillDisappear:(BOOL)animated{
	[memoTextView resignFirstResponder];
}
//--------------------------------
-(void)initAdd:(int)_pageNo pageCount:(int)_pageCount{
	nowPageNo = _pageNo;
	pageNo = _pageNo;
	pageCount = _pageCount;
	icon = NOTE_ICON_MEMO;
	[self setPageNo:pageNo];
	[self setIcon:icon];
	memoTextView.text = @"";

	UIBarButtonItem* addButton = [[[UIBarButtonItem alloc]
								   initWithTitle:@"追加"
								   style:UIBarButtonItemStyleDone
								   target:self
								   action:@selector(addEnd)
								   ] autorelease];
	self.navigationItem.rightBarButtonItem = addButton;
}
//--------------------------------
-(void)addEnd{
	Note* note = [Note getInstance];
	[note.viewCtrl.tableView addMemo:pageNo icon:(NOTE_ICON)icon memo:memoTextView.text];
	[note.navi popViewControllerAnimated:YES];
}
//--------------------------------
-(void)initEdit:(int)_cellRow pageNo:(int)_pageNo pageCount:(int)_pageCount icon:(int)_icon memoTex:(NSString*)_memoText{
	cellRow = _cellRow;
	nowPageNo = _pageNo;
	pageNo = _pageNo;
	pageCount = _pageCount;
	icon = _icon;
	[self setPageNo:pageNo];
	[self setIcon:icon];
	memoTextView.text = _memoText;

	UIBarButtonItem* addButton = [[[UIBarButtonItem alloc]
								   initWithTitle:@"完了"
								   style:UIBarButtonItemStyleDone
								   target:self
								   action:@selector(editEnd)
								   ] autorelease];
	self.navigationItem.rightBarButtonItem = addButton;
}
//--------------------------------
-(void)editEnd{
	Note* note = [Note getInstance];
	[note.viewCtrl.tableView editMemo:cellRow pageNo:pageNo icon:(NOTE_ICON)icon memo:memoTextView.text];
	[note.navi popViewControllerAnimated:YES];
}
//--------------------------------
-(void)showMemoButton:(BOOL)show{
	BOOL hidden = TRUE;
	if(show){
		hidden = FALSE;
	}
	memoClearButton.hidden = hidden;
	memoEndButton.hidden = hidden;
}
//--------------------------------
-(void)setPageNo:(int)_pageNo{
	NSString* text;
	if(_pageNo > 0){
		text = [NSString stringWithFormat:@"%d", _pageNo];
	}else{
		text = @"---";
	}
	static int states[]={
		UIControlStateNormal,
		UIControlStateHighlighted,
		UIControlStateDisabled,
		UIControlStateSelected,
		UIControlStateApplication,
		UIControlStateReserved,
	};
	for(int i = 0; i < ARRAYSIZE(states); i++){
		[pageNoButton setTitle:text forState:states[i]];
	}
}
//--------------------------------
-(void)setIcon:(int)_icon{
	UIImage* image = [[Note getInstance].viewCtrl.tableView getIconImage:(NOTE_ICON)_icon];
	static int states[]={
		UIControlStateNormal,
		UIControlStateHighlighted,
		UIControlStateDisabled,
		UIControlStateSelected,
		UIControlStateApplication,
		UIControlStateReserved,
	};
	for(int i = 0; i < ARRAYSIZE(states); i++){
		[iconImageButton setImage:image forState:states[i]];
	}
	
}
//--------------------------------
-(IBAction)pageNoEdit:(id)sender{
	pickerType = NOTE_ADD_PICKER_PAGE_NO;
	[pickerView selectRow:pageNo inComponent:0 animated:NO];
	[pickerView reloadAllComponents];
	{
		CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
		CGRect frame = pickerAllView.frame;
		frame.origin.y = appFrame.size.height;
		[pickerAllView setFrame:frame];
	}
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	{
		CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
		CGRect frame = pickerAllView.frame;
		frame.origin.y = appFrame.size.height-frame.size.height;
		[pickerAllView setFrame:frame];
		pickerAllView.hidden = FALSE;
	}
	[UIView commitAnimations];

	[pickerView selectRow:pageNo inComponent:0 animated:NO];
	[pickerView reloadAllComponents];
}
//--------------------------------
-(IBAction)iconEdit:(id)sender{
	pickerType = NOTE_ADD_PICKER_ICON;
	[pickerView selectRow:icon inComponent:0 animated:NO];
	[pickerView reloadAllComponents];
	{
		CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
		CGRect frame = pickerAllView.frame;
		frame.origin.y = appFrame.size.height;
		[pickerAllView setFrame:frame];
	}
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	{
		CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
		CGRect frame = pickerAllView.frame;
		frame.origin.y = appFrame.size.height-frame.size.height;
		[pickerAllView setFrame:frame];
		pickerAllView.hidden = FALSE;
	}
	[UIView commitAnimations];

	[pickerView selectRow:icon inComponent:0 animated:NO];
	[pickerView reloadAllComponents];
}
//--------------------------------
-(IBAction)pickerEnd:(id)sender{
	switch(pickerType){
		case NOTE_ADD_PICKER_PAGE_NO:
		{
			pageNo = [pickerView selectedRowInComponent:0];
			[self setPageNo:pageNo];
			break;
		}
		case NOTE_ADD_PICKER_ICON:
		{
			icon = [pickerView selectedRowInComponent:0];
			[self setIcon:icon];
			break;
		}
	}
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"pickerEnd" context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	{
		CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
		CGRect frame = pickerAllView.frame;
		frame.origin.y = appFrame.size.height;
		[pickerAllView setFrame:frame];
	}
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
}
//--------------------------------
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	if([animationID isEqualToString:@"pickerEnd"]){
		pickerAllView.hidden = TRUE;
	}		
}
//--------------------------------
-(IBAction)memoClear:(id)sender{
	UIAlertView* alert = [[UIAlertView alloc]
						  initWithTitle:@"削除"
						  message:@"メモを削除します。\nよろしいですか？"
						  delegate:self
						  cancelButtonTitle:@"いいえ"
						  otherButtonTitles:@"はい", nil];
	[alert show];	
}
//--------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 1){
		memoTextView.text = @"";
	}
}
//--------------------------------
-(IBAction)memoEnd:(id)sender{
	[memoTextView resignFirstResponder];
}
//--------------------------------
- (BOOL)textViewShouldBeginEditing:(UITextView*)textView{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	{
		CGRect frame = self.view.frame;
		frame.origin.y = -(UPED_Y);
		[self.view setFrame:frame];
	}
	{
		CGRect frame = memoTextView.frame;
		frame.size.height = UPED_H;
		memoTextView.frame = frame;
		
	}
	{
		[hideView setAlpha:0.0f];
	}
	[UIView commitAnimations];
	[self showMemoButton:TRUE];
	return TRUE;
}
//--------------------------------
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	{
		CGRect frame = self.view.frame;
		frame.origin.y = 0.0f;
		[self.view setFrame:frame];
	}
	{
		CGRect frame = memoTextView.frame;
		frame.size.height = DEFAULT_H;
		memoTextView.frame = frame;
	}
	{
		[hideView setAlpha:1.0f];
	}
	[UIView commitAnimations];
	[self showMemoButton:FALSE];
	return TRUE;
}

//********************************
// UIPickerViewDelegate
//--------------------------------
- (void) pickerView: (UIPickerView*)pView didSelectRow:(NSInteger)row  inComponent:(NSInteger)component{  
}
//--------------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//--------------------------------
-(NSInteger)pickerView:(UIPickerView*)view numberOfRowsInComponent:(NSInteger)component{
	int rowCount = 0;
	switch(pickerType){
		case NOTE_ADD_PICKER_PAGE_NO:
			rowCount = pageCount+1;
			break;
		case NOTE_ADD_PICKER_ICON:
			rowCount = NOTE_ICON_COUNT;
			break;
	}
    return rowCount;
}
//--------------------------------
-(UIView*)pickerView:(UIPickerView*)picker viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView*)view{
	if(view != nil){
		NSArray* subviews = view.subviews;
		UIView* subview = nil;
		for(subview in subviews){
			[subview removeFromSuperview];
		}
	}
	if(view == nil){
		view = [[UIView alloc] initWithFrame:CGRectZero];
	}
	switch(pickerType){
		case NOTE_ADD_PICKER_PAGE_NO:
		{
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-160.0f,-11.0f,320.0f,23.0f)];
			label.backgroundColor = [UIColor clearColor];
			label.opaque = NO;
			label.textAlignment = UITextAlignmentCenter;
			label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
			[label setTag:component+100];
			[view addSubview:label];
			[label release];
			if(row == 0){
				label.text = @"---";
			}else{
				label.text = [NSString stringWithFormat:@"%d", row];
			}
			if(row == nowPageNo){
				UILabel *nowLabel;
				nowLabel = [[UILabel alloc] initWithFrame:CGRectMake(-140.0f,-11.0f,120.0f,23.0f)];
				nowLabel.backgroundColor = [UIColor clearColor];
				nowLabel.opaque = NO;
				nowLabel.textAlignment = UITextAlignmentLeft;
				nowLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
				nowLabel.text = @"現在のページ";
				[view addSubview:nowLabel];
				[nowLabel release];
			}
			break;
		}
		case NOTE_ADD_PICKER_ICON:
		{
			{
				UIImage* image = [[Note getInstance].viewCtrl.tableView getIconImage:(NOTE_ICON)row];
				UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
				imageView.frame = CGRectMake(-40.0f, -18.0f, image.size.width, image.size.height);
				[view addSubview:imageView];
				[imageView release];
			}
			{
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,-11.0f,120.0f,23.0f)];;
				label.backgroundColor = [UIColor clearColor];
				label.opaque = NO;
				label.textAlignment = UITextAlignmentLeft;
				label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
				label.text = [NoteTableView getIconText:(NOTE_ICON)row];
				[view addSubview:label];
				[label release];
			}
			break;
		}
	}
	return view;
}

@end
