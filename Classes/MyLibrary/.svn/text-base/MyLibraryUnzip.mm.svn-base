#import "MyLibraryUnzip.h"
#import "MyAppDelegate.h"
#import "AppData.h"
#import "ZipReadStream.h"
#import "ZipFile.h"
#import "BookUtil.h"

#define PROG_BAR_INFO_FM @"%d / %d File"

//********************************
@implementation MyLibraryUnzipViewController

@synthesize filePath;
@synthesize unzipLoopTimer;

//--------------------------------
-(void)viewDidLoad{
	self.title = @"解凍";
	{
		UIBarButtonItem* button = [[[UIBarButtonItem alloc]
									initWithTitle:@"戻る"
									style:UIBarButtonItemStylePlain
									target:self
									action:@selector(backButton)
									] autorelease];
		self.navigationItem.leftBarButtonItem = button;
	}
}
//--------------------------------
- (void)viewWillAppear:(BOOL)animated{
	NSString* fileName = [filePath lastPathComponent];
	NSLOG(@"fileName: %@", fileName);
	infoText.text = [NSString stringWithFormat:@"%@ を解凍しています。", fileName];
	progBarInfolabel.text = [NSString stringWithFormat:PROG_BAR_INFO_FM, 0, 0];
	readButton.enabled = NO;
	prog.progress = 0.0f;
	createdFileCount = 0;
	
	// 解凍初期化
	{
		zip = [[ZipFile alloc] initWithFileName:filePath mode:ZipFileModeUnzip];
		[zip goToFirstFileInZip];
		NSUInteger zipNum = [zip numFilesInZip];
		NSLOG(@"Zip Contents Num: %d", zipNum);
		zipFileNum = zipNum;
		if(zipNum > 0){
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString* documentsPath = [paths objectAtIndex:0];
			NSString *unzipDirName = [[filePath lastPathComponent] stringByDeletingPathExtension];
			NSLOG(@"unzip dir : %@", unzipDirName);
			NSString *unzipDirPath = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, unzipDirName];
			NSLOG(@"unzip dir : %@", unzipDirPath);
			
			// 既存ディレクトリがあれば削除
			if([[NSFileManager defaultManager] fileExistsAtPath:unzipDirPath]){
				[[NSFileManager defaultManager] removeItemAtPath:unzipDirPath error:nil];
			}
			
			// ディレクトリ作成
			[[NSFileManager defaultManager] createDirectoryAtPath:unzipDirPath withIntermediateDirectories:YES attributes:nil error:nil];
		}else{
			[zip close];
			[zip release];
			zip = NULL;
		}
	}
	self.unzipLoopTimer = [NSTimer scheduledTimerWithTimeInterval:0.00001f target:self selector:@selector(unzipUpdate) userInfo:nil repeats:YES];
	ASSERT(unzipLoopTimer);
}
//--------------------------------
-(void)dealloc{
	[unzipLoopTimer release];
	[filePath release];
	[super dealloc];
}
//--------------------------------
-(void)initParam{
}
//--------------------------------
-(void)cleanup:(NSString*)_filePath{
	filePath = [NSString stringWithString:_filePath];
}
//--------------------------------
-(void)unzipUpdate{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsPath = [paths objectAtIndex:0];
	NSString *unzipDirName = [[filePath lastPathComponent] stringByDeletingPathExtension];
	NSLOG(@"unzip dir : %@", unzipDirName);
	NSString *unzipDirPath = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, unzipDirName];
	NSLOG(@"unzip dir : %@", unzipDirPath);

	FileInZipInfo* zipInfo = [zip getCurrentFileInZipInfo];
	NSLOG(@"unzip name:%@ size:%d", [zipInfo name], [zipInfo length]);
	ZipReadStream* read = [zip readCurrentFileInZip];
	NSMutableData* data = [[NSMutableData alloc] initWithLength:[zipInfo length]];
	if([zipInfo length] > 0 && [read readDataWithBuffer:data]){
		NSString* name = [[zipInfo name] lastPathComponent];
		if(!name){
			name = [NSString stringWithFormat:@"%04d.jpg", createdFileCount];
		}
		NSString* unzipCreatefilePath = [NSString stringWithFormat:@"%@/%@", unzipDirPath, name];
		
		// ファイル作成
		[data writeToFile:unzipCreatefilePath atomically:YES];
		NSLOG(@"unzip size:%d ファイル作成:%@", [zipInfo length], unzipCreatefilePath);
	}
	[read finishedReading];
	[data release];

	// 解凍ファイルカウント
	createdFileCount++;
	// 進行度のテキスト更新
	progBarInfolabel.text = [NSString stringWithFormat:PROG_BAR_INFO_FM, createdFileCount, zipFileNum];
	//プログレスバーの更新
	prog.progress = (float)createdFileCount / (float)zipFileNum;

	// 終了処理
	BOOL nextState = [zip goToNextFileInZip];
	if(!nextState){
		NSString* fileName = [filePath lastPathComponent];
		NSString* bookName = [fileName stringByDeletingPathExtension];
		NSLOG(@"fileName", fileName);
		NSLOG(@"bookName", bookName);

		infoText.text = [NSString stringWithFormat:@"%@ の解凍が完了しました。", fileName];
		[zip close];
		[zip release];
		zip = NULL;
		[unzipLoopTimer invalidate];
		readButton.enabled = YES;

		// zipファイル削除
		[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

		// 書籍情報の保存
		AppData::setupBook(bookName);
		ms::Sint32 pageCount = BookUtil::getPageCountWithBookName(bookName);
		AppData::setBookPageCount(bookName, pageCount);

		// 書籍一覧画面
		{
			MyLibraryTable* table = getMyLibraryTable();
			// ZIPを削除
			{
				int count = [table.tableItems count];
				for(int i = 0; i < count; i++){
					MyLibraryTableItem* item = [table.tableItems objectAtIndex:i];
					if([item.title isEqualToString:[NSString stringWithFormat:@"ZIP:%@", fileName]]){
						[table removeItemWithTitle:item.title];
						break;
					}
				}
			}
			// 書籍を追加
			{
				BOOL exist = FALSE;
				{
					int count = [table.tableItems count];
					for(int i = 0; i < count; i++){
						MyLibraryTableItem* item = [table.tableItems objectAtIndex:i];
						if([item.title isEqualToString:bookName]){
							exist = TRUE;
						}
					}
				}
				if(!exist){
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString* documentsPath = [paths objectAtIndex:0];
					NSString *unzipDirPath = [NSString stringWithFormat:@"%@/Books/%@", documentsPath, bookName];
					
					MyLibraryTableItem* item = [[MyLibraryTableItem alloc] initWithTitle:bookName path:unzipDirPath type:MYLIBRARY_TABLEITEM_TYPE_BOOK];
					NSLog(@"%d", [table.tableItems count]);
					[table.tableItems insertObject:item atIndex:[table.tableItems count]-1];
				}
			}
			[table updateList];
		}
	}
}
//--------------------------------
-(IBAction)cancel:(id)sender{
}
//--------------------------------
-(IBAction)read:(id)sender{
	//NSLOG(@"%@", [[tableItems objectAtIndex:[indexPath row]] title]);
	NSString *unzipDirName = [[filePath lastPathComponent] stringByDeletingPathExtension];
	[getMyAppDelegateInstance() changeSceneConfig:unzipDirName];
}
//--------------------------------
-(void)backButton{
	[zip close];
	[zip release];
	zip = NULL;
	[unzipLoopTimer invalidate];

	[self.navigationController popViewControllerAnimated:YES];
}
@end
