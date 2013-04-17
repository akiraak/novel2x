#import <UIKit/UIKit.h>
#import "ZipFile.h"

@interface MyLibraryUnzipViewController : UIViewController {
@private
	NSString* filePath;
	NSTimer* unzipLoopTimer;
	IBOutlet UITextView* infoText;
	IBOutlet UILabel* progBarInfolabel;
	IBOutlet UIProgressView* prog;
	IBOutlet UIButton* readButton;
	ZipFile* zip;
	int zipFileNum;
	int createdFileCount;
	
}

//@property (readonly) NoteTableView* tableView;
@property (nonatomic, retain) NSString* filePath;
@property (nonatomic, retain) NSTimer* unzipLoopTimer;


-(void)initParam;
-(void)cleanup:(NSString*)_filePath;

-(IBAction)read:(id)sender;

@end
